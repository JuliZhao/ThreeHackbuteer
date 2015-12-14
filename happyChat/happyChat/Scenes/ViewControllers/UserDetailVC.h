//
//  UserDetailVC.h
//  happyChat
//
//  Created by zy on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserDetailVC : UIViewController
// 传过来的好友
@property (nonatomic, strong) AVUser *likeFriend;
@property (nonatomic, strong) NSString *imgStr;
@property (nonatomic, strong) NSString *labText;

@end
