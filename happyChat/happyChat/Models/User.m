//
//  User.m
//  happyChat
//
//  Created by zy on 15/12/2.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "User.h"

@implementation User

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(instancetype)initWithName:(NSString *)name userImage:(UIImage *)userImage{
    if ([self init]) {
        self.name = name;
        self.userImage = userImage;
    }
    return self;
}

@end
