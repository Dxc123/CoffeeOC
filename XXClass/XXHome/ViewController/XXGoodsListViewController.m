//
//  XXGoodsListViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/20.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXGoodsListViewController.h"
#import "GoodsTableViewCell.h"
#import "MachineListTableViewCell.h"
#import "ImageBtn.h"
#import "MachineView.h"

#import "MachineModel.h"
#import "YinliaoModel.h"
#import "AMMachineTypeModel.h"

@interface XXGoodsListViewController ()
<UITableViewDelegate,
UITableViewDataSource,
XXBaseViewControllerDelegate>
// 头视图
@property (nonatomic, strong) MachineView *machineView;

@property (nonatomic, strong) UITableView *tableView;
// 机器编码
@property (nonatomic, strong) NSMutableString *machineSns;

@property (nonatomic, strong) NSMutableArray *machineTypeArr;;
// 记录section是否展开
@property (nonatomic, strong) NSMutableDictionary *markDic;

@end

@implementation XXGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实时备货信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
    [self loadData];
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];
}

- (void)setupPageSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
}

- (void)setupPageSubviewsProperty
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.tableView.hidden = YES;
    [XXHomeHandle requestMachineGoodsListWithMachineSn:self.machineSns callback:^(NSMutableArray *typeArray, BOOL isSuccess) {
        self.machineTypeArr = typeArray;
        self.loadDataSuccess = isSuccess;
        [self.tableView reloadData];
        self.tableView.hidden = !isSuccess;
        if (isSuccess) {
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AMMachineTypeModel *typeModel;
    NSString *tag = [NSString stringWithFormat:@"%ld",
                     section+2000];
    if (section != 0) {
        if ([self.markDic[tag] integerValue] == 1 && self.machineTypeArr.count != 0) {
            typeModel = self.machineTypeArr[section - 1];
            return typeModel.machineRoadList.count;
        } else {
            return 0;
        }
    } else {
        if ([self.markDic[tag] integerValue] == 1) {
            return self.machineArr.count;
        } else {
            return 1;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kCellHeight * UISCALE;
    } else {
        return 64 * UISCALE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.machineArr.count > 1) {
            return SECTION_HEIGHT * UISCALE;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return SECTION_HEIGHT * UISCALE;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 背景view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTION_HEIGHT * UISCALE)];
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTap:)];
    view.tag = 2000 + section;
    [view addGestureRecognizer:tap];
    
    // 下线view
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    [view addSubview:bottomLine];
    
    // 箭头view
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * UISCALE, 13 * UISCALE, 24 * UISCALE, 24 * UISCALE)];
    arrowView.image = IMAGE(@"ic_right_black");
    [view addSubview:arrowView];
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)view.tag];
    if ([self.markDic[str] integerValue] == 1) {
        arrowView.image = IMAGE(@"ic_down_black");
    }
    
    // 内容label
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(10 * UISCALE);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-10 * UISCALE);
        make.width.mas_equalTo(150 * UISCALE);
        make.left.mas_equalTo(arrowView.mas_right).offset(11 * UISCALE);
    }];
    label.font = FontNotoSansLightWithSafeSize(14);
    if (section == 1) {
        label.text = @"饮料";
    } else if (section == 2) {
        label.text = @"食品";
    } else if (section == 3) {
        label.text = @"其他";
    }
    
    // 数量label
    UILabel *numLabel = [[UILabel alloc] init];
    [view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(10 * UISCALE);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-10 * UISCALE);
        make.right.mas_equalTo(view.mas_right).offset(-11 * UISCALE);
        make.left.mas_equalTo(label.mas_right).offset(11 * UISCALE);
    }];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = FontNotoSansLightWithSafeSize(14);
    
    AMMachineTypeModel *typeModel;
    if (self.machineTypeArr.count != 0) {
        typeModel = self.machineTypeArr[section - 1];
        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
                         (long)[typeModel.totalOutStockCount integerValue]];
    } else {
        numLabel.text = @"总缺货量0";
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // 背景view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTION_HEIGHT * UISCALE)];
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTap:)];
    view.tag = 2000 + section;
    [view addGestureRecognizer:tap];
    
    // 下线view
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    [view addSubview:bottomLine];
    
    // 下拉
    NSString *title = [NSString stringWithFormat:@"查看全部%ld台机器", (unsigned long)self.machineArr.count];
    ImageBtn *imgBtn = [[ImageBtn alloc] initWithFrame:CGRectMake(110 * UISCALE, 0, 100 * UISCALE, SECTION_HEIGHT * UISCALE)
                                                 Title:title
                                                 Image:IMAGE(@"ic_down_black")];
    imgBtn.lb_title.textColor = [UIColor grayColor];
    imgBtn.lb_title.font = FontNotoSansLightWithSafeSize(14);
    [view addSubview:imgBtn];
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)view.tag];
    if ([self.markDic[str] integerValue] == 1) {
        NSString *title = [NSString stringWithFormat:@"收起全部%ld台机器", (unsigned long)self.machineArr.count];
        [imgBtn resetData:title Image:IMAGE(@"ic_up_black")];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        static NSString *reuse = @"GoodsTableViewCell";
        GoodsTableViewCell *cell = [[GoodsTableViewCell alloc] init];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AMMachineTypeModel *typeModel = self.machineTypeArr[indexPath.section - 1];
        NSDictionary *dic = typeModel.machineRoadList[indexPath.row];
        YinliaoModel *yinliao = [[YinliaoModel alloc] init];
        [yinliao setValuesForKeysWithDictionary:dic];
        cell.isLive = YES;
        cell.goodsInfoLabel.text = [NSString stringWithFormat:@"%@(%@%@装)", yinliao.goodsName, yinliao.goodsNum,yinliao.goodsUnit];
        cell.numLabel.text = [NSString stringWithFormat:@"需%@箱 %@", yinliao.outStockBoxCount, yinliao.outStockCount];
        return cell;
    } else {
        static NSString *reuse = @"MachineListTableViewCell";
        MachineListTableViewCell *cell = [[MachineListTableViewCell alloc] init];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MachineModel *machine = self.machineArr[indexPath.row];
        cell.machineSn = machine.machineSn;
        cell.position = machine.positionName;
        cell.isGuzhang = [machine.isGuzhang integerValue];
        cell.isQuehuo = [machine.isQuehuo integerValue];
        cell.isQuebi = [machine.isQuebi integerValue];
        cell.isDuanwang = [machine.isDuanwang integerValue];
        return cell;
    }
}

#pragma mark - custom delegate
- (void)refreshPageData
{
    [self loadData];
}

#pragma mark - event response
- (void)sectionTap:(UITapGestureRecognizer *)tap
{
    NSString *tag = [NSString stringWithFormat:@"%ld", tap.view.tag];
    if ([self.markDic[tag] integerValue] == 1) {
        [self.markDic setObject:@"0" forKey:tag];
    } else {
        [self.markDic setObject:@"1" forKey:tag];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tap.view.tag - 2000];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - setters and getterss
- (NSMutableString *)machineSns
{
    if (_machineSns == nil) {
        self.machineSns = [NSMutableString string];
        for (MachineModel *machine in self.machineArr) {
            [self.machineSns appendFormat:@"%@;", machine.machineSn];
        }
    }
    return _machineSns;
}

- (NSMutableDictionary *)markDic
{
    if (_markDic == nil) {
        self.markDic = [NSMutableDictionary dictionary];
    }
    return _markDic;
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
