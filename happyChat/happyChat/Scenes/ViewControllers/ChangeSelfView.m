//
//  ChangeSelfView.m
//  happyChat
//
//  Created by 钱鹏 on 15/12/8.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ChangeSelfView.h"
#import "ChangeSelfViewCell.h"
#import "ChangeSelfViewCell2.h"
#import "BirthdayView.h"

@interface ChangeSelfView ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,retain) NSArray *selfArray;
//存放姓名
@property (nonatomic,retain) UITextField *nameField;
//存放性别
@property (nonatomic,retain) NSString *genderString;
// 存放个性签名
@property (nonatomic, retain) UITextField *signatureTV;

@property (nonatomic,retain) AVFile *userAV;
@property (nonatomic,retain) NSData *userImgData;

@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *userGender;
@property (nonatomic,retain) NSString *userDate;
@property (nonatomic,retain) UIImage *userImg;
@property (nonatomic, retain) NSString *userSignature;
@property (nonatomic,retain) AVFile *imageFile;

@end

@implementation ChangeSelfView
int Tag;
- (void)viewWillAppear:(BOOL)animated{
    [self getUserDetail];
    Tag = 0;
}

-(void) getUserDetail{
    //检索用户数据
    AVQuery *query = [AVQuery queryWithClassName:@"UserDetail"];
    [query whereKey:@"userId" equalTo:[AVUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *obj = objects.lastObject;
            NSLog(@"%@", obj);
            self.userName = [obj objectForKey:@"userName"];
            self.userGender = [obj objectForKey:@"userGender"];
            self.userDate = [obj objectForKey:@"userBirthday"];
            self.userAV = [obj objectForKey:@"userHeadImg"];
            self.userImgData = [_userAV getData];
            
            self.userSignature = [obj objectForKey:@"userSignature"];
            [self.tableView reloadData];
        }
    }];
    
    NSLog(@"%@",[AVUser currentUser].objectId);
    NSLog(@"%@",_userName);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(save:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangeSelfViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"changeCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangeSelfViewCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"changeCell2"];
    
    self.selfArray = @[@"头像",@"用户名",@"性别",@"生日", @"个性签名", @"注销"];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(Return:)];
    [self.navigationItem setLeftBarButtonItem:left];
    
}

- (void)Return:(UIBarButtonItem *)sender{
    if (Tag == 0) {
        //创建alert
        UIAlertController *returnAlert = [UIAlertController alertControllerWithTitle:@"您还没有保存,确认返回?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        //确定点击事件
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [returnAlert addAction:yes];
        [returnAlert addAction:no];
        
        [self presentViewController:returnAlert animated:yes completion:nil];
        
    }else
        
        [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat weight = [UIScreen mainScreen].bounds.size.width;
    //头像的内容
    if (indexPath.row == 0) {
    ChangeSelfViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headLabel.text = _selfArray[indexPath.row];
        // cell的辅助样式:右边出现一个小箭头
        cell.accessoryType =  UITableViewCellStyleValue1;
        //头像
        if (_userImg == nil) {
            if (_userImgData == nil) {
                cell.headImg.image = [UIImage imageNamed:@"用户.png"];
            }else {
                cell.headImg.image = [UIImage imageWithData:_userImgData];
            }
        }else {
            cell.headImg.image = _userImg;
        }

        return cell;
        
    }else{
        ChangeSelfViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"changeCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headLabel.text = _selfArray[indexPath.row];
        cell.endLabel.font = [UIFont systemFontOfSize:13];
        cell.endLabel.textColor = [UIColor grayColor];
//        cell.endLabel.textAlignment = NSTextAlignmentCenter;
        //名字
        if (indexPath.row == 1) {
            if (_nameField.text == nil) {
                
                if (_userName == nil) {
                    cell.endLabel.text = @"无";
                }else{
                    cell.endLabel.text = _userName;
                }
                
            }else{
                cell.endLabel.text = _nameField.text;
            }
     }
        //性别
        if (indexPath.row == 2) {
                            if (_genderString == nil) {
                                if (_userGender == nil) {
                                    cell.endLabel.text = @"男";
                                }else{
                                    cell.endLabel.text = _userGender;
                                }
                            }else if ([_genderString isEqualToString:@"女"]){
                                cell.endLabel.text = _genderString;
                            }else{
                                cell.endLabel.text = _genderString;
                            }
            
        }
        
        //生日
        if (indexPath.row == 3) {
            if (_birthStr == nil) {
                if (_userDate == nil) {
                    
                    cell.endLabel.text = @"2000-00-00";
                }else {
                    cell.endLabel.text = _userDate;
                }
            }else{
                cell.endLabel.text = _birthStr;
            }
        }
        // 个性签名
        if (indexPath.row == 4) {
            if (_signatureTV.text == nil) {
                if (_userSignature == nil) {
                    cell.endLabel.text = @"无";
                }else{
                    cell.endLabel.text = _userSignature;
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                }
                
            }else{
                cell.endLabel.text = _signatureTV.text;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
            }
        }
        // 注销
        if (indexPath.row == 5) {
            cell.endLabel.hidden = YES;
            cell.headLabel.hidden = YES;
            cell.logOut.hidden = NO;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //给头像添加点击事件
    if (indexPath.row == 0) {
        UIImagePickerController *pic = [[UIImagePickerController alloc]init];
        
        pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pic.allowsEditing = YES;
        pic.delegate = self;
        
        [self presentViewController:pic animated:YES completion:nil];
    }

    //给修改姓名添加点击事件
    if (indexPath.row == 1) {
        //创建alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改名称" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        // 添加TextField
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"用户名";
            self.nameField = textField;
        }];
        //确定点击事件
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",_nameField.text);
            [self.tableView reloadData];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            self.nameField.text = _userName;
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:sure];
        
        // 添加视图
        [self presentViewController:alert animated:YES completion:nil];
        
    }
//    ------------------------------------
    // 更改签名
    if (indexPath.row == 4) {
        //创建alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改签名" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        // 添加TextView
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"个性签名";
            self.signatureTV = textField;
        }];
        //确定点击事件
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",_signatureTV.text);
            [self.tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:sure];
        
        // 添加视图
        [self presentViewController:alert animated:YES completion:nil];
    }
    
//---------------------------------------------------------------
    //修改性别
    if (indexPath.row == 2) {
        //创建alert
        UIAlertController *genderAlert = [UIAlertController alertControllerWithTitle:@"修改性别" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        //确定点击事件
        UIAlertAction *Man = [UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            _genderString = @"男";
            NSLog(@"%@",_genderString);
            [self.tableView reloadData];
        }];
        
        //否认
        UIAlertAction *Woman = [UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            _genderString = @"女";
            NSLog(@"%@",_genderString);
            [self.tableView reloadData];
        }];
        
        [genderAlert addAction:Man];
        [genderAlert addAction:Woman];
        
        // 添加视图
        [self presentViewController:genderAlert animated:YES completion:nil];

        
    }
//--------------------------------------------------------------
    //修改生日
    if (indexPath.row == 3) {
        
        BirthdayView *birVC = [[BirthdayView alloc]init];
        

        CATransition *transition = [CATransition animation];
        [transition setSubtype:kCATransitionFromTop];
        [self.navigationController pushViewController:birVC animated:NO];//必须设置为no，动画才有效
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        //设置代理
        birVC.delegate = self;
        
    }
    
//    ---------------------------------------------------------------
    // 注销
    if (indexPath.row == 5) {
        [AVUser logOut];  //清除缓存用户对象
        [self.navigationController popViewControllerAnimated:NO];
    }
}


// 协议方法选择结束之后执行
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.userImg = img;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    NSLog(@"%@",img);
}




- (void)birthday:(NSString *)passage{
    _birthStr = passage;
    [self.tableView reloadData];
    NSLog(@"%@",_birthStr);
}

- (void)save:(UIBarButtonItem *)sender {
    //创建alert
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"是否保存" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //储存图像
        if (_userImg != nil) {
            UIImage *image = _userImg;
            NSData *imageData = UIImagePNGRepresentation(image);
            NSString *str = [NSString stringWithFormat:@"%@.png", [AVUser currentUser].objectId];
            self.imageFile = [AVFile fileWithName:str data:imageData];
            [_imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                // 成功或失败处理...
                if (succeeded) {
                    NSLog(@"数据处理成功");
                }else {
                    NSLog(@"处理失败:%@",error);
                }
                
            }];
            
        }
        
        //保存用户信息
        AVObject *userObject = [AVObject objectWithClassName:@"UserDetail"];
        [userObject setObject:_nameField.text forKey:@"userName"];
        [userObject setObject:_genderString forKey:@"userGender"];
        [userObject setObject:_birthStr forKey:@"userBirthday"];
        [userObject setObject:[AVUser currentUser].objectId forKey:@"userId"];
        [userObject setObject:_imageFile forKey:@"userHeadImg"];
        [userObject setObject:_signatureTV.text  forKey:@"userSignature"];
        //        [userObject save];
        [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if (_nameField.text == nil) {
                    [userObject setObject:_userName forKey:@"userName"];
                }
                if (_genderString == nil) {
                    [userObject setObject:_userGender forKey:@"userGender"];
                }
                if (_birthStr == nil) {
                    [userObject setObject:_userDate forKey:@"userBirthday"];
                }
                if (_userImg == nil) {
                    
                    [userObject setObject:_userAV forKey:@"userHeadImg"];
                }
                if (_signatureTV.text == nil) {
                    [userObject setObject:_userSignature forKey:@"userSignature"];
                }
                
                [userObject saveInBackground];
                //保存前删除
                AVQuery *query = [AVQuery queryWithClassName:@"UserDetail"];
                [query whereKey:@"userId" equalTo:[AVUser currentUser].objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects.count > 1) {
                            [objects.firstObject deleteInBackground];
                        }
                    }
                }];

                
                NSLog(@"保存成功");
                [userObject refresh];
                Tag = 1;
                // post 保存成功
            } else {
                // 保存 post 时出错
                NSLog(@"错悟:%@",error);
            }
        }];
    }];
    
    [saveAlert addAction:cancelAction];
    [saveAlert addAction:defaultAction];
    
    // 添加视图
    [self presentViewController:saveAlert animated:YES completion:nil];
    
}
//- (void)alertTextFieldDidChange:(NSNotification *)notification{
//    
//    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
//    if (alertController) {
//        
//        // 下标为1 的是添加了监听事件 也是最后一个AlertController.textField.lastObject
//        
//        UITextField *lisen = alertController.textFields[1];
//        // 限制，如果lisen输入的长度要限制在5个字以内，否则不允许点击默认Default键
//        // 当UITextField输入字数超过5个 是按钮变为灰色 enabled为NO
//        UIAlertAction *action = alertController.actions.lastObject;
//        action.enabled = lisen.text.length > 5;
//        
//    }
//}

//- (void)viewWillAppear:(BOOL)animated{
//    [self.tableView reloadData];
//}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
