//
//  CommentCell.m
//  happyChat
//
//  Created by zy on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"

@implementation CommentCell

- (void)setComment:(Comment *)comment {
    _comment = comment;
    self.imgView.image = [UIImage imageNamed:comment.comImg];
    self.lab4Name.text = comment.comName;
    self.lab4Content.text = comment.content;
}

- (void)awakeFromNib {
    // Initialization code
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
