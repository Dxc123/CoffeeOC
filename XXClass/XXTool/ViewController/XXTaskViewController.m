//
//  XXTaskViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXTaskViewController.h"
#import "XXTaskDetailViewController.h"
#import "XXHistoryViewController.h"
#import "XXNotificationViewController.h"
#import "XXHeaderLine.h"

typedef enum :NSInteger{
    chooseButton = 10,
    bgViewTags = 20,
    
}tags;

@interface XXTaskViewController ()<UIScrollViewDelegate>
{
    UIView *selectView;
    UIScrollView *bgScroll;
}
@property(nonatomic,strong)XXHeaderLine *headerLine;
@end
@implementation XXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"任务";
       [self setupUI];
}
- (void)setupUI{
    
   
    _headerLine = [[XXHeaderLine alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40)];
    _headerLine.items = @[@"未完成",@"已完成"];
    
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
    
    //设置Scroll上的俩bgView，装载 未完成和已完成 界面
    for (int i = 0; i<2; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, bgScroll.frame.size.height);
        //        bgView.backgroundColor=BLUE;
        bgView.tag = bgViewTags+i;
        [bgScroll addSubview:bgView];
    }
    
        UIView *NoTaskView = [bgScroll viewWithTag:bgViewTags+0];
        XXHistoryViewController *notaskTableVC = [[XXHistoryViewController alloc]init];
        notaskTableVC.markID = 2;
        [NoTaskView addSubview:notaskTableVC.view];
        [self addChildViewController:notaskTableVC];
        [notaskTableVC contentViewFrameBounds:CGRectMake(0, 0, NoTaskView.frame.size.width, NoTaskView.frame.size.height-60)];
        [notaskTableVC returnModelForTask:^(AMTaskModel *model) {
            //       进入未完成详情界面
            XXTaskDetailViewController *detailVC = [[XXTaskDetailViewController alloc]init];
            detailVC.isArchive = NO;
            detailVC.markID = 0;
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    
        UIView *taskView = [bgScroll viewWithTag:bgViewTags+1];
        XXNotificationViewController *taskVC = [[XXNotificationViewController alloc]init];
        taskVC.markID = 2;
        [taskView addSubview:taskVC.view];
        [self addChildViewController:taskVC];
        [taskVC contentViewFrameBounds:CGRectMake(0, 0, NoTaskView.frame.size.width, taskView.frame.size.height-60)];
        [taskVC returnModelForTask:^(AMTaskModel *model) {
            //进入详情界面
            XXTaskDetailViewController *detailVC = [[XXTaskDetailViewController alloc]init];
            detailVC.isArchive = YES;
            detailVC.markID = 0;
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
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
