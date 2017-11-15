//
//  XXQuhuoViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXQuhuoViewController.h"
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
@interface XXQuhuoViewController ()
<UITableViewDelegate,
UITableViewDataSource,
XXBaseViewControllerDelegate,UIAlertViewDelegate>
{
    UIButton *myCreateButton;
}
@property (nonatomic, strong) AlarmInfoModel *alarm;
@property (nonatomic, strong) MachineModel *machine;
//@property (nonatomic, strong) CoffeeMachineModel *coffeeMachine;
// 头视图
//@property (nonatomic, strong) MachineView *machineView;
//@property (nonatomic, strong) XXQuhuoHeaderView *machineView;
@property (nonatomic, strong) XXQueHuoView *machineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *alarmTableView;
// 记录section是否展开
@property (nonatomic, strong) NSMutableDictionary *markDic;


@end

@implementation XXQuhuoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];
    [self loadData];
     self.navigationItem.title = @"缺货查询";
    if (self.isFail) {
        self.navigationItem.title = @"故障详情";
    }

//    else {
//        self.navigationItem.title = @"缺货查询";
//        [self addFullGoodsButton];
//    }
}
//添加的补货按钮，在这里设置
//- (void)addFullGoodsButton{
//    myCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    myCreateButton.frame = CGRectMake(0, SCREEN_HEIGHT-64-64*UISCALE, SCREEN_WIDTH, 64*UISCALE);
//    [self.view addSubview:myCreateButton];
//    myCreateButton.sd_layout.widthIs(SCREEN_WIDTH).heightIs(64*UISCALE).leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
//    [myCreateButton setBackgroundColor:RGB_COLOR(68, 138, 255)];
//    myCreateButton.titleLabel.font = FontNotoSansLightWithSafeSize(18);
//    [myCreateButton setTitle:@"完成补货" forState:UIControlStateNormal];
//    [myCreateButton addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
//    
//    myCreateButton.hidden = YES;
//}
//- (void)buttonChoose:(UIButton *)sender{
//    
//    [XWAlert showAlertWithTitle:@"温馨提示 " message:@"确定该机器货道已全部补满，需要一键补满所有货道？" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
//        [SVProgressHUD showWithStatus:@"处理中..."];
//        [XXToolHandle fillUpGoodsWithMachineId:self.machineSn WithBlock:^(BOOL isArchive) {
//            if (isArchive) {
//                [SVProgressHUD showImage:nil status:@"补货成功"];
//                [self loadData];
//            }
//        }];
//
//        
//    } cancleHandle:^{
//        
//    }];
//}
- (void)setMachine:(MachineModel *)machine{
    if (_machine!=machine) {
        _machine = machine;
    }
    for (int i = 0; i<self.machine.alarmInfoList.count; i++) {
        AlarmInfoModel *alarm = self.machine.alarmInfoList[i];
        if (alarm.typeName.length==0) {
            [self.machine.alarmInfoList removeObjectAtIndex:i];
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
    //    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.machineView = [XXQueHuoView new];
    self.machineView.lineView.hidden = YES;
//    self.machineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120 * UISCALE);
    self.tableView.tableHeaderView = self.machineView;
    [self.machineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0*UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(0*UISCALE);
         make.top.mas_equalTo(self.view.top).offset(0*UISCALE);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(150*UISCALE);
    }];
    
}

- (void)setupPageSubviewsProperty
{
    //    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[AlarmInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AlarmInfoTableViewCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.tableView.hidden = YES;
    [XXHomeHandle requestMachineGoodsWithMachineSn:self.machineSn callback:^(id machine, BOOL isSuccess) {
        self.machine = machine;
        self.loadDataSuccess = isSuccess;
        self.machineView.titleText = self.machine.machineSn;
        self.machineView.isQuehuo = [self.machine.isQuehuo integerValue];
        self.machineView.isQuebi = [self.machine.isQuebi integerValue];
        self.machineView.isDuanwang = [self.machine.isDuanwang integerValue];
        self.machineView.isGuzhang = [self.machine.isGuzhang integerValue];
        self.machineView.detailText = [NSString stringWithFormat:@"%@·%@", self.machine.routeName, self.machine.positionName];
        [self.tableView reloadData];
        self.tableView.hidden = !isSuccess;
        if (isSuccess) {
            [SVProgressHUD dismiss];
        }
//        long allCout = (long)[self.machine.yinliaoOutStockCount integerValue]+(long)[self.machine.shipinOutStockCount integerValue]+(long)[self.machine.qitaOutStockCount integerValue];
//        if (allCout>0) {
//            myCreateButton.hidden = NO;
//        }else{
//            myCreateButton.hidden = YES;
//        }
//        [self.machineView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.view.mas_left).offset(0*UISCALE);
//            make.right.mas_equalTo(self.view.mas_right).offset(0*UISCALE);
//            make.width.mas_equalTo(self.view.mas_width);
//           make.height.mas_equalTo(120*UISCALE*self.machine.alarmInfoList.count*40*UISCALE);
//        }];
    }];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *tag = [NSString stringWithFormat:@"%ld", section + 2000];
    if (section != 0) {
        if ([self.markDic[tag] integerValue] == 1) {
            if (section == 1) {
                return self.machine.yinliaoRoadList.count;
            } else if (section == 2){
                return self.machine.shipinRoadList.count;
            } else {
                return self.machine.qitaRoadList.count;
            }
        } else {
            return 0;
        }
    } else {
        return self.machine.alarmInfoList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isFail) {
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return SECTION_HEIGHT * UISCALE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return 64 * UISCALE;
    } else {
        AlarmInfoModel *model = self.machine.alarmInfoList[indexPath.row];
        return (40 * UISCALE + model.addHig);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.machine.alarmInfoList.count != 0) {
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
    label.font = FontNotoSansLightWithSafeSize(13);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(10 * UISCALE);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-10 * UISCALE);
        make.width.mas_equalTo(150 * UISCALE);
        make.left.mas_equalTo(arrowView.mas_right).offset(11 * UISCALE);
    }];
    if (section == 1) {
        label.text = @"饮料";
    }
        else if (section == 2) {
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
    numLabel.font = FontNotoSansLightWithSafeSize(13);
    
    if (section == 1) {
        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
                         (long)[self.machine.yinliaoOutStockCount integerValue]];
    } else if (section == 2) {
        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
                         (long)[self.machine.shipinOutStockCount integerValue]];
    } else if (section == 3) {
        numLabel.text = [NSString stringWithFormat:@"总缺货量%ld",
                         (long)[self.machine.qitaOutStockCount integerValue]];
    }
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
    if (indexPath.section != 0) {
        static NSString *reuse = @"goodsTableViewCell";
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (cell == nil) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YinliaoModel *yinliao = [[YinliaoModel alloc] init];
        if (indexPath.section == 1) {
            yinliao = self.machine.yinliaoRoadList[indexPath.row];
        }
            else if (indexPath.section == 2) {
            yinliao = self.machine.shipinRoadList[indexPath.row];
        } else if (indexPath.section == 3) {
            yinliao = self.machine.qitaRoadList[indexPath.row];
        }
        cell.goodsStateLabel.text = yinliao.goodsState;
        cell.goodsInfoLabel.text = [NSString stringWithFormat:@"%@(%@%@装)", yinliao.goodsName, yinliao.goodsNum, yinliao.goodsUnit];
        cell.numLabel.text = yinliao.outStockCount;
        return cell;
    } else {
        AlarmInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlarmInfoTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AlarmInfoModel *alarm = self.machine.alarmInfoList[indexPath.row];
        cell.aIModel = alarm;
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
