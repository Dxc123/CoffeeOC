//
//  XXExchangeViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXExchangeViewController.h"
#import "XXCreateShopInfoTableViewCell.h"
#import "AMCheJiTableViewCell.h"
#import "AMAccountModel.h"
#import "ReasonView.h"
#import "RouteListView.h"
#import "XXNoNetView.h"
#import "XXNoDataView.h"


typedef enum :NSInteger{
    typeButtonTags = 10,
    routeTags = 20,
}tags;

@interface XXExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *searchView;
    UITableView *detailTableView;
    UIButton *button;
    BOOL isShow;
    UITextField *searchText;
    NSInteger oldIndexRow;
    NSString *machineID;
    
    NSString *routeID;
    NSString *routeName;
    NSString *routesRember;
    
    XXNoNetView *noNetCon;
    XXNoDataView *noDataView;
    
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *reloadArr;
@property (nonatomic ,strong) NSIndexPath  * selectedIndexPath;//标记
@property (nonatomic, strong) NSMutableArray *selectorArr;

@end

@implementation XXExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    oldIndexRow = 0;
    self.view.backgroundColor = COLOR_GRAY;
    self.navigationItem.title = @"撤机换线列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(searchForLine)];
//    routeName = @"全部线路";
    
    [self createView];
    [self getRouteFoeNew];
}
- (void)getRouteFoeNew{
    __weak typeof(self)weakself = self;
    [XXToolHandle getAllRoutesWithBlock:^(NSString *allRoutes,BOOL LossConnect) {
        routesRember = allRoutes;
        routeID = allRoutes;
        [weakself getDataWithArchiveStr:@"加载成功!"];
    }];
    
}
- (void)createView{
    searchView = [[UIView alloc]init];
    searchView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 0);
    searchView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    searchView.clipsToBounds = YES;
    [self.view addSubview:searchView];
    
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(10, 5, SCREEN_WIDTH-20-50, 30);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5;
    contentView.clipsToBounds = YES;
    [searchView addSubview:contentView];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"ic_search_hui"];
    image.frame = CGRectMake(0, 0, contentView.frame.size.height, contentView.frame.size.height);
    [contentView addSubview:image];
    
    searchText = [[UITextField alloc]init];
    searchText.frame = CGRectMake(image.frame.size.height+5, 5, contentView.frame.size.width-5-contentView.frame.size.height, contentView.frame.size.height);
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.placeholder = @"请输入机器编号搜索";
    searchText.font = FONT_OF_SIZE(13);
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeyDone;
    [searchView addSubview:searchText];
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    quitBtn.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 40);
    [searchView addSubview:quitBtn];
    quitBtn.titleLabel.font = FONT_OF_SIZE(17);
    [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quitSearch) forControlEvents:UIControlEventTouchUpInside];
    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, 40);
//    button.backgroundColor = COLOR_MAIN;
//    [button addTarget:self action:@selector(chooseRoute) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:button];
//    UILabel *label = [[UILabel alloc]init];
//    label.text = @"全部线路";
//    label.textAlignment = 1;
//    label.tag = routeTags;
//    label.font = FONT_OF_SIZE(13);
//    label.textColor = [UIColor whiteColor];
//    CGSize size = [label sizeThatFits:CGSizeMake(0, 40)];
//    label.frame = CGRectMake(10, 0, size.width, 40);
////    [button addSubview:label];
//    UIImageView *chooseImage = [[UIImageView alloc]init];
//    chooseImage.image = [UIImage imageNamed:@"ic_down"];
//    [button addSubview:chooseImage];
//    [chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(label.mas_right);
//        make.top.mas_equalTo(label).offset(10);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(20);
//    }];
    //设置底部按钮
    NSArray *arr = @[@"申请撤机",@"申请换线"];
    UIView *typeView = [[UIView alloc]init];
    typeView.frame = CGRectMake(0, SCREEN_HEIGHT-60*UISCALE, SCREEN_WIDTH, 60*UISCALE);
    //    typeView.backgroundColor = COLOR_MAIN;
    typeView.backgroundColor = RGB(248, 248, 248);
    [self.view addSubview:typeView];
    for (int i = 0; i<2; i++) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        typeBtn.frame = CGRectMake(SCREEN_WIDTH/2*i, 10*UISCALE, SCREEN_WIDTH/2, typeView.frame.size.height);
        [typeBtn setTitle:arr[i] forState:UIControlStateNormal];
        typeBtn.titleLabel.font = FONT_OF_SIZE(18);
        typeBtn.tag = typeButtonTags+i;
        [typeBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [typeView addSubview:typeBtn];
        [typeBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    }
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(typeView.frame.size.width/2, 10, 1, 40)];
    centerView.backgroundColor = [UIColor grayColor];
    [typeView addSubview:centerView];
    
    
    
    detailTableView = [[UITableView alloc]init];
    detailTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-60-searchView.frame.size.height-40-10);//CGRectGetMaxY(button.frame)
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [self.view addSubview:detailTableView];
    [detailTableView registerClass:[AMCheJiTableViewCell class] forCellReuseIdentifier:@"typeCell"];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [detailTableView setTableFooterView:view];
//     detailTableView .allowsMultipleSelection = YES;//允许多选
//    detailTableView.editing = YES;
//    detailTableView.allowsMultipleSelectionDuringEditing = YES;
    
    noNetCon = [[XXNoNetView alloc]initWithFrame:detailTableView.frame];
    [noNetCon refreshForNewMessage:^{
        [self getRouteFoeNew];
    }];
    [self.view addSubview:noNetCon];
    [noNetCon againConfigurationWithHeight:64*UISCALE];
    //发送通知changeAndReloadTableView
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAndReloadTableView) name:UITextFieldTextDidChangeNotification object:nil];
    
}
//、、撤机换线-根据线路获取机器信息列表
- (void)getDataWithArchiveStr:(NSString *)str{
    [noDataView removeFromSuperview];
    [SVProgressHUD showWithStatus:@"加载中..."];
    __weak typeof(self)weakself = self;
    
    [XXToolHandle getChejiOrHuanXianWithRouteId:routeID WithBlock:^(NSMutableArray *dataArr,BOOL LossConnect) {
        if (LossConnect) {
            [SVProgressHUD dismiss];
            noDataView = [[XXNoDataView alloc]initWithFrame:detailTableView.frame];
            [noDataView reloadWithPicName:@"ic_empty" AndTitle:[dataArr firstObject]];
            [self.view addSubview:noDataView];
        }else{
            [weakself.dataArr removeAllObjects];
            [weakself.reloadArr removeAllObjects];
            
            if (dataArr != nil) {
                for (int i = 0; i<dataArr.count; i++) {
                    [weakself.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
                [weakself.reloadArr addObjectsFromArray:dataArr];
                [detailTableView reloadData];
                
                dispatch_queue_t q =
                dispatch_queue_create("yibu", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(q, ^{
                    [SVProgressHUD showImage:nil status:str];
                });
                
            }else{
                noDataView = [[XXNoDataView alloc]initWithFrame:detailTableView.frame];
                [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"本线路没有可撤机换线的售货机"];
                [self.view addSubview:noDataView];
                [SVProgressHUD dismiss];
            }
            oldIndexRow = 0;
            [noNetCon dismiss];
        }
    }];
    
}
- (void)changeAndReloadTableView{
    [self.dataArr removeAllObjects];
    
    if (searchText.text.length==0) {
        for (int i = 0; i<self.reloadArr.count; i++) {
            [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }else{
        for (int i = 0; i<self.reloadArr.count; i++) {
            AMAccountModel *aModel = self.reloadArr[i];
            NSString *machineType = aModel.machineType;
            if ([machineType containsString:searchText.text]) {
                [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    [detailTableView reloadData];
    
}
//撤机|换线按钮点击事件
- (void)chooseType:(UIButton *)sender{
    
    if (machineID.length>0) {
        static BOOL isHuanXian;
        ReasonView *view = [[ReasonView alloc]initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:view];
        NSString *type;
        if (sender.tag-typeButtonTags == 0) {
            isHuanXian = NO;
            type = @"撤机";
        }else if (sender.tag-typeButtonTags ==1){
            isHuanXian = YES;
            type = @"换线";
        }
//        NSUTF8StringEncoding
        __weak typeof(self)weakSelf = self;
        [view getReasonPlaceHolderMessage:type FromView:^(NSString *applyReason) {
            [SVProgressHUD showImage:nil status:@"申请提交中..."];
            [XXToolHandle getCheJiOrHuanXianWithmachineType:machineID AndServiceType:[NSString stringWithFormat:@"%d",isHuanXian] AndReason:[applyReason stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                                                   WithBack:^(BOOL isArchive,BOOL LossConnect) {
                if (isArchive) {
                    searchText.text = nil;
                    machineID = nil;
                    [weakSelf getDataWithArchiveStr:@"申请成功，等待审核"];
                }else{
                    [SVProgressHUD showImage:nil status:@"申请失败，请重新提交"];
                }
                
            }];
        }];
    }else{
        [SVProgressHUD showImage:nil status:@"请先选择售货机"];
    }
    
}
//- (void)chooseRoute{
//    
//    //#warning 选择路线
//    __weak typeof(self)weakself = self;
//    UILabel *routeLabel = [self.view viewWithTag:routeTags];
//    if ([routeID isEqualToString:routesRember]) {
//        routeID = @"0";
//    }
//    [RouteListView routeId:routeID action:^(NSString *route_id, NSString *route_name) {
//        routeLabel.text = route_name;
//        CGSize size = [routeLabel sizeThatFits:CGSizeMake(0, 40)];
//        routeLabel.frame = CGRectMake(10, 0, size.width+5, 40);
//        if ([route_id isEqualToString:@"0"]) {
//            routeID = routesRember;
//        }else{
//            routeID = route_id;
//        }
//        routeName = route_name;
//        [weakself getDataWithArchiveStr:@"加载成功！"];
//    }];
//}
- (void)quitSearch{
    isShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
        searchView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 0);
//        button.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, 40);
        detailTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-60-searchView.frame.size.height-64);
    }];
    
}
- (void)searchForLine{
    isShow = !isShow;
    
    if (isShow) {
        [UIView animateWithDuration:0.25 animations:^{
            searchView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
//            button.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, 40);
            detailTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-60-64-searchView.frame.size.height);//CGRectGetMaxY(button.frame)
        }];
    }else{
        [self quitSearch];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [noDataView removeFromSuperview];
    [noNetCon dismiss];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -->tableViewDelegate | DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72*UISCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMCheJiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!cell) {
        cell = [[AMCheJiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
        
    }
    AMAccountModel *accountModel = self.reloadArr[[self.dataArr[indexPath.row] intValue]];
    cell.model = accountModel;
    
//    machineID = accountModel.machineType;
//    cell.selectedBackgroundView=[UIView new];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;

//    cell.delegate = self;
//    cell.testBtn.tag = indexPath.row;


    return cell;
}

// 多选状态
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//   return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}
// 选中（将选中row添加到selectorArr中）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    [self.selectorArr addObject:self.reloadArr[[self.dataArr[indexPath.row] integerValue]]];
    
    
    
    
    AMAccountModel *oldModel = self.reloadArr[oldIndexRow];
    oldModel.isSelect = NO;
    AMAccountModel *aModel = self.reloadArr[[self.dataArr[indexPath.row] integerValue]];
    aModel.isSelect = YES;
    machineID = aModel.machineType;
    oldIndexRow = [self.dataArr[indexPath.row] integerValue];
    [tableView reloadData];
}
// 取消选中（将选中row移出到selectorArr中）
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    //    AMAccountModel *oldModel = self.reloadArr[oldIndexRow];
    //    oldModel.isSelect = NO;

//        if (self.selectorArr.count > 0) {
//            [self.selectorArr removeObject:self.reloadArr[[self.dataArr[indexPath.row] integerValue]]];
//        }
//   
//}


#pragma mark -TestCell Delegate
//-(void)SelectedCell:(UIButton *)sender{
////    sender.selected=!sender.selected;
//    if (sender.selected) {
//
//        [_reloadArr addObject:_dataArr[sender.tag]];//选中添加
//        AMAccountModel *aModel = self.reloadArr[[self.dataArr[sender.tag] integerValue]];
//        aModel.isSelect = YES;
//        machineID = aModel.machineType;
//        NSLog(@"machineID=%@",machineID);
//        [detailTableView reloadData];
//
//        
//    }else{
//        [_reloadArr removeObject:_dataArr[sender.tag]];//再选取消
//        AMAccountModel *oldModel =self.reloadArr[[self.dataArr[sender.tag] integerValue]]; //self.reloadArr[sender.tag];
//        oldModel.isSelect = NO;
//        machineID = oldModel.machineType;
//        NSLog(@"oldmachineID=%@",machineID);
//
//       machineID = nil;
//        
//    }
//    for (int i=0; i<_reloadArr.count; i++) {
//        NSLog(@"%@",_reloadArr[i]);//便于观察选中后的数据
//    }
//    NSLog(@"==============");
//}




- (NSMutableArray *)reloadArr{
    if (!_reloadArr) {
        _reloadArr = [NSMutableArray array];
    }
    return _reloadArr;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)selectorArr
{
    if (_selectorArr == nil) {
        self.selectorArr = [NSMutableArray array];
    }
    return _selectorArr;
}




@end
