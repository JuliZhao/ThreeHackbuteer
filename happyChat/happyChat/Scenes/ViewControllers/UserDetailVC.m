//
//  UserDetailVC.m
//  happyChat
//
//  Created by zy on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "UserDetailVC.h"
#import "User.h"
#import "LoginVC.h"

#define kWidth [UIScreen mainScreen].bounds.size.width/2.0

@interface UserDetailVC ()
@property (strong, nonatomic) IBOutlet UIImageView *userImgView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLab;
@property (strong, nonatomic) IBOutlet UILabel *userSignatureLab;
@property (strong, nonatomic) IBOutlet UILabel *fansLab;
@property (strong, nonatomic) IBOutlet UILabel *likeLab;
@property (weak, nonatomic) IBOutlet UILabel *genderLab;
@property (weak, nonatomic) IBOutlet UILabel *birLab;

@property (nonatomic, assign) BOOL isExist;
@property (strong, nonatomic) IBOutlet UIButton *followOrNot;

- (IBAction)back:(UIButton *)sender;
- (IBAction)addFriend:(UIButton *)sender;

@end

@implementation UserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.userImgView.layer.cornerRadius = self.view.frame.size.width*0.25;
    self.usernameLab.text = self.likeFriend.username;
    [self getFriendObjectId];
    if (_imgStr) {
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:_imgStr]];
    }else{
        self.userImgView.image = [UIImage imageNamed:[self getImg]];
    }
    if (_labText) {
        self.userSignatureLab.text = _labText;
    }
    if (_genderStr) {
        self.genderLab.text = [NSString stringWithFormat:@"性别 : %@", _genderStr];
    }
    if (_birText) {
        self.birLab.text = [NSString stringWithFormat:@"生日 : %@", _birText];
    }
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

-(void) getFriendObjectId {
    [self judgeIsExist];
    [self.likeFriend getFollowersAndFollowees:^(NSDictionary *dict, NSError *error) {
        NSArray *followers=dict[@"followers"];
        self.fansLab.text = [NSString stringWithFormat:@"粉丝 : %ld", (unsigned long)followers.count];
        NSArray *followees=dict[@"followees"];
        self.likeLab.text = [NSString stringWithFormat:@"关注 : %ld", (unsigned long)followees.count];
    }];
}

-(void)judgeIsExist{
    //关注列表查询
    AVQuery *query= [AVUser followeeQuery:[AVUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                if ([objects containsObject:self.likeFriend]) {
                    self.isExist = YES;
                    [self.followOrNot setTitle:@"取消关注" forState:(UIControlStateNormal)];
                }else {
                    self.isExist = NO;
                    [self.followOrNot setTitle:@"关注" forState:(UIControlStateNormal)];
                }
            }
        }
    }];
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

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFriend:(UIButton *)sender {
    if ([AVUser currentUser]) {
        if (_isExist) {
            //取消关注
            [[AVUser currentUser] unfollow:self.likeFriend.objectId andCallback:^(BOOL succeeded, NSError *error) {
                [self getFriendObjectId];
            }];
            [sender setTitle:@"关注" forState:(UIControlStateNormal)];
            _isExist = NO;
            
        }else{
            //关注
            [[AVUser currentUser] follow:self.likeFriend.objectId andCallback:^(BOOL succeeded, NSError *error) {
                [self getFriendObjectId];
            }];
            [sender setTitle:@"取消关注" forState:(UIControlStateNormal)];
            _isExist = YES;
        }
    }else {
        //创建alert
        UIAlertController *returnAlert = [UIAlertController alertControllerWithTitle:@"您还没有登陆?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        //确定点击事件
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"登陆" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            UINavigationController *vc = [LoginVC sharedLoginVC];
            [self showDetailViewController:vc sender:nil];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [returnAlert addAction:yes];
        [returnAlert addAction:no];
        
        [self presentViewController:returnAlert animated:yes completion:nil];
    }
}
@end
