//
//  PushCell.h
//  happyChat
//
//  Created by zy on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

typedef void (^Block)();
typedef void (^BlockStr)(NSString *str,NSString *nameStr,UIImage *pic);
typedef void (^BlockPic)(UIImage *pic);

@interface PushCell : UITableViewCell

@property (copy, nonatomic) Block myBlock1;
@property (copy, nonatomic) Block myBlockStr;
@property (copy, nonatomic) Block myBlockPic;

@property (nonatomic, retain) Status *status;
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *pushTimeLab;
@property (strong, nonatomic) IBOutlet UIView *pushImgView;
// 文本高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;


@end
