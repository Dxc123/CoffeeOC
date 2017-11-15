//
//  XXNoticeViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXNotificationViewController.h"
#import "XXNoticeTableViewCell.h"
#import "AMGatherModel.h"
#import "AMGatherTableViewCell.h"
#import "AMTaskSectionTitleModel.h"
#import "AMTaskTableViewCell.h"
#import "AMTaskModel.h"

#import "AMWorningTableViewCell.h"

#import "XXNoNetView.h"

#import "AMNotificationTableViewCell.h"
#import "AMDataBaseTool.h"
#import "XXNotiDetailViewController.h"
#import "XXNoDataView.h"


typedef enum :NSInteger{
    sectionButtonTag = 10,
    dataChooseTag = 30,
    allOrDelectTag = 50,
}tags;


@interface XXNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myNTableView;
    XXNoNetView *noNetView;
    XXNoDataView *noDataView;
    UIView  *DataChooView;
    
    BOOL isEditing;
    UIView *chooseView;
}
@property(strong,nonatomic)NSMutableArray *sectionArr;
@property(nonatomic,strong)NSMutableArray *dateArr;
@end

@implementation XXNotificationViewController

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
    myNTableView = [[UITableView alloc]init];
    myNTableView.delegate = self;
    myNTableView.dataSource = self;
    myNTableView.frame = self.view.frame;
    [self.view addSubview:myNTableView];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [myNTableView setTableFooterView:view];
    myNTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    noNetView = [[XXNoNetView alloc]initWithFrame:myNTableView.frame];
    [noNetView refreshForNewMessage:^{
        [self getData];
    }];
    [self.view addSubview:noNetView];
    
    [self getChoose];
}

- (void)getChoose{
    switch (self.markID) {
        case 0:
        {
            self.title = @"通知";
//            self.navigationController.navigationBar.barTintColor=RGB(249, 249, 249);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editor)];
            myNTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            myNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [myNTableView registerClass:[AMNotificationTableViewCell class] forCellReuseIdentifier:@"notificationCell"];
            [self getData];
//            [self sideForPopupNewChooseForDatabase];
            //底部按钮背景View
            chooseView = [[UIView alloc]init];//WithFrame:CGRectMake(0, SCREEN_HEIGHT-60*SCALE-64, SCREEN_WIDTH, 60*SCALE)];
            chooseView.hidden = YES;
            chooseView.backgroundColor = COLOR_MAIN;
            [self.view addSubview:chooseView];
            chooseView.sd_layout.widthIs(SCREEN_WIDTH).heightIs(64*UISCALE).bottomSpaceToView(self.view, 0).leftSpaceToView(self.view, 0);
            NSArray *arr = @[@"全选",@"删除"];
            for (int i = 0 ; i < 2; i++) {
                UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                myCreateButton.titleLabel.font = FONT_OF_SIZE(18);
                myCreateButton.frame = CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, chooseView.frame.size.height);
                [myCreateButton setBackgroundColor:COLOR_MAIN ];
                myCreateButton.tag = allOrDelectTag+i;
                [myCreateButton setTitle:arr[i] forState:UIControlStateNormal];
                [myCreateButton addTarget:self action:@selector(allChoose:) forControlEvents:UIControlEventTouchUpInside];
                [chooseView addSubview:myCreateButton];
            }
            UIView *centerView = [[UIView alloc]init];
            centerView.frame = CGRectMake(SCREEN_WIDTH/2, 16, 1, chooseView.frame.size.height-32);
            centerView.backgroundColor = RGBACOLOR(233, 233, 233, 1);
            [chooseView addSubview:centerView];
        }
            break;
        case 1:
        {
            [myNTableView registerClass:[AMGatherTableViewCell class] forCellReuseIdentifier:@"gatherCell"];
        }
            break;
        case 2:
        {
            __weak typeof(self) weakself = self;
            
            [myNTableView registerClass:[AMTaskTableViewCell class] forCellReuseIdentifier:@"taskCell"];
            [weakself getData];
            
            myNTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself getData];
            }];
        }
            break;
        case 3:
        {
            __weak typeof(self) weakself = self;
            
            [myNTableView registerClass:[AMWorningTableViewCell class] forCellReuseIdentifier:@"warningCell"];
            [weakself getData];
            
            myNTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself getData];
            }];
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark---添加的删除数据库操作
//编辑状态
- (void)editor{
    isEditing = YES;
    chooseView.hidden = NO;
    myNTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-60*UISCALE);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全部已读" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];
    if ([AMDataBaseTool queryWithNoRead] >0) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clearForBack)];
    for (AMNotificationModel *model in self.dateArr) {
        model.isChoose = YES;
    }
    [myNTableView reloadData];
}
//取消编辑状态
- (void)clearForBack{
    isEditing = NO;
    myNTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    chooseView.hidden = YES;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIImageView *backIamge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_arrow_left"] highlightedImage:[UIImage imageNamed:@"ic_arrow_left"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [bgView addGestureRecognizer:tap];
    backIamge.frame = CGRectMake(-20, 0, 40, 44);
    [bgView addSubview:backIamge];
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.frame = CGRectMake(5+6, 10, 43, 24);
    contentLabel.text = @"工具";
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:contentLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bgView];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"<工具" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editor)];
    for (AMNotificationModel *model in self.dateArr) {
        model.isChoose = NO;
    }
    [myNTableView reloadData];
}
- (void)allChoose:(UIButton *)sender{
    switch (sender.tag-allOrDelectTag) {
        case 0:
        {
            if ([sender.titleLabel.text isEqualToString:@"全选"]) {
                [sender setTitle:@"取消全选" forState:UIControlStateNormal];
                //全选
                for (AMNotificationModel *model in self.dateArr) {
                    model.isSelect = YES;
                }
            }else if([sender.titleLabel.text isEqualToString:@"取消全选"]){
                [sender setTitle:@"全选" forState:UIControlStateNormal];
                //全选
                for (AMNotificationModel *model in self.dateArr) {
                    model.isSelect = NO;
                }
            }
            [myNTableView reloadData];
        }
            break;
        case 1:
        {
            [self alertViewShow];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertViewShow{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除所选通知？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionEnsure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除
        NSArray *arr = [NSArray arrayWithArray:self.dateArr];
        [SVProgressHUD showWithStatus:@"处理中..."];
        //创建串行队列
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (AMNotificationModel *model in arr) {
                if (model.isSelect) {
                    [AMDataBaseTool cleanDataForAleardyReadWithID:[model.ID intValue]];
                    [self.dateArr removeObject:model];
                }
            }
            [self performSelectorOnMainThread:@selector(chooseReload) withObject:nil waitUntilDone:YES];
        });
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:actionEnsure];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}
- (void)chooseReload{
    [myNTableView reloadData];
    [SVProgressHUD showImage:nil status:@"处理完成"];
}
//全部已读
- (void)clearAll{
    [AMDataBaseTool reMarkAllDataWithReaded];
    //    [self.dateArr removeAllObjects];
    //    self.dateArr = [AMDataBaseTool queryAllSqlite];
    for (AMNotificationModel *model in self.dateArr) {
        model.isChoose = YES;
        model.isRead = @"1";
    }
    [myNTableView reloadData];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    
}

#pragma mark------获取数据请求
- (void)getData{
    [noDataView removeFromSuperview];
    __weak typeof(self) weakself = self;
    switch (self.markID) {
        case 0:
        {
            self.dateArr = [AMDataBaseTool queryAllSqlite];
            if (!(self.dateArr.count>0)) {
                noDataView = [[XXNoDataView alloc]initWithFrame:myNTableView.frame];
                [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂时没有通知!"];
                [self.view addSubview:noDataView];
            }
            [myNTableView reloadData];
            [noNetView dismiss];
            
        }
            break;
        case 1:{
            self.refresh();
        }
            break;
        case 2:
        {
            //3已完成参数请求
            [XXToolHandle getTaskContentWithTaskType:@"3" WithBlock:^(NSDictionary *Dic,BOOL LossConnect) {
                if (!LossConnect) {
                    
                    [weakself.sectionArr removeAllObjects];
                    NSArray *titleArr = [Dic allKeys];
                    if (!(titleArr.count>0)) {
                        noDataView = [[XXNoDataView alloc]initWithFrame:myNTableView.frame];
                        [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂时没有任务！"];
                        [self.view addSubview:noDataView];
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
                    [myNTableView reloadData];
                    [noNetView dismiss];
                }
                
                [myNTableView.mj_header endRefreshing];
            }];
            
        }
            break;
        case 3:
        {
            [XXToolHandle getAlertTypeMeaasgeBlock:^(NSMutableArray *arr,BOOL LossConnect) {
                if (!LossConnect) {
                    if (!(arr.count>0)) {
                        noDataView = [[XXNoDataView alloc]initWithFrame:myNTableView.frame];
                        [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂时没有告警信息!"];
                        [self.view addSubview:noDataView];
                        
                    }
                    [weakself.dateArr removeAllObjects];
                    [weakself.dateArr addObjectsFromArray:arr];
                    [myNTableView reloadData];
                    [noNetView dismiss];
                }
                [myNTableView.mj_header endRefreshing];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)refreshWithDateArr:(NSMutableArray *)arr WithIsLossCnnect:(BOOL)LossConnect{
    if (!LossConnect) {
        
        [noDataView removeFromSuperview];
        if (!(arr.count>0)) {
            noDataView = [[XXNoDataView alloc]initWithFrame:myNTableView.frame];
            [noDataView reloadWithPicName:@"ic_empty" AndTitle:@"暂无销量汇总"];
            [self.view addSubview:noDataView];
        }
        
        [self.dateArr removeAllObjects];
        [self.dateArr addObjectsFromArray:arr];
        [myNTableView reloadData];
        [noNetView dismiss];
    }
}
- (void)contentViewFrameBounds:(CGRect )bounds{
    myNTableView.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}
- (void)returnModelForTask:(ReturnTaskTurnBlock)taskBlock{
    self.returnTaskBlock = taskBlock;
}
- (void)returnWorningTypeForTask:(WorningTypeReturnBlock)worningTypeBlock{
    self.typeBlock = worningTypeBlock;
}
- (void)returnForRefreash:(RefreshForSaleDetail)block{
    self.refresh = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [noDataView removeFromSuperview];
    [noNetView dismiss];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
    if (self.markID == 1) {
        return 60*UISCALE;
    }else if (self.markID == 2||self.markID == 0||self.markID == 3){
        return 76*UISCALE;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.markID == 1) {
        AMGatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gatherCell"];
        if (!cell) {
            cell = [[AMGatherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gatherCell"];
        }
        AMGatherModel *model = self.dateArr[indexPath.row];
        cell.selectIndex = 1;
        cell.model = model;
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
        AMWorningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"warningCell"];
        if (!cell) {
            cell = [[AMWorningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"warningCell"];
        }
        AMWorTypeModel *model = self.dateArr[indexPath.row];
        cell.markID = 1;
        cell.typeModel = model;
        return cell;
    }else if (self.markID == 0){
        AMNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
        if (!cell) {
            cell = [[AMNotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
        }
        AMNotificationModel *model = self.dateArr[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.markID == 2){
        AMTaskModel *model = self.dateArr[indexPath.section][indexPath.row];
        if (self.returnTaskBlock) {
            self.returnTaskBlock(model);
        }
    }else if (self.markID == 3){
        AMWorTypeModel *model = self.dateArr[indexPath.row];
        if (self.typeBlock) {
            self.typeBlock(model.typeId);
        }
    }else if (self.markID == 0){
        AMNotificationModel *model = self.dateArr[indexPath.row];
        if (isEditing) {
            model.isSelect = !model.isSelect;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            BOOL isAll = YES;
            for (AMNotificationModel *model in self.dateArr) {
                if (!model.isSelect) {
                    isAll = NO;
                }
            }
            UIButton *chooseBtn = [self.view viewWithTag:allOrDelectTag+0];
            if (isAll) {
                [chooseBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else{
                [chooseBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
        }else{
            [AMDataBaseTool updateToAleradyReadWithID:[model.ID intValue]];
            model.isRead = @"1";
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            XXNotiDetailViewController *detailVC = [[XXNotiDetailViewController alloc]init];
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
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
    [myNTableView reloadData];
    
}

@end
