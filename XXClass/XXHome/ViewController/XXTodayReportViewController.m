//
//  XXTodayReportViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/18.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXTodayReportViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "AMTodayReportTableViewCell.h"

#import "ImageBtn.h"
#import "RouteListView.h"

#import "AMTodayReportModel.h"
#import "AMReportAlarmModel.h"



@interface XXTodayReportViewController ()<UITableViewDelegate,UITableViewDataSource,XXBaseViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ImageBtn *routeBtn;

@property (nonatomic, copy) NSString *routeId;

@property (nonatomic, strong) AMTodayReportModel *reportModel;

@end

@implementation XXTodayReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日运营报告";
    self.view.backgroundColor = [UIColor whiteColor];
    self.routeId = @"0";
    
    [self loadDataWithRouteId:@"0"];
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];
}

- (void)setupPageSubviews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36 * UISCALE)];
    [self.view addSubview:topView];
    topView.backgroundColor = BLUE;
    self.routeBtn = [[ImageBtn alloc] initWithFrame:CGRectMake(20 * UISCALE,0, 0, 36 * UISCALE) Title:@"全部线路" Image:IMAGE(@"down_icon")];
    self.routeBtn.lb_title.font = FontNotoSansLightWithSafeSize(16);
    self.routeBtn.lb_title.textColor=[UIColor whiteColor];
    [topView addSubview:self.routeBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)-2, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    
}

- (void)setupPageSubviewsProperty
{
    [self.routeBtn resetData:@"全部线路" Image:IMAGE(@"down_icon")];
    UITapGestureRecognizer *routeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(routeTap)];
    [self.routeBtn addGestureRecognizer:routeTap];
    
    //    self.tableView.bounces = NO;
    self.tableView.backgroundColor = RGB_COLOR(235, 235, 235);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.reportModel.noReplenishMachineList.count;
    } else {
        return self.reportModel.replenishMachineList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76 * UISCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 * UISCALE;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180 * UISCALE;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 176 * UISCALE)];
    view.backgroundColor = BLUE;
    // tipLabel 补货台数(台)
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 100* UISCALE,  SCREEN_WIDTH, 18 * UISCALE)];
    tipsLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:tipsLabel];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.font = FontNotoSansLightWithSafeSize(17);
    // 底部标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    [view addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = FontNotoSansLightWithSafeSize(16);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom).offset(0.5);
        make.height.mas_equalTo(48 * UISCALE);
    }];
    //    底部标题白色view
    UIView *lineView = [[UIView alloc] init];
    [view addSubview:lineView];
    lineView.backgroundColor = LINE_COLOR;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.right.mas_equalTo(titleLabel.mas_right);
        make.top.mas_equalTo(view.mas_top).offset(0.5);
        make.height.mas_equalTo(0.5);
    }];
    // 数字label
    UILabel *numLabel = [[UILabel alloc] init];
    [view addSubview:numLabel];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = FontNotoSansLightWithSafeSize(48);
    numLabel.frame=CGRectMake(0 , 20* UISCALE,  SCREEN_WIDTH, 50 * UISCALE);
    //    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(view.mas_left);
    //        make.right.mas_equalTo(view.mas_right);
    //        make.top.mas_equalTo(tipsLabel.mas_bottom);
    //        make.bottom.mas_equalTo(titleLabel.mas_top).offset(-20 * UISCALE);
    //    }];
    
    if (section == 0) {
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.reportModel.replenishedCount integerValue]];
        tipsLabel.text = @"补货台数(台)";
        titleLabel.text = [NSString stringWithFormat:@"   未补货推荐点位%ld台",
                           (long)[self.reportModel.noReplenishCount integerValue]];
    } else {
        numLabel.text = [NSString stringWithFormat:@"%ld/%ld",
                         (long)[self.reportModel.allRouteCount integerValue],
                         (long)[self.reportModel.currentRouteCount integerValue]];
        tipsLabel.text = @"补货次数(全部线路/当前线路)";
        titleLabel.text = [NSString stringWithFormat:@"   已补货%ld台",
                           (long)[self.reportModel.replenishCount integerValue]];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *reuse = @"AMTodayReportTableViewCella";
        AMTodayReportTableViewCell *cell = [[AMTodayReportTableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
        }
        cell.isTimeShow = NO;
//        cell.freeBtn.backgroundColor = BLUE;
        [cell.freeBtn setTitle:@"完成补货" forState:UIControlStateNormal];
        [cell.freeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [cell.freeBtn setBackgroundColor:BLUE];
        cell.freeBtn.tag = indexPath.row + 1000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buHuo:)];
        [cell.freeBtn addGestureRecognizer:tap];
        
        AMReportAlarmModel *alarmModel = self.reportModel.noReplenishMachineList[indexPath.row];
        cell.machineSn = alarmModel.machineSn;
        cell.position = [NSString stringWithFormat:@"%@·%@", alarmModel.routeName, alarmModel.positionName];;
        cell.timeStyleLabel.text = [NSString stringWithFormat:@"缺货%ld小时", (long)[alarmModel.distanceHour integerValue]];
        
        return cell;
    } else {
        static NSString *reuse = @"AMTodayReportTableViewCellb";
        AMTodayReportTableViewCell *cell = [[AMTodayReportTableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
        }
        cell.isTimeShow = YES;
        [cell.freeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        AMReportAlarmModel *alarmModel = self.reportModel.replenishMachineList[indexPath.row];
        cell.machineSn = alarmModel.machineSn;
        cell.position = [NSString stringWithFormat:@"%@·%@", alarmModel.routeName, alarmModel.positionName];;
        [cell.freeBtn setTitle:alarmModel.transactTime forState:UIControlStateNormal];
        cell.freeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        if ([alarmModel.transactType integerValue] == 1) {
            cell.timeStyleLabel.text = @"手机补货";
        } else {
            cell.timeStyleLabel.text = @"机器补货";
        }
        cell.timeStyleLabel.textColor = BLUE;
        
        return cell;
    }
}

#pragma mark - custom delegate
- (void)refreshPageData
{
    [self loadDataWithRouteId:self.routeId];
}

#pragma mark - private method
- (void)loadDataWithRouteId:(NSString *)routeId
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.tableView.hidden = YES;
    self.routeBtn.hidden = YES;
    [XXHomeHandle requestReportWithManagerId:MANAGER_ID routeId:routeId callback:^(id report, BOOL isSuccess) {
        self.reportModel = report;
        self.loadDataSuccess = isSuccess;
        [self.tableView reloadData];
        self.tableView.hidden = !isSuccess;
        self.routeBtn.hidden = !isSuccess;
        if (isSuccess) {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)hudDismiss:(BOOL)isSuccess
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [self loadDataWithRouteId:self.routeId];
        }
    });
}

#pragma mark - event response
- (void)routeTap
{
    [RouteListView routeId:self.routeId action:^(NSString *route_id, NSString *route_name) {
        self.routeId = route_id;
        [self loadDataWithRouteId:self.routeId];
        [self.routeBtn resetData:route_name Image:IMAGE(@"down_icon")];
    }];
}

- (void)buHuo:(UITapGestureRecognizer *)tap
{
    NSInteger i = tap.view.tag - 1000;
    AMReportAlarmModel *alarmModel = self.reportModel.noReplenishMachineList[i];
    [SVProgressHUD show];
    self.tableView.userInteractionEnabled = NO;
    [XXHomeHandle completeGoodsWithManagerId:MANAGER_ID alarmId:alarmModel.alarmId callback:^(BOOL isSuccess) {
        [self hudDismiss:isSuccess];
        self.tableView.userInteractionEnabled = YES;
    }];
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
