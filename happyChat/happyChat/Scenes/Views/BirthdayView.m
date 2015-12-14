//
//  BirthdayView.m
//  happyChat
//
//  Created by 钱鹏 on 15/12/9.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "BirthdayView.h"

@interface BirthdayView ()
//datePicker
@property (nonatomic,retain) UIDatePicker *dataPiker;
@property (nonatomic,retain) NSString *birthdayStr;


@end

@implementation BirthdayView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat weight = [UIScreen mainScreen].bounds.size.width;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    //创建对象
    self.dataPiker = [[UIDatePicker alloc]initWithFrame:CGRectMake(weight/13, weight/4, 0, 0)];
    //属性设置
    //设置样式
    _dataPiker.datePickerMode = UIDatePickerModeDate;
    //设置时间间隔
    _dataPiker.minuteInterval = 1;
    //设置日历
    [_dataPiker setCalendar:[NSCalendar currentCalendar]];
    
    //设置日期选择控件的地区
    [_dataPiker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    //设置最小日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter dateFromString:@"1949-10-01"];
    
    //最大日期
    NSDate *maxDate = [NSDate date];
    
    [_dataPiker setMinimumDate:minDate];
    [_dataPiker setMaximumDate:maxDate];
    
    
    //添加事件
    [_dataPiker addTarget:self action:@selector(dateValueChange:) forControlEvents:(UIControlEventValueChanged)];
    
    
    //添加按钮
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.frame = CGRectMake(weight/5, weight, weight/6, weight/10);
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(2*weight/3, weight, weight/6, weight/10);
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancelBtn];
    
    
    
    //添加到视图
    [self.view addSubview:_dataPiker];
    
}


- (void)sure:(UIButton *)sender{
    //代理传值
    [_delegate birthday:_birthdayStr];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dateValueChange:(UIDatePicker *)sender{
    
    _dataPiker = (UIDatePicker *)sender;
    NSDate *date = _dataPiker.date;
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    self.birthdayStr = [formater stringFromDate:date];
    
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
