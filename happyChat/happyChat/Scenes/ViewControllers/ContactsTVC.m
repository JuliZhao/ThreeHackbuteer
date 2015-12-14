//
//  ContactsTVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ContactsTVC.h"
#import "FriendCell.h"
#import "ChatDetailVC.h"
#import "ChangeSelfView.h"
#import "LoginVC.h"

@interface ContactsTVC ()
@property (strong, nonatomic) IBOutlet UIImageView *backImgView;
@property (strong, nonatomic) IBOutlet UIImageView *userImgView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLab;
// 签名
@property (strong, nonatomic) IBOutlet UILabel *signatureLab;
@property (strong, nonatomic) IBOutlet UILabel *likeLab;
@property (strong, nonatomic) IBOutlet UILabel *followLab;

@property (strong, nonatomic) NSMutableArray *array;
@property (nonatomic, strong) NSMutableDictionary *headImgDic;
@property (nonatomic, strong) NSMutableDictionary *signatureDic;
@end

@implementation ContactsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"friendCell"];
    [self getSignature];
}

-(void) getSignature{
    // 检索用户数据
    AVQuery *query1 = [AVQuery queryWithClassName:@"UserDetail"];
    if ([AVUser currentUser]) {
        [query1 whereKey:@"userId" notContainedIn:@[[AVUser currentUser].objectId]];
    }
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *obj in objects) {
                NSString *str = [obj objectForKey:@"userSignature"];
                [self.signatureDic setObject:str forKey:obj[@"userId"]];
                AVQuery *fileQuery = [AVFile query];
                [fileQuery orderByDescending:@"craetedAt"];
                [fileQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.png", obj[@"userId"]]];
                AVFile *object = [AVFile fileWithAVObject:[fileQuery getFirstObject]];
                [self.headImgDic setObject:object.url forKey:obj[@"userId"]];
            }
            [self.tableView reloadData];
        }
    }];
}

-(void) getMyself{
        AVQuery *fileQuery = [AVFile query];
        [fileQuery orderByDescending:@"craetedAt"];
        [fileQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.png", [AVUser currentUser].objectId]];
        AVFile *object = [AVFile fileWithAVObject:[fileQuery getFirstObject]];
        if (object.url) {
            [self.userImgView sd_setImageWithURL:[NSURL URLWithString:object.url]];
        }
    //检索用户数据
        AVQuery *query = [AVQuery queryWithClassName:@"UserDetail"];
        [query whereKey:@"userId" equalTo:[AVUser currentUser].objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                AVObject *obj = objects.lastObject;
                self.signatureLab.text = [obj objectForKey:@"userSignature"];
            }
        }];
}

-(NSMutableDictionary *)headImgDic{
    if (!_headImgDic) {
        _headImgDic = [NSMutableDictionary dictionary];
    }
    return _headImgDic;
}

-(NSMutableDictionary *) signatureDic{
    if (!_signatureDic) {
        _signatureDic = [NSMutableDictionary dictionary];
    }
    return _signatureDic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([AVUser currentUser]) {
        self.userNameLab.text = [AVUser currentUser].username;
        [self addTap];
        [self getLikePerson];
        [self setLikeAndFollow];
        self.navigationItem.rightBarButtonItem = nil;
        [self getMyself];
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登陆" style:(UIBarButtonItemStyleDone) target:self action:@selector(login)];
        if (_array.count) {
            [_array removeAllObjects];
        }
        [self.tableView reloadData];
        self.userImgView.image = [UIImage imageNamed:@"用户"];
        self.userNameLab.text = @"未知";
        self.followLab.text = @"粉丝 : 0";
        self.likeLab.text = @"关注 : 0";
        self.signatureLab.text = @"TA很懒，什么都没写~~";
        NSLog(@"%d", self.userImgView.userInteractionEnabled);
        self.userImgView.userInteractionEnabled = NO;
        self.signatureLab.userInteractionEnabled = NO;
        self.userNameLab.userInteractionEnabled = NO;
    }
}

-(void) login {
    UINavigationController *vc = [LoginVC sharedLoginVC];
    [self showDetailViewController:vc sender:nil];
}

-(void) addTap{
    self.userNameLab.userInteractionEnabled = YES;
    self.userImgView.userInteractionEnabled = YES;
    self.signatureLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.userImgView addGestureRecognizer:tap1];
    [self.signatureLab addGestureRecognizer:tap2];
    [self.userNameLab addGestureRecognizer:tap3];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    ChangeSelfView *change = [[ChangeSelfView alloc]init];
    [self.navigationController pushViewController:change animated:YES];
}

-(void) setLikeAndFollow{
    [[AVUser currentUser] getFollowersAndFollowees:^(NSDictionary *dict, NSError *error) {
        NSArray *followers=dict[@"followers"];
        self.followLab.text = [NSString stringWithFormat:@"粉丝 : %ld", (unsigned long)followers.count];
        NSArray *followees=dict[@"followees"];
        self.likeLab.text = [NSString stringWithFormat:@"关注 : %ld", (unsigned long)followees.count];
    }];
}

- (void) getLikePerson{
    //关注列表查询
    AVQuery *query= [AVUser followeeQuery:[AVUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (_array.count) {
                [_array removeAllObjects];
            }
            for (AVUser *user in objects) {
                [self.array addObject:user];
                [self.tableView reloadData];
            }
        }
    }];
}

-(NSMutableArray *) array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    AVUser *user = self.array[indexPath.row];
    cell.nameLab.text = user.username;
    if (_signatureDic[user.objectId]) {
        cell.textLab.text = _signatureDic[user.objectId];
    }
    if (_headImgDic[user.objectId]) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:_headImgDic[user.objectId]]];
    }else {
        cell.imgView.image = [UIImage imageNamed:[self getImg]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

#pragma mark --- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatDetailVC *chat = [[ChatDetailVC alloc]init];
    chat.otherChater = self.array[indexPath.row];
    [self.navigationController pushViewController:chat animated:YES];
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
