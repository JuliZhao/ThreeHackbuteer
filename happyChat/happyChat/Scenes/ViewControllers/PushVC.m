//
//  PushVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "PushVC.h"
#import "LoginVC.h"

@interface PushVC () <UIImagePickerControllerDelegate>

- (IBAction)pushStatus:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@property (nonatomic, retain) AVObject *obj;
@property (weak, nonatomic) IBOutlet UITextView *tv4content;

- (IBAction)btn4picture:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation PushVC

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
    if (_content) {
        NSString *str = [NSString stringWithFormat:@"【转发自】%@ // %@",_userName,_content];
        self.tv4content.text = str;
        self.imgView.image = _picture;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
}

// 点击试图空白处回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tv4content resignFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imgView.image = img;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushStatus:(UIButton *)sender {
    if ([AVUser currentUser]) {
        
        // 当文字照片为空时，不能发送
        if (self.tv4content.text == nil || [self.tv4content.text isEqualToString: @""] || self.imgView.image == nil || [self.imgView.image isEqual: @""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"文字照片不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
            //确定点击事件
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        // 文字存储
        NSString *str = _tv4content.text;
        AVUser *currentUser = [AVUser currentUser];
        NSString *userId = currentUser.objectId;
        NSString *nameStr = currentUser.username;
        
        UIImage *testImg = _imgView.image;
        //图片储存
        NSData *imageData = UIImagePNGRepresentation(testImg);
        AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                self.obj = [AVObject objectWithClassName:@"push"];
                [_obj setObject:userId forKey:@"userId"];
                [_obj setObject:str forKey:@"content"];
                [_obj setObject:imageFile forKey:@"picture"];
                [_obj setObject:nameStr forKey:@"allUser"];
                [_obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"%@",error);
                    }
                }];
            }
        }];
        // 成功发送后输入框置为nil
        _tv4content.text = nil;
        _imgView.image = nil;
        _content = nil;
        _picture = nil;
        self.tabBarController.selectedIndex = 0;
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

- (IBAction)back:(UIButton *)sender {
    // 取消发送后输入框置为nil
    _tv4content.text = nil;
    _imgView.image = nil;
    _content = nil;
    _picture = nil;
    self.tabBarController.selectedIndex = 0;
}

// btn -- 添加图片
- (IBAction)btn4picture:(UIButton *)sender {
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pic.allowsEditing = YES;
    pic.delegate = self;
    [self presentViewController:pic animated:YES completion:nil];
}
@end
