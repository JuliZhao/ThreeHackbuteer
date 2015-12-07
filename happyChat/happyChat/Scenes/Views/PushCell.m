//
//  PushCell.m
//  happyChat
//
//  Created by zy on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "PushCell.h"
#import "TabBarVC.h"

@implementation PushCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)pushAction:(UIButton *)sender {
    TabBarVC *tab = [TabBarVC sharedTabBarVC];
    tab.selectedIndex = 2;
}
- (IBAction)commentAction:(UIButton *)sender {
    self.myBlock1();
}
- (IBAction)goodAction:(UIButton *)sender {
    self.myBlock2();
}

@end
