//
//  XXSearchViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/19.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXSearchViewController.h"
#import "AMSearchTableViewCell.h"
#import "XXPlacehoderView.h"
#import "XXQuhuoViewController.h"
#import "BaseSearchBar.h"
#import "MachineModel.h"


@interface XXSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) BaseSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) XXPlacehoderView *placeholderView;

@property (nonatomic, assign) BOOL showCache;


@end

@implementation XXSearchViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor=[UIColor lightGrayColor];
    [self wr_setNavBarBarTintColor:[UIColor colorHexToBinaryWithString:@"#2da9ff"]];
    [self wr_setNavBarBackgroundAlpha:0];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    
    [self setupUI];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.showCache = YES;
    self.searchBar.text = nil;
    self.dataArr = [USER_DEFAULTS objectForKey:@"searchCache"];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)setupUI
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.holderView = [[XXPlacehoderView alloc] init];
    self.holderView.frame = self.tableView.frame;
    [self.tableView addSubview:self.holderView];
   
    
    self.searchBar = [[BaseSearchBar alloc] init];
    self.searchBar.translucent=NO;
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入机器编号";
    self.searchBar.barTintColor=[UIColor colorHexToBinaryWithString:@"#0483de"];;
    //    self.searchBar.keyboardType=UIKeyboardTypeNumberPad;
    self.holderView.isSearch = YES;
    self.navigationItem.titleView = self.searchBar;


    
    
}



#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MACHINE_CELL_HEIGHT * UISCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.showCache && self.dataArr.count != 0) {
        return 50 * UISCALE;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 * UISCALE)];
    label.backgroundColor = RGB_COLOR(235, 235, 235);
    label.font = FontNotoSansLightWithSafeSize(16);
    label.text = @"清空搜索历史";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCache)];
    [label addGestureRecognizer:tap];
    label.userInteractionEnabled = YES;
    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"AMSearchTableViewCell";
    AMSearchTableViewCell *cell = [[AMSearchTableViewCell alloc] init];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    }
    MachineModel *machine = [[MachineModel alloc] init];
    if (self.showCache) {
        NSDictionary *machineDic = self.dataArr[indexPath.row];
        [machine setValuesForKeysWithDictionary:machineDic];
        cell.imgView.image = IMAGE(@"ic_history");
        self.holderView.hidden = YES;
    } else {
        machine = self.dataArr[indexPath.row];
        cell.imgView.image = IMAGE(@"ic_search_black");
    }
    cell.machineSn = machine.machineSn;
    cell.position = [NSString stringWithFormat:@"%@·%@", machine.machineName, machine.positionName];
    cell.isGuzhang = [machine.isGuzhang integerValue];
    cell.isQuehuo = [machine.isQuehuo integerValue];
    cell.isQuebi = [machine.isQuebi integerValue];
    cell.isDuanwang = [machine.isDuanwang integerValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXQuhuoViewController*quehuoVC = [[XXQuhuoViewController alloc] init];
    MachineModel *machine = [[MachineModel alloc] init];
    if (self.showCache) {
        NSDictionary *machineDic = self.dataArr[indexPath.row];
        [machine setValuesForKeysWithDictionary:machineDic];
    } else {
        machine = self.dataArr[indexPath.row];
    }
    quehuoVC.machineSn = machine.machineSn;
    [self.navigationController pushViewController:quehuoVC animated:YES];
    
    [self saveCache:machine];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (BOOL)isChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ( [self isChinese:searchText]) {
        
        [XWAlert showAlertWithTitle:@"请输入机器编号" message:nil confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle: Alert confirmHandle:^{
            NSLog(@"确定");
        } cancleHandle:^{
            NSLog(@"取消");
        }];
    }else{
        if (searchText.length != 0) {
            
           //请求数据
            [self loadData:searchText];
            self.showCache = NO;
        } else {
            self.dataArr = [USER_DEFAULTS objectForKey:@"searchCache"];
            if (self.dataArr.count == 0) {
                self.holderView.hidden = NO;
                self.showCache = NO;
            } else {
                self.showCache = YES;
            }
            [self.tableView reloadData];
        }

    }
    
    
//    if (searchText.length != 0) {
//        [self loadData:searchText];
//        self.showCache = NO;
//    } else {
//        self.dataArr = [USER_DEFAULTS objectForKey:@"searchCache"];
//        if (self.dataArr.count == 0) {
//            self.holderView.hidden = NO;
//            self.showCache = NO;
//        } else {
//            self.showCache = YES;
//        }
//        [self.tableView reloadData];
//    }
}
- (void)loadData:(NSString *)searchText
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [XXHomeHandle requestSearchWithManagerId:MANAGER_ID text:searchText callback:^(NSMutableArray *dataArray) {
        self.dataArr = dataArray;
        if (self.dataArr.count != 0) {
            self.holderView.hidden = YES;
        } else {
            self.holderView.hidden = NO;
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

#pragma mark - private method
// 存储搜索历史
- (void)saveCache:(MachineModel *)machine
{
    // 存储搜索历史
    NSDictionary *dic = [machine yy_modelToJSONObject];
    
    NSArray *cacheArr = [USER_DEFAULTS objectForKey:@"searchCache"];
    if (!cacheArr) {
        cacheArr = [NSArray array];
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:cacheArr];
    for (NSInteger i = 0; i < tempArr.count; i++) {
        NSDictionary *temp = tempArr[i];
        if ([temp[@"machineSn"] isEqual:dic[@"machineSn"]]) {
            [tempArr removeObject:temp];
            break;
        }
    }
    [tempArr addObject:dic];
    if (tempArr.count > 10) {
        [tempArr removeObjectAtIndex:0];
    }
    cacheArr = [[tempArr reverseObjectEnumerator] allObjects];
    [USER_DEFAULTS setObject:cacheArr forKey:@"searchCache"];
}


#pragma mark - event response
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearCache
{
    [USER_DEFAULTS removeObjectForKey:@"searchCache"];
    self.dataArr = [NSMutableArray array];
    [self.tableView reloadData];
    self.holderView.hidden = NO;
}
- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
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
