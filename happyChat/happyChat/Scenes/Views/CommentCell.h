//
//  CommentCell.h
//  happyChat
//
//  Created by zy on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Comment;

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) Comment *comment;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lab4Name;
@property (weak, nonatomic) IBOutlet UILabel *lab4Content;

@end
