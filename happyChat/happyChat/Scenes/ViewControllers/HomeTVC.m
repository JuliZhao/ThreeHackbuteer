//
//  HomeTVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "HomeTVC.h"
#import "PushCell.h"
#import "Status.h"
#import "HomeDetailTVC.h"
#import "PushVC.h"
#import "TabBarVC.h"
#import "ChangeImageVC.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface HomeTVC ()

@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *array;
- (IBAction)btn4Reload:(UIButton *)sender;

@property (nonatomic, strong) NSMutableDictionary *headImgDic;
@property (nonatomic, strong) UIView *reloadView;

@end

@implementation HomeTVC

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self.tabBarController.tabBar setHidden:NO];
    [self readStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PushCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pushCell"];
    [self getSignature];
}

-(void) getSignature{
    // 检索用户数据
    AVQuery *query1 = [AVUser query];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVUser *user in objects) {
                AVQuery *fileQuery = [AVFile query];
                [fileQuery orderByDescending:@"craetedAt"];
                [fileQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.png", user.objectId]];
                AVFile *object = [AVFile fileWithAVObject:[fileQuery getFirstObject]];
                if (object.url) {
                    [self.headImgDic setObject:object.url forKey:user.objectId];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

-(NSMutableDictionary *)headImgDic{
    if (!_headImgDic) {
        _headImgDic = [NSMutableDictionary dictionary];
    }
    return _headImgDic;
}

-(void) readStatus{
    if (_array.count) {
        [_array removeAllObjects];
    }
    
    [LeanCloudDBHelper findAllWithClassName:@"push" HasArrayKey:nil Return:^(id result) {
        if (result) {
            for (AVObject *objc in result) {
                // 读取内容
                NSString *str = [objc objectForKey:@"content"];
                // 读取发布时间
                NSDate *date = [objc objectForKey:@"createdAt"];
                // 读取图片
                AVFile *attachment2 = [objc objectForKey:@"picture"];
                NSData *imageData = [attachment2 getData];
                UIImage *image = [[UIImage alloc]initWithData:imageData];
                // 读取用户名
                NSString *nameStr = [objc objectForKey:@"allUser"];
                // 读取userId
                NSString *userId = [objc objectForKey:@"userId"];
                // 读取objectId
                NSString *objectId = [objc objectForKey:@"objectId"];
                NSLog(@"状态objectId:%@",objectId);
                
                // model赋值
                self.status = [[Status alloc] initWithUserName:nameStr content:str picArray:@[image] address:@"bb" pushTime:date userImage:@"1.jpg" type:@"dd" objectId:objectId userId:userId];
                
                [self.array addObject:_status];
                self.dataArray = [NSMutableArray arrayWithArray:_array];
            }
            [self removeView];
            [self.tableView reloadData];
        }
    }];
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    
}
// cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PushCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.status = _dataArray[indexPath.row];
    [cell setStatus:_status];
    
    // 图片放大
    cell.myBlockPic = ^(UIImage *pic) {
        ChangeImageVC *change = [[ChangeImageVC alloc] init];
        change.picture = pic;
        [self presentViewController:change animated:YES completion:nil];
    };

    // 分享
    cell.myBlockStr = ^(NSString *str,NSString *nameStr,UIImage *pic) {
        NSLog(@"content的内容：%@",str);
        UINavigationController *nav = self.tabBarController.viewControllers[2];
        PushVC *pc =  nav.viewControllers[0];
        pc.content = str;
        pc.userName = nameStr;
        pc.picture = pic;
        self.tabBarController.selectedIndex = 2;
        
    };
    // 评论
    cell.myBlock1 = ^() {
        NSLog(@"评论");
        HomeDetailTVC *homeDetailTVC = [[HomeDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
        
        self.status = _dataArray[indexPath.row];
        homeDetailTVC.statusModel = _status;
        
        [self.navigationController pushViewController:homeDetailTVC animated:YES];

    };
    // 点赞
//    typeof (cell)temp = cell;
//    cell.myBlock2 = ^() {
//        temp.praise.imageView.image = [UIImage imageNamed:@"已赞"];
//    };
    
    // 设置头像
    if (_headImgDic[_status.userId]) {
        [cell.userImg sd_setImageWithURL:[NSURL URLWithString:_headImgDic[_status.userId]]];
    }else {
        cell.userImg.image = [UIImage imageNamed:[self getImg]];
    }
    
    // 根据文本内容调整content高度
    cell.contentHeight.constant = [self textHeight:_status.content];
    
    return cell;
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailTVC *homeDetailTVC = [[HomeDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
    
    self.status = _dataArray[indexPath.row];
    homeDetailTVC.statusModel = _status;
    
    [self.navigationController pushViewController:homeDetailTVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 根据信息多少调整cell的高度（正常：263）
    return [self textHeight:_status.content] + 240;
}

// 自定义content高度
- (CGFloat)textHeight:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(Width - 22, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    // 返回计算好的高度
    return rect.size.height + 10;
}

// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

-(void) removeView{
    [_reloadView removeFromSuperview];
}

-(void) setAView{
    self.reloadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
    lab.backgroundColor = [UIColor lightGrayColor];
    lab.text = @"正在加载";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [_reloadView addSubview:lab];
    [self.view addSubview:_reloadView];
}

// 刷新
- (IBAction)btn4Reload:(UIButton *)sender {
    [self setAView];
    [self readStatus];
}


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
