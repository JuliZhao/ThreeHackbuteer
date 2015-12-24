//
//  LeanCloudDBHelper.h
//  URLencode
//
//  Created by 王冬 on 15/12/4.
//  Copyright © 2015年 王冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
typedef void  (^Callback)(BOOL result);
typedef void (^ReturnObject)(id result);

typedef enum {
    PhoneNumber = 0,
    UserName,
}LoginType;
@interface LeanCloudDBHelper : NSObject
@property(nonatomic, copy) ReturnObject returnResult;
/**
 *  增加记录/修改记录
 *  如果model存在则是修改记录，否则就是添加记录
 *
 *  @param className 添加/修改的表名
 *  @param model     保存的Model对象
 */
+ (void)saveObjectWithClassName:(NSString *)className Model:(id)model CallBack:(Callback)callback;

/**
 *  删除记录
 *
 *  @param className 表名
 *  @param objectId  要删除的对象的Id
 */
+ (void)deleteObjectWithClassName:(NSString *)className ObjectId:(NSString *)objectId CallBack:(Callback)callback;

/*************** 查询记录 *****************/
/**
 *  查询所有记录
 *
 *  @param className    表名
 */
+ (void)findAllWithClassName:(NSString *)className HasArrayKey:(NSString *)fileArrayKey Return:(ReturnObject)returnObject;

/**
 *  条件查询
 *
 *  @param className      表名
 *  @param conditionKey   条件名
 *  @param conditionValue 条件的值
 */
+ (void)findObjectWithClassName:(NSString *)className ConditionKey:(NSString *)conditionKey ConditionValue:(id)conditionValue HasArrayKey:(NSString *)fileArrayKey Return:(ReturnObject)returnObject;

/**
 *  获取记录个数
 *
 *  @param className      表名
 *  @param conditionKey   条件名
 *  @param conditionValue 条件值
 */
+ (void)getCountWithClassName:(NSString *)className ConditionKey:(NSString *)conditionKey ConditionValue:(id)conditionValue Return:(ReturnObject)returnObject;

/**
 *  sql语句查询
 *
 *  @param cql     sql语句
 */
- (void)findObjectWithCql:(NSString *)cql, ...;

/*************** 用户操作 *****************/
/**
 *  用户登录
 *
 *  @param type     登录方式 - 账号、电话
 *  @param value    登录的值
 *  @param pwd      密码
 */
+ (void)loginWithKey:(LoginType)type Value:(NSString *)value Pwd:(NSString *)pwd CallBack:(ReturnObject)callback;
@end
