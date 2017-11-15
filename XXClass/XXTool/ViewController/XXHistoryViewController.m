//
//  XXHostoryViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXHistoryViewController.h"
#import "AMDetailModel.h"
#import "AMDateTableViewCell.h"
#import "AMTaskTableViewCell.h"
#import "AMTaskSectionTitleModel.h"
#import "AMTaskTableViewCell.h"
#import "AMTaskModel.h"

#import "AMWorningTableViewCell.h"
#import "XXStockViewController.h"

#import "AMHistoryModel.h"
#import "AMHistoryTableViewCell.h"
#import "XXNoNetView.h"
#import "XXNoDataView.h"

typedef enum :NSInteger{
    sectionButtonTag = 10,
    cellTags = 30,
}tags;




@interface XXHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *myHTableView;
    int index;
    XXNoNetView *noNetView;
    XXNoDataView *noDataView;
}
@property(strong,nonatomic)NSMutableArray *sectionArr;
@property(strong,nonatomic)NSMutableArray *dateArr;
@end

@implementation XXHistoryViewController

- (NSMutableArray *)sectionArr{
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}
- (NSMutableArray *)dateArr{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    index = 0;
    
    myHTableView = [[UITableView alloc]init];
    myHTableView.frame = self.view.frame;
    myHTableView.delegate = self;
    myHTableView.dataSource = self;
    [self.view addSubview:myHTableView];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [myHTableView setTableFooterView:view];
    myHTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //无网络
    noNetView = [[XXNoNetView alloc]initWithFrame:myHTableView.frame];
    [noNetView refreshForNewMessage:^{
        [self getData];
    }];
    [self.view addSubview:noNetView];
    
    [self getChoose];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)contentViewFrameBounds:(CGRect )bounds{
    
    myHTableView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}

- (void)getChoose{
    switch (self.markID) {
        case 0:
        {
            __weak typeof(self) weakself = self;
            self.navigationItem.title = @"历史备货单";
            [self.navigationController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor blackColor]}];
            myHTableView.frame = CGRectMake(0,0 ,SCREEN_WIDTH, SCREEN_HEIGHT);
            [myHTableView registerClass:[AMHistoryTableViewCell class] forCellReuseIdentifier:@"historyCell"];
            [self getData];
            myHTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                index = 0;
                [weakself getData];
            }];
            
            myHTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                index = index+12;
                [weakself getData];
            }];
        }
            break;
        case 1:
        {
            myHTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [noNetView againConfigurationWithHeight:-60];
            [myHTableView registerClass:[AMDateTableViewCell class] forCellReuseIdentifier:@"detailCell"];
        }
            break;
        case 2:
        {
            
            __weak typeof(self) weakself = self;
            
            [myHTableView registerClass:[AMTaskTableViewCell class] forCellReuseIdentifier:@"taskCell"];
            [weakself getData];
            
            myHTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself getData];
            }];
            [weakself getData];
        }
            break;
        case 3:
        {
            //告警列表
            __weak typeof(self) weakself = self;
            
            [myHTableView registerClass:[AMWorningTableViewCell class] forCellReuseIdentifier:@"worningCell"];
            [weakself getData];
            
            myHTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                index = 0;
                [weakself getData];
            }];
            
            myHTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                index = index+10;
                [weakself getData];
            }];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)getData{
    [noDataView removeFromSuperview];
    
    __weak typeof(self) weakself = self;
    
    switch (self.markID) {
        case 0:
        {
            [XXToolHandle getHistoryStockupInfoListWithIndex:[NSString stringWithFormat:@"%d",index] andBlock:^(NSMutableArray *arr,BOOL LossConnect) {
                if (!LossConnect) {
                    
                    if (index == 0) {
                        [weakself.dateArr removeAllObjects];
                        if (!(arr.count>0)) {
                            noDataView = [[XXNoDataView alloc]initWithFrame:myHTableView.frame];
                            [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"没有备货单信息"];
                            [weakself.view addSubview:noDataView];
                        }
                    }
                    [weakself.dateArr addObjectsFromArray:arr];
                    [myHTableView reloadData];
                    [noNetView dismiss];
                }
                [myHTableView.mj_header endRefreshing];
                [myHTableView.mj_footer endRefreshing];
            }];
        }
            break;
        case 1:{
            //
            weakself.refresh();
        }
            break;
        case 2:
        {
            //1未完成参数请求
            [XXToolHandle getTaskContentWithTaskType:@"1" WithBlock:^(NSDictionary *Dic,BOOL LossConnect) {
                if (!LossConnect) {
                    
                    [weakself.sectionArr removeAllObjects];
                    NSArray *titleArr = [Dic allKeys];
                    if (!(titleArr.count>0)) {
                        noDataView = [[XXNoDataView alloc]initWithFrame:myHTableView.frame];
                        [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂时没有任务"];
                        [weakself.view addSubview:noDataView];
                    }else{
                        for (int i = 0; i<titleArr.count; i++) {
                            AMTaskSectionTitleModel *model = [[AMTaskSectionTitleModel alloc]init];
                            model.isOn = NO;
                            model.sectionTitle = titleArr[i];
                            [weakself.sectionArr addObject:model];
                        }
                        [weakself.dateArr removeAllObjects];
                        [weakself.dateArr addObjectsFromArray:[Dic allValues]];
                    }
                    
                    [myHTableView reloadData];
                    [noNetView dismiss];
                }
                [myHTableView.mj_header endRefreshing];
            }];
        }
            break;
        case 3:
        {
            [XXToolHandle getAlermMessageWithIndex:[NSString stringWithFormat:@"%d",index] andBackBlock:^(NSMutableArray *arr,BOOL LossConnect) {
                if (!LossConnect) {
                    
                    if (index == 0) {
                        [weakself.dateArr removeAllObjects];
                        if (!(arr.count>0)) {
                            noDataView = [[XXNoDataView alloc]initWithFrame:myHTableView.frame];
                            [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂时没有告警信息"];
                            [weakself.view addSubview:noDataView];
                            
                        }
                    }
                    [weakself.dateArr addObjectsFromArray:arr];
                    [myHTableView reloadData];
                    [noNetView dismiss];
                }
                [myHTableView.mj_header endRefreshing];
                [myHTableView.mj_footer endRefreshing];
            }];
        }
            break;
            
            
        default:
            break;
    }
    
}

- (void)refreshWithDateArr:(NSMutableArray *)arr WithIsLossCnnect:(BOOL)LossConnect{
    if (!LossConnect) {
        [self.dateArr removeAllObjects];
        [self.dateArr addObjectsFromArray:arr];
        [myHTableView reloadData];
        [noNetView dismiss];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noDataView removeFromSuperview];
    [noNetView dismiss];
}
- (void)ReturnTurnForOnLinePersonText:(ReturnTurnBlock)block{
    self.returnTurnBlock = block;
}
- (void)returnModelForTask:(ReturnTaskTurnBlock)taskBlock{
    self.returnTaskBlock = taskBlock;
}
//返回3标记的
- (void)returnMachineIDForTask:(WorningMachineReturnBlock)machineBlock{
    self.machineReturnBlock = machineBlock;
}
- (void)returnForRefreash:(RefreshForSaleDetail)block{
    self.refresh = block;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark-->UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.markID == 2) {
        return self.sectionArr.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.markID == 2) {
        AMTaskSectionTitleModel *model = self.sectionArr[section];
        if (model.isOn) {
            return [self.dateArr[section] count];
        }else{
            return 0;
        }
    }else{
        return self.dateArr.count;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.markID == 1||self.markID == 2||self.markID == 3) {
        return 76*UISCALE;
    }else if (self.markID == 0){
        return 60*UISCALE;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.markID == 1) {
        AMDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!cell) {
            cell = [[AMDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
        }
        AMDetailModel *model = self.dateArr[indexPath.row];
        cell.selectChoose = 2;
        cell.detailModel = model;
        return cell;
        
    }else if (self.markID == 2){
        AMTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
        if (!cell) {
            cell = [[AMTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"];
        }
        AMTaskModel *model = self.dateArr[indexPath.section][indexPath.row];
        cell.taskModel = model;
        return cell;
    }else if (self.markID == 3){
        AMWorningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"worningCell"];
        if (!cell) {
            cell = [[AMWorningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"worningCell"];
        }
        AMMachWorModel *model = self.dateArr[indexPath.row];
        cell.markID = 0;
        cell.model = model;
        return cell;
    }else if (self.markID == 0){
        AMHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
        if (!cell) {
            cell = [[AMHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"historyCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        AMHistoryModel *model = self.dateArr[indexPath.row];
        cell.markID = 0;
        cell.hisModel = model;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.markID == 1) {
        AMDetailModel *model = self.dateArr[indexPath.row];
        if (self.returnTurnBlock) {
            self.returnTurnBlock(model.machineType,model.adressPart);
        }
    }else if (self.markID == 2){
        AMTaskModel *model = self.dateArr[indexPath.section][indexPath.row];
        if (self.returnTaskBlock) {
            self.returnTaskBlock(model);
        }
    }else if (self.markID == 3){
        //返回机器详情界面
        AMMachWorModel *model = self.dateArr[indexPath.row];
        if (self.machineReturnBlock) {
            self.machineReturnBlock(model.machineType);
        }
    }else if (self.markID == 0){
        //历史备货单详情
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AMHistoryModel *model = self.dateArr[indexPath.row];
        XXStockViewController *stockVC = [[XXStockViewController alloc]init];
        stockVC.stockupId = model.stockup_id;
        stockVC.timeStr = model.stockupTime;
        stockVC.createTimeStr=model.timeStr;//备货单创建时间
        [self.navigationController pushViewController:stockVC animated:YES];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
        
        
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.markID ==2) {
        AMTaskSectionTitleModel *model = self.sectionArr[section];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [button addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = sectionButtonTag+section;
        UIImage *image = [UIImage imageNamed:@"ic_up_black"];
        UIImageView *imageChoose = [[UIImageView alloc]init];
        imageChoose.center = CGPointMake(10, button.center.y);
        imageChoose.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageChoose.image = image;
        if (model.isOn) {
            imageChoose.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            imageChoose.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        [button addSubview:imageChoose];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(CGRectGetMaxX(imageChoose.frame),0 , SCREEN_WIDTH-CGRectGetMaxX(imageChoose.frame), 44);
        label.text = model.sectionTitle;
        label.font = FONT_OF_SIZE(16);
        [button addSubview:label];
        UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
        separView.backgroundColor = separeLineColor;
        [button addSubview:separView];
        return button;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.markID == 2) {
        return 44;
    }else{
        return 0;
    }
}

//点击头视图按钮，是列表达到收放
- (void)clickHeaderButton:(UIButton *)sender
{
    //sender.selected = !sender.selected; 用这种方式来区分判断是不行的，因为每次刷新就会调用tableview的头视图，就会重新创建头视图的按钮。达不到效果，所以需要有一个页面加载后只创建一次的变量来记录
    AMTaskSectionTitleModel *model = self.sectionArr[sender.tag-sectionButtonTag];
    model.isOn = !model.isOn;
    //    [myHTableView reloadData];
    
    [myHTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-sectionButtonTag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
