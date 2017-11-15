//
//  view1.m
//  test
//
//  Created by 博爱 on 16/5/11.
//  Copyright © 2016年 博爱之家. All rights reserved.
//

#import "view1.h"
#import "MachineListTableViewCell2.h"
#import "RouteModel.h"
#import "MachineModel.h"
#import "XXHomeHandle.h"
#import "XXQuhuoViewController.h"

@interface view1 ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
//@property (nonatomic, strong) UITableView   *tableView;
// section数组
@property (nonatomic, strong) NSMutableArray *sectionArr;
// 咖啡机器数组
@property (nonatomic, strong) NSMutableArray *coffeeMachineArr;
// 机器数组
@property (nonatomic, strong) NSMutableArray *machineArr;
// 记录当前路线Id
@property (nonatomic, copy) NSString *routeId;

@end

@implementation view1

- (instancetype)initWithFrame:(CGRect)frame withSelectRowBlock:(selectRowBlock)selectRowBlock
{
    if (self = [super initWithFrame:frame])
    {
        self.selectBlock = selectRowBlock;
                
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-20*UISCALE)];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
        
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //一进入就加载全部路线列表
        [self loadData:@"0" isShowProgress:YES];
        self.routeId = @"0";
    }
    return self;
}



- (void)loadData:(NSString *)routeId isShowProgress:(BOOL)isShow
{
    if (isShow) {
        self.tableView.hidden = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    self.tableView.userInteractionEnabled = NO;
    
    
    
    [XXHomeHandle requestMachineCountWithManagerId:MANAGER_ID routeId:routeId callback:^(NSMutableArray *countArray, NSMutableArray *sectionArray, NSMutableArray *machineArray, NSMutableArray *coffeeMachineArray,NSString *replenishmentCount, NSString *lossAmount, BOOL isSuccess) {
        NSLog(@"cell嵌套内容");
        self.machineArr = machineArray;
        self.coffeeMachineArr = coffeeMachineArray;
        self.sectionArr = sectionArray;
        
//        self.loadDataSuccess = isSuccess;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.userInteractionEnabled = YES;
        self.tableView.hidden = !isSuccess;
        if ( isSuccess) {
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
        }
    }];
}
//配置tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210*UISCALE) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.estimatedRowHeight = 44;
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return 10;
    RouteModel *route = self.sectionArr[section];
    return route.machineInfoList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*UISCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuse = @"MachineListTableViewCell2";
    MachineListTableViewCell2 *cell = [[MachineListTableViewCell2 alloc] init];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    RouteModel *route = self.sectionArr[indexPath.section];
    MachineModel *machine = route.machineInfoList[indexPath.row];
    cell.machineSn = machine.machineSn;
    cell.position = machine.positionName;
    cell.isGuzhang = [machine.isGuzhang integerValue];
    cell.isDuanwang = [machine.isDuanwang integerValue];
    cell.isQuehuo = [machine.isQuehuo integerValue];
    cell.isQuebi = [machine.isQuebi integerValue];
    
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"cell:%ld",_index];
    
    //    RouteModel *route = [[RouteModel alloc] init];
    //     cell.textLabel.text = [NSString stringWithFormat:@"%@(共%@台)", route.routeName, route.machineCount];
    
//    cell.tiaozhuan = ^(NSInteger num){
//        ViewController *viewC = [[ViewController alloc]init];
//        [self.navigationController pushViewController:viewC animated:YES];
//    };

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld%ld",(long)indexPath.section,(long)indexPath.row);
 
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    RouteModel *route = self.sectionArr[indexPath.section];
    MachineModel *machine = route.machineInfoList[indexPath.row];

//    QuehuoViewController *quehuoVC = [[QuehuoViewController alloc] init];
//    quehuoVC.machineSn = machine.machineSn;
//    [self.navigationController pushViewController:quehuoVC animated:YES];
    XXQuhuoViewController *quehuoVC = [[XXQuhuoViewController alloc] init];
    quehuoVC.machineSn = machine.machineSn;
    
    [self.navigationController pushViewController:quehuoVC animated:YES];




}
//设置cell的背景色

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];
    //[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];


}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

//自定义view中push到下一个导航控制器 ，获取当前自定义view所在的导航控制器
//获取视图控制器
- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}
//获取导航控制器
- (UINavigationController*)navigationController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}
@end
