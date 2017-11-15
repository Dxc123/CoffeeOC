//
//  XXLiveStockUpViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/20.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXLiveStockUpViewController.h"
#import "MachineListTableViewCell.h"
#import "XXGoodsListViewController.h"
// Model
#import "RouteModel.h"
#import "MachineModel.h"


@interface XXLiveStockUpViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate,
XXBaseViewControllerDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectorArr;

@property (nonatomic, strong) RouteModel *route;

@property (nonatomic, assign) BOOL searchShow;


@end

@implementation XXLiveStockUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"生成指定机器的备货单";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"ic_search") style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    //    self.searchBar = [[UISearchBar alloc] init];
    //    [self.view addSubview:self.searchBar];
    //    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    //    self.searchBar.placeholder = @"输入查询的机器编号";
    //    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
    //    self.searchBar.delegate = self;
    //    self.searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //
    
    
    [self setupUI];
    [self loadDataWithText:@"0"];
    self.holderView.isSearch = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self barDisapper];
    self.searchShow = NO;
}

- (void)setupUI
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60 * UISCALE);
    
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15 * UISCALE, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    //多选
    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    
    
    
    // 全选button布局
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:selectAll];
    selectAll.tag = 3000;
    
    [selectAll setBackgroundColor:RGB_COLOR(68, 138, 255) ];
    selectAll.titleLabel.font = FontNotoSansLightWithSafeSize(18);
    [selectAll addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(60 * UISCALE);
    }];
    
    // 确定button布局
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sureBtn];
    [sureBtn setBackgroundColor:RGB_COLOR(68, 138, 255) ];
    sureBtn.titleLabel.font = FontNotoSansLightWithSafeSize(18);
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(60 * UISCALE);
    }];
    //分割线
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor whiteColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectAll.mas_right);
        make.width.mas_equalTo(0.5);
        make.top.mas_equalTo(selectAll.mas_top).offset(18 * UISCALE);
        make.bottom.mas_equalTo(selectAll.mas_bottom).offset(-17 * UISCALE);
    }];
}

- (void)loadDataWithText:(NSString *)text
{
    self.tableView.hidden = YES;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [XXHomeHandle requestSearchWithRouteId:self.routeId text:text callback:^(id route) {
        self.route = route;
        [SVProgressHUD dismiss];
        self.tableView.hidden = NO;
        if (self.selectorArr.count != self.route.machineInfoList.count) {
            UIButton *button = [self.view viewWithTag:3000];
            [button setTitle:@"全选" forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        [self saveSeleted];
        if (self.route.machineInfoList.count == 0) {
            self.tableView.hidden = YES;
            self.holderView.hidden = NO;
        }
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.route.machineInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76 * UISCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"MachineListTableViewCell";
    
    MachineListTableViewCell *cell = [[MachineListTableViewCell alloc] init];
    if(cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    }
//    cell.selectionStyle= UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    
    MachineModel *machine = self.route.machineInfoList[indexPath.row];
    cell.machineSn = machine.machineSn;
    cell.position = machine.positionName;
    cell.isGuzhang = [machine.isGuzhang integerValue];
    cell.isQuehuo = [machine.isQuehuo integerValue];
    cell.isQuebi = [machine.isQuebi integerValue];
    cell.isDuanwang = [machine.isDuanwang integerValue];
//    cell.machineView.lineView.hidden = YES;
    
    return cell;
}


// 多选状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;//出现多选按钮，当中间是&是，多选按钮消失，可自定义自定义多选按钮！
}

// 选中（将选中row添加到selectorArr中）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectorArr addObject:self.route.machineInfoList[indexPath.row]];
    if (self.selectorArr.count == self.route.machineInfoList.count) {
        UIButton *button = [self.view viewWithTag:3000];
        [button setTitle:@"取消全选" forState:UIControlStateNormal];
    }
}

// 取消选中（将选中row移出selectorArr）
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectorArr.count > 0) {
        [self.selectorArr removeObject:self.route.machineInfoList[indexPath.row]];
    }
    if (self.selectorArr.count != self.route.machineInfoList.count) {
        UIButton *button = [self.view viewWithTag:3000];
        [button setTitle:@"全选" forState:UIControlStateNormal];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [self loadDataWithText:@"0"];
    } else {
        [self loadDataWithText:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self barDisapper];
    self.searchShow = !self.searchShow;
}

#pragma mark - custom delegate
- (void)refreshPageData
{
    [self loadDataWithText:@"0"];
}

// 保留已选中
- (void)saveSeleted
{
    if (self.selectorArr.count != 0) {
        for (NSInteger i = 0; i < self.selectorArr.count; i++) {
            MachineModel *temp = self.selectorArr[i];
            for (NSInteger j = 0; j < self.route.machineInfoList.count; j++) {
                MachineModel *model = self.route.machineInfoList[j];
                if ([model.machineSn isEqualToString:temp.machineSn]) {
                    [self.route.machineInfoList removeObject:model];
                }
            }
            [self.route.machineInfoList insertObject:temp atIndex:0];
        }
        [self.tableView reloadData];
        for (int i = 0; i < self.selectorArr.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if (self.selectorArr.count == self.route.machineInfoList.count) {
            UIButton *button = [self.view viewWithTag:3000];
            [button setTitle:@"取消全选" forState:UIControlStateNormal];
        }
    }
}

- (void)barDisapper
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(0, 64 * UISCALE, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60 * UISCALE);
        self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        [self.searchBar resignFirstResponder];
    }];
}


#pragma mark - event response
- (void)allSelect:(UIButton *)button
{
    if (self.route.machineInfoList.count != 0) {
        if ([button.titleLabel.text isEqualToString:@"全选"]) {
            [button setTitle:@"取消全选" forState:UIControlStateNormal];
            for (int i = 0; i < self.route.machineInfoList.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self.selectorArr setArray:self.route.machineInfoList];
            }
        } else {
            [self.selectorArr removeAllObjects];
            [button setTitle:@"全选" forState:UIControlStateNormal];
            for (int i = 0; i < self.route.machineInfoList.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
    }
}

- (void)sure:(UIButton *)button
{
    if (self.selectorArr.count != 0) {
        
        XXGoodsListViewController *goodsVC = [[XXGoodsListViewController alloc] init];
        goodsVC.machineArr = self.selectorArr;
        [self.navigationController pushViewController:goodsVC animated:YES];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }else{
        [XWAlert showAlertWithTitle:@"提示" message:@"请选择机器" preferredStyle:Alert autoDismissTime:0.5];
        
    }
}

- (void)search
{
    if (!self.searchShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.searchBar.frame = CGRectMake(0, 64 * UISCALE, SCREEN_WIDTH, 44 * UISCALE);
            self.tableView.frame = CGRectMake(0, 64 * UISCALE*2, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 104 * UISCALE);
        }];
    } else {
        [self barDisapper];
    }
    self.searchShow = !self.searchShow;
}

#pragma mark - setters and getters
- (NSMutableArray *)selectorArr
{
    if (_selectorArr == nil) {
        self.selectorArr = [NSMutableArray array];
    }
    return _selectorArr;
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
