//
//  HomeDetailTVC.m
//  happyChat
//
//  Created by zy on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "HomeDetailTVC.h"
#import "PushDetailCell.h"
#import "CommentCell.h"
#import "Comment.h"
#import "Status.h"
#import "PushVC.h"
#import "CommentVC.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface HomeDetailTVC ()

@property (nonatomic, strong) Comment *comment;
@property (nonatomic, strong) NSMutableArray *accetpArray;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation HomeDetailTVC

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self.tabBarController.tabBar setHidden:YES];
    [self readStatus];
}

-(void) readStatus{
    if (_accetpArray.count) {
        [_accetpArray removeAllObjects];
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"commentClass"];
    [query whereKey:@"statusId" equalTo:_statusModel.objectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *objc in objects) {
                // 读取内容
                NSString *str = [objc objectForKey:@"comment"];
                // 读取用户名
                NSString *nameStr = [objc objectForKey:@"allUser"];
                // 读取objectId
                NSString *statusId = [objc objectForKey:@"statusId"];
//                NSLog(@"测试:%@",_statusModel.objectId);
//                NSLog(@"测试:%@",statusId);
                
                // model赋值
                self.comment = [[Comment alloc] initWithComName:nameStr content:str statusId:statusId comImg:@"用户"];
                [self.accetpArray addObject:_comment];
                self.commentArray = [NSMutableArray arrayWithArray:_accetpArray];
                
                [self.tableView reloadData];
            }
        }
        
        
    }];
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

- (void) segment {
    // 图片数组
    self.array = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"分享"],[UIImage imageNamed:@"评论"],[UIImage imageNamed:@"赞"], nil];
    // 1.创建并初始化
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:_array];
    // 2.设置属性
    segmentControl.frame = CGRectMake(0, Height-30-64, Width, 30);
    // tintColor
    segmentControl.tintColor = [UIColor lightGrayColor];
    // 设置在点击后是否恢复原样
    segmentControl.momentary = YES;
    // 添加事件
    [segmentControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];  // 必须使用ValueChanged
    // 3.添加到视图
    [self.view addSubview:segmentControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self segment];
    [self.tableView registerNib:[UINib nibWithNibName:@"PushDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pushDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentCell"];

}

// segmentClick:事件：点击不同的分段下标，随机改变颜色并且输出一句话
- (void)segmentClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        UINavigationController *nav = self.tabBarController.viewControllers[2];
        PushVC *pc =  nav.viewControllers[0];
        pc.content = _statusModel.content;
        pc.userName = _statusModel.userName;
        pc.picture = _statusModel.picArray.lastObject;
        self.tabBarController.selectedIndex = 2;
        
    } else if (sender.selectedSegmentIndex == 1) {
        CommentVC *ct = [[CommentVC alloc] init];
        ct.objectId = _statusModel.objectId;
        [self.navigationController pushViewController:ct animated:YES];
        
    } else {
        [self.array replaceObjectAtIndex:2 withObject:[UIImage imageNamed:@"已赞"]];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
// 分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _commentArray.count;
}
// cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PushDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushDetailCell" forIndexPath:indexPath];
        cell.status = _statusModel;
        // 根据文本内容调整content高度
        cell.contentHeight.constant = [self textHeight:_statusModel.content];
        cell.userImg.image = [UIImage imageNamed:[self getImg]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        self.comment = _commentArray[indexPath.row];
        [cell setComment:_comment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgView.image = [UIImage imageNamed:[self getImg]];
        return cell;
    }

}
// 自定义 -- 根据信息多少调整cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self textHeight:_statusModel.content] + 180;
    }
    return 80;
}

// 自定义content高度
- (CGFloat)textHeight:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(Width - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    // 返回计算好的高度
    return rect.size.height + 10;
}

// 设置分区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"正文";
    }
    return @"评论";
}
// 分区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return 15;
}
// 懒加载
- (NSMutableArray *)accetpArray {
    if (!_accetpArray) {
        self.accetpArray = [NSMutableArray array];
    }
    return _accetpArray;
}
- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
- (NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
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
