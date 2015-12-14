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
    AVQuery *query1 = [AVQuery queryWithClassName:@"UserDetail"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *obj in objects) {
                NSString *str = [obj objectForKey:@"userSignature"];
                [self.signatureDic setObject:str forKey:obj[@"userId"]];
                AVQuery *fileQuery = [AVFile query];
                [fileQuery orderByDescending:@"craetedAt"];
                [fileQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.png", obj[@"userId"]]];
                AVFile *object = [AVFile fileWithAVObject:[fileQuery getFirstObject]];
                [self.userImgDic setObject:object.url forKey:obj[@"userId"]];
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
