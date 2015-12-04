//
//  TabBarVC.m
//  happyChat
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "TabBarVC.h"
#import "HomeTVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

static TabBarVC *tabVC = nil;
+(instancetype)sharedTabBarVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        tabVC = [sb instantiateViewControllerWithIdentifier:@"tabBar"];
    });
    return tabVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
