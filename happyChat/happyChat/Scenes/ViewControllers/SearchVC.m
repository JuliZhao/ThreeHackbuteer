//
//  SearchVC.m
//  happyChat
//
//  Created by zy on 15/12/3.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "SearchVC.h"
#import "User.h"

@interface SearchVC ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LeanCloudDBHelper *lean = [LeanCloudDBHelper new];
    [lean findObjectWithCql:@"select * from _User"];
    lean.returnResult = ^(id result){
        NSLog(@"%@",result);
        for (AVObject *user in result) {
            UIImage *image = [UIImage imageWithData:user[@"userImage"]];
            User *users = [[User alloc]initWithName:user[@"username"] userImage:image];
            [self.array addObject:users];
        }
    };
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    User *user = self.array[indexPath.row];
//    cell.imageView.image = user.userImage;
    cell.textLabel.text = user.name;
    return cell;
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
