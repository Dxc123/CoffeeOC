//
//  XXReportViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXReportViewController.h"
#import "XXReportTableViewCell.h"
#import "XXSuppleTableViewCell.h"
#import "RouteListView.h"
#import "CFLineChartView.h"
#import "XXDateViewController.h"
#import "XXAccountViewController.h"
#import "XXNotificationViewController.h"
#import "ImageBtn.h"
typedef enum :NSInteger{
    TodaySaleTags=100,
    TodayonlineTags =200,
    TodaycashTags  =300,
    YesterdayonlineTags=400,
    YesterdaycashTags  =500,
    YesterdayTags = 600,
    DetailViewTags = 130,
    DetailMarkTags = 340,
    titleLabelTags = 60,
}tags;
@interface XXReportViewController ()<UIScrollViewDelegate>
{
    NSString *route_ID;
    NSString *route_Name;
    UILabel *title_Label;
    UIView *titleView;
    UIScrollView *bgScroll;
    BOOL isArchive;
}
@property (nonatomic, strong) ImageBtn *routeBtn;
@property (nonatomic, strong) UIView *todYerView;//背景
@property (nonatomic, strong) CFLineChartView *LCView;
@property (strong,nonatomic)NSMutableArray *x_names;
@property (strong,nonatomic)NSMutableArray *targets;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIImageView *image;
@end
@implementation XXReportViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    bgScroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    
    [bgScroll.mj_header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
   bgScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_tools"] style:UIBarButtonItemStylePlain target:self action:@selector(ShouldPay)];
//
//    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_report"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonForMore)];
    [self addTitleView];
    [self createView];
    [self getData];
}

- (void)addTitleView{
//    titleView = [[UIView alloc]init];
//    title_Label = [[UILabel alloc]init];
//    title_Label.text = @"全部线路";
//    title_Label.textAlignment = NSTextAlignmentCenter;
//    title_Label.tag = titleLabelTags;
//    title_Label.textColor = [UIColor blackColor];
//    CGSize size = [title_Label sizeThatFits:CGSizeMake(0, 40)];
//    if (size.width>(SCREEN_WIDTH-40*UISCALE)) {
//        size = CGSizeMake(SCREEN_WIDTH-40*UISCALE, 40);
//    }
//    title_Label.frame = CGRectMake(0, 0, size.width, 40);
//    [titleView addSubview:title_Label];
//    UIImageView *chooseImage = [[UIImageView alloc]init];
//    chooseImage.image = [UIImage imageNamed:@"iv_circle_bottom"];
//    [titleView addSubview:chooseImage];
//    [chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(title_Label.mas_right).offset(5);
//        make.top.mas_equalTo(title_Label).offset(16);
//        make.height.mas_equalTo(10);
//        make.width.mas_equalTo(10);
//    }];
//    titleView.frame = CGRectMake(0, 0, size.width+35, 40);
//    titleView.backgroundColor = [UIColor grayColor];
//    self.navigationItem.titleView = titleView;
    self.routeBtn =[[ImageBtn alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Title:@"全部路线" Image: [UIImage imageNamed:@"iv_circle_bottom"]];
    self.navigationItem.titleView=self.routeBtn;
    
    route_ID = @"0";
    route_Name = @"全部线路";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseRoute)];
    [self.routeBtn addGestureRecognizer:tap];
}
- (void)chooseRoute{
    __weak typeof(self)weakself = self;
    //弹出路线选择界面
    [RouteListView routeId:route_ID action:^(NSString *route_id, NSString *route_name) {
//        title_Label.text = route_name;
//        CGSize size = [title_Label sizeThatFits:CGSizeMake(0, 40)];
//        if (size.width>(SCREEN_WIDTH-40)) {
//            size = CGSizeMake(SCREEN_WIDTH-40, 40);
//        }
//        titleView.center = CGPointMake(SCREEN_WIDTH/2,20);
//        title_Label.frame = CGRectMake(0, 0, size.width, 40);
//        titleView.bounds = CGRectMake(0, 0, size.width+40, 40);
//        route_ID = route_id;
//        route_Name = route_name;
//        [bgScroll.mj_header beginRefreshing];
    
        route_ID = route_id;
        [self.routeBtn resetData:route_name Image:IMAGE(@"bule_down_icon")];
//        [self loadData:self.routeId isShowProgress:YES];
 
        [weakself getData];
    }];
}


- (void)createView{
  
    bgScroll = [[UIScrollView alloc]init];
    bgScroll.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgScroll.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    [self.view addSubview:bgScroll];
    bgScroll.contentSize = CGSizeMake(0, 150*UISCALE+35*UISCALE+150*UISCALE+220*UISCALE+125*UISCALE*2+2*UISCALE*5+120*UISCALE+20*UISCALE);

     //1.今日
    UIView *todYerView = [[UIView alloc]init];
    todYerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150*UISCALE);
    todYerView.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];//COLOR_MAIN;
    [bgScroll addSubview:todYerView];
            //中间分割线
    UIView *centerView = [[UIView alloc]init];
    centerView.frame = CGRectMake(SCREEN_WIDTH/2-12*UISCALE, 16*UISCALE, 1, 125*UISCALE);
    centerView.backgroundColor = RGBACOLOR(233, 233, 233, 1);
    [todYerView addSubview:centerView];
    //lab字体颜色
    UIColor *titleColor = [UIColor whiteColor];

    for (int i = 0; i<2; i++) {
        //显示今日销售额、本月累计销售额 lab
        UILabel *todSaleLabel = [[UILabel alloc]init];
        todSaleLabel.frame = CGRectMake(20+SCREEN_WIDTH/2*i, 5, SCREEN_WIDTH/2-16, 36);
        todSaleLabel.text = i<1?@"今日销售额(元)":@"本月累计销售额(元)";
        todSaleLabel.textColor = titleColor;
        todSaleLabel.font = FONT_OF_SIZE(12);
        [todYerView addSubview:todSaleLabel];
       //显示今日销售额、本月累计销售额 数字lab
        UILabel *allMoney = [[UILabel alloc]init];
        allMoney.frame = CGRectMake(5*UISCALE+SCREEN_WIDTH/2*i, 46*UISCALE,SCREEN_WIDTH/2-32, 128-36*2);
        allMoney.text = @"0";
        allMoney.font = FONT_OF_SIZE(28);
        allMoney.textAlignment = NSTextAlignmentCenter;
        allMoney.textColor = titleColor;
        [todYerView addSubview:allMoney];
        allMoney.tag= TodaySaleTags+i;
        
        //显示 在线  0   现金  0 数字的lab
        //在线
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.frame = CGRectMake((SCREEN_WIDTH/2)*i, 100*UISCALE, SCREEN_WIDTH/4, 36);
//        moneyLabel.backgroundColor=[UIColor orangeColor];
        moneyLabel.textColor = titleColor;
        moneyLabel.textAlignment=NSTextAlignmentCenter;
        moneyLabel.text = @"在线";
        moneyLabel.font = FONT_OF_SIZE(12);
        [todYerView addSubview:moneyLabel];
        //现金
        UILabel *moneyLabel1 = [[UILabel alloc]init];
        moneyLabel1.frame = CGRectMake(SCREEN_WIDTH/4+(SCREEN_WIDTH/2)*i, 100*UISCALE, SCREEN_WIDTH/4, 36);
        moneyLabel1.textColor = titleColor;
        moneyLabel1.textAlignment=NSTextAlignmentCenter;
        moneyLabel1.text = @"现金";
        moneyLabel1.font = FONT_OF_SIZE(12);
        [todYerView addSubview:moneyLabel1];
        
        //在线数字
        UILabel *moneyLabel2 = [[UILabel alloc]init];
        moneyLabel2.frame = CGRectMake((SCREEN_WIDTH/2)*i, 120*UISCALE, SCREEN_WIDTH/4, 36);
        moneyLabel2.textColor = titleColor;
        moneyLabel2.textAlignment=NSTextAlignmentCenter;
        moneyLabel2.text = @"0";
        moneyLabel2.font = FONT_OF_SIZE(12);
        [todYerView addSubview:moneyLabel2];
        moneyLabel2.tag=TodayonlineTags+i;
        //现金数字
        UILabel *moneyLabel3 = [[UILabel alloc]init];
        moneyLabel3.frame = CGRectMake(SCREEN_WIDTH/4+(SCREEN_WIDTH/2)*i, 120*UISCALE, SCREEN_WIDTH/4, 36);
        moneyLabel3.textColor = titleColor;
        moneyLabel3.textAlignment=NSTextAlignmentCenter;
        moneyLabel3.text = @"0";
        moneyLabel3.font = FONT_OF_SIZE(12);
        [todYerView addSubview:moneyLabel3];
        moneyLabel3.tag=TodaycashTags+i;
    
}
    
        //昨日查看更多
        UIView *moreView = [[UIView alloc]init];
        moreView.frame = CGRectMake(0, CGRectGetMaxY(todYerView.frame), SCREEN_WIDTH, 35*UISCALE);
        moreView.backgroundColor = [UIColor whiteColor];
        [bgScroll addSubview:moreView];
        UILabel *attenLabel = [[UILabel alloc]init];
        attenLabel.frame = CGRectMake(16, 0, 80, 35);
        attenLabel.text = @"昨日";
        attenLabel.font = FONT_OF_SIZE(15);
        [moreView addSubview:attenLabel];
    
    
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        moreBtn.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, 35);
        [moreBtn setTitle:@"查看更多>" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = FONT_OF_SIZE(13);
        [moreBtn setTintColor:BLUE];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"whiteSelect"] forState:UIControlStateHighlighted];
        [moreBtn addTarget:self action:@selector(buttonForMore) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:moreBtn];
    
//   2.昨日
    
    UIView *yestodayView = [[UIView alloc]init];
    yestodayView.frame = CGRectMake(0, CGRectGetMaxY(moreView.frame)+2*UISCALE, SCREEN_WIDTH, 150*UISCALE);
    yestodayView.backgroundColor = [UIColor whiteColor];
    [bgScroll addSubview:yestodayView];
    
    
    //中间分割线
    UIView *yescenterView = [[UIView alloc]init];
    yescenterView .frame = CGRectMake(SCREEN_WIDTH/2-10*UISCALE, CGRectGetMaxY(moreView.frame)+18*UISCALE, 1, 120*UISCALE);
    yescenterView .backgroundColor = RGBACOLOR(233, 233, 233, 1);
    [bgScroll addSubview:yescenterView ];
    
    for (int i = 0; i<2; i++) {
        
        //显示昨日销售额、昨日销售量(件) lab
        UILabel *yesSaleLabel = [[UILabel alloc]init];
        yesSaleLabel.frame = CGRectMake(20+SCREEN_WIDTH/2*i, 5, SCREEN_WIDTH/2-16, 36);
        yesSaleLabel.text = i<1?@"昨日销售额(元)":@"昨日销售量(件)";
        yesSaleLabel.textColor = [UIColor grayColor];
        yesSaleLabel.font = FONT_OF_SIZE(12);
        [yestodayView addSubview:yesSaleLabel];
        
         //显示昨日销售额、昨日销售量(件)数量 lab
        UILabel *yesallMoney = [[UILabel alloc]init];
        yesallMoney .frame = CGRectMake(5*UISCALE+SCREEN_WIDTH/2*i, 46*UISCALE,SCREEN_WIDTH/2-32, 36);
        yesallMoney .text = @"0";
        yesallMoney .font = FONT_OF_SIZE(36);
        yesallMoney .textAlignment = NSTextAlignmentCenter;
        yesallMoney .textColor = COLOR_MAIN;
        [yestodayView addSubview:yesallMoney ];
        yesallMoney.tag=YesterdayTags+i;
        
        //显示 在线  0   现金  0 数字的lab
        //在线
        UILabel *yesmoneyLabel = [[UILabel alloc]init];
        yesmoneyLabel.frame = CGRectMake((SCREEN_WIDTH/2)*i, 100*UISCALE, SCREEN_WIDTH/4, 36);
        //        moneyLabel.backgroundColor=[UIColor orangeColor];
        yesmoneyLabel.textColor = COLOR_GRAY;
        yesmoneyLabel.textAlignment=NSTextAlignmentCenter;
        yesmoneyLabel.text = @"在线";
        yesmoneyLabel.font = FONT_OF_SIZE(12);
        [yestodayView addSubview:yesmoneyLabel];
        //现金
        UILabel *yesmoneyLabel1 = [[UILabel alloc]init];
        yesmoneyLabel1.frame = CGRectMake(SCREEN_WIDTH/4+(SCREEN_WIDTH/2)*i, 100*UISCALE, SCREEN_WIDTH/4, 36);
        yesmoneyLabel1.textColor = COLOR_GRAY;
        yesmoneyLabel1.textAlignment=NSTextAlignmentCenter;
        yesmoneyLabel1.text = @"现金";
        yesmoneyLabel1.font = FONT_OF_SIZE(12);
        [yestodayView addSubview:yesmoneyLabel1];
        
        //在线数字
        UILabel *moneyLabel2 = [[UILabel alloc]init];
        moneyLabel2.frame = CGRectMake((SCREEN_WIDTH/2)*i, 120*UISCALE, SCREEN_WIDTH/4, 36);
        moneyLabel2.textColor = COLOR_GRAY;
        moneyLabel2.textAlignment=NSTextAlignmentCenter;
        moneyLabel2.text = @"0";
        moneyLabel2.font = FONT_OF_SIZE(12);
        [yestodayView addSubview:moneyLabel2];
        moneyLabel2.tag=YesterdayonlineTags+i;
        //现金数字
        UILabel *yesmoneyLabel3 = [[UILabel alloc]init];
        yesmoneyLabel3.frame = CGRectMake(SCREEN_WIDTH/4+(SCREEN_WIDTH/2)*i, 120*UISCALE, SCREEN_WIDTH/4, 36);
        yesmoneyLabel3.textColor = COLOR_GRAY;
        yesmoneyLabel3.textAlignment=NSTextAlignmentCenter;
        yesmoneyLabel3.text = @"0";
        yesmoneyLabel3.font = FONT_OF_SIZE(12);
        [yestodayView addSubview:yesmoneyLabel3];
        yesmoneyLabel3.tag=YesterdaycashTags+i;
    }

  
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(yestodayView.frame)+2*UISCALE, SCREEN_WIDTH, 35*UISCALE)];
    lab.backgroundColor=[UIColor whiteColor];
    lab.text=@"近七日销售情况";
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor blackColor];
    [bgScroll addSubview:lab];;

 //    初始化折线图
    CFLineChartView *LCView = [CFLineChartView lineChartViewWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame)+0.5, SCREEN_WIDTH, 210*UISCALE)];
    LCView.backgroundColor=[UIColor whiteColor];
//    LCView.xValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
//    LCView.yValues = @[@35, @5, @80, @40, @50, @13, @50, @75,@25, @100, @64, @95, @33, @100];
    [bgScroll addSubview:LCView];
    self.LCView=LCView;
//    self.LCView.isShowLine = YES;// 是否显示方格
    self.LCView.isShowPoint = YES;// 是否显示点
    self.LCView.isShowValue = YES;//是否显示数据
    
    

     NSArray *titeArr = @[@"运营评分",@"补货(台)"];

        //背景View
        UIView *detailView = [[UIView alloc]init];
        detailView.frame = CGRectMake(0, CGRectGetMaxY(LCView.frame)+5,SCREEN_WIDTH, 125*UISCALE);
        detailView.backgroundColor = [UIColor whiteColor];
        [bgScroll addSubview:detailView];
    for (int i = 0; i<titeArr.count ; i++) {
             //显示title
        UILabel *titleLabel = [[UILabel alloc]init];

        titleLabel.frame = CGRectMake(30+(SCREEN_WIDTH/2+50)*i, 0, 150, 36);
        titleLabel.text = titeArr[i];
//        titleLabel.backgroundColor=[UIColor orangeColor];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.font = FONT_OF_SIZE(17);
        titleLabel.textColor = COLOR_GRAY;
        [detailView addSubview:titleLabel];
        //中间分割线
        UIView *centerLine=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 13, 1, 100)];
        centerLine.backgroundColor=[UIColor lightGrayColor];
        [detailView addSubview:centerLine];

        //显示数字的lab
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.frame = CGRectMake(50+SCREEN_WIDTH/2*i, CGRectGetMaxY(titleLabel.frame)+10, 100, 50);
        numberLabel.font = FONT_OF_SIZE(40);
        numberLabel.tag = DetailViewTags+i;
        numberLabel.text = @"0";
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = COLOR_MAIN;
        [detailView addSubview:numberLabel];
    }
    //推荐台数及损失
    UILabel *yunyingdetailLabel = [[UILabel alloc]init];
    yunyingdetailLabel.frame = CGRectMake(-10, 128-36, SCREEN_WIDTH/2+30, 36);
//    yunyingdetailLabel.backgroundColor=[UIColor orangeColor];
    yunyingdetailLabel.textAlignment=NSTextAlignmentCenter;
    yunyingdetailLabel.tag = DetailMarkTags+0;
    [detailView addSubview:yunyingdetailLabel];
    yunyingdetailLabel.font = FONT_OF_SIZE(12);
    yunyingdetailLabel.attributedText = [self getAttributiteStrWithNumMachine:@"0" andloss:@"0"];
    

    
    //应收款
    UIView *detailView1 = [[UIView alloc]init];
    detailView1.frame = CGRectMake(0, CGRectGetMaxY(detailView.frame)+5,SCREEN_WIDTH, 125*UISCALE);
    detailView1.backgroundColor = [UIColor whiteColor];
    [bgScroll addSubview:detailView1];
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 128);
    [accountButton setBackgroundColor:RGBACOLOR(248, 248, 248, 1)];
    [detailView1 addSubview:accountButton];
    
    UILabel *moneyLab=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 50)];
    moneyLab.text=@"应收款";
    moneyLab.textAlignment=NSTextAlignmentLeft;
    moneyLab.textColor=[UIColor grayColor];
    [accountButton addSubview:moneyLab];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.frame = CGRectMake(30, 128-36,SCREEN_WIDTH-32, 36);
    detailLabel.tag = DetailMarkTags+2;
    [accountButton addSubview:detailLabel];
    detailLabel.font = FONT_OF_SIZE(12);
    detailLabel.attributedText = [self getAttributeStrWithMachineNum:@"0"];
    UILabel *moneyNum = [[UILabel alloc]init];
    moneyNum.frame = CGRectMake(30, 50,SCREEN_WIDTH-60, 50);
    moneyNum.textAlignment=NSTextAlignmentCenter;
    moneyNum.textColor = COLOR_MAIN;
    moneyNum.tag = DetailViewTags+2;
    [accountButton addSubview:moneyNum];
    moneyNum.font = FONT_OF_SIZE(40);
    [accountButton addSubview:moneyNum];
    
    [accountButton addTarget:self action:@selector(ShouldPay) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *chooseImage = [[UIImageView alloc]init];
    chooseImage.center = CGPointMake(SCREEN_WIDTH-16-20, accountButton.frame.size.height/2);
    chooseImage.bounds = CGRectMake(0, 0, 40, 40);
    chooseImage.image = [UIImage imageNamed:@"next"];
    [accountButton addSubview:chooseImage];
    
    
    
    
    bgScroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];

    [bgScroll.mj_header beginRefreshing];

}

- (void)ShouldPay{
    XXAccountViewController *accountVC = [[XXAccountViewController alloc]init];
    accountVC.routeStr = route_Name;
    accountVC.routeID = route_ID;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)buttonForMore{
    //二级查看更多界面

    XXDateViewController *dataVC = [[XXDateViewController alloc]init];
    dataVC.routeID = route_ID;
    dataVC.routeName = route_Name;
    [self.navigationController pushViewController:dataVC animated:YES];
}


//刷新数据
- (void)getData{
    isArchive = NO;
    //今日营销额
    __block UILabel *todayLabel = [self.view viewWithTag:TodaySaleTags+0];
    //本月累计销售额
    __block UILabel *monthLabel = [self.view viewWithTag:TodaySaleTags+1];
    //今日在线／现金
    __block UILabel *todOnlineMonLab = [self.view viewWithTag:TodayonlineTags+0];
    
    __block UILabel *todOffLineMonLab = [self.view viewWithTag:TodaycashTags+0];
    //本月在线／现金
    __block UILabel *monthOnlineMonLab = [self.view viewWithTag:TodayonlineTags+1];
     __block UILabel *monthOfflineMonLab = [self.view viewWithTag:TodaycashTags+1];
    
    
    //昨日销售额
    __block UILabel *yesterdayLabel = [self.view viewWithTag:YesterdayTags+0];
    //销售件
    __block UILabel *typeLabel = [self.view viewWithTag:YesterdayTags+1];
    
    //昨日销售额在线／现金
    __block UILabel *yesOnlineMonLab = [self.view viewWithTag:YesterdayonlineTags+0];
    __block UILabel *yesOffLineMonLab = [self.view viewWithTag:YesterdaycashTags+0];
    //昨日销售件在线／现金
    __block UILabel *typePicOnlineLab = [self.view viewWithTag:YesterdayonlineTags+1];
    __block UILabel *typePicOfflineLab = [self.view viewWithTag:YesterdaycashTags+1];

    
    
    
    //运营评分
    __block UILabel *yunLabel = [self.view viewWithTag:DetailViewTags+0];
    __block UILabel *yunDetailLabel = [self.view viewWithTag:DetailMarkTags+0];
    
    __block UILabel *buhuoLabel = [self.view viewWithTag:DetailViewTags+1];
    //应收款
    __block UILabel *shoukuanLabel = [self.view viewWithTag:DetailViewTags+2];
    __block UILabel *shoukuanDetailLabel = [self.view viewWithTag:DetailMarkTags+2];
    
    //#warning 加载请求刷新数据
    __weak typeof(self) weakSelf = self;
    [XXReportHandle getReportDetailDateWithRouteID:route_ID withBlock:^(NSString *todayMoney, NSString *monthMoney, NSString *todOnlineMon, NSString *todOffLineMon, NSString *monthOnlineMon, NSString *monthOfflineMon, NSString *yesterMon, NSString *typePic, NSString *yesOnlineMon, NSString *yesOffLineMon, NSString *typePicOnline, NSString *typePicOffline, NSString *yunying, NSString *yunyingDetail, NSString *lossMoney, NSString *buhuo, NSString *shoukuan, NSString *shoukuanDetail, NSMutableArray *dateArr, NSMutableArray *totalMoneyArr) {
        
        if (dateArr.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
            todayLabel.text = todayMoney;
            monthLabel.text = monthMoney;
                
            todOnlineMonLab.text = todOnlineMon;
            todOffLineMonLab.text = todOffLineMon;
                
                
            monthOnlineMonLab.text = monthOnlineMon;
            monthOfflineMonLab.text =monthOfflineMon;

            yesterdayLabel.text = yesterMon;
            typeLabel.text = typePic;
                
            yesOnlineMonLab.text = yesOnlineMon;
            yesOffLineMonLab.text = yesOffLineMon;
                
                
           typePicOnlineLab.text = typePicOnline;
                
          typePicOfflineLab.text = typePicOffline;
                yunLabel.text = yunying;
                NSAttributedString *yunAttributedStr = [weakSelf getAttributiteStrWithNumMachine:yunyingDetail andloss:lossMoney];
                yunDetailLabel.attributedText = yunAttributedStr;
                buhuoLabel.text = buhuo;
                shoukuanLabel.text = shoukuan;
                NSAttributedString *shoukuanAttributedStr = [weakSelf getAttributeStrWithMachineNum:shoukuanDetail];
                shoukuanDetailLabel.attributedText = shoukuanAttributedStr;
            
                //处理折线图数据
                NSMutableArray *dates=[NSMutableArray arrayWithCapacity:0];
                NSMutableArray *numbers=[NSMutableArray arrayWithCapacity:0];
                
                //  七天日期数值 按日期排列
                for (int i = 0; i<dateArr.count; i++) {
                    [dates addObject:dateArr[dateArr.count-1-i]];
                }
                //七天日期按顺序排列
                for (int i = 0; i<totalMoneyArr.count; i++) {
                    [numbers addObject:totalMoneyArr[totalMoneyArr.count-1-i]];
                }
                
                self.LCView.xValues =dates;
                self.LCView.yValues = numbers;
                //画直线折线图

                [self.LCView drawChartWithLineChartType:  LineChartType_Straight pointType: PointType_Circel];
         

                isArchive = YES;
            });
        }
        [bgScroll.mj_header endRefreshing];
    }];
}


- (NSMutableAttributedString *)getAttributiteStrWithNumMachine:(NSString *)machineNum andloss:(NSString *)lossMoney{
    
    NSUInteger numMach = machineNum.length;
    NSUInteger lossNum = lossMoney.length;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@台未处理机器,损失%@元",machineNum,lossMoney]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value: RGBACOLOR(168, 45, 27, 1)
     
                          range:NSMakeRange(0, numMach)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:COLOR_GRAY
     
                          range:NSMakeRange(numMach, 9)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value: RGBACOLOR(168, 45, 27, 1)
     
                          range:NSMakeRange(9+numMach, lossNum)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value: COLOR_GRAY
     
                          range:NSMakeRange(9+numMach+lossNum, 1)];
    return AttributedStr;
    
}
- (NSMutableAttributedString *)getAttributeStrWithMachineNum:(NSString *)machineNum{
    
    NSUInteger numberMach = machineNum.length;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"应收款机器%@台",machineNum]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:COLOR_MAIN
     
                          range:NSMakeRange(5, numberMach)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:COLOR_GRAY
     
                          range:NSMakeRange(numberMach+5, 1)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:COLOR_GRAY
     
                          range:NSMakeRange(0, 5)];
    return AttributedStr;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
