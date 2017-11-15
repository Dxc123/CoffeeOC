//
//  XXFailViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/19.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXFailViewController.h"
#import "MachineListTableViewCell.h"
#import "MachineModel.h"
#import "XXFailHeaderView.h"
#import "XXQuhuoViewController.h"
@interface XXFailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
XXBaseViewControllerDelegate>
@property (nonatomic, strong) XXFailHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation XXFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];
    [self loadDataShowProgress:YES];
}

- (void)setupPageSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.headerView = [[XXFailHeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220 * UISCALE);
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupPageSubviewsProperty
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataShowProgress:NO];
    }];
    
    switch (self.machineType) {
        case 1:
            //            self.headerView.backgroundColor =BLUE;
            
            self.headerView.bgImage.image=IMAGE(@"noshop_icon");
            
            self.headerView.topLabel.text = @"当前线路待补货设备数(台)";
            break;
        case 2:
            //            self.headerView.backgroundColor = QUEBI_COLOR;
            self.headerView.bgImage.image=IMAGE(@"wendu_icon");
            self.headerView.topLabel.text = @"当前线路咖啡机设备数(台)";
            self.headerView.numLabel.textColor=RGB(240, 193, 46);
            break;
        case 3:
            //            self.headerView.backgroundColor =BUHUO_COLOR;
            self.headerView.bgImage.image=IMAGE(@"nonet-icon");
            self.headerView.topLabel.text = @"当前线路断网设备数(台)";
             self.headerView.numLabel.textColor=RGB(95, 223, 236);
            break;
        case 4:
            //            self.headerView.backgroundColor = GUZHANG_COLOR;
            self.headerView.bgImage.image=IMAGE(@"preblem_icon");
            self.headerView.topLabel.text = @"当前线路故障设备数(台)";
             self.headerView.numLabel.textColor=[UIColor redColor];
            break;
        default:
            break;
    }
}

#pragma mark - private method
- (void)loadDataShowProgress:(BOOL)isShow
{
    if (isShow) {
        self.tableView.hidden = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    
    [XXHomeHandle requestFailListWithManagerId:MANAGER_ID routeId:self.routeId machineType:self.machineType callback:^(NSMutableArray *dataArray, NSString *machineCount, BOOL isSuccess) {
        self.dataArr = dataArray;
        self.loadDataSuccess = isSuccess;
        self.headerView.numLabel.text = machineCount;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.tableView.hidden = !isSuccess;
        if (self.isViewLoaded && self.view.window && isSuccess) {
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight * UISCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"MachineListTableViewCell";
    MachineListTableViewCell *cell = [[MachineListTableViewCell alloc] init];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    }
    MachineModel *machine = self.dataArr[indexPath.row];
    cell.machineSn = machine.machineSn;
    cell.position = [NSString stringWithFormat:@"%@·%@", machine.machineName, machine.positionName];
    cell.isGuzhang = [machine.isGuzhang integerValue];
    cell.isQuehuo = [machine.isQuehuo integerValue];
    cell.isQuebi = [machine.isQuebi integerValue];
    cell.isDuanwang = [machine.isDuanwang integerValue];
    if ([machine.isGuzhang integerValue] == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MachineModel *machine = self.dataArr[indexPath.row];
    if ([machine.isGuzhang integerValue] == 1) {
        XXQuhuoViewController *quehuoVC = [[XXQuhuoViewController alloc] init];
        quehuoVC.isFail = YES;
        quehuoVC.machineSn = machine.machineSn;
        [self.navigationController pushViewController:quehuoVC animated:YES];
    }
}

#pragma mark - custom delegate
- (void)refreshPageData
{
    [self loadDataShowProgress:YES];
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
