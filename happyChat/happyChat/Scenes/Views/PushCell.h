//
//  PushCell.h
//  happyChat
//
//  Created by zy on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Block)();

@interface PushCell : UITableViewCell

@property (copy, nonatomic) Block myBlock1;
@property (copy, nonatomic) Block myBlock2;

@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *pushTimeLab;
@property (strong, nonatomic) IBOutlet UIView *pushImgView;

@end
