//
//  Helper.h
//  happyChat
//
//  Created by zy on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

@property (nonatomic, strong) NSMutableDictionary *userImgDic;
@property (nonatomic, strong) NSMutableDictionary *signatureDic;

+(Helper *)sharedHelper;

-(void) getImg;

@end
