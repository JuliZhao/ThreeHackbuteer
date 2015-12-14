//
//  User.h
//  happyChat
//
//  Created by zy on 15/12/2.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
// 用户名
@property (nonatomic, strong) NSString *name;
// 头像
@property (nonatomic, strong) UIImage *userImage;

-(instancetype)initWithName:(NSString *)name
                                  userImage:(UIImage *)userImage;

@end
