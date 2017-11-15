//
//  XXShopListDetailViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/20.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXShopListDetailViewController.h"
#import "XXShopListDetailTableViewCell.h"
#import "XWAlert.h"
#import "AMNextGoodsListTableViewCell.h"
#import "PPNumberButton.h"
#import "TitleAndCountView.h"
#import "XXSetEmailViewController.h"
#import "YinliaoModel.h"
#import "UIButton+ImageTitleSpacing.h"
#import "XXNoDataView.h"
#import "XXNoNetView.h"
#import "XXNextGoodsListTableViewCell.h"
#import "XXAMNextGoodsListTableViewCell.h"

@interface XXShopListDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UINavigationControllerDelegate,
UIAlertViewDelegate,
PPNumberButtonDelegate,
ShopcatCellDelegate,
XXBaseViewControllerDelegate>
{
    XXNoNetView *noNetView;
    XXNoDataView *noDataView;

}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TitleAndCountView *headerCountView;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) NSMutableArray *goodsArr;

@property (nonatomic, strong) NSMutableArray *sendNumArr;

@property (nonatomic, strong) NSMutableString *goodsInfoStr;
@end

@implementation XXShopListDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"次日备货单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
    
    if ([self.hasSend isEqualToString:@"Ture"]) {
        [self loadDataWithTure];
    }else if ([self.hasSend isEqualToString:@"False"]){
        
        [self loadDataWithFalse];
    }
    [self setupPageSubviews];
    [self setupPageSubviewsProperty];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        if ([self.hasSend isEqualToString:@"Ture"]) {  //False //[self.hasSend integerValue] == 1
            [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view);
            }];
            
            } else {
            [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50 * UISCALE);
            }];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view).offset(-50 * UISCALE);
            }];
          
        }
    [self.view layoutIfNeeded];
    [self.view updateConstraintsIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noDataView removeFromSuperview];
    
}

- (void)setupPageSubviews
{
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    //    button.backgroundColor=[UIColor orangeColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:IMAGE(@"back_icon") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    spaceItem.width = -5 * UISCALE;
    self.navigationItem.leftBarButtonItems = @[spaceItem,backItem];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    
    //设置发送按钮
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50 * UISCALE);
    }];
    self.sendBtn.hidden = YES;
    //设置发送按钮
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.bottom.mas_equalTo(self.sendBtn.mas_top);
    }];
}

- (void)setupPageSubviewsProperty
{
    self.tableView.bounces = NO;
  
    self.tableView.tableHeaderView = [self setupHeaderView];  //设置tableHeaderView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -15 * UISCALE, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([self.hasSend isEqualToString:@"True"]) {
            [self loadDataWithTure];
            
        }
        else if ([self.hasSend isEqualToString:@"False"]){
            
            [self loadDataWithFalse];
        }
    }];
      [self.tableView.mj_header beginRefreshing];
    
    [self.sendBtn setBackgroundColor:RGB_COLOR(68, 138, 255) ];
    self.sendBtn.titleLabel.font = FontNotoSansLightWithSafeSize(18);
    [self.sendBtn addTarget:self action:@selector(sendAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn setTitle:@"发送次日备货单" forState:UIControlStateNormal];
}


#pragma mark - 网络请求数据
- (void)loadDataWithTure
{//Ture
    [noDataView removeFromSuperview];
    __weak typeof(self) weakself = self;

    self.tableView.hidden = YES;
    self.sendBtn.hidden = YES;
    [SVProgressHUD showWithStatus:@"加载中..."];
    //获取备货单详细Stockupdetail
    [XXHomeHandle requestStockupdetailWithManagerId:MANAGER_ID routeId:self.routeId  callback:^(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess) {
                [self.goodsArr removeAllObjects];
                [self.sendNumArr removeAllObjects];
                self.goodsArr = goodsArray;
                self.sendNumArr = sendNumberArray;
        
        if (!(self.goodsArr.count >0)) {
            noDataView = [[XXNoDataView alloc]initWithFrame:self.tableView.frame];
            [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂无数据"];
            [weakself.view addSubview:noDataView];
        }
    
        
        [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view);
        }];

                self.headerCountView.leftCountLabel.text = statisticsMachineCount;
                self.headerCountView.rightCountLabel.text = noStatisticsMachineCount;
                self.loadDataSuccess = isSuccess;
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                self.tableView.hidden = !isSuccess;
                self.sendBtn.hidden = !isSuccess;
                if (isSuccess) {
                    [SVProgressHUD dismiss];
                }

    }];
    
//    [XXHomeHandle requestNextDayGoodsWithManagerId:MANAGER_ID routeId:self.routeId callback:^(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess) {
//        [self.goodsArr removeAllObjects];
//        [self.sendNumArr removeAllObjects];
//        self.goodsArr = goodsArray;
//        self.sendNumArr = sendNumberArray;
//        self.headerCountView.leftCountLabel.text = statisticsMachineCount;
//        self.headerCountView.rightCountLabel.text = noStatisticsMachineCount;
//        self.loadDataSuccess = isSuccess;
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//        self.tableView.hidden = !isSuccess;
//        self.sendBtn.hidden = !isSuccess;
//        if (isSuccess) {
//            [SVProgressHUD dismiss];
//        }
//    }];
}
- (void)loadDataWithFalse{//False
    [noDataView removeFromSuperview];
    __weak typeof(self) weakself = self;
    
    self.tableView.hidden = YES;

    self.sendBtn.hidden =NO;

    [SVProgressHUD showWithStatus:@"加载中..."];
//    获取生成次日备货单列表nextdaypickinglist
//    http://app-yy-api.zjxfyb.com/api/home/manager/3/route/101024/nextdaypickinglist
    [XXHomeHandle requestNextDayGoodsWithManagerId:MANAGER_ID routeId:self.routeId callback:^(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess) {
        [self.goodsArr removeAllObjects];
        [self.sendNumArr removeAllObjects];
    
        self.goodsArr = goodsArray;
        self.sendNumArr = sendNumberArray;
        
        if (!(self.goodsArr.count >0)) {
            noDataView = [[XXNoDataView alloc]initWithFrame:self.tableView.frame];
            [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂无数据"];
            [weakself.view addSubview:noDataView];
        }

        
        [self.sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(-50 * UISCALE);
        }];
        

        self.headerCountView.leftCountLabel.text = statisticsMachineCount;
        self.headerCountView.rightCountLabel.text = noStatisticsMachineCount;
        self.loadDataSuccess = isSuccess;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.tableView.hidden = !isSuccess;
        self.sendBtn.hidden = !isSuccess;
        if (isSuccess) {
            [SVProgressHUD dismiss];
        }
    }];

    
}

#pragma mark - UITableViewDelegate and UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64 * UISCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT * UISCALE;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45 * UISCALE)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * UISCALE, 0, 80 * UISCALE, SECTION_HEIGHT * UISCALE)];
    nameLabel.text = @"商品名称";
    nameLabel.font = FontNotoSansLightWithSafeSize(14);
    [view addSubview:nameLabel];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140 * UISCALE, 0, 80 * UISCALE, SECTION_HEIGHT * UISCALE)];
    unitLabel.text = @"备货量(箱)";
    unitLabel.font = FontNotoSansLightWithSafeSize(14);
    [view addSubview:unitLabel];
    UILabel *unitLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(unitLabel.frame), 0, 50 * UISCALE, SECTION_HEIGHT * UISCALE)];
    unitLabel1.text = @"缺货量";
    unitLabel1.font = FontNotoSansLightWithSafeSize(10);
    unitLabel1.textColor=[UIColor grayColor];
    [view addSubview:unitLabel1];

    
    // 下线view
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height + 0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    [view addSubview:bottomLine];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_hasSend isEqualToString:@"False"]) {
        
        static NSString *reuse = @"AMNextGoodsListTableViewCell";
        [self.tableView registerClass:[AMNextGoodsListTableViewCell class] forCellReuseIdentifier:reuse ];
        AMNextGoodsListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YinliaoModel *yinliao = self.goodsArr[indexPath.row];
        cell.infoLabel.text = [NSString stringWithFormat:@"%@(%@%@装)", yinliao.goodsName, yinliao.goodsNum, yinliao.goodsUnit];;
        cell.numBtn.currentNumber = [yinliao.outStockBoxCount integerValue];
        cell.btnTag = indexPath.row + 1000;
        cell.numBtn.delegate = self;
//        cell.numBtn.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
//            NSLog(@"%ld",num);
//    };
        
        return cell;
    }else {//if ([_hasSend isEqualToString:@"Ture"])
        
        static NSString *reuseCell = @"XXNextGoodsListTableViewCell";
        [self.tableView registerClass:[XXNextGoodsListTableViewCell class] forCellReuseIdentifier:reuseCell];

        XXNextGoodsListTableViewCell *cell = [[XXNextGoodsListTableViewCell alloc] init];
        
        if(cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YinliaoModel *yinliao = self.goodsArr[indexPath.row];
        cell.infoLabel.text = [NSString stringWithFormat:@"%@(%@%@装)", yinliao.goodsName, yinliao.goodsNum, yinliao.goodsUnit];;
        cell.numlab.text = [NSString stringWithFormat:@"%@",yinliao.outStockBoxCount];
//        cell.btnTag = indexPath.row + 1000;
////        cell.numBtn.delegate = self;

        
         return cell;
        
        
    }

    return nil;
    
}


#pragma mark - PPButtonDelegate
- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    NSLog(@"%@",increaseStatus ? @"加运算":@"减运算");

    NSString *str = [NSString stringWithFormat:@"%ld", (long)number];
     NSLog(@"number=%ld",(long)number);
    [self.sendNumArr setObject:str atIndexedSubscript:numberButton.tag - 1000];
    NSLog(@"sendNumArr=%@",self.sendNumArr);
    
    // 修改模型数据
//    YinliaoModel *yinliao =[[YinliaoModel alloc] init];
//    yinliao.outStockBoxCount = str;
//    NSLog(@"str=%@",str);

}



#pragma mark - custom delegate
- (void)refreshPageData
{
//    [self loadDataWithTure];
//    if ([self.hasSend isEqualToString:@"Ture"]) {
//        [self loadDataWithTure];
//    }else if ([self.hasSend isEqualToString:@"False"]){
//        
//        [self loadDataWithFalse];
//    }

}


#pragma mark - private method
- (void)hudDismiss:(BOOL)success
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.sendBtn.userInteractionEnabled = YES;
    });
}

- (UIView *)setupHeaderView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 123 * UISCALE)];
//    bottomView.backgroundColor = RGB_COLOR(235, 235, 235);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115 * UISCALE)];
    view.backgroundColor = RGB_COLOR(68, 138, 255);
    [bottomView addSubview:view];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * UISCALE, 8 * UISCALE, SCREEN_WIDTH, 18 * UISCALE)];
    [view addSubview:tipLabel];
    tipLabel.text = @"推荐生成时间(21:00-23:00)";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = FontNotoSansLightWithSafeSize(13);
    
    self.headerCountView = [[TitleAndCountView alloc] initWithFrame:CGRectMake(0, 25 * UISCALE, SCREEN_WIDTH, 90)];
    self.headerCountView.backgroundColor=RGB_COLOR(68, 138, 255);
    [view addSubview:self.headerCountView];
    self.headerCountView.leftTitleLabel.text = @"统计的售货机(台)";
    self.headerCountView.rightTitleLabel.text = @"未统计的售货机(台)";
    self.headerCountView.leftTitleLabel.textColor=[UIColor whiteColor];
    self.headerCountView.rightTitleLabel.textColor=[UIColor whiteColor];
    [self.headerCountView setTitleAlignment:NSTextAlignmentCenter];
    [self.headerCountView setTitleFont:FontNotoSansLightWithSafeSize(17)];
    [self.headerCountView setCountColor:[UIColor whiteColor]];//RGB_COLOR(68, 138, 255)];
    [self.headerCountView setCountFont:FontNotoSansLightWithSafeSize(36)];
    self.headerCountView.hideLine = YES;
    return bottomView;
}


#pragma mark - Btn Action
- (void)sendAciton
{
    if (self.goodsArr.count != 0) {
        self.goodsInfoStr = [NSMutableString string];
        for (NSInteger i = 0; i < self.goodsArr.count; i++) {
            YinliaoModel *yinliao = self.goodsArr[i];
//            machine_sn1,road_no1,goods_num1;machine_sn2,road_no2,goods_num2;....
            NSString *tempStr = [NSString stringWithFormat:@"%@,%@,%@;", yinliao.machineSn, yinliao.roadNo, self.sendNumArr[i]];
            [self.goodsInfoStr appendFormat:@"%@", tempStr];
        }
        [self sendData];
    }
}


- (void)sendData
{
    NSString *mail = MANAGER_EMAIL;
    if (mail.length == 0) {
        [XWAlert showAlertWithTitle:@"温馨提示" message:@"还未设置备货单接收邮箱，是否前往设置？" confirmTitle:@"前往设置" cancelTitle:@"稍后再说" preferredStyle:Alert confirmHandle:^{
            XXSetEmailViewController *mailVC = [[XXSetEmailViewController alloc] init];
            [self.navigationController pushViewController:mailVC animated:YES];

        } cancleHandle:^{
            [self.navigationController popViewControllerAnimated:YES];

        }];

    } else {
        self.sendBtn.userInteractionEnabled = NO;
        [SVProgressHUD showWithStatus:@"发送中..."];
    
        //       machine_sn1,road_no1,goods_num1;machine_sn2,road_no2,goods_num2;....

        
        [XXHomeHandle sendGoodsWithManagerId:MANAGER_ID routeId:self.routeId goodsInfoStr:self.goodsInfoStr callback:^(BOOL isSuccess) {
            [self hudDismiss:isSuccess];
            self.sendBtn.userInteractionEnabled = YES;
        }];
    }
}


- (void)backBack:(UIButton *)Btn
{

    if (self.goodsArr.count != 0 && [self.hasSend isEqualToString:@"False"]) {
        
        [XWAlert showAlertWithTitle:@"温馨提示" message:@"确定要放弃此次编辑？" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
             [self.navigationController popViewControllerAnimated:YES];
            
        } cancleHandle:^{
           

            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - setters and getters
- (NSMutableArray *)goodsArr
{
    if (_goodsArr == nil) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

- (NSMutableArray *)sendNumArr
{
    if (_sendNumArr == nil) {
        self.sendNumArr = [NSMutableArray array];
    }
    return _sendNumArr;
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
