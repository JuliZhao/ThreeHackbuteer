//
//  ChatDetailVC.m
//  happyChat
//
//  Created by lanou3g on 15/12/6.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ChatDetailVC.h"
#import "MyCell.h"
#import "OtherCell.h"

@interface ChatDetailVC ()<UITextFieldDelegate, AVIMClientDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AVIMClient *client;
//用来记录聊天信息
@property (nonatomic,strong) NSMutableArray * messages;
//聊天对话
@property (nonatomic,strong) AVIMConversation * converstaion;

@property (nonatomic, strong) NSString *conversationName;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *messageTF;
- (IBAction)sendMessage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

@end

@implementation ChatDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageTF.delegate = self;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"other"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"my"];
    // 创建聊天
    [self createConversation];
}

-(void) createConversation{
    
    //  创建了一个 client
    self.client = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].username];
    
    __block typeof(self) temp = self;
    
    //  用自己的名字作为 ClientId 打开 client
    [self.client openWithClientId:[AVUser currentUser].username callback:^(BOOL succeeded, NSError *error) {
        
        temp.client.delegate = self;
        //TODO: 应该先查看是否之前创建了聊天对话
        
        //聊天对话查询对象
        AVIMConversationQuery *query = [self.client conversationQuery];
        //查找对话名字是 两个对话人姓名
        [query whereKey:@"name" equalTo:[self getConversation]];
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            //如果数据库中没有对话就创建一个
            if (objects.count == 0) {
                //创建回话
                [self.client createConversationWithName:[self getConversation] clientIds:@[[AVUser currentUser].username, _chater] callback:^(AVIMConversation *conversation, NSError *error) {
                    self.converstaion = conversation;
                }];
            }else{
                //取到最后一个对话
                self.converstaion = objects.lastObject;
                //查询之前的对话
                [self.converstaion queryMessagesWithLimit:10 callback:^(NSArray *objects, NSError *error) {
                    for (AVIMMessage *message in objects) {
                        [self.messages addObject:message];
                    }
                    [self.tableView reloadData];
                }];
            }
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVIMClientDelegate
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    NSLog(@"%@",message.content);
}
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    //    NSLog(@"%@",message.text);
}
//接受代理方法
-(void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    NSLog(@"_____%d",message.ioType);
    NSLog(@"+++++++%@",message.content);
    [self.messages addObject:message];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //构造发送的消息
    AVIMMessage *avmessage = [AVIMMessage messageWithContent:textField.text];
    avmessage.clientId = [AVUser currentUser].username;
    avmessage.conversationId = self.conversationName;
    
    //发送消息
    [self.converstaion sendMessage:avmessage callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送消息成功");
        }
    }];
    
    [self.messages addObject:avmessage];
    if (self.messages.count) {
        NSInteger row = self.messages.count - 1;
        NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationNone)];
        [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    [textField resignFirstResponder];
    return YES;
}

//根据两个人得用户名来排序来生成一个对话名
- (NSString *)getConversation{
    //    NSString *myname = [AVUser currentUser].username;
    //    NSString *chaterName = self.chater.username;
    NSString *myname = [AVUser currentUser].username;
    NSString *chaterName = _chater;
    if ([myname compare:chaterName] == NSOrderedAscending) {
        
        return [NSString stringWithFormat:@"%@%@",chaterName,myname];
    }else{
        return [NSString stringWithFormat:@"%@%@",myname,chaterName];
    }
}


-(NSMutableArray *)messages{
    if (!_messages) {
        _messages = [[NSMutableArray alloc]init];
    }
    return _messages;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMMessage *message = self.messages[indexPath.row];
    if (message.ioType == 2) {
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my" forIndexPath:indexPath];
#warning 
        cell.message = message;
        return cell;
    }else{
        OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
        cell.message =message;
        return cell;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendMessage:(UIButton *)sender {
}
@end
