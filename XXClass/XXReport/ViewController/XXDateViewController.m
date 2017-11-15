//
//  XXDateViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXDateViewController.h"
#import "AMDateTableViewCell.h"
#import "AMDateModel.h"
#import "RouteListView.h"
#import "XXNoNetView.h"
#import "XXNoDataView.h"
#import "XXDetailViewController.h"


@interface XXDateViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *dateTableView;
    int a;
    NSString *route_ID;
    NSString *route_Name;
    UILabel *routeLabel;
    NSString *routesRember;
    XXNoNetView *noNetView;
    XXNoDataView *noDataView;
    
}
@property(strong,nonatomic)NSMutableArray *dateArr;


@end

@implementation XXDateViewController

- (NSMutableArray *)dateArr{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self->dateTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.navigationController.navigationBar.translucent=YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"日期选择";
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
//    
    route_Name = self.routeName;
    route_ID = self.routeID;
    
    [self createView];
    [self getDate];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(duanwang:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
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
//    button.backgroundColor = COLOR_MAIN;
    [button addTarget:self action:@selector(chooseRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    routeLabel = [[UILabel alloc]init];
    routeLabel.text = route_Name;
    routeLabel.textAlignment = 1;
    routeLabel.font = FONT_OF_SIZE(15);
    routeLabel.textColor = [UIColor blackColor];
    CGSize size = [routeLabel sizeThatFits:CGSizeMake(0, 36)];
    routeLabel.frame = CGRectMake(10, 0, size.width, 36);
//    routeLabel.textAlignment=NSTextAlignmentCenter;
    [button addSubview:routeLabel];
    UIImageView *chooseImage = [[UIImageView alloc]init];
    chooseImage.image = [UIImage imageNamed:@"bule_down_icon"];
    //    chooseImage.frame = CGRectMake(CGRectGetMaxX(routeLabel.frame), 0, 40, 40);
    [button addSubview:chooseImage];
    [chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(routeLabel.mas_right).offset(8*UISCALE                                      );
        make.top.mas_equalTo(routeLabel).offset(11*UISCALE);
        make.height.mas_equalTo(10*UISCALE);
        make.width.mas_equalTo(10*UISCALE);
    }];
    
    NSArray *arr = @[@"日期",@"销售额(元)",@"销售量(件)"];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor=RGB(249, 249, 249);
    bgView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), SCREEN_WIDTH, 40);
    [self.view addSubview:bgView];
    for (int i = 0; i<3; i++) {
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.frame = CGRectMake(SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, bgView.frame.size.height);
        dateLabel.text = arr[i];
        dateLabel.font = FONT_OF_SIZE(15);
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor=[UIColor blackColor];
        [bgView addSubview:dateLabel];
    }
    //    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height+0.5, SCREEN_WIDTH, 0.5)];
    //    separView.backgroundColor = [UIColor grayColor];;
    //    [bgView addSubview:separView];
    //
    
    dateTableView = [[UITableView alloc]init];
    dateTableView.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(bgView.frame));
    dateTableView.delegate = self;
    dateTableView.dataSource = self;
    [self.view addSubview:dateTableView];
    dateTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [dateTableView registerClass:[AMDateTableViewCell class] forCellReuseIdentifier:@"cell"];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [dateTableView setTableFooterView:view];
    
    
    noNetView = [[XXNoNetView alloc]initWithFrame:dateTableView.frame];
    [noNetView refreshForNewMessage:^{
        a = 0;
        [self getDate];
    }];
    [self.view addSubview:noNetView];
    
    
    __weak typeof(self) weakSelf = self;
    dateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        a = 0;
        [weakSelf loadData];
    }];
    dateTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        a = a+10;
        [weakSelf loadData];
    }];
    
    
}

- (void)loadData{
    
    __weak typeof(self) weakSelf = self;
    
    [XXReportHandle getDateArrWithRouteID:route_ID andBegainIndex:[NSString stringWithFormat:@"%d",a] andCount:[NSString stringWithFormat:@"%d",10] WithBlock:^(NSMutableArray *dateArr,BOOL LossConnect) {
        if (!LossConnect) {
            if (a==0) {
                [weakSelf.dateArr removeAllObjects];
                if (dateArr != nil) {
                    noDataView.hidden = YES;
                    [weakSelf.dateArr addObjectsFromArray:dateArr];
                }else{
                    noDataView.hidden = NO;;
                    [noDataView reloadWithPicName:@"ic_no_alter" AndTitle:@"哎呀，没数据。。。"];
                }
            }else{
                if (dateArr!=nil) {
                    noDataView.hidden = YES;
                    [weakSelf.dateArr addObjectsFromArray:dateArr];
                }
            }
            
            [noNetView removeFromSuperview];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [dateTableView reloadData];
            [dateTableView.mj_header endRefreshing];
            [dateTableView.mj_footer endRefreshing];
        });
    }];
    
}

- (void)getDate{
    noDataView = [[XXNoDataView alloc]initWithFrame:dateTableView.frame];
    [noDataView reloadWithPicName:nil AndTitle:@"数据加载中..."];
    [self.view addSubview:noDataView];
    
    __weak typeof(self)weakself = self;
    if ([route_ID isEqualToString:@"0"]||route_ID.length<1) {
        
        [XXToolHandle getAllRoutesWithBlock:^(NSString *allRoutes,BOOL LossConnect) {
            if (!LossConnect) {
                if (allRoutes.length<1) {
                    [noDataView reloadWithPicName:@"ic_no_alter" AndTitle:@"没有可选的线路，请先分配线路"];
                }else{
                    route_ID = allRoutes;
                    routesRember = allRoutes;
                    route_Name = @"全部线路";
                    [weakself loadData];
                }
            }
        }];
    }else{
        [self loadData];
    }
    
}
- (void)chooseRoute{
    __weak typeof(self)weakself = self;
    if ([route_ID isEqualToString:routesRember]) {
        route_ID = @"0";
    }
    //换过路线之后调用请求刷新，把a重制为0；
    [RouteListView routeId:route_ID action:^(NSString *route_id, NSString *route_name) {
        routeLabel.text = route_name;
        CGSize size = [routeLabel sizeThatFits:CGSizeMake(0, 36)];
        routeLabel.frame = CGRectMake(10, 0, size.width, 36);
        if ([route_id isEqualToString:@"0"]) {
            route_ID = routesRember;
        }else{
            route_ID = route_id;
        }
        route_Name = route_name;
        
        [dateTableView.mj_header beginRefreshing];
        [weakself loadData];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*UISCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dateArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AMDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    AMDateModel *model = self.dateArr[indexPath.row];
    cell.selectChoose = 1;
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMDateModel *model = self.dateArr[indexPath.row];
    XXDetailViewController *detailVC = [[XXDetailViewController alloc]init];
    detailVC.data = model.dateStr;
    detailVC.route = route_ID;
    NSLog(@" detailVC.route=%@",detailVC.route);
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noDataView removeFromSuperview];
}

@end
