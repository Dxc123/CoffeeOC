//
//  XXDetailViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/23.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXDetailViewController.h"
#import "XXShipmentViewController.h"
#import "XXHistoryViewController.h"
#import "XXNotificationViewController.h"

typedef enum :NSInteger{
    chooseButton = 10,
    bgViewTags = 20,
    saleLabelTags = 30,
}tags;

@interface XXDetailViewController ()<UIScrollViewDelegate>
{
    UIView *selectView;
    UIButton *selectBtn;
    
    XXHistoryViewController *detailTableVC;
    XXNotificationViewController *gatherTableVC;
    BOOL isNotDetail;
    UIScrollView *bgScroll;
    
}
@property(strong,nonatomic)NSMutableArray *detailArr;
@property(strong,nonatomic)NSMutableArray *saleArr;


@end

@implementation XXDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"销售详情";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    设置透明的背景图，便于识别底部线条有没有被隐藏
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    //此处使底部线条失效
    [navigationBar setShadowImage:[UIImage new]];
    [self createView];
    [self getDate];
}
- (NSMutableArray *)detailArr{
    if (!_detailArr) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}
- (NSMutableArray *)saleArr{
    if (!_saleArr) {
        _saleArr = [NSMutableArray array];
    }
    return _saleArr;
}
- (void)createView{
    UIView *titleChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
//    titleChooseView.backgroundColor = BLUE;
    [self.view addSubview:titleChooseView];
    NSArray *arr = @[@"各点位销售详情",@"商品销量汇总"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.tag = chooseButton + i;
        if (i == 0) {
            button.titleLabel.font = FONT_OF_SIZE(17);
            selectBtn = button;
        }
        button.frame = CGRectMake(SCREEN_WIDTH/2*i, 0,SCREEN_WIDTH/2, titleChooseView.frame.size.height);
        [button setTintColor:BLUE];
        [button addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
        [titleChooseView addSubview:button];
    }
    //蓝色下划线
    selectView = [[UIView alloc]initWithFrame:CGRectMake(0, titleChooseView.frame.size.height-2,SCREEN_WIDTH/2, 3)];
    selectView.backgroundColor = BLUE;//[UIColor whiteColor];
    [titleChooseView addSubview:selectView];
    
    bgScroll = [[UIScrollView alloc]init];
    bgScroll.frame = CGRectMake(0, CGRectGetMaxY(titleChooseView.frame), SCREEN_WIDTH,SCREEN_HEIGHT);
    bgScroll.delegate = self;
    bgScroll.pagingEnabled = YES;
    bgScroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-CGRectGetMaxY(titleChooseView.frame));
    [self.view addSubview:bgScroll];
    //创建俩个横向滑动的Scroll
    for (int i = 0; i<2; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, bgScroll.frame.size.height);
        bgView.tag = bgViewTags+i;
        [bgScroll addSubview:bgView];
    }
    
    UIView *detailView = [bgScroll viewWithTag:bgViewTags+0];
//        UIScrollView *detailScroll = [[UIScrollView  alloc]init];
//        detailScroll.frame = CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height);
//        detailScroll.contentSize = CGSizeMake(detailView.frame.size.width, detailView.frame.size.height+100);
//        [detailView addSubview:detailScroll];
    UIView *saleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 80)];
    saleView.backgroundColor = RGB(248, 248, 248);//COLOR_MAIN;
    [detailView addSubview:saleView];
    //分割线
//    for (int i = 0; i<2; i++) {
//        UIView *partView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*(i+1), 10, 1, 80)];
//        partView.backgroundColor = [UIColor grayColor];
//        [saleView addSubview:partView];
//    }
    //各点位销售销售详情
    NSArray *titleArr = @[@"售货机",@"销售额(元)",@"销售量(件)"];
    for (int i = 0; i<3; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 5,SCREEN_WIDTH/3, 40)];
        titleLabel.text = titleArr[i];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font = FONT_OF_SIZE(15);
        [saleView addSubview:titleLabel];
        UILabel *saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, CGRectGetMaxY(titleLabel.frame),SCREEN_WIDTH/3, 40)];
        saleLabel.textAlignment = NSTextAlignmentCenter;
        saleLabel.font = FONT_OF_SIZE(28);
        saleLabel.textColor = BLUE;
        [saleView addSubview:saleLabel];
        saleLabel.tag = saleLabelTags+i;
    }
    UIView *detailTableView = [[UIView alloc]init];
    detailTableView.frame = CGRectMake(0, CGRectGetMaxY(saleView.frame), detailView.frame.size.width, detailView.frame.size.height-80-64);
    
    [detailView addSubview:detailTableView];
    
    detailTableVC = [[XXHistoryViewController alloc] init];
    detailTableVC.markID = 1;
    [detailTableVC returnForRefreash:^{
        [self getDate];
    }];
    [detailTableView addSubview:detailTableVC.view];
    [self addChildViewController:detailTableVC];
    [detailTableVC contentViewFrameBounds:detailTableView.frame];
    
    [detailTableVC ReturnTurnForOnLinePersonText:^(NSString *machineID,NSString *routeStr) {
        XXShipmentViewController *shipVC = [[XXShipmentViewController alloc]init];
    
        shipVC.dateType = self.data;
        shipVC.machineType = machineID;
        shipVC.routeStr = routeStr;
        shipVC.routeId = self.route;
        NSLog(@"shipVC.routeId=%@",shipVC.routeId);
        [self.navigationController pushViewController:shipVC animated:YES];
    }];
    
    //商品销量汇总
       UIView *gatherView = [bgScroll viewWithTag:bgViewTags+1];

    UIView *gatherTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    gatherTitleView.backgroundColor=[UIColor orangeColor];
    [gatherView addSubview:gatherTitleView];


    NSArray *gatherTitleArr = @[@"排名",@"商品名称",@"        销量",@"销量/件"];

    for (int i=0; i<4; i++) {
        UILabel *gatherTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*UISCALE+(SCREEN_WIDTH/5+28*UISCALE)*i, 5,SCREEN_WIDTH/5-10*UISCALE, 40)];
        gatherTitleLabel.text = gatherTitleArr[i];
        gatherTitleLabel.textColor = [UIColor blackColor];
        gatherTitleLabel.textAlignment=NSTextAlignmentCenter;
        gatherTitleLabel.font = FONT_OF_SIZE(14);
        [gatherView addSubview:gatherTitleLabel];
        
    }
    
//    UILabel *paiming = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, gatherTitleView.frame.size.height)];
//    paiming.text = @"排名";
//    paiming.font = FONT_OF_SIZE(13);
//    paiming.textColor= [UIColor orangeColor];
//    paiming.textAlignment = NSTextAlignmentCenter;
//    [gatherTitleView addSubview:paiming];
//    UILabel *goodName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5*2, gatherTitleView.frame.size.height)];
//    goodName.text = @"商品名称";
//    goodName.textColor=separeLineColor;
//    goodName.font = FONT_OF_SIZE(13);
//    goodName.textAlignment = NSTextAlignmentCenter;
//    [gatherTitleView addSubview:goodName];
//    UILabel *xiaoliang = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*3, 0, SCREEN_WIDTH/5, gatherTitleView.frame.size.height)];
//    xiaoliang.textAlignment = NSTextAlignmentCenter;
//    xiaoliang.text = @"销量";
//    xiaoliang.textColor=separeLineColor;
//    xiaoliang.font = FONT_OF_SIZE(13);
//    [gatherTitleView addSubview:xiaoliang];
//    UILabel *tai = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*4, 0, SCREEN_WIDTH/5, gatherTitleView.frame.size.height)];
//    tai.text = @"销量/台";
//    tai.textColor=separeLineColor;
//    tai.font = FONT_OF_SIZE(13);
//    tai.textAlignment = NSTextAlignmentCenter;
//    [gatherTitleView addSubview:tai];
    //分割线
//    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, gatherTitleView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
//    separView.backgroundColor = separeLineColor;
//    [gatherTitleView addSubview:separView];
    
    UIView *gatherTableView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(gatherTitleView.frame), gatherView.frame.size.width, gatherView.frame.size.height-64)];
    [gatherView addSubview:gatherTableView];
    
    gatherTableVC = [[XXNotificationViewController alloc]init];
    gatherTableVC.markID = 1;
    [gatherTableVC returnForRefreash:^{
        [self getDate];
    }];
    [gatherTableView addSubview:gatherTableVC.view];
    [self addChildViewController:gatherTableVC];
    [gatherTableVC contentViewFrameBounds:gatherTableView.frame];
}
- (void)getDate{
    __weak typeof(self) weakself = self;
    NSLog(@"route=%@",self.route);

    //各点位销售详情
    [XXReportHandle getAllPointDetailGetMoneyWithDate:self.data AndRoutes:self.route WithBlock:^(NSMutableArray *dataArr,NSString *machineNumbe,NSString *xiaoshoue,NSString *xiaoshouliang,BOOL LossConnect) {
        if (!LossConnect) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *arr = @[machineNumbe,xiaoshoue,xiaoshouliang];
                for (int i = 0; i<3; i++) {
                    UILabel *label = [weakself.view viewWithTag:saleLabelTags+i];
                    label.text = arr[i];
                }
                [detailTableVC refreshWithDateArr:dataArr WithIsLossCnnect:LossConnect];
            });
            
        }
    }];
    
    //商品销售汇总
    [XXReportHandle getGatherGoodsSaleMessageWithDate:self.data AndRoutes:self.route WithBlock:^(NSMutableArray *dataArr,BOOL LossConnect) {
        
        [gatherTableVC refreshWithDateArr:dataArr WithIsLossCnnect:LossConnect];
    }];
    
}

- (void)buttonChoose:(UIButton *)sender{
    
    [UIView animateWithDuration:0.25 animations:^{
        selectBtn.titleLabel.font = FONT_OF_SIZE(14);
        sender.titleLabel.font = FONT_OF_SIZE(17);
        selectView.center = CGPointMake(sender.center.x, selectView.center.y);
        bgScroll.contentOffset = CGPointMake(SCREEN_WIDTH*(sender.tag-chooseButton), 0);
    }];
    selectBtn = sender;
//    [selectBtn setTintColor:[UIColor blackColor]];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == 0) {
        UIButton *detailBtn = [self.view viewWithTag:chooseButton+0];
        UIButton *allBtn = [self.view viewWithTag:chooseButton+1];
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.x/SCREEN_WIDTH == 0) {
                detailBtn.titleLabel.font = FONT_OF_SIZE(17);
                allBtn.titleLabel.font = FONT_OF_SIZE(14);
            }else{
                detailBtn.titleLabel.font = FONT_OF_SIZE(14);
                allBtn.titleLabel.font = FONT_OF_SIZE(17);
            }
            selectView.center = CGPointMake(scrollView.contentOffset.x/SCREEN_WIDTH*(SCREEN_WIDTH/2)+SCREEN_WIDTH/4, selectView.center.y);
        }];
    }
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
