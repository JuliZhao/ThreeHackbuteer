//
//  ChangeSelfView.h
//  happyChat
//
//  Created by 钱鹏 on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BirthdayView.h"


@interface ChangeSelfView : UITableViewController<BirthdayViewDelegate>
//存放生日
@property (nonatomic,retain) NSString *birthStr;

@end
