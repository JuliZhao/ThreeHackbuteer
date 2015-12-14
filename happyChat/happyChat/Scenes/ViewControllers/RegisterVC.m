//
//  RegisterVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *pswTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;

- (IBAction)action4Register:(UIButton *)sender;
- (IBAction)action4Back:(UIButton *)sender;
- (IBAction)textSecureAction:(UIButton *)sender;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _pswTF.secureTextEntry = YES;
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
//注册
- (IBAction)action4Register:(UIButton *)sender {
    AVUser *user = [AVUser user];
    user.username = _nameTF.text;
    user.password =  _pswTF.text;
    user.email = _emailTF.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"注册失败:%@",error);
        }
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.nameTF.text = nil;
    self.emailTF.text = nil;
    self.pswTF.text = nil;
}

- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textSecureAction:(UIButton *)sender {
    if (_pswTF.secureTextEntry == NO) {
        [sender setImage:[UIImage imageNamed:@"闭眼.png"] forState:UIControlStateNormal];
        _pswTF.secureTextEntry = YES;
    }else{
        [sender setImage:[UIImage imageNamed:@"睁眼.png"] forState:UIControlStateNormal];
        _pswTF.secureTextEntry = NO;
    }
}
@end
