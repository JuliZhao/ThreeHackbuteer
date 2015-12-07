//
//  MyCell.h
//  happyChat
//
//  Created by zy on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *myContent;
@property (strong, nonatomic) IBOutlet UIImageView *myImg;
@property (nonatomic, strong) AVIMMessage *message;

@end
