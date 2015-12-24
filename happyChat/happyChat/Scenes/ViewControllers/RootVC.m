//
//  RootVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "RootVC.h"
#import "TabBarVC.h"
#import "Helper.h"

@interface RootVC ()
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLab;
@property (strong, nonatomic) IBOutlet UIButton *hangBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[Helper sharedHelper] getImg];
    [self getSignature];
}

-(void) getSignature{
    // 检索用户数据
    
    AVQuery *fileQuery = [AVFile query];
    [fileQuery orderByDescending:@"craetedAt"];
    [fileQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.png", [AVUser currentUser].objectId]];
    AVFile *object = [AVFile fileWithAVObject:[fileQuery getFirstObject]];
    if (object.url) {
        [_userImg sd_setImageWithURL:[NSURL URLWithString:object.url]];
    }else {
        _userImg.image = [UIImage imageNamed:[self getImg]];
    }
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 判断是否有用户登录
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        // 允许用户使用应用
        self.hangBtn.hidden = YES;
        self.loginBtn.hidden = YES;
        self.registerBtn.hidden = YES;
        self.welcomeLab.hidden = NO;
        self.userImg.hidden = NO;
        // 延迟一秒执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            TabBarVC *tabVC = [TabBarVC sharedTabBarVC];
            [self showDetailViewController:tabVC sender:nil];
        });
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        self.hangBtn.hidden = NO;
        self.loginBtn.hidden = NO;
        self.registerBtn.hidden = NO;
        self.welcomeLab.hidden = YES;
        self.userImg.hidden = YES;
    }
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
