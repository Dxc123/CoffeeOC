//
//  XXHomeViewController.m
//  mikewuYunYing
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXHomeViewController.h"
#import "XXShopListViewController.h"
#import "XXTodayReportViewController.h"
#import "XXSearchViewController.h"
#import "YBPopupMenu.h"
#import "XXQuhuoViewController.h"
#import "XXFailViewController.h"
#import "XXQuhuoViewController.h"
#import "XXLiveStockUpViewController.h"
#import "XXMeViewController.h"
#import "CheckNewVersion.h"//检测更新
#import "XHVersion.h"//检测更新
#import "TableViewCell.h"
#import "XXTableViewCell.h"
#import "XXTemperatureVC.h"
#import "XXTemperatureVC1.h"

//view
#import "UIButton+ImageTitleSpacing.h"
#import "ImageBtn.h"
#import "RouteListView.h"
#import "MachineCountCollectionViewCell.h"
#import "TitleAndCountView.h"
#import "MachineListTableViewCell.h"
//Model
#import "XXRouteListModel.h"
#import "RouteModel.h"
#import "MachineModel.h"

#define Mytag 1000
@interface XXHomeViewController ()
<UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UIViewControllerPreviewingDelegate,
YBPopupMenuDelegate,
UIScrollViewDelegate>
{
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;

}
@property (nonatomic, strong) ImageBtn *routeBtn;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableView *centertableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TitleAndCountView *headerView;
@property (nonatomic, strong) UIView *tableViewHeaderView;//表头背景View
@property (nonatomic, strong) UIImageView *bgimage;
@property(nonatomic,strong)UIButton *fourBtn;
@property(nonatomic,strong)UIButton *centerBtn;
@property(nonatomic,strong)UILabel *numberLab;//待补货机器数
@property(nonatomic,strong)UILabel *moneyLab;//不补货损失金钱数
@property(nonatomic,assign)CGFloat historyY;

// 标题数组
@property (nonatomic, strong) NSArray *titleArr;
// 图片数组
@property (nonatomic, strong) NSArray *titleImgArr;
// 数量数组
@property (nonatomic, strong) NSMutableArray *countArr;
// 记录section是否展开
@property (nonatomic, strong) NSMutableDictionary *markDic;
// section数组
@property (nonatomic, strong) NSMutableArray *sectionArr;
// 咖啡机器数组
@property (nonatomic, strong) NSMutableArray *coffeeMachineArr;
// 机器数组
@property (nonatomic, strong) NSMutableArray *machineArr;
// 记录当前路线Id
@property (nonatomic, copy) NSString *routeId;

@end

@implementation XXHomeViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadData:self.routeId isShowProgress:NO];
//    }];
//    [self.tableView.mj_header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.view.backgroundColor=RGB(249, 249, 249);
    [self wr_setNavBarTintColor:[UIColor colorHexToBinaryWithString:@"#2da9ff"]];
//    [self wr_setNavBarBackgroundAlpha:0];


    //一进入就加载全部路线列表
    [self loadData:@"0" isShowProgress:YES];
    self.routeId = @"0";

    [self setupUI];
    [self setnavigationBar];
//    [self checkMethod];//检查更新方法
    [self checkMethod1];//检查更新方法

   }
-(void)setnavigationBar{
       //自定义navigationBar.title
    self.routeBtn =[[ImageBtn alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Title:@"全部路线" Image: [UIImage imageNamed:@"iv_circle_bottom"]];
    self.navigationItem.titleView=self.routeBtn;
    UITapGestureRecognizer *routeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(routeTap:)];
    [self.routeBtn addGestureRecognizer:routeTap];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"iv_thirdline"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"iv_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];


}

-(void)setupUI{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,140 * UISCALE)];
    bgView.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];
    [self.view addSubview:bgView];
    
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    searchBar.barStyle=UISearchBarStyleDefault;
    searchBar.barTintColor=[UIColor colorHexToBinaryWithString:@"#0483de"];;
    searchBar.placeholder=@"请输入机器编号";
    searchBar.translucent=YES;
    searchBar.userInteractionEnabled=NO;
    [bgView addSubview:searchBar];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn .frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:searchBtn];
    
    
    self.titleArr = @[@"缺货", @"温度",@"断网", @"故障"];
    self.titleImgArr = @[ @"iv_four_quehuo", @"iv_four_wendu",@"iv_four_duanwang",@"iv_four_guzhang"];

    // collectionView布局
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(SCREEN_WIDTH / 4,80 * UISCALE);
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame), SCREEN_WIDTH, 100 * UISCALE) collectionViewLayout:layOut];
    [bgView addSubview:self.collectionView];

    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[MachineCountCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MachineCountCollectionViewCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame)+20, SCREEN_WIDTH, 60)];
    [self.view addSubview:_numberLab];
    _numberLab.textColor = [UIColor blackColor];
    _numberLab.textAlignment = NSTextAlignmentCenter;
    _numberLab.text = @"今日待补货机器(台): 0";
    _numberLab.backgroundColor = [UIColor whiteColor];
   

    // tableView布局
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_numberLab.frame)+25, SCREEN_WIDTH, SCREEN_HEIGHT-188 * UISCALE-30-49) style: UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc] init];
   ;
//    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell2" bundle:nil] forCellReuseIdentifier:@"TableViewCell2"];
    
    //    //自定义headerView
//    self.headerView = [[TitleAndCountView alloc] init];
//    [self.tableView setTableHeaderView:self.headerView];
//    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 88 * UISCALE);
//    self.headerView.hideLine = NO;
//    self.headerView.leftTitleLabel.text = @"今日待补货机器(台)";
//    self.headerView.rightTitleLabel.text = @"不补货的损失(元)";
//    self.headerView.leftCountLabel.textColor= BLUE;
//    self.headerView.rightCountLabel.textColor= BLUE;
//    // 上分割线view
//    UIView *Line = [[UIView alloc] init];//WithFrame:CGRectMake(0, view.frame.size.height , SCREEN_WIDTH, 0.5)];
//    [self.headerView addSubview:Line];
//    Line.sd_layout.widthIs(SCREEN_WIDTH).heightIs(0.5).topSpaceToView(self.headerView, 0).leftSpaceToView(self.headerView, 0);
//    Line.backgroundColor = LINE_COLOR;
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadData:self.routeId isShowProgress:NO];
//    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData:self.routeId isShowProgress:NO];
    }];

    
   }

/*  数据请求
 *  routeId:线路id
 *  isShow:是否显示progress
 */
- (void)loadData:(NSString *)routeId isShowProgress:(BOOL)isShow
{
    if (isShow) {
        self.tableView.hidden = YES;
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    self.tableView.userInteractionEnabled = NO;
    self.markDic = [NSMutableDictionary dictionary];
 
    
        [XXHomeHandle requestMachineCountWithManagerId:MANAGER_ID routeId:routeId callback:^(NSMutableArray *countArray, NSMutableArray *sectionArray, NSMutableArray *machineArray, NSMutableArray *coffeeMachineArray,NSString *replenishmentCount, NSString *lossAmount, BOOL isSuccess) {
            self.countArr = countArray;
            self.machineArr = machineArray;
            self.coffeeMachineArr = coffeeMachineArray;
            self.sectionArr = sectionArray;
//            self.headerView.leftCountLabel.text = replenishmentCount;
//            self.headerView.rightCountLabel.text = lossAmount;
            _numberLab.text = [NSString stringWithFormat:@"今日待补货机器(台):     %@",replenishmentCount];
            self.loadDataSuccess = isSuccess;
            [self.collectionView reloadData];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.userInteractionEnabled = YES;
            self.tableView.hidden = !isSuccess;
            if (self.navigationController.visibleViewController == self && isSuccess) {
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
            }
        }];
}



#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MachineCountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MachineCountCollectionViewCell class]) forIndexPath:indexPath];
    cell.itemTitleLabel.text = self.titleArr[indexPath.item];
    cell.itemTitleLabel.textColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:self.titleImgArr[indexPath.item]];
    cell.imgView.image = image;
    if (self.countArr.count != 0) {
        cell.countText = self.countArr[indexPath.item];
    }
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            //给cell注册3DTouch的peek（预览）和pop功能
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.item + 1;
    XXFailViewController *failVC = [[XXFailViewController alloc] init];
    failVC.routeId = self.routeId;
    
    failVC.machineType = index;
    switch (index) {
        case 1:
        {
            failVC.navigationItem.title = @"缺货";
            [self.navigationController pushViewController:failVC animated:YES];
            }
            break;
        case 2:
        {
//            failVC.navigationItem.title = @"温度";
//            [self.navigationController pushViewController:failVC animated:YES];
            XXTemperatureVC *tVC = [[XXTemperatureVC alloc] init];
//            XXTemperatureVC1 *tVC = [[XXTemperatureVC1 alloc] init];
            [self.navigationController pushViewController:tVC animated:YES];
        }
            break;
        case 3:
        {
            failVC.navigationItem.title = @"断网";
            [self.navigationController pushViewController:failVC animated:YES];
        }
            break;
        case 4:
        {
            failVC.navigationItem.title = @"故障";
            [self.navigationController pushViewController:failVC animated:YES];
        }
            break;
            
        default:
            break;
    }
//    if (index == 1) {
//      
//        
//    }else if (index == 2) {
//        failVC.navigationItem.title = @"温度";
//        failVC.machineType = 0;
//    }else if (index == 3) {
//        failVC.navigationItem.title = @"断网";
//        
//    } else if (index == 4) {
//        failVC.navigationItem.title = @"故障";
//             }
//      [self.navigationController pushViewController:failVC animated:YES];
//    
    
   
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(MachineCountCollectionViewCell* )[previewingContext sourceView]];
    //设定预览的界面
    NSInteger index = indexPath.item + 1;
    XXFailViewController *failVC = [[XXFailViewController alloc] init];
    failVC.routeId = self.routeId;
    failVC.machineType = index;
    if (index == 1) {
        failVC.navigationItem.title = @"补货";
    } else if (index == 2) {
        failVC.navigationItem.title = @"温度";
    } else if (index == 3) {
        failVC.navigationItem.title = @"断网";
    } else if (index == 4) {
        failVC.navigationItem.title = @"故障";
    }
    failVC.preferredContentSize = CGSizeMake(0.0f, 500.0f * UISCALE);
    //返回预览界面
    return failVC;
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}



#pragma mark -->UITableViewDataSource and UITableViewDelegate
//到少分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArr.count;

  }
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{

    NSString *tag = [NSString stringWithFormat:@"%ld", section + 1000];
    if ([self.markDic[tag] integerValue] == 1) {
        RouteModel *route = self.sectionArr[section];
        
        NSInteger count =  route.machineInfoList.count >route.coffeeMachineInfoList.count? route.machineInfoList.count:route.coffeeMachineInfoList.count;
        
        return count;//route.machineInfoList.count;
    } else {
        return 0;
    }

   }
//cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

      return 280;


}
// section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50* UISCALE;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//cell赋值
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *reuse = @"MachineListTableViewCell";
//    MachineListTableViewCell *cell = [[MachineListTableViewCell alloc] init];
//    if (!cell) {
//        cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
//    }
//    //显示分割线
//    tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//
//    RouteModel *route = self.sectionArr[indexPath.section];
//    MachineModel *machine = route.machineInfoList[indexPath.row];
//    cell.machineSn = machine.machineSn;
//    cell.position = machine.positionName;
//    cell.isGuzhang = [machine.isGuzhang integerValue];
//    cell.isQuehuo = [machine.isQuehuo integerValue];
//    cell.isQuebi = [machine.isQuebi integerValue];
//    cell.isDuanwang = [machine.isDuanwang integerValue];
//    static NSString *ID = @"TableViewCell2";
//    TableViewCell2 *cell= [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];///[[NSBundle mainBundle] loadNibNamed:@"TableViewCell2" owner:self options:nil];
 
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell2" owner:self options:nil] firstObject];
//
//    }
    
    static NSString *reuse = @"XXTableViewCell";
    XXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[XXTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    return cell;
    
}
//设置cell的背景色

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];//[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    
//    
//}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionArr[section];
}

// section头部显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    // 背景view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45 * UISCALE)];
    view.backgroundColor = [UIColor whiteColor];
    // 单击的recognizer，收缩分组cell
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTap:)];
    view.tag = 1000 + section;
    [view addGestureRecognizer:tap];
    // 上分割线view
    UIView *Line = [[UIView alloc] init];//WithFrame:CGRectMake(0, view.frame.size.height , SCREEN_WIDTH, 0.5)];
    [view addSubview:Line];
    Line.sd_layout.widthIs(SCREEN_WIDTH).heightIs(0.5).topSpaceToView(view, 0.5).leftSpaceToView(view, 0);
    Line.backgroundColor = LINE_COLOR;

    // 下分割线view
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height , SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    [view addSubview:bottomLine];
    // 箭头view
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * UISCALE, 18 * UISCALE, 18 , 18 )];
    arrowView.image = IMAGE(@"icon_blue_right");
    [view addSubview:arrowView];

//    设置图片箭头旋转

    NSString *str = [NSString stringWithFormat:@"%ld", (long)view.tag];
      double degree;
    if ([self.markDic[str] integerValue] == 1) {
//        arrowView.image = IMAGE(@"jiantou_down");
        degree = M_PI/2;
        }
        else{
            degree = 0;
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
        } completion:NULL];


    RouteModel *route = [[RouteModel alloc] init];
    if (self.sectionArr.count != 0) {
        route = self.sectionArr[section];
    }

    // 篮子图标
    UIButton *lanziBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:lanziBtn];
    [lanziBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.right.mas_equalTo(view.mas_right);
        make.width.mas_equalTo(60 * UISCALE);
    }];
    [lanziBtn setImage:IMAGE(@"jianyou_icon") forState:UIControlStateNormal];
    [lanziBtn addTarget:self action:@selector(lanziAction:) forControlEvents:UIControlEventTouchUpInside];
    lanziBtn.tag = section + 2000;
    if ([route.machineCount integerValue] == 0) {
        lanziBtn.userInteractionEnabled = NO;
    }
    // 内容label
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(10 * UISCALE);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-10 * UISCALE);
        make.right.mas_equalTo(lanziBtn.mas_left).offset(-11 * UISCALE);
        make.left.mas_equalTo(arrowView.mas_right).offset(11 * UISCALE);
    }];
    label.font = FontNotoSansLightWithSafeSize(17);
    label.text = [NSString stringWithFormat:@"%@(共%@台)", route.routeName, route.machineCount];
    return view;

    }


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%ld%ld",(long)indexPath.section,(long)indexPath.row);
//    
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    RouteModel *route = self.sectionArr[indexPath.section];
//    MachineModel *machine = route.machineInfoList[indexPath.row];
//
////    QuehuoViewController *quehuoVC = [[QuehuoViewController alloc] init];
////    quehuoVC.machineSn = machine.machineSn;
////    [self.navigationController pushViewController:quehuoVC animated:YES];
//    XXQuhuoViewController *quehuoVC = [[XXQuhuoViewController alloc] init];
//    quehuoVC.machineSn = machine.machineSn;
//    [self.navigationController pushViewController:quehuoVC animated:YES];
//    
//
//
//   
//}


#pragma mark - ***** UIScrollViewDelegate




#pragma mark - custom delegate
- (void)refreshPageData
{
    [self loadData:self.routeId isShowProgress:YES];
}


#pragma mark - action
// 线路展开
- (void)sectionTap:(UITapGestureRecognizer *)tap
{
    NSString *tag = [NSString stringWithFormat:@"%ld", tap.view.tag];
    if ([self.markDic[tag] integerValue] == 1) {
        [self.markDic setObject:@"0" forKey:tag];
    } else {
        [self.markDic setObject:@"1" forKey:tag];
    }
    
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tap.view.tag - 1000];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

// 线路切换
- (void)routeTap:(UITapGestureRecognizer *)tap
{
    [RouteListView routeId:self.routeId action:^(NSString *route_id, NSString *route_name) {
        self.routeId = route_id;
        [self.routeBtn resetData:route_name Image:IMAGE(@"bule_down_icon")];
        [self loadData:self.routeId isShowProgress:YES];
    }];
}

// 搜索点击方法
- (void)searchAction
{
    NSLog(@"点击了搜索");
    XXSearchViewController *searchVC = [[XXSearchViewController alloc] init];
    searchVC.routeId = self.routeId;
    [self.navigationController pushViewController:searchVC animated:YES];
}

// 篮子方法
- (void)lanziAction:(UIButton *)button
{
    RouteModel *route = self.sectionArr[button.tag - 2000];
    XXLiveStockUpViewController *stockUpVC = [[XXLiveStockUpViewController alloc] init];
    stockUpVC.routeId = route.routeId;
    [self.navigationController pushViewController:stockUpVC animated:YES];
}


-(void)leftClick{

 [self.navigationController pushViewController:[XXMeViewController new] animated:YES];
}

-(void)rightClick:(UIButton *)btn{
    
    [YBPopupMenu showRelyOnView:btn titles:self.itemss icons:nil menuWidth:170 delegate:self];
   

}

- (NSArray *)itemss {
    return @[
             //@"生成次日备货单",
             @"查看今日运营报告",
             ];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",self.itemss[index]);
    switch (index) {
        case 0:
        {
//            [self.navigationController pushViewController:[XXShopListViewController new] animated:YES];
            [self.navigationController pushViewController:[XXTodayReportViewController new] animated:YES];
            
        }
            break;
            
        case 1:
        {
            [self.navigationController pushViewController:[XXTodayReportViewController new] animated:YES];
          
            
        }
            break;
        default:
            break;
    }
    
}

-(void)centerClick{
    
    if (_centertableView.hidden == NO) {
        _centertableView.hidden = YES;
        
    }else{
        _centertableView.hidden = NO;

    }
    
}

-(void)checkMethod1{
    NSLog(@"新版本更新");
    //1.新版本检测(使用默认提示框)
    [XHVersion checkNewVersion];
    
    //2.如果你需要自定义提示框,请使用下面方法
    [XHVersion checkNewVersionAndCustomAlert:^(XHAppInfo *appInfo) {

        //appInfo为新版本在AppStore相关信息
        //请在此处自定义您的提示框
        NSLog(@"新版本信息:\n 版本号 = %@ \n 更新时间 = %@\n 更新日志 = %@ \n 在AppStore中链接 = %@\n AppId = %@ \n bundleId = %@" ,appInfo.version,appInfo.currentVersionReleaseDate,appInfo.releaseNotes,appInfo.trackViewUrl,appInfo.trackId,appInfo.bundleId);

    }];
}
-(void)checkMethod{
// 叮咚屋运营   https://itunes.apple.com/cn/app/%E5%8F%AE%E5%92%9A%E5%B1%8B%E8%BF%90%E8%90%A5/id1244668622?mt=8
//   米克屋运营  https://itunes.apple.com/us/app/%E7%B1%B3%E5%85%8B%E5%B1%8B%E8%BF%90%E8%90%A5/id1282951128?l=zh&ls=1&mt=8
    //检查更新  米克屋运营 1282951128
    [CheckNewVersion checkNewVersionWithAppID:@"https://itunes.apple.com/us/app/%E7%B1%B3%E5%85%8B%E5%B1%8B%E8%BF%90%E8%90%A5/id1282951128?l=zh&ls=1&mt=8" controller:self];
    
//    [CheckNewVersion checkNewVersionWithAppID:@"" customAlert:^(AppleStoreModelInfo *appInfomation) {
//        
//    }];//自定义alert的方法
}


- (NSMutableArray *)sectionArr {
    
    if (!_sectionArr) {
        
        _sectionArr = [[NSMutableArray alloc] init];
    }
    return _sectionArr;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.bgimage.hidden=YES;
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
