//
//  ChangeImageVC.m
//  happyChat
//
//  Created by zy on 15/12/19.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ChangeImageVC.h"

@interface ChangeImageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ChangeImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.image = _picture;
    self.imgView.userInteractionEnabled = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addTap];
}

- (void)addTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
