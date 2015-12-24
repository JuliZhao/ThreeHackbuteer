//
//  FriendCell.h
//  happyChat
//
//  Created by zy on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *textLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;

@end
