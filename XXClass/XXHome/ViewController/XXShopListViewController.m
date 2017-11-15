//
//  XXShopListViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/18.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXShopListViewController.h"
#import "XXShopListDetailViewController.h"
#import "RouteModel.h"

@interface XXShopListViewController ()<UITableViewDataSource,UITableViewDelegate,XXBaseViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *routeArr;


@end

@implementation XXShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//      self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    self.navigationItem.title = @"选择线路";
    
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
       [self.tableView.mj_header beginRefreshing];
    [self loadData];
}

- (void)setupPageSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
}

- (void)setupPageSubviewsProperty
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15 * UISCALE, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
           }];
    


}

- (void)loadData
{
    self.tableView.hidden = YES;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [XXHomeHandle requestRouteListWidthManagerId:MANAGER_ID callback:^(NSMutableArray *routeArray, BOOL isSuccess) {
        self.routeArr = routeArray;
        self.loadDataSuccess = isSuccess;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

        self.tableView.hidden = !isSuccess;
        if (isSuccess) {
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - UITableViewDelegate and UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SECTION_HEIGHT * UISCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    RouteModel *route = self.routeArr[indexPath.row];
    cell.textLabel.text = route.routeName;
    cell.textLabel.font = FontNotoSansLightWithSafeSize(16);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RouteModel *route = self.routeArr[indexPath.row];
    XXShopListDetailViewController *goodsVC = [[XXShopListDetailViewController alloc] init];
    goodsVC.routeId = route.routeId;
    goodsVC.hasSend = route.stockupFlg;
    NSLog(@"goodsVC.hasSend=%@",goodsVC.hasSend);
    [self.navigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - custom delegate
- (void)refreshPageData
{
    [self loadData];
}

#pragma mark - setters and getters
- (NSMutableArray *)routeArr
{
    if (_routeArr == nil) {
        self.routeArr = [NSMutableArray array];
    }
    return _routeArr;
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
