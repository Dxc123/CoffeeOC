//
//  XXShipmentViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/2.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXShipmentViewController.h"
#import "AMGatherTableViewCell.h"
#import "XXNoDataView.h"
#import "XXNoNetView.h"
#import "SZCalendarPicker.h"

@interface XXShipmentViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    int index;
    NSString *DateString;
    XXNoDataView *noDataView;
    XXNoNetView *noNetView;
}
@property(strong,nonatomic)NSMutableArray *dateArr;
@property(strong,nonatomic)UILabel *routeNum;
@property(strong,nonatomic)UILabel *routeName;
@end

@implementation XXShipmentViewController

- (NSMutableArray *)dateArr{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:bar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"出货日志";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[self getTitleChooseWithPicName:@"ic_down_black" andTitle:self.dateType]];
    [self createView];
    DateString = self.dateType;
    [self getDataWithDate:self.dateType];
    
}

- (void)createView{
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100*UISCALE)];
    image.image=IMAGE(@"noshopbg_icon");
    [self.view addSubview:image];
    UILabel *routeNum = [[UILabel alloc]init];
    routeNum.text=@"0";
    routeNum.textAlignment = NSTextAlignmentCenter;
    routeNum.textColor = [UIColor whiteColor];
    routeNum.font=[UIFont systemFontOfSize:22];
    routeNum.frame = CGRectMake(0, 0, SCREEN_WIDTH,50);
    [image addSubview:routeNum];
    self.routeNum=routeNum;
    self.routeNum.text=[NSString stringWithFormat:@"%@",self.machineType];
    UILabel *routeName = [[UILabel alloc]init];
    routeName.text=@"0";
    routeName.textAlignment = NSTextAlignmentCenter;
    routeName.textColor = [UIColor whiteColor];
    routeName.font=[UIFont systemFontOfSize:20];
    routeName.frame = CGRectMake(0, CGRectGetMaxY(routeNum.frame), SCREEN_WIDTH,50);
    [image addSubview:routeName];
    self.routeName=routeName;
    self.routeName.text=[NSString stringWithFormat:@"%@",self.routeStr];
    
    
    //    UILabel *titleLabel = [[UILabel alloc]init];
    //    titleLabel.backgroundColor = COLOR_MAIN;
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.numberOfLines = 2;
    //    titleLabel.attributedText = [self getAttributeStrWithMachineNum:self.machineType andLineStr:self.routeStr];
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
    //    [self.view addSubview:titleLabel];
    
    myTableView = [[UITableView alloc]init];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.frame = CGRectMake(0, CGRectGetMaxY(image.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64-100*UISCALE);
    [self.view addSubview:myTableView];
    
    [myTableView registerClass:[AMGatherTableViewCell class] forCellReuseIdentifier:@"goodsCell"];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [myTableView setTableFooterView:view];
    
    __weak typeof(self) weakself = self;
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        index = 0;
        [weakself getDataWithDate:DateString];
    }];
    
    myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        index = index+10;
        [weakself getDataWithDate:DateString];
    }];
    
    noDataView = [[XXNoDataView alloc]initWithFrame:myTableView.frame];
    [noDataView reloadWithPicName:nil AndTitle:@"数据加载中..."];
    [self.view addSubview:noDataView];
    noNetView = [[XXNoNetView alloc]initWithFrame:myTableView.frame];
    [noNetView refreshForNewMessage:^{
        [weakself getDataWithDate:weakself.dateType];
    }];
    [self.view addSubview:noNetView];
}
- (void)getDataWithDate:(NSString *)dateStr{
    //    [myTableView reloadData];
    
    __weak typeof(self) weakself = self;
    [XXReportHandle getOutLogInfoListWithmachineID:self.machineType andDate:dateStr WithDataStr:self.routeId AndIndex:[NSString stringWithFormat:@"%d",index] WithBlock:^(NSMutableArray *arr,BOOL LossConnect) {
        if (!LossConnect) {
            if (index == 0) {
                //                [weakself.dateArr removeAllObjects];
            }
            if (index == 0&&!(arr.count>0)) {
                [noDataView reloadWithPicName:@"ic_no_alter" AndTitle:@"此售货机当日没有售货信息"];
            }else{
                [noDataView removeFromSuperview];
            }
            [weakself.dateArr addObjectsFromArray:arr];
            [myTableView reloadData];
            [noNetView dismiss];
        }
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
    }];
}
//选择日期
- (void)chooseDate{
    
    static BOOL isShow;
    [noDataView removeFromSuperview];
    if (!isShow) {
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.tag = 100;
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
        calendarPicker.frame = CGRectMake(0, 64, SCREEN_WIDTH, 352);
        __weak typeof(self) weakself = self;
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            NSString *dateStr = [NSString stringWithFormat:@"%li-%02li-%02li", (long)year,(long)month,(long)day];
            DateString = dateStr;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[self getTitleChooseWithPicName:@"ic_down" andTitle:dateStr]];
            index = 0;
            [weakself.dateArr removeAllObjects];
            isShow = NO;
            
            noDataView = [[XXNoDataView alloc]initWithFrame:myTableView.frame];
            [noDataView reloadWithPicName:nil AndTitle:@"数据加载中..."];
            [self.view addSubview:noDataView];
            noNetView = [[XXNoNetView alloc]initWithFrame:myTableView.frame];
            [noNetView refreshForNewMessage:^{
                [self getDataWithDate:dateStr];
            }];
            [self.view addSubview:noNetView];
            [self getDataWithDate:dateStr];
        };
    }else{
        
        SZCalendarPicker *calendarPicker = [self.view viewWithTag:100];
        [calendarPicker hide];
        //        [calendarPicker removeFromSuperview];
    }
    isShow = !isShow;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noDataView removeFromSuperview];
    [noNetView dismiss];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*UISCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMGatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
    if (!cell) {
        cell = [[AMGatherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsCell"];
    }
    AMShipModel *model = self.dateArr[indexPath.row];
    cell.selectIndex = 2;
    cell.shipModel = model;
    return cell;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSDate *)nsdateString:(NSString *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate* string=[dateFormat dateFromString:date];
    
    return string;
}
- (UIView *)getTitleChooseWithPicName:(NSString *)picName andTitle:(NSString *)title{
    
    UIView *rightView = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.font = FONT_OF_SIZE(16);
    label.text = title;
    label.textColor = [UIColor blackColor];
    CGSize size = [label sizeThatFits:CGSizeMake(0, 20)];
    label.frame = CGRectMake(0, 0, size.width, size.height);
    [rightView addSubview:label];
    UIImage *image = [UIImage imageNamed:picName];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(size.width, -5, image.size.width, image.size.height);
    imageView.image = image;
    [rightView addSubview:imageView];
    rightView.bounds = CGRectMake(0, 0, size.width+image.size.width, size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate)];
    [rightView addGestureRecognizer:tap];
    
    return rightView;
}
- (NSMutableAttributedString *)getAttributeStrWithMachineNum:(NSString *)machineNum andLineStr:(NSString *)lineStr{
    NSUInteger numberMach = machineNum.length;
    NSUInteger numberLine = lineStr.length;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n\n%@",machineNum,lineStr]];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:FONT_OF_SIZE(17)
                          range:NSMakeRange(0, numberMach)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:FONT_OF_SIZE(17)
                          range:NSMakeRange(numberMach+1, numberLine)];
    return AttributedStr;
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
