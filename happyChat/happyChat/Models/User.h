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
// 密码
@property (nonatomic, strong) NSString *psw;

@end
