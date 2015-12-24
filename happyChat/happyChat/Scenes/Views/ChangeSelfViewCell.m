//
//  ChangeSelfViewCell.m
//  happyChat
//
//  Created by 钱鹏 on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ChangeSelfViewCell.h"

@implementation ChangeSelfViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 25;
    self.headImg.contentMode = UIViewContentModeScaleToFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
