//
//  PushDetailCell.h
//  happyChat
//
//  Created by zy on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

typedef void (^BlockPic)();

@interface PushDetailCell : UITableViewCell

@property (nonatomic, copy) BlockPic myBlockPic;

@property (nonatomic, strong) Status *status;
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *pushTimeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
