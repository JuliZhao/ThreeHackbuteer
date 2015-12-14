//
//  PushDetailCell.m
//  happyChat
//
//  Created by zy on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "PushDetailCell.h"
#import "Status.h"

@implementation PushDetailCell

- (void)setStatus:(Status *)status {
    // 发布内容
    self.contentLab.text = status.content;
    // 发布图片
    self.imgView.image = status.picArray.lastObject;
    // 发布人
    self.userName.text = status.userName;
    // 发布时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
    self.pushTimeLab.text = [formatter stringFromDate:status.pushTime];
    
}


- (void)awakeFromNib {
    // Initialization code
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
