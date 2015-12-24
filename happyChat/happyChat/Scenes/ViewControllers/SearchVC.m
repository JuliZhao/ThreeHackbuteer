//
//  SearchVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "SearchVC.h"
#import "User.h"
#import "UserDetailVC.h"
#import "FriendCell.h"

@interface SearchVC ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) IBOutlet UIView *searchView;
// 搜索框
@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
// 所有用户
@property (strong, nonatomic) NSMutableArray *array;
// 所有用户名
@property (strong, nonatomic) NSMutableArray *nameArray;
// 存放所有搜索结果
@property (nonatomic, strong) NSMutableArray *searchResult;
// 存放搜索出的用户的详细信息
@property (nonatomic, strong) NSMutableArray *personArray;
// 存放照片
@property (nonatomic, strong) NSMutableDictionary *headImgDic;
@property (nonatomic, strong) NSMutableDictionary *signatureDic;
@property (nonatomic, strong) NSMutableDictionary *genderDic;
@property (nonatomic, strong) NSMutableDictionary *birthdayDic;

// 新承接数组
@property (nonatomic,strong) NSMutableArray *arrayNew;
@property (nonatomic, strong) NSMutableArray *nameArrayNew;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"friendCell"];
    [self createSearchControll];
    [self getSignature];
    [self getData];
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
                NSString *str1 = [obj objectForKey:@"userGender"];
                [self.genderDic setObject:str1 forKey:obj[@"userId"]];
                NSString *str2 = [obj objectForKey:@"userBirthday"];
                [self.birthdayDic setObject:str2 forKey:obj[@"userId"]];
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

-(void) getData {
    if (_array.count) {
        [_array removeAllObjects];
    }
    if (_nameArray.count) {
        [_nameArray removeAllObjects];
    }
    AVQuery *query = [AVUser query];
    if ([AVUser currentUser]) {
        [query whereKey:@"objectId" notContainedIn:@[[AVUser currentUser].objectId]];
    }
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (AVUser *user in objects) {
                    [self.array addObject:user];
                    [self.nameArray addObject:user.username];
                }
                self.arrayNew = [NSMutableArray arrayWithArray:_array];
                self.nameArrayNew = [NSMutableArray arrayWithArray:_nameArray];
                [self.tableView reloadData];
            }
        }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
}

-(void) createSearchControll{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    NSLog(@"%@", NSStringFromCGRect(_searchController.searchBar.frame));
    // 设置搜索框背景颜色
    _searchController.dimsBackgroundDuringPresentation = NO;
    // 设置搜索资源更新代理
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"输入查找的用户名";
    [self.searchView addSubview:_searchController.searchBar];
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

-(NSMutableDictionary *)genderDic{
    if (!_genderDic) {
        _genderDic = [NSMutableDictionary dictionary];
    }
    return _genderDic;
}

-(NSMutableDictionary *) birthdayDic{
    if (!_birthdayDic) {
        _birthdayDic = [NSMutableDictionary dictionary];
    }
    return _birthdayDic;
}

-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

-(NSMutableArray *) personArray{
    if (!_personArray) {
        _personArray = [NSMutableArray array];
    }
    return _personArray;
}

-(NSMutableArray *) nameArray{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

-(NSString *)getImg{
    int a = arc4random_uniform((int)6);
    return [NSString stringWithFormat:@"%d", a+1];
}

#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.personArray.count;
    return self.searchController.active == YES ? self.personArray.count : self.arrayNew.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AVUser *user = (self.searchController.active == YES) ? self.personArray[indexPath.row] : self.arrayNew[indexPath.row];
    
    cell.nameLab.text =  user.username;
        
    if (_headImgDic[user.objectId]) {
        [cell.imgView sd_setImageWithURL:_headImgDic[user.objectId]];
    }else {
        cell.imgView.image = [UIImage imageNamed:[self getImg]];
    }
    
    
    if (self.signatureDic[user.objectId]) {
        cell.textLab.text = self.signatureDic[user.objectId];
    }
    
    
    return cell;
}

#pragma mark --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDetailVC *userDVC = [[UserDetailVC alloc]init];
    userDVC.likeFriend = (self.searchController.active == YES) ? self.personArray[indexPath.row] : self.arrayNew[indexPath.row];
    if (_signatureDic[userDVC.likeFriend.objectId]) {
        userDVC.labText = _signatureDic[userDVC.likeFriend.objectId];
    }
    if (_headImgDic[userDVC.likeFriend.objectId]) {
        userDVC.imgStr = _headImgDic[userDVC.likeFriend.objectId];
    }
    if (_genderDic[userDVC.likeFriend.objectId]) {
        userDVC.genderStr = _genderDic[userDVC.likeFriend.objectId];
    }
    if (_birthdayDic[userDVC.likeFriend.objectId]) {
        userDVC.birText = _birthdayDic[userDVC.likeFriend.objectId];
    }
    [self showDetailViewController:userDVC sender:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



#pragma mark --- UISearchControllerDelegate
// 遵循协议，必须走这个方法，通过这个方法，来更新内容
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.personArray removeAllObjects];
    [self.searchResult removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd]%@", self.searchController.searchBar.text];
    self.searchResult = [self.nameArrayNew filteredArrayUsingPredicate:predicate].mutableCopy;
    NSLog(@"%@", self.searchResult);
    for (NSString *str in self.searchResult) {
//        for (User *user in self.array) {
//            if ([user.name isEqualToString:str]) {
//                [self.personArray addObject:user];
//                continue;
//            }
//        }
        for (AVUser *user in self.arrayNew) {
            if ([user.username isEqualToString:str]) {
                [self.personArray addObject:user];
                continue;
            }
        }
    }
    
    [self.tableView reloadData];
    
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
