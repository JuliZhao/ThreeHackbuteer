//
//  PushCell.m
//  happyChat
//
//  Created by zy on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "PushCell.h"
#import "TabBarVC.h"
#import "Status.h"

@implementation PushCell

- (void)awakeFromNib {
    // Initialization code
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setStatus:(Status *)status {
    _status = status;
    // 发布内容
    self.contentLab.text = status.content;
    // 发布图片
    self.imgView.image = status.picArray.lastObject;
    // -----------------图片交互打开---------------
    self.imgView.userInteractionEnabled = YES;
    // 为图片添加tap手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.imgView addGestureRecognizer:tap];
    
    // 发布人
    self.userName.text = status.userName;
    // 发布时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
    self.pushTimeLab.text = [formatter stringFromDate:status.pushTime];
//    NSLog(@"=========%@   %@",status.pushTime, [status.pushTime class]);
}

// tap方法
- (void)tapAction:(UITapGestureRecognizer *)sender {
    _myBlockPic(_status.picArray.lastObject);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pushAction:(UIButton *)sender {
    _myBlockStr(_status.content,_status.userName,_status.picArray.lastObject);

}
- (IBAction)commentAction:(UIButton *)sender {
    self.myBlock1();
}
- (IBAction)goodAction:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"已赞"] forState:(UIControlStateNormal)];
}

@end
