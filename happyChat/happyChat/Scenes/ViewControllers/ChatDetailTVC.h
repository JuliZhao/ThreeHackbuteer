//
//  ChatDetailTVC.h
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVUser.h"

@interface ChatDetailTVC : UITableViewController

@property (nonatomic,strong) NSString *targetClientId;
@property (nonatomic,strong) AVUser * chater;

@end
