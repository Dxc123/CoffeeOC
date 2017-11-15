//
//  NotiDetailViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXNotiDetailViewController.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    Tag = 10,
}tags;

@interface XXNotiDetailViewController ()

@end

@implementation XXNotiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    self.navigationItem.title = @"消息通知";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self createView];
}
- (void)createView{
    
    //背景view
    UIView *chooseView = [[UIView alloc]init];
    chooseView.backgroundColor = [UIColor whiteColor];
    chooseView.layer.cornerRadius = 5;
    chooseView.tag = Tag+1;
    [self.view addSubview:chooseView];
    
    //title提示
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = FONT_OF_SIZE(16);
    titleLabel.numberOfLines = 0;
    titleLabel.tag = Tag + 2;
    [chooseView addSubview:titleLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]init];
    //    timeLabel.center = CGPointMake(SCREEN_WIDTH/2, 30);
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = 1;
//    timeLabel.backgroundColor=[UIColor orangeColor];
    timeLabel.tag = Tag+0;
    timeLabel.font = FONT_OF_SIZE(14);
    [chooseView addSubview:timeLabel];

    
    //机器编号+地址
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.tag = Tag+3;
    contentLabel.font = FONT_OF_SIZE(13);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    [chooseView addSubview:contentLabel];
    
}
- (void)setModel:(AMNotificationModel *)model{
    if (_model!=model) {
        _model = model;
    }
    [self getReload];
}
- (void)getReload{
    UILabel *timeLabel = [self.view viewWithTag:Tag+0];
    timeLabel.text = _model.timeStr;
    CGSize timeLabelSize = [timeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-80, 0)];
    timeLabel.frame = CGRectMake(180, 9, timeLabelSize.width, timeLabelSize.height);
   
    
    UIView *bgView = [self.view viewWithTag:Tag+1];
    
    UILabel *titleLabel = [self.view viewWithTag:Tag+2];
    titleLabel.text = _model.titleStr;
    CGSize titleSize = [titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-80, 0)];
    titleLabel.frame = CGRectMake(16, 9, titleSize.width, titleSize.height);
    
    UILabel *contentLabel = [self.view viewWithTag:Tag+3];
    contentLabel.text = _model.adressStr;
    CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-80, 0)];
    contentLabel.frame = CGRectMake(16, titleSize.height+22, contentSize.width, contentSize.height);
    bgView.frame = CGRectMake(16, 64, SCREEN_WIDTH-32, titleSize.height+contentSize.height+9+13+14);
    
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
