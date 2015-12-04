//
//  OtherCell.m
//  happyChat
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "OtherCell.h"

@implementation OtherCell

- (void)awakeFromNib {
    // Initialization code
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
