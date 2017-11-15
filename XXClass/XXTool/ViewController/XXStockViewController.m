//
//  XXStockViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/6/2.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXStockViewController.h"
#import "AMTaskSectionTitleModel.h"
#import "AMHistoryDetailModel.h"
#import "AMHistoryTableViewCell.h"
#import "XXNoNetView.h"
typedef enum :NSInteger{
    sectionButtonTag = 10,
    cellTags = 20,
}tags;

@interface XXStockViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myDetailTableView;
    XXNoNetView *noNetView;
}
@property(strong,nonatomic)NSMutableArray *dataArr;
@property(strong,nonatomic)NSMutableArray *sectionArr;



@end

@implementation XXStockViewController

- (NSMutableArray *)sectionArr{
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    self.navigationItem.title = @"备货单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self createView];
    [self getData];
}
- (void)createView{
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(10, 0, 150, 40);
    timeLabel.font = FONT_OF_SIZE(14);
    timeLabel.text = [NSString stringWithFormat:@"%@备货单",self.timeStr];
    timeLabel.textColor = COLOR_GRAY;
    [titleView addSubview:timeLabel];
    UILabel *createtimeLabel = [[UILabel alloc]init];
    createtimeLabel.frame = CGRectMake(SCREEN_WIDTH-230*UISCALE, 0, 250, 40);
    createtimeLabel.font = FONT_OF_SIZE(14);
    createtimeLabel.text = [NSString stringWithFormat:@"生成时间:%@",self.createTimeStr];
    createtimeLabel.textColor = COLOR_GRAY;
    [titleView addSubview:createtimeLabel];
    
    
    
    
    
    
    
    myDetailTableView = [[UITableView alloc]init];
    myDetailTableView.delegate = self;
    myDetailTableView.dataSource = self;
    myDetailTableView.frame = CGRectMake(0, CGRectGetMaxY(titleView.frame)+5, SCREEN_WIDTH, SCREEN_HEIGHT-5-CGRectGetMaxY(titleView.frame));
    [self.view addSubview:myDetailTableView];
    myDetailTableView.tableFooterView=[[UIView alloc] init];
    myDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myDetailTableView registerClass:[AMHistoryTableViewCell class] forCellReuseIdentifier:@"cell"];
    __weak typeof(self) weakself = self;
    myDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getData];
    }];
    
    noNetView = [[XXNoNetView alloc]initWithFrame:myDetailTableView.frame];
    [noNetView refreshForNewMessage:^{
        [weakself getData];
    }];
    [self.view addSubview:noNetView];
    
}

- (void)getData{
    __weak typeof(self)weakself = self;
    [XXToolHandle getHistoryDetailStockupInfoListWithStockID:self.stockupId andBlock:^(NSMutableDictionary *Dic,BOOL LossConnect) {
        
        NSArray *titleArr = [Dic allKeys];
        [weakself.sectionArr removeAllObjects];
        for (int i = 0; i<titleArr.count; i++) {
            AMTaskSectionTitleModel *model = [[AMTaskSectionTitleModel alloc]init];
            model.isOn = NO;
            model.sectionTitle = titleArr[i];
            [weakself.sectionArr addObject:model];
        }
        [weakself.dataArr removeAllObjects];
        [weakself.dataArr addObjectsFromArray:[Dic allValues]];
        [myDetailTableView reloadData];
        
        [myDetailTableView.mj_header endRefreshing];
        
        [noNetView dismiss];
    }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AMHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    AMHistoryDetailModel *model = self.dataArr[indexPath.section][indexPath.row];
    cell.markID = 1;
    cell.detailModel = model;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AMTaskSectionTitleModel *model = self.sectionArr[section];
    if (model.isOn) {
        return [self.dataArr[section] count];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*UISCALE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
    NSArray *contentArr = [model.sectionTitle componentsSeparatedByString:@"-"];
    UILabel *label = [[UILabel alloc]init];
    label.font = FONT_OF_SIZE(16);
    label.frame = CGRectMake(CGRectGetMaxX(imageChoose.frame),0 , SCREEN_WIDTH-CGRectGetMaxX(imageChoose.frame), 44);
    label.text = [contentArr firstObject];
    [button addSubview:label];
    UILabel *quehuoLabel = [[UILabel alloc]init];
    quehuoLabel.frame = CGRectMake(SCREEN_WIDTH-110, 12, 100, 20);
    quehuoLabel.font = FONT_OF_SIZE(13);
    quehuoLabel.textAlignment = NSTextAlignmentRight;
    quehuoLabel.text = [NSString stringWithFormat:@"总缺货量%@",[contentArr lastObject]];
    [button addSubview:quehuoLabel];
    
    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height-0.5,SCREEN_WIDTH, 0.5)];
    separView.backgroundColor = separeLineColor;
    [button addSubview:separView];
    return button;
}

- (void)clickHeaderButton:(UIButton *)sender
{
    //sender.selected = !sender.selected; 用这种方式来区分判断是不行的，因为每次刷新就会调用tableview的头视图，就会重新创建头视图的按钮。达不到效果，所以需要有一个页面加载后只创建一次的变量来记录
    AMTaskSectionTitleModel *model = self.sectionArr[sender.tag-sectionButtonTag];
    model.isOn = !model.isOn;
    //    [myHTableView reloadData];
    
    [myDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-sectionButtonTag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

@end
