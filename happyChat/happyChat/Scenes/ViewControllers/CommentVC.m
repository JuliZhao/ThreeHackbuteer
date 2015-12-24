//
//  CommentVC.m
//  happyChat
//
//  Created by zy on 15/12/10.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "CommentVC.h"
#import "HomeDetailTVC.h"

@interface CommentVC ()

@property (nonatomic, retain) AVObject *obj;
@property (weak, nonatomic) IBOutlet UITextView *tv4comment;
- (IBAction)action4Comment:(UIButton *)sender;

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 点击试图空白处回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tv4comment resignFirstResponder];
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

- (IBAction)action4Comment:(UIButton *)sender {
    if (_tv4comment.text.length) {
        // 文字存储
        NSString *str = _tv4comment.text;
        AVUser *currentUser = [AVUser currentUser];
        NSString *nameStr = currentUser.username;
        
        self.obj = [AVObject objectWithClassName:@"commentClass"];
        [_obj setObject:str forKey:@"comment"];
        [_obj setObject:nameStr forKey:@"allUser"];
        [_obj setObject:_objectId forKey:@"statusId"];
        
        [_obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论内容不能为空" preferredStyle:0];
        UIAlertAction *def = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:def];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
