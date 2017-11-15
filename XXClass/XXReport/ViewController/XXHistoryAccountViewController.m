//
//  XXHistoryAccountViewController.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXHistoryAccountViewController.h"
#import "RouteListView.h"
#import "AMDateTableViewCell.h"


@interface XXHistoryAccountViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int index;
    NSString *route_ID;
    UILabel *routeLabel;
    UITableView *accHisTableView;
    UIButton *routeButton;
    UITextField *searchText;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation XXHistoryAccountViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(221, 221, 221, 1);
    self.navigationItem.title = @"应收款记录";
    route_ID = self.routeID;
    index = 0;
    [self createView];
    
}
- (void)createView{
    UIView *searchView = [[UIView alloc]init];
    searchView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    searchView.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    [self.view addSubview:searchView];
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(8, 7, SCREEN_WIDTH-16, 30);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5;
    contentView.clipsToBounds = YES;
    [searchView addSubview:contentView];
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"ic_search_hui"];
    image.frame = CGRectMake(0, 0, contentView.frame.size.height, contentView.frame.size.height);
    [contentView addSubview:image];
    searchText = [[UITextField alloc]init];
    searchText.frame = CGRectMake(CGRectGetMaxX(image.frame)+8, 0, contentView.frame.size.width-(CGRectGetMaxX(image.frame)+8), contentView.frame.size.height);
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.placeholder = @"搜索售货机编号";
    searchText.font = FONT_OF_SIZE(14);
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeyDone;
    [contentView addSubview:searchText];
    
    
    routeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    routeButton.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, 44);
    routeButton.backgroundColor = [UIColor whiteColor];
    [routeButton addTarget:self action:@selector(chooseRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:routeButton];
    routeLabel = [[UILabel alloc]init];
    routeLabel.text = self.routeName;
    routeLabel.textAlignment = 1;
    routeLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    routeLabel.font = FONT_OF_SIZE(15);
    CGSize size = [routeLabel sizeThatFits:CGSizeMake(0, 21)];
    routeLabel.frame = CGRectMake(10, routeButton.frame.size.height/2-size.height/2, size.width, size.height);
    [routeButton addSubview:routeLabel];
    UIImageView *chooseImage = [[UIImageView alloc]init];
    chooseImage.image = [UIImage imageNamed:@"ic_down_black"];
    [routeButton addSubview:chooseImage];
    [chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(routeLabel.mas_right);
        make.top.mas_equalTo(routeLabel).offset(-3);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];

    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(routeButton.frame)+2,SCREEN_WIDTH, 44)];
    cellView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellView];
    NSArray *arr = @[@"售货机编号",@"补货时间",@"应收款(元)"].copy;
    for (int i = 0; i<3; i++) {
        UILabel *cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 0,SCREEN_WIDTH/3, cellView.frame.size.height)];
        cellLabel.font = FONT_OF_SIZE(15);
        cellLabel.textColor = RGBACOLOR(51, 51, 51, 1);
        cellLabel.text=arr[i];
        cellLabel.textAlignment = 1;
        [cellView addSubview:cellLabel];
    }
    
    accHisTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cellView.frame)+1,SCREEN_WIDTH, SCREEN_HEIGHT-(CGRectGetMaxY(cellView.frame)+1)-64)];
    accHisTableView.delegate = self;
    accHisTableView.dataSource = self;
    [self.view addSubview:accHisTableView];
    [accHisTableView registerClass:[AMDateTableViewCell class] forCellReuseIdentifier:@"cell"];
    __weak typeof(self)weakself = self;
    accHisTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        index = 0;
        [weakself getData];
    }];
    accHisTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        index = index+10;
        [weakself getData];
    }];
    accHisTableView.tableFooterView = [UIView new];
    accHisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (void)chooseRoute{
    __weak typeof(self)weakself = self;
    //弹出路线选择界面
    [RouteListView routeId:route_ID action:^(NSString *route_id, NSString *route_name) {
        routeLabel.text = route_name;
//        CGSize size = [routeLabel sizeThatFits:CGSizeMake(0, 21)];
//        if (size.width>(SCREEN_WIDTH-40)) {
//            size = CGSizeMake(SCREEN_WIDTH-40, 21);
//        }
//        routeLabel.frame = CGRectMake(10, routeButton.frame.size.height/2-size.height/2, size.width, size.height);
        route_ID = route_id;
        [accHisTableView.mj_header beginRefreshing];
        [weakself getData];
    }];
}



- (void)getData{
    __weak typeof (self)weakself = self;
    [XXReportHandle historyAccountMoneyWithChartStr:searchText.text andRouteId:route_ID andIndex:index WithBack:^(NSMutableArray *Arr, BOOL isSuccess) {
        
        if (isSuccess) {
            if (index) {
                [weakself.dataArr removeAllObjects];
            }
            [weakself.dataArr addObjectsFromArray:Arr];
            [accHisTableView reloadData];
        }
        [accHisTableView.mj_header endRefreshing];
        [accHisTableView.mj_footer endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 76*UISCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AMDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectChoose = 4;
    cell.accHisModel = self.dataArr[indexPath.row];
    return cell;
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
