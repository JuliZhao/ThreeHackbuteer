//
//  ChatTVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ChatTVC.h"
#import "ChatDetailVC.h"
#import "FriendCell.h"
#import "LoginVC.h"

@interface ChatTVC () <AVIMClientDelegate>

@property (nonatomic, strong) AVIMClient *client;

@property (nonatomic, strong) NSMutableArray *conversations;
@property (nonatomic, strong) NSMutableArray *chaters;
@property (nonatomic, strong) NSMutableArray *lastMessage;
@property (nonatomic, strong) NSMutableArray *updateArray;
@property (nonatomic, strong) NSMutableDictionary *headImgDic;

@end

@implementation ChatTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"friendCell"];
    [self getSignature];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([AVUser currentUser]) {
        [self getConversations];
        self.navigationItem.rightBarButtonItem = nil;
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登陆" style:(UIBarButtonItemStyleDone) target:self action:@selector(login)];
        if (_chaters.count) {
            [_chaters removeAllObjects];
        }
        if (_conversations.count) {
            [_conversations removeAllObjects];
        }
        [self.tableView reloadData];
    }
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

-(NSMutableDictionary *)headImgDic{
    if (!_headImgDic) {
        _headImgDic = [NSMutableDictionary dictionary];
    }
    return _headImgDic;
}

-(void) login {
    UINavigationController *vc = [LoginVC sharedLoginVC];
    [self showDetailViewController:vc sender:nil];

}

-(void) getConversations{
    //  创建了一个 client
    self.client = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].objectId];
    
    __block typeof(self) temp = self;
    [self.client openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
        temp.client.delegate = temp;
        //聊天对话查询对象
        AVIMConversationQuery *query = [temp.client conversationQuery];
//        [query whereKey:@"m" containsString:[AVUser currentUser].objectId];
        [query whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].objectId]];
        NSLog(@"%@", [AVUser currentUser].objectId);
        query.limit = 10;
//        [query whereKey:@"name" containsString:[AVUser currentUser].objectId];
        [query orderByDescending:@"updatedAt"];
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            if (_conversations.count) {
                [_conversations removeAllObjects];
            }
            if (_chaters.count) {
                [_chaters removeAllObjects];
            }
            NSLog(@"%ld", (unsigned long)objects.count);
            for (AVIMConversation *con in objects) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:con.members];
                [array removeObject:[AVUser currentUser].objectId];
                NSLog(@"%@", array);
                [con queryMessagesWithLimit:1 callback:^(NSArray *objects, NSError *error) {
                    AVIMMessage *message = objects.lastObject;
                    if (message.content) {
                        [self.lastMessage addObject:message.content];
                    }else {
                        [self.lastMessage addObject:@"[消息]"];
                    }
                    NSLog(@"%@", message.content);
                    // 设置数据模型的时间
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(message.sendTimestamp / 1000)];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MM-dd HH:mm"];
                    [self.updateArray addObject:[formatter stringFromDate:confromTimesp]];
                    NSLog(@"%@", _updateArray.lastObject);
                }];
                AVQuery *userQ = [AVUser query];
                [userQ whereKey:@"objectId" equalTo:array.lastObject];
                [userQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        AVUser *user = objects.lastObject;
                        [temp.chaters addObject:user];
                        NSLog(@"%@", _chaters);
                        [temp.conversations addObject:con];
                        [temp.tableView reloadData];
                    } else {
                        // 输出错误信息
                        NSLog(@"没有这个人：%@",error);
                    }
                }];
            }
        }];
    }];
}

-(NSMutableArray *)lastMessage{
    if (!_lastMessage) {
        _lastMessage = [NSMutableArray array];
    }
    return _lastMessage;
}

-(NSMutableArray *)updateArray{
    if (!_updateArray) {
        _updateArray = [NSMutableArray array];
    }
    return _updateArray;
}

-(NSMutableArray *)chaters{
    if (!_chaters) {
        _chaters = [NSMutableArray array];
    }
    return _chaters;
}

-(NSMutableArray *)conversations{
    if (!_conversations) {
        _conversations = [NSMutableArray array];
    }
    return _conversations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.chaters.count && self.conversations.count) {
        return self.chaters.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MM-dd HH:mm"];
//    NSDate *date = [self.conversations[indexPath.row] lastMessageAt];
    if (_updateArray.count) {
        cell.timeLab.text = _updateArray[indexPath.row];
    }
//    cell.timeLab.text = [formatter stringFromDate:date];
    cell.nameLab.text = [self.chaters[indexPath.row] username];
    if (_lastMessage.count) {
        cell.textLab.text = _lastMessage[indexPath.row];
    }else{
        cell.textLab.text = @"[消息]";
    }
    if (_headImgDic[[self.chaters[indexPath.row] objectId]]) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:_headImgDic[[self.chaters[indexPath.row] objectId]]]];
    }else {
        cell.imgView.image = [UIImage imageNamed:[self getImg]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatDetailVC *chat = [[ChatDetailVC alloc]init];
    chat.converstaion = self.conversations[indexPath.row];
    chat.otherChater = self.chaters[indexPath.row];
    [self.navigationController pushViewController:chat animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
