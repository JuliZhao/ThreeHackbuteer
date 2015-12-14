//
//  Comment.m
//  happyChat
//
//  Created by zy on 15/12/2.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithComName:(NSString *)comName
                        content:(NSString *)content
                       statusId:(NSString *)statusId
                         comImg:(NSString *)comImg {
    if ([super init]) {
        self.comName = comName;
        self.content = content;
        self.statusId = statusId;
        self.comImg = comImg;
    }
    return self;
}

@end
