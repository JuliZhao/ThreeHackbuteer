//
//  BirthdayView.h
//  happyChat
//
//  Created by 钱鹏 on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BirthdayViewDelegate <NSObject>

- (void)birthday:(NSString *) passage;

@end

@interface BirthdayView : UIViewController

@property (nonatomic, assign) id<BirthdayViewDelegate> delegate;

@end
