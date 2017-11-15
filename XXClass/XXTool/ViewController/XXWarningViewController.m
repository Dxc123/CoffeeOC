//
//  WarningViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//
#import "XXWarningViewController.h"
#import "XXTaskDetailViewController.h"
#import "XXHistoryViewController.h"
#import "XXNotificationViewController.h"
#import "XXTypeViewController.h"
#import "XXHeaderLine.h"
typedef enum :NSInteger{
    chooseButton = 10,
    bgViewTags = 20,
    
}tags;

@interface XXWarningViewController ()<UIScrollViewDelegate>
{
    UIView *selectView;
    UIScrollView *bgScroll;
}
@property(nonatomic,strong)XXHeaderLine *headerLine;
@end

@implementation XXWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"告警";
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //设置透明的背景图，便于识别底部线条有没有被隐藏
//   [navigationBar setBackgroundImage:[[UIImage alloc] init]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    [navigationBar setShadowImage:[UIImage new]];
    [self setupUI];
}
- (void)setupUI{
    
    _headerLine = [[XXHeaderLine alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    _headerLine.items = @[@"告警机器",@"告警类别"];
    
    __weak typeof(self) weakSelf = self;
    _headerLine.itemClickAtIndex = ^(NSInteger index){
        [weakSelf adjustScrollView:index];
    };
    [self.view addSubview: _headerLine];
    
    
    //设置Scroll
    bgScroll = [[UIScrollView alloc]init];
    bgScroll.frame = CGRectMake(0, CGRectGetMaxY(_headerLine.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_headerLine.frame));
    bgScroll.delegate = self;
    bgScroll.pagingEnabled = YES;
    bgScroll.directionalLockEnabled = YES;
    bgScroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-CGRectGetMaxY(_headerLine.frame));
    //      bgScroll.backgroundColor=BLUE;
    [self.view addSubview:bgScroll];
    
    //设置Scroll上的俩bgView
    for (int i = 0; i<2; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, bgScroll.frame.size.height);
        //        bgView.backgroundColor=BLUE;
        bgView.tag = bgViewTags+i;
        [bgScroll addSubview:bgView];
    }

    
    
    //告警机器
    UIView *machineTypeWornView = [self.view viewWithTag:bgViewTags+0];
    XXHistoryViewController *machineWorningTabView = [[XXHistoryViewController alloc]init];
    machineWorningTabView.markID = 3;
    [machineTypeWornView addSubview:machineWorningTabView.view];
    [self addChildViewController:machineWorningTabView];
    
    [machineWorningTabView contentViewFrameBounds:CGRectMake(0, 0, machineTypeWornView.frame.size.width, machineTypeWornView.frame.size.height-60)];
    [machineWorningTabView returnMachineIDForTask:^(NSString *machineID) {
//        跳转进入详情界面
        XXTaskDetailViewController *worningDetailVC = [[XXTaskDetailViewController alloc]init];
        worningDetailVC.markID = 1;
        worningDetailVC.machineID = machineID;
        [self.navigationController pushViewController:worningDetailVC animated:YES];
    }];
    
//    告警类别
    UIView *typeWorningView = [self.view viewWithTag:bgViewTags+1];
    XXNotificationViewController *typeVC = [[XXNotificationViewController alloc]init];
    typeVC.markID = 3;
    [typeWorningView addSubview:typeVC.view];
    [self addChildViewController:typeVC];
    [typeVC contentViewFrameBounds:CGRectMake(0, 0, typeWorningView.frame.size.width, typeWorningView.frame.size.height-60)];
    [typeVC returnWorningTypeForTask:^(NSString *typeLevel) {
//        跳转进入告警类别详情界面
        XXTypeViewController *typeVC = [[XXTypeViewController alloc]init];
        typeVC.typeID = typeLevel;
        [self.navigationController pushViewController:typeVC animated:YES];
    }];
    
    
   
}


#pragma mark-通过点击button来改变scrollview的偏移量
-(void)adjustScrollView:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        bgScroll.contentOffset = CGPointMake(index*bgScroll.bounds.size.width, 0);
    }];
}

#pragma mark-选中scorllview来调整headvie的选中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_headerLine setSelectAtIndex:index];
    
    
}


#pragma mark
-(void)changeScrollview:(NSInteger)index{
    
    [UIView animateWithDuration:0 animations:^{
        bgScroll.contentOffset = CGPointMake(index*bgScroll.bounds.size.width, 0);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.25 animations:^{
        selectView.center = CGPointMake(scrollView.contentOffset.x/SCREEN_WIDTH*(SCREEN_WIDTH/2)+SCREEN_WIDTH/4, selectView.center.y);
    }];
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
