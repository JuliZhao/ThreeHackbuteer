//
//  Comment.h
//  happyChat
//
//  Created by zy on 15/12/2.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

// 那条状态的评论
@property (nonatomic, strong) NSString *statusId;
// 是回复还是评论
@property (nonatomic, strong) NSString *type;
// 评论内容
@property (nonatomic, strong) NSString *content;
// 评论人名字
@property (nonatomic, strong) NSString *comName;

@end
