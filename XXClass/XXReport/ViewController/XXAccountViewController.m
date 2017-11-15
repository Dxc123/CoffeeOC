//
//  XXAccountViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXAccountViewController.h"
#import "AMDateTableViewCell.h"
#import "AMAccountModel.h"
#import "RouteListView.h"
#import "XXNoNetView.h"
#import "XXNoDataView.h"
#import <AFNetworking.h>
#import "XXHistoryAccountViewController.h"
typedef enum :NSInteger{
    saleLabelTags = 10,
    
}tags;

@interface XXAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *Routelabel;
    UITableView *machDetailTableView;
    NSString *routeStrChoose;
    XXNoNetView *noNetView;
    XXNoDataView *noDataView;
    NSString *route_Name;
}
@property(strong,nonatomic)NSMutableArray *dateArr;

@end

@implementation XXAccountViewController

- (NSMutableArray *)dateArr{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"应收款";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;

    
//        [self.navigationController.navigationBar setTitleTextAttributes:
//         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lishi"] style:UIBarButtonItemStylePlain target:self action:@selector(HistoryForMoney)];
//    
    routeStrChoose = self.routeID;
    route_Name = self.routeStr;
    [self createView];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(duanwang:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}
//历史应收款
- (void)HistoryForMoney{
    XXHistoryAccountViewController *historyVC = [[XXHistoryAccountViewController alloc]init];
    historyVC.routeName = route_Name;
    historyVC.routeID = routeStrChoose;
    [self.navigationController pushViewController:historyVC animated:YES];
}
- (void)duanwang:(NSNotification *)sender{
    NSDictionary *dic = sender.userInfo;
    //获取网络状态
    NSInteger status = [[dic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    if (status == 0) {
        noDataView.hidden = YES;
    }
    
}
- (void)createView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 64, SCREEN_WIDTH, 36);
    button.backgroundColor = COLOR_MAIN;
    [button addTarget:self action:@selector(chooseRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    Routelabel = [[UILabel alloc]init];
    Routelabel.text = route_Name;
    Routelabel.font = FONT_OF_SIZE(13);
    Routelabel.textColor = [UIColor whiteColor];
    Routelabel.textColor = [UIColor whiteColor];
    CGSize size = [Routelabel sizeThatFits:CGSizeMake(0, 40)];
    Routelabel.frame = CGRectMake(10, 0, size.width, 40);
    [button addSubview:Routelabel];
    UIImageView *chooseImage = [[UIImageView alloc]init];
    chooseImage.image = [UIImage imageNamed:@"ic_down"];
    chooseImage.frame = CGRectMake(CGRectGetMaxX(Routelabel.frame), 0, 40, 40);
    [button addSubview:chooseImage];
    [chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Routelabel.mas_right);
        make.top.mas_equalTo(Routelabel).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    UILabel *dateStr = [[UILabel alloc]init];
    dateStr.frame = CGRectMake(SCREEN_WIDTH-110, 0, 100, 40);
    dateStr.text = self.DateString;
    dateStr.textColor = [UIColor whiteColor];
    [button addSubview:dateStr];
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), SCREEN_WIDTH, 100);
    bgView.backgroundColor = COLOR_MAIN;
    [self.view addSubview:bgView];
    NSArray *titleArr = @[@"售货机",@"应收款(元)"];
    for (int i = 0; i<2; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+SCREEN_WIDTH/2*i, 5, SCREEN_WIDTH/2-20, 40)];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = FONT_OF_SIZE(12);
        [bgView addSubview:titleLabel];
        UILabel *saleLabel = [[UILabel alloc]init];
        saleLabel.center = CGPointMake(SCREEN_WIDTH/4+SCREEN_WIDTH/2*i, 55);
        saleLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH/2-2, 60);
        saleLabel.textAlignment = NSTextAlignmentCenter;
        saleLabel.font = FONT_OF_SIZE(36);
        saleLabel.text = @"0";
        saleLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:saleLabel];
        saleLabel.tag = saleLabelTags+i;
    }
    UIView *centerView = [[UIView alloc]init];
    centerView.frame = CGRectMake(SCREEN_WIDTH/2, 10, 0.5, 80);
    centerView.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    [bgView addSubview:centerView];
    
    machDetailTableView = [[UITableView alloc]init];
    machDetailTableView.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(bgView.frame)-64);
    machDetailTableView.delegate = self;
    machDetailTableView.dataSource = self;
    [self.view addSubview:machDetailTableView];
    machDetailTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [machDetailTableView registerClass:[AMDateTableViewCell class] forCellReuseIdentifier:@"accountCell"];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [machDetailTableView setTableFooterView:view];
    
    noNetView = [[XXNoNetView alloc]initWithFrame:machDetailTableView.frame];
    [noNetView refreshForNewMessage:^{
        [self getData];
    }];
    [self.view addSubview:noNetView];
    
    
    noDataView = [[XXNoDataView alloc]initWithFrame:machDetailTableView.frame];
    [noDataView reloadWithPicName:nil AndTitle:@"数据加载中..."];
    [self.view addSubview:noDataView];
}
- (void)getData{
    
    UILabel *totalMachineLabel = [self.view viewWithTag:saleLabelTags+0];
    UILabel *totalMoneyLabel = [self.view viewWithTag:saleLabelTags+1];
    
    __weak typeof(self) weakself = self;
    //#warning 全部线路routeid这里为0
    [XXReportHandle getMoneyForAccountDetailWithRouteIDS:routeStrChoose WithBlock:^(NSMutableArray *arr,NSString *totalMachineNum,NSString *totalMoney,BOOL LossConnect) {
        if (arr.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                totalMachineLabel.text = totalMachineNum;
                totalMoneyLabel.text = totalMoney;
                [weakself.dateArr removeAllObjects];
                [weakself.dateArr addObjectsFromArray:arr];
                [machDetailTableView reloadData];
                
                [noNetView removeFromSuperview];
                noDataView.hidden = YES;
            });
        }else{
            totalMachineLabel.text = @"0";
            totalMoneyLabel.text = @"0";
            noDataView.hidden = NO;
            [noDataView reloadWithPicName:@"ic_no_alter" AndTitle:@"本线路没有可收款的售货机"];
        }
        
    }];
}

//选择路线
- (void)chooseRoute{
    
    __weak typeof(self)weakself = self;
    [RouteListView routeId:routeStrChoose action:^(NSString *route_id, NSString *route_name) {
        route_Name = route_name;
        Routelabel.text = route_name;
        CGSize size = [Routelabel sizeThatFits:CGSizeMake(0, 40)];
        Routelabel.frame = CGRectMake(10, 0, size.width, 40);
        routeStrChoose = route_id;
        noDataView.hidden = NO;
        [noDataView reloadWithPicName:nil AndTitle:@"数据加载中..."];
        [weakself getData];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noDataView removeFromSuperview];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76*UISCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell"];
    if (!cell) {
        cell = [[AMDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountCell"];
    }
    cell.contentView.backgroundColor=RGB(248, 248, 248);
    AMAccountModel *model = self.dateArr[indexPath.row];
    cell.selectChoose = 3;
    cell.accountModel = model;
    return cell;
}


@end
