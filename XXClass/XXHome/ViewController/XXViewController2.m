//
//  XXViewController2.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/10/25.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXViewController2.h"
#import "MachineListTableViewCell2.h"
#import "RouteModel.h"
#import "MachineModel.h"
#import "CoffeeMachineModel.h"
#import "XXHomeHandle.h"
@interface XXViewController2 ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray * _dataArray;
    NSArray *_rowArray;
    NSArray *_sectionArray;

}
@property (nonatomic, strong) UITableView   *tableView;
// section数组
@property (nonatomic, strong) NSMutableArray *sectionArr;
// 咖啡机器数组
@property (nonatomic, strong) NSMutableArray *coffeeMachineArr;
// 机器数组
@property (nonatomic, strong) NSMutableArray *machineArr;
// 记录当前路线Id
@property (nonatomic, copy) NSString *routeId;

@end

@implementation XXViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置tableView
    [self setUpTableView];
    
    //一进入就加载全部路线列表
    [self loadData:@"0" isShowProgress:YES];
    self.routeId = @"0";
    
}

- (void)loadData:(NSString *)routeId isShowProgress:(BOOL)isShow
{
    if (isShow) {
        self.tableView.hidden = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    self.tableView.userInteractionEnabled = NO;
    
    
    
    [XXHomeHandle requestMachineCountWithManagerId:MANAGER_ID routeId:routeId callback:^(NSMutableArray *countArray, NSMutableArray *sectionArray, NSMutableArray *machineArray, NSMutableArray *coffeeMachineArray,NSString *replenishmentCount, NSString *lossAmount, BOOL isSuccess) {
        NSLog(@"cell嵌套内容");
        self.machineArr = machineArray;
        self.coffeeMachineArr = coffeeMachineArray;
        self.sectionArr = sectionArray;
        
        self.loadDataSuccess = isSuccess;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.userInteractionEnabled = YES;
        self.tableView.hidden = !isSuccess;
        if ( isSuccess) {
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
        }
    }];
}
//配置tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210*UISCALE) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor =[UIColor colorHexToBinaryWithString:@"#2da9ff"];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return 10;
    RouteModel *route = self.sectionArr[section];
    return route.coffeeMachineInfoList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*UISCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //    };
    
    static NSString *reuse = @"MachineListTableViewCell";
    MachineListTableViewCell2 *cell = [[MachineListTableViewCell2 alloc] init];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    }
    //显示分割线
    //  tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    RouteModel *route = self.sectionArr[indexPath.section];
    CoffeeMachineModel *machine = route.coffeeMachineInfoList[indexPath.row];
    cell.machineSn = machine.machineSn;
    cell.position = machine.positionName;
    cell.isGuzhang = [machine.isGuzhang integerValue];
    cell.isDuanwang = [machine.isDuanwang integerValue];
//    cell.isQuehuo = [machine.isQuehuo integerValue];
//    cell.isQuebi = [machine.isQuebi integerValue];
    
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"cell:%ld",_index];
    
    //    RouteModel *route = [[RouteModel alloc] init];
    //     cell.textLabel.text = [NSString stringWithFormat:@"%@(共%@台)", route.routeName, route.machineCount];
    return cell;
}
//设置cell的背景色

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];//[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
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
