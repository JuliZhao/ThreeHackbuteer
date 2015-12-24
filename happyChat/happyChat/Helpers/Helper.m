//
//  Helper.m
//  happyChat
//
//  Created by zy on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "Helper.h"

@implementation Helper
static Helper *helper = nil;
+(Helper *)sharedHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[Helper alloc]init];
    });
    return helper;
}

-(void)getImg{
    // 检索用户数据
    AVQuery *query1 = [AVUser query];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVUser *user in objects) {
                AVQuery *fileQuery = [AVFile query];
                [fileQuery orderByDescending:@"craetedAt"];
                [fileQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.png", user.objectId]];
                AVFile *object = [AVFile fileWithAVObject:[fileQuery getFirstObject]];
                if (object.url) {
                    [self.userImgDic setObject:object.url forKey:user.objectId];
                }
            }
        }
    }];
}

-(NSMutableDictionary *) userImgDic{
    if (!_userImgDic) {
        _userImgDic = [NSMutableDictionary dictionary];
    }
    return _userImgDic;
}

-(NSMutableDictionary *) signatureDic{
    if (!_signatureDic) {
        _signatureDic = [NSMutableDictionary dictionary];
    }
    return _signatureDic;
}

@end
