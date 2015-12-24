//
//  LoginVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "LoginVC.h"
#import "TabBarVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *userPswTF;
- (IBAction)action4Login:(UIButton *)sender;
- (IBAction)textSecureAction:(UIButton *)sender;

@end

@implementation LoginVC

static UINavigationController *loginVC = nil;
+(UINavigationController *)sharedLoginVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        loginVC = [sb instantiateViewControllerWithIdentifier:@"loginNav"];
    });
    return loginVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userPswTF.secureTextEntry = YES;
    self.userNameTF.delegate = self;
    self.userPswTF.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(back:)];
}

// 点击试图空白处回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_userNameTF]) {
        [_userPswTF becomeFirstResponder];
    }else {
        [_userPswTF resignFirstResponder];
        [self action4Login:nil];
    }
    return YES;
}


-(void) back:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"登录失败:%@",error);
            NSString *str = [NSString stringWithFormat:@"详情:%@", error];
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"用户名或密码不正确" message:str preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            
            [errorAlert addAction:defaultAction];
            
            [self presentViewController:errorAlert animated:YES completion:nil];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.userPswTF.text = nil;
}

- (IBAction)textSecureAction:(UIButton *)sender {
    if (_userPswTF.secureTextEntry == NO) {
        [sender setImage:[UIImage imageNamed:@"闭眼.png"] forState:UIControlStateNormal];
        _userPswTF.secureTextEntry = YES;
    }else{
        [sender setImage:[UIImage imageNamed:@"睁眼.png"] forState:UIControlStateNormal];
        _userPswTF.secureTextEntry = NO;
    }
}
@end
