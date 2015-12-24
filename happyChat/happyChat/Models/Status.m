//
//  Status.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "Status.h"

@implementation Status

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithUserName:(NSString *)name content:(NSString *)content picArray:(NSArray *)picArray address:(NSString *)address pushTime:(NSDate *)pushTime userImage:(NSString *)userImage type:(NSString *)type objectId:(NSString *)objectId userId:(NSString *)userId{
    if ([super init]) {
        self.userName = name;
        self.content = content;
        self.picArray = picArray;
        self.type = type;
        self.pushTime = pushTime;
        self.userImage = userImage;
        self.address = address;
        self.objectId = objectId;
        self.userId = userId;
    }
    return self;
}


@end
