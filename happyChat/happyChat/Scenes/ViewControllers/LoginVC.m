//
//  LoginVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "LoginVC.h"
#import "TabBarVC.h"

@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *userPswTF;
- (IBAction)action4Login:(UIButton *)sender;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
//登陆
- (IBAction)action4Login:(UIButton *)sender {
    [AVUser logInWithUsernameInBackground:_userNameTF.text password:_userPswTF.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"登陆成功");
            TabBarVC *tabVC = [TabBarVC sharedTabBarVC];
            [self showDetailViewController:tabVC sender:nil];
        } else {
            NSLog(@"登录失败:%@",error);
        }
    }];

    
    
}
@end
