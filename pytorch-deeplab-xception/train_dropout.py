import argparse
import os
import numpy as np
from tqdm import tqdm
import time
from mypath import Path
import torch
#from dataloaders import make_data_loader
from modeling.sync_batchnorm.replicate import patch_replication_callback
from modeling.deeplab_dropout import *
from utils.loss import SegmentationLosses
from utils.calculate_weights import calculate_weigths_labels
from utils.lr_scheduler import LR_Scheduler
from utils.saver import Saver
from utils.summaries import TensorboardSummary
from utils.metrics import Evaluator
#from pytorchtools import EarlyStopping
#early_stopping = EarlyStopping(patience=5, verbose=True)
import sys
#HOME = os.path.expanduser('~')
#this path should be modified according to user's direction
#basicCodes_path = HOME + '/data2/Front_DL3/script/'

#sys.path.append(basicCodes_path)
from datasetRS_MP import *
import parameters
from basic_src import *



class Trainer(object):
    def __init__(self, args):
        self.args = args

        # Define Saver
        self.saver = Saver(args)
        self.saver.save_experiment_config()
        # Define Tensorboard Summary
        
        # Define Dataloader
        kwargs = {'num_workers': args.workers, 'pin_memory': True}

        parameters.set_saved_parafile_path(args.para)
        patch_w = parameters.get_digit_parameters("", "train_patch_width", None, 'int')
        patch_h = parameters.get_digit_parameters("", "train_patch_height", None, 'int')
        overlay_x = parameters.get_digit_parameters("", "train_pixel_overlay_x", None, 'int')
        overlay_y = parameters.get_digit_parameters("", "train_pixel_overlay_y", None, 'int')
        crop_height = parameters.get_digit_parameters("", "crop_height", None, 'int')
        crop_width = parameters.get_digit_parameters("", "crop_width", None, 'int')
        start_time=time.time()
        print("start loading data")

        dataset = RemoteSensingImg(args.dataroot, args.list, patch_w, patch_h, overlay_x, overlay_y)
        end_time=time.time()
        print("Remote sensing data loading complete, time used: %d second"%(end_time-start_time))
        print("start deep learning loading")
        start_time=time.time()
        

        #train_loader = torch.utils.data.DataLoader(dataset, batch_size=args.batch_size,
        #                                           num_workers=args.workers, shuffle=True)
        train_length = int(len(dataset) * 0.95)
        validation_length = len(dataset) - train_length
	#print ("totol data len is %d , train_length is %d"%(len(train_loader),train_length))	
        [self.train_dataset, self.val_dataset] = torch.utils.data.random_split(dataset, (train_length, validation_length))
        print("len of train dataset is %d and val dataset is %d and total datalen is %d"%(len(self.train_dataset),len(self.val_dataset),len(dataset)))
        self.train_loader=torch.utils.data.DataLoader(self.train_dataset, batch_size=args.batch_size,num_workers=args.workers, shuffle=True,drop_last=True)
        self.val_loader=torch.utils.data.DataLoader(self.val_dataset, batch_size=args.batch_size,num_workers=args.workers, shuffle=True,drop_last=True)
        print("len of train loader is %d and val loader is %d"%(len(self.train_loader),len(self.val_loader)))
        end_time=time.time()
        print("time for loading data is %d second"%(end_time-start_time))
	#self.train_loader, self.val_loader, self.test_loader, self.nclass = make_data_loader(args, **kwargs)
	
        # Define network
        model = DeepLab(num_classes=1,
                        backbone=args.backbone,
                        output_stride=args.out_stride,
                        sync_bn=args.sync_bn,
                        freeze_bn=args.freeze_bn)

        train_params = [{'params': model.get_1x_lr_params(), 'lr': args.lr},
                        {'params': model.get_10x_lr_params(), 'lr': args.lr * 10}]

        # Define Optimizer
        optimizer = torch.optim.SGD(train_params, momentum=args.momentum,
                                    weight_decay=args.weight_decay, nesterov=args.nesterov)




        # whether to use class balanced weights
        # if args.use_balanced_weights:
        #     classes_weights_path = os.path.join(Path.db_root_dir(args.dataset), args.dataset+'_classes_weights.npy')
        #     if os.path.isfile(classes_weights_path):
        #         weight = np.load(classes_weights_path)
        #     else:
        #         weight = calculate_weigths_labels(args.dataset, self.train_loader, self.nclass)
        #     weight = torch.from_numpy(weight.astype(np.float32))
        # else:
        #     weight = None





        # Define Criterion
        #self.criterion = SegmentationLosses(weight=weight, cuda=args.cuda).build_loss(mode=args.loss_type)


        self.criterion=nn.BCELoss()

        if args.cuda:
            self.criterion=self.criterion.cuda()


        self.model, self.optimizer = model, optimizer
        
        # Define Evaluator
        self.evaluator = Evaluator(2)
        # Define lr scheduler
        print("lenght of train_loader is %d"%(len(self.train_loader)))
        self.scheduler = LR_Scheduler(args.lr_scheduler, args.lr,
                                            args.epochs, len(self.train_loader))

        # Using cuda
        if args.cuda:
            self.model = torch.nn.DataParallel(self.model, device_ids=args.gpu_ids)
            #self.model = torch.nn.DataParallel(self.model)
            patch_replication_callback(self.model)
            self.model = self.model.cuda()

        # Resuming checkpoint
        self.best_pred = 999999999
        if args.resume is not None:
            if not os.path.isfile(args.resume):
                raise RuntimeError("=> no checkpoint found at '{}'" .format(args.resume))
            checkpoint = torch.load(args.resume)
            args.start_epoch = checkpoint['epoch']
            if args.cuda:
                self.model.module.load_state_dict(checkpoint['state_dict'])
            else:
                self.model.load_state_dict(checkpoint['state_dict'])
            if not args.ft:
                self.optimizer.load_state_dict(checkpoint['optimizer'])
            self.best_pred = checkpoint['best_pred']
            print("=> loaded checkpoint '{}' (epoch {}) with best mIoU {}"
                  .format(args.resume, checkpoint['epoch'], checkpoint['best_pred']))

        # Clear start epoch if fine-tuning
        if args.ft:
            args.start_epoch = 0
            self.best_pred=999999999

    def training(self, epoch):
        train_start_time=time.time()
        train_loss = 0.0
        self.model.train()
        #tbar = tqdm(self.train_loader)
        num_img_tr = len(self.train_loader)
        print("start training at epoch %d, with the training length of %d"%(epoch,num_img_tr))
        for i, (x, y) in enumerate(self.train_loader):
            start_time=time.time()
            #print(x)
            #print(y)
            image, target = x, y
            if self.args.cuda:
                image, target = image.cuda(), target.cuda()
            self.scheduler(self.optimizer, i, epoch, self.best_pred)
            self.optimizer.zero_grad()
            output = self.model(image)
            loss = self.criterion(output, target)
            loss.backward()
            self.optimizer.step()
            train_loss += loss.item()
            end_time=time.time()
            #tbar.set_description('Train loss: %.3f' % (train_loss / (i + 1)))
            print('[The loss for iteration %d is %.3f and the time used is %.3f]'%(i+num_img_tr*epoch,loss.item(),end_time-start_time))

        train_end_time=time.time()
        print('[Epoch: %d, numImages: %5d, time used : %.3f hour]' % (epoch, i * self.args.batch_size + image.data.shape[0],(train_end_time-train_start_time)/3600))
        print('Loss: %.3f' % (train_loss/len(self.train_loader)))
	
        with open(self.args.checkname+".train_out.txt", 'a') as log:
            out_massage='[Epoch: %d, numImages: %5d]' % (epoch, i * self.args.batch_size + image.data.shape[0])
            log.writelines(out_massage+'\n')
            out_massage='Loss: %.3f' % (train_loss/len(self.train_loader))
            log.writelines(out_massage+'\n')
        if self.args.no_val:
            # save checkpoint every epoch
            is_best = False
            self.saver.save_checkpoint({
                'epoch': epoch + 1,
                'state_dict': self.model.module.state_dict(),
                'optimizer': self.optimizer.state_dict(),
                'best_pred': self.best_pred,
            }, is_best)


    def validation(self, epoch):
        time_val_start=time.time()
        self.model.eval()
        self.evaluator.reset()
        #tbar = tqdm(self.val_loader, desc='\r')
        test_loss = 0.0
        for i, (x, y) in enumerate(self.val_loader):
            start_time=time.time()
            image, target = x,y
            if self.args.cuda:
                image, target = image.cuda(), target.cuda()
            with torch.no_grad():
                output = self.model(image)
            loss = self.criterion(output, target)
            test_loss += loss.item()
            #tbar.set_description('Test loss: %.3f' % (test_loss / (i + 1)))
            #pred = output.data.cpu().numpy()
            #target = target.cpu().numpy()
            #pred = np.argmax(pred, axis=1)
            # Add batch sample into evaluator
            #self.evaluator.add_batch(target, pred)
            end_time=time.time()
            print("validate on the %d patch of total %d patch, the time used is %.2f"%(i,len(self.val_loader),end_time-start_time))

        # Fast test during the training

        #Acc = self.evaluator.Pixel_Accuracy()
        #Acc_class = self.evaluator.Pixel_Accuracy_Class()
        #mIoU = self.evaluator.Mean_Intersection_over_Union()
        #FWIoU = self.evaluator.Frequency_Weighted_Intersection_over_Union()
        time_val_end=time.time()
        print('Validation:')
        print('[Epoch: %d, numImages: %5d, time used: %.3f hour]' % (epoch, len(self.val_loader), (time_val_end-time_val_start)/3600))
        #print("Acc:{}, Acc_class:{}, mIoU:{}, fwIoU: {}".format(Acc, Acc_class, mIoU, FWIoU))
        print('Validation Loss: %.3f' % (test_loss/len((self.val_loader))))

        with open(self.args.checkname+".train_out.txt", 'a') as log:
            out_message='Validation:'
            log.writelines(out_message+'\n')
            out_message='Validation Loss: %.3f' % (test_loss/len((self.val_loader)))
            log.writelines(out_message+'\n')
        new_pred = test_loss

        if new_pred < self.best_pred:
            print("saveing model")
            start_time=time.time()
            is_best = True
            self.best_pred = new_pred
            self.saver.save_checkpoint({
                'epoch': epoch + 1,
                'state_dict': self.model.module.state_dict(),
                'optimizer': self.optimizer.state_dict(),
                'best_pred': self.best_pred,
            }, is_best,self.args.checkname)
            end_time=time.time()
            print("time for saving model is %.2f second"%(end_time-start_time))
            return False
        else:
            return True



def main():
    parser = argparse.ArgumentParser(description="PyTorch DeeplabV3Plus Training")
    parser.add_argument('--backbone', type=str, default='resnet',
                        choices=['resnet', 'xception', 'drn', 'drndropout', 'mobilenet'],
                        help='backbone name (default: resnet)')
    parser.add_argument('--out-stride', type=int, default=16,
                        help='network output stride (default: 8)')



    parser.add_argument('--workers', type=int, default=4,
                        metavar='N', help='dataloader threads')

    # parser.add_argument('--base-size', type=int, default=513,
    #                     help='base image size')

    # parser.add_argument('--crop-size', type=int, default=513,
    #                     help='crop image size')

    parser.add_argument('--sync-bn', type=bool, default=None,
                        help='whether to use sync bn (default: auto)')
    parser.add_argument('--freeze-bn', type=bool, default=False,
                        help='whether to freeze bn parameters (default: False)')
    # parser.add_argument('--loss-type', type=str, default='ce',
    #                     choices=['ce', 'focal'],
    #                     help='loss func type (default: ce)')
    # training hyper params
    parser.add_argument('--epochs', type=int, default=None, metavar='N',
                        help='number of epochs to train (default: auto)')
    parser.add_argument('--start_epoch', type=int, default=0,
                        metavar='N', help='start epochs (default:0)')
    parser.add_argument('--batch-size', type=int, default=None,
                        metavar='N', help='input batch size for \
                                training (default: auto)')
    # parser.add_argument('--test-batch-size', type=int, default=None,
    #                     metavar='N', help='input batch size for \
    #                             testing (default: auto)')

    # optimizer params
    parser.add_argument('--lr', type=float, default=None, metavar='LR',
                        help='learning rate (default: auto)')



    parser.add_argument('--lr-scheduler', type=str, default='poly',
                        choices=['poly', 'step', 'cos'],
                        help='lr scheduler mode: (default: poly)')
    parser.add_argument('--momentum', type=float, default=0.9,
                        metavar='M', help='momentum (default: 0.9)')
    parser.add_argument('--weight-decay', type=float, default=5e-4,
                        metavar='M', help='w-decay (default: 5e-4)')

    #related to SDG
    parser.add_argument('--nesterov', action='store_true', default=False,
                        help='whether use nesterov (default: False)')
    # cuda, seed and logging
    parser.add_argument('--no-cuda', action='store_true', default=
                        False, help='disables CUDA training')
    parser.add_argument('--gpu-ids', type=str, default='0',
                        help='use which gpu to train, must be a \
                        comma-separated list of integers only (default=0)')
    parser.add_argument('--seed', type=int, default=1, metavar='S',
                        help='random seed (default: 1)')
    # checking point
    parser.add_argument('--resume', type=str, default=None,
                        help='put the path to resuming file if needed')

    parser.add_argument('--checkname', type=str, default=None,
                        help='set the checkpoint name')
    # finetuning pre-trained models
    parser.add_argument('--ft', action='store_true', default=True,
                        help='finetuning on a different dataset')
    # evaluation option
    parser.add_argument('--eval-interval', type=int, default=1,
                        help='evaluuation interval (default: 1)')
    parser.add_argument('--no-val', action='store_true', default=False,
                        help='skip validation during training')
    parser.add_argument('--patience', type=int,default=5,help='patience for early stopping')
    parser.add_argument('dataroot', help='path to dataset of kaggle ultrasound nerve segmentation')
    parser.add_argument('para', help='path to the parameter file')
    parser.add_argument('list', help='path to the list file')


    args = parser.parse_args()

    args.cuda = not args.no_cuda and torch.cuda.is_available()
    if args.cuda:
        try:
            args.gpu_ids = [int(s) for s in args.gpu_ids.split(',')]
        except ValueError:
            raise ValueError('Argument --gpu_ids must be a comma-separated list of integers only')

    if args.sync_bn is None:
        if args.cuda and len(args.gpu_ids) > 1:
            args.sync_bn = True
        else:
            args.sync_bn = False

    # default settings for epochs, batch_size and lr
    # if args.epochs is None:
    #     epoches = {
    #         'coco': 30,
    #         'cityscapes': 200,
    #         'pascal': 50,
    #     }
    #     args.epochs = epoches[args.dataset.lower()]
    #
    # if args.batch_size is None:
    #     args.batch_size = 4 * len(args.gpu_ids)
    #
    # if args.test_batch_size is None:
    #     args.test_batch_size = args.batch_size
    #
    # if args.lr is None:
    #     lrs = {
    #         'coco': 0.1,
    #         'cityscapes': 0.01,
    #         'pascal': 0.007,
    #     }
    #     args.lr = lrs[args.dataset.lower()] / (4 * len(args.gpu_ids)) * args.batch_size


    if args.checkname is None:
        args.checkname = 'deeplab-'+str(args.backbone)
    print(args)
    torch.manual_seed(args.seed)
    trainer = Trainer(args)
    print('Starting Epoch:', trainer.args.start_epoch)
    print('Total Epoches:', trainer.args.epochs)
    early_stop_count=0
    for epoch in range(trainer.args.start_epoch, trainer.args.epochs):
        trainer.training(epoch)
        if not trainer.args.no_val and epoch % args.eval_interval == (args.eval_interval - 1):
            early_stop=trainer.validation(epoch)
            if early_stop:
                early_stop_count += 1
                print ("early stop count is %d"%(early_stop_count))
            else:
                early_stop_count=0
            if early_stop_count > args.patience:
                print("early stopping at epoch %d"%(epoch))
                break


if __name__ == "__main__":
   main()
