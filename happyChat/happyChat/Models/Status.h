//
//  Status.h
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject

// 发布人名字
@property (nonatomic, strong) NSString *userName;
// 发布文字内容
@property (nonatomic, strong) NSString *content;
// 发布图片
@property (nonatomic, strong) NSArray *picArray;
// 地址
@property (nonatomic, strong) NSString *address;
// 类型 （广场还是朋友圈）
@property (nonatomic, strong) NSString *type;

@end
