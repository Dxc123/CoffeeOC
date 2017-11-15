//
//  XXCoffeeQueHuoViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/13.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXCoffeeQueHuoViewController.h"
#import "AlarmInfoTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "MachineView.h"
#import "MachineModel.h"
#import "CoffeeMachineModel.h"
#import "YinliaoModel.h"
#import "AlarmInfoModel.h"
#import "MachineModel.h"
#import "XXQuhuoHeaderView.h"
#import "XXQueHuoView.h"
#import "XXCoffeeQueHuoCell.h"
#import "CoffeeMaterialPredictListModel.h"
@interface XXCoffeeQueHuoViewController ()
<UITableViewDelegate,
UITableViewDataSource,
XXBaseViewControllerDelegate,UIAlertViewDelegate>
{
    UIButton *myCreateButton;
}
@property (nonatomic, strong) AlarmInfoModel *alarm;
@property (nonatomic, strong) MachineModel *machine;
@property (nonatomic, strong) CoffeeMachineModel *coffeeMachine;
// 头视图
//@property (nonatomic, strong) MachineView *machineView;
//@property (nonatomic, strong) XXQuhuoHeaderView *machineView;
@property (nonatomic, strong) XXQueHuoView *machineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *alarmTableView;
// 记录section是否展开
@property (nonatomic, strong) NSMutableDictionary *markDic;

@end

@implementation XXCoffeeQueHuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];
    [self loadData];
    [self loadeCoffeeData];
    self.navigationItem.title = @"咖啡机缺货查询";
    
}
- (void)setMachine:(CoffeeMachineModel *)machine{
    if (_coffeeMachine!=machine) {
        _coffeeMachine = machine;
    }
    for (int i = 0; i<self.coffeeMachine.alarmInfoList.count; i++) {
        AlarmInfoModel *alarm = self.coffeeMachine.alarmInfoList[i];
        if (alarm.typeName.length==0) {
            [self.coffeeMachine.alarmInfoList removeObjectAtIndex:i];
        }
    }
}

- (void)setupPageSubviews
{
    //    self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.machineView = [XXQueHuoView new];
    self.machineView.lineView.hidden = YES;
    self.tableView.tableHeaderView = self.machineView;
    [self.machineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0*UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(0*UISCALE);
        make.top.mas_equalTo(self.view.top).offset(0*UISCALE);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(180*UISCALE);
    }];
    
}

- (void)setupPageSubviewsProperty
{
    //    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[AlarmInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AlarmInfoTableViewCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.tableView.hidden = YES;
    self.tableView.hidden = YES;
    [XXHomeHandle requestCoffeeMachineGoodsWithMachineSn:self.machineSn callback:^(id machine, BOOL isSuccess) {
                self.machine = machine;
                self.loadDataSuccess = isSuccess;
                self.machineView.titleText = self.coffeeMachine.machineSn;
                self.machineView.isQuehuo = [self.coffeeMachine.isQuehuo integerValue];
                self.machineView.isQuebi = [self.coffeeMachine.isQuebi integerValue];
                self.machineView.isDuanwang = [self.coffeeMachine.isDuanwang integerValue];
                self.machineView.isGuzhang = [self.coffeeMachine.isGuzhang integerValue];
                self.machineView.detailText = [NSString stringWithFormat:@"%@·%@", self.coffeeMachine.routeName, self.coffeeMachine.positionName];
                [self.tableView reloadData];
                self.tableView.hidden = !isSuccess;
                if (isSuccess) {
                    [SVProgressHUD dismiss];
                }
    }];
    
}

-(void)loadeCoffeeData{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.tableView.hidden = YES;
    
    
    
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.coffeeMachine.MaterialPredictList.count;
    
//    NSString *tag = [NSString stringWithFormat:@"%ld", section + 2000];
//    if (section != 0) {
//        if ([self.markDic[tag] integerValue] == 1) {
//            if (section == 1) {
//                return self.machine.yinliaoRoadList.count;
//            } else if (section == 2){
//                return self.machine.shipinRoadList.count;
//            } else {
//                return self.machine.qitaRoadList.count;
//            }
//        } else {
//            return 0;
//        }
//    } else {
//        return self.machine.alarmInfoList.count;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    if (self.isFail) {
//        return 1;
//    } else {
//        return 4;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT * UISCALE;
//    if (section == 0) {
//        return 0;
//    } else {
//        return SECTION_HEIGHT * UISCALE;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 50 * UISCALE;
//    if (indexPath.section != 0) {
//        return 64 * UISCALE;
//    }
//    else {
//        AlarmInfoModel *model = self.coffeeMachine.alarmInfoList[indexPath.row];
//        return (40 * UISCALE + model.addHig);
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.coffeeMachine.alarmInfoList.count != 0) {
        return 0.5;
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
    NSArray *titles = @[@"物料名称",@"货道容量",@"出货量"];
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0+i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 45)];
        [view addSubview:lab];
        lab.text = titles[i];
        lab.textAlignment = NSTextAlignmentCenter;
//        lab.font = [UIFont systemFontOfSize:17];
    
    }
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTap:)];
//    view.tag = 2000 + section;
//    [view addGestureRecognizer:tap];
//
//    // 下线view
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
//    bottomLine.backgroundColor = LINE_COLOR;
//    [view addSubview:bottomLine];
//
//    // 箭头view
//    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * UISCALE, 13 * UISCALE, 24 * UISCALE, 24 * UISCALE)];
//    arrowView.image = IMAGE(@"ic_right_black");
//    [view addSubview:arrowView];
//
//    NSString *str = [NSString stringWithFormat:@"%ld", (long)view.tag];
//    if ([self.markDic[str] integerValue] == 1) {
//        arrowView.image = IMAGE(@"ic_down_black");
//    }
//
//    // 内容label
//    UILabel *label = [[UILabel alloc] init];
//    [view addSubview:label];
//    label.font = FontNotoSansLightWithSafeSize(13);
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(view.mas_top).offset(10 * UISCALE);
//        make.bottom.mas_equalTo(view.mas_bottom).offset(-10 * UISCALE);
//        make.width.mas_equalTo(150 * UISCALE);
//        make.left.mas_equalTo(arrowView.mas_right).offset(11 * UISCALE);
//    }];
//    if (section == 1) {
//        label.text = @"饮料";
//    }
//    else if (section == 2) {
//        label.text = @"食品";
//    } else if (section == 3) {
//        label.text = @"其他";
//    }
//
//    // 数量label
//    UILabel *numLabel = [[UILabel alloc] init];
//    [view addSubview:numLabel];
//    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(view.mas_top).offset(10 * UISCALE);
//        make.bottom.mas_equalTo(view.mas_bottom).offset(-10 * UISCALE);
//        make.right.mas_equalTo(view.mas_right).offset(-11 * UISCALE);
//        make.left.mas_equalTo(label.mas_right).offset(11 * UISCALE);
//    }];
//    numLabel.textAlignment = NSTextAlignmentRight;
//    numLabel.font = FontNotoSansLightWithSafeSize(13);
//
//    if (section == 1) {
//        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
//                         (long)[self.machine.yinliaoOutStockCount integerValue]];
//    } else if (section == 2) {
//        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
//                         (long)[self.machine.shipinOutStockCount integerValue]];
//    } else if (section == 3) {
//        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
//                         (long)[self.machine.qitaOutStockCount integerValue]];
//    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // 线view
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    return bottomLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        static NSString *reuse = @"XXCoffeeQueHuoCell";
        XXCoffeeQueHuoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
                if (cell == nil) {
                    cell = [[XXCoffeeQueHuoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CoffeeMaterialPredictListModel *coffee = self.coffeeMachine.MaterialPredictList[indexPath.row];
        cell.nameLabel.text = coffee.materialName;
        cell.amountLabel.text = coffee.roadNum;
        cell.numLabel.text = coffee.amount;
        
        return cell;


    return cell;
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

#pragma mark - setters and getters
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
