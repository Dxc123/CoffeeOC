//
//  XXAlertViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXTypeViewController.h"
#import "AMMachWorModel.h"
#import "XXNoNetView.h"
#import "XXTaskDetailViewController.h"

@interface XXTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *wornTableView;
    int index;
    XXNoNetView *noNetCon;
}
@property(strong,nonatomic)NSMutableArray *dataArr;
@end

@implementation XXTypeViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    index = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"告警类别";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self createView];
    [self getData];
}
- (void)createView{
    //告警界面
    wornTableView = [[UITableView alloc]init];
    wornTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    wornTableView.delegate = self;
    wornTableView.dataSource = self;
    [self.view addSubview:wornTableView];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [wornTableView setTableFooterView:view];
    wornTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [wornTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    wornTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        index = 0;
        [self getData];
    }];
    wornTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        index = index+10;
        [self getData];
    }];
    
    noNetCon = [[XXNoNetView alloc]initWithFrame:wornTableView.frame];
    [noNetCon refreshForNewMessage:^{
        [self getData];
    }];
    [self.view addSubview:noNetCon];
    
}
- (void)getData{
    [XXToolHandle getWorningDetailByType:self.typeID AndIndex:[NSString stringWithFormat:@"%d",index] WithBlock:^(NSMutableArray *arr,BOOL LossConnect) {
        if (arr != nil) {
            if (index ==0 ) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            [wornTableView reloadData];
        }
        [wornTableView.mj_footer endRefreshingWithNoMoreData];
        [wornTableView.mj_header endRefreshing];
        [noNetCon dismiss];
    }];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noNetCon dismiss];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *delectLabel = [cell.contentView viewWithTag:100];
    [delectLabel removeFromSuperview];
    AMMachWorModel *model = self.dataArr[indexPath.row];
    cell.textLabel.attributedText = [self getAttributeStrWithMachineNum:model.machineType andLineStr:model.worningType];
    cell.textLabel.textColor = RGB(117, 117, 117);
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.frame = CGRectMake(SCREEN_WIDTH-70, 76*UISCALE/2-12, 48, 24);
    typeLabel.layer.borderWidth = 1;
    typeLabel.layer.cornerRadius = 5;
    typeLabel.tag = 100;
    typeLabel.font = FONT_OF_SIZE(12);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:typeLabel];
    if ([model.alermLevel isEqualToString:@"0"]) {
        typeLabel.text = @"普通";
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    }else if ([model.alermLevel isEqualToString:@"1"]){
        typeLabel.text = @"重要";
        typeLabel.textColor = RGB(245,166,35);
        typeLabel.layer.borderColor = [RGB(245,166,35) CGColor];
    }else if ([model.alermLevel isEqualToString:@"2"]){
        typeLabel.text = @"严重";
        typeLabel.textColor = RGB(255,107,121);
        typeLabel.layer.borderColor = [RGB(255,107,121) CGColor];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMMachWorModel *model = self.dataArr[indexPath.row];
    XXTaskDetailViewController *detailVC = [[XXTaskDetailViewController alloc]init];
    detailVC.machineID = model.machineType;
    detailVC.markID = 1;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76*UISCALE;
    
}


- (NSMutableAttributedString *)getAttributeStrWithMachineNum:(NSString *)machineNum andLineStr:(NSString *)lineStr{
    NSUInteger numberMach = machineNum.length;
    NSUInteger numberLine = lineStr.length;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",machineNum,lineStr]];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:FONT_OF_SIZE(16)
                          range:NSMakeRange(0, numberMach)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:FONT_OF_SIZE(14)
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
