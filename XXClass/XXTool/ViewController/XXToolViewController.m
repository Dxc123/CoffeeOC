//
//  XXToolViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXToolViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "XXTaskViewController.h"
#import "XXNotificationViewController.h"
#import "XXHistoryViewController.h"
#import "XXExchangeViewController.h"
#import "XXBillViewController.h"
#import "AMDataBaseTool.h"
#import "XXWarningViewController.h"
#import "XXBadge.h"
#import <PPBadgeView.h>
#import <SDAutoLayout.h>

typedef enum :NSInteger{
    buttonChooseTags = 10,
    showNumberTags = 20,
}tags;

@interface XXToolViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _presentedRow;
}
@property(nonatomic,strong) UIButton *btn;

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation XXToolViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRedCount];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
//    [self setupTableView];
}

-(void)setUI{
       UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 64*UISCALE, SCREEN_WIDTH, 260*UISCALE)];
//    [backView setBackgroundColor:RGB(249, 249, 249)];
    [self.view addSubview:backView];
    NSArray *titles = @[@"通知",@"任务", @"警告",@"历史备货单", @"月账单", @"撤机换线"];
    NSArray *images=@[@"tools_notice",@"tools_task",@"tools_alert",@"tools_history",@"tools_bille",@"tools_exchange"];
    
//九宫格
    for (int i =0; i<6; i++) {
        CGFloat btnW=80*UISCALE;
        CGFloat btnH=60*UISCALE;
        CGFloat btnStarX=25*UISCALE;//边界XX距离
        CGFloat btnStarY=40*UISCALE;//边界Y距离
        int totalCol=3;//列数
        int totalRow=2;//行数
        int row=i/totalCol;//行号
        int col=i%totalCol;//列号
        //列间隙
        CGFloat Xmagrin=(backView.frame.size.width-totalCol*btnW-2*btnStarX)/(totalCol-1
                                                                               );
        //行间隙
        CGFloat Ymagrin=(backView.frame.size.height-totalRow*btnH-2*btnStarY)/(totalRow-1
                                                                                );
        //坐标X  Y
        CGFloat x=btnStarX+col*(btnW+Xmagrin);
        
        CGFloat y=btnStarY+row*(btnH+Ymagrin);
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom
                        ];
        btn.frame=CGRectMake(x, y, btnW, btnH);
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font=FONT_OF_SIZE(12);;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag=2017 + i;
        [btn addTarget:self action:@selector(sixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        // image在上，title在下
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:30*UISCALE];
        [backView addSubview:btn];
        //设置3个显示小红点的lab
        if (i<3) {
            UILabel *numberLabel = [[UILabel alloc]init];
//            numberLabel.frame = CGRectMake(CGRectGetMaxX(btn.frame)-36*UISCALE, CGRectGetMinY(btn.frame)-50*UISCALE, 20, 20);
//            numberLabel.backgroundColor=[UIColor blackColor];
            numberLabel.clipsToBounds = YES;
            numberLabel.layer.cornerRadius = 7;
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.font = FONT_OF_SIZE(13);
            numberLabel.textAlignment = 1;
            numberLabel.tag = showNumberTags+i;
            [btn addSubview:numberLabel];
     numberLabel.sd_layout.widthIs(25).heightIs(25).rightSpaceToView(btn, -10*UISCALE).topSpaceToView(btn, -15*UISCALE);
    
        }
       if (i == 5) {
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
           [btn setTitle:@"" forState:UIControlStateNormal];
           
       }
        
        
        
//        设置xy轴边框线
        for (int i = 0; i<2; i++) {
            
            //y轴
            UIView *YView = [[UIView alloc]init];
            YView.frame = CGRectMake(SCREEN_WIDTH/3*(i+1), 0, 1, SCREEN_WIDTH/3*2+60*UISCALE);
            YView.backgroundColor = RGBACOLOR(236, 236, 236, 1);
            [self.view addSubview:YView];
            
          //x轴
            UIView *XView = [[UIView alloc]init];
            XView.frame = CGRectMake(0, SCREEN_WIDTH/3*(i+1)+65*UISCALE, SCREEN_WIDTH, 1);
            XView.backgroundColor = RGBACOLOR(236, 236, 236, 1);
            [self.view addSubview:XView];

        }
        
        
        
    }

}

//获取最新的统计信息修改红色标记显示信息
-(void)setupRedCount{
    
//  对应接口 http://app-yy-api.zjxfyb.com/api/system/manager/3/messageinfolist/0/1000
    
    
//     UILabel *worningLabel = [self.view viewWithTag:showNumberTags+2];
//    [XXToolHandle getRedCountwithBlock:^(NSInteger *taskCount, NSInteger *messageListCount, NSInteger*alarmCount) {
//        
//        NSLog(@"taskCount=%ld\nmessageListCount=%ld\nalarmCount=%ld",(long)alarmCount,(long)messageListCount,(long)alarmCount);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (alarmCount>0) {
//                        worningLabel.backgroundColor = [UIColor redColor];
//                        worningLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)alarmCount];
//                        CGSize size = [worningLabel sizeThatFits:CGSizeMake(0, 20)];
//                        worningLabel.bounds = CGRectMake(0, 0, size.width>20?size.width:20, size.height);
//                    }else{
//                        worningLabel.backgroundColor = [UIColor clearColor];
//                        worningLabel.text = nil;
//                    }
//                    
//                });
//        
//        
//    }];
//    
   
    
    

    //获取任务 小红点数
    UILabel *taskLabel = [self.view viewWithTag:showNumberTags + 1];
    

    [XXToolHandle getTaWithTaskType:@"1" WithBlock:^(NSDictionary *Dic,BOOL LossConnect) {
        NSArray *arr = [Dic allValues];
        NSInteger a = 0;
        if (arr.count>0) {
            for (NSMutableArray *dataArr in arr) {
                a = a+dataArr.count;
            
            }
//            self.navigationController.tabBarItem.badgeValue = @"";//系统显示小红点
            dispatch_async(dispatch_get_main_queue(), ^{
                taskLabel.backgroundColor = [UIColor redColor];
                taskLabel.text = [NSString stringWithFormat:@"%ld",(long)a];
                CGSize size = [taskLabel sizeThatFits:CGSizeMake(0, 20)];
                taskLabel.bounds = CGRectMake(0, 0, size.width>20?size.width:20, size.height);
              
                

            });
        }else{
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.text = nil;
        }
    }];
    

    
    //获取通知 小红点数
    UILabel *notificenumberLabel = [self.view viewWithTag:showNumberTags + 0];
    int a = [AMDataBaseTool queryWithNoRead];
    NSLog(@"通知小红点数=%d",a);
    if (a == 0) {
        notificenumberLabel.backgroundColor = [UIColor clearColor];
        notificenumberLabel.text = nil;
//        [self.navigationController.tabBarItem  hidenBadge];
        [self.navigationController.tabBarItem  pp_hiddenBadge];
        [self.navigationItem.rightBarButtonItem  pp_hiddenBadge];

    }else{
        notificenumberLabel.backgroundColor = [UIColor redColor];
        notificenumberLabel.text = [NSString stringWithFormat:@"%d",a];
        CGSize size = [notificenumberLabel sizeThatFits:CGSizeMake(0, 20)];
        notificenumberLabel.bounds = CGRectMake(0, 0, size.width>20?size.width:20, size.height);
        
//        [self.navigationController.tabBarItem  showBadge];//有通知时，"工具"显示红点
        [self.navigationController.tabBarItem pp_addDotWithColor:nil];
        [self.navigationItem.rightBarButtonItem pp_addDotWithColor:nil];


    }
        //获取警告 小红点数
    UILabel *worningLabel = [self.view viewWithTag:showNumberTags+2];
    [XXToolHandle getWorningNumberWithBlock:^(NSInteger number,BOOL LossConnect) {
        NSLog(@"警告小红点数=%ld",(long)number);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (number>0) {
                worningLabel.backgroundColor = [UIColor redColor];
                worningLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)number];
                CGSize size = [worningLabel sizeThatFits:CGSizeMake(0, 20)];
                worningLabel.bounds = CGRectMake(0, 0, size.width>20?size.width:20, size.height);
                
             
              
            }else{
                worningLabel.backgroundColor = [UIColor clearColor];
                worningLabel.text = nil;
            }
            
        });
    }];

    
}


#pragma mark -->Btn Action
-(void)leftClick:(UIButton *)btn{
    
    
    [self.navigationController pushViewController:[XXHistoryViewController new] animated:YES];
    
}


-(void)rightClick:(UIButton *)btn{
    
   
    [self.navigationController pushViewController:[XXNotificationViewController new] animated:YES];
    
}


-(void)sixBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 2017:
        {
        
            [self.navigationController pushViewController:[XXNotificationViewController new] animated:YES];
           
            
        }
            break;
        case 2017+1:
        {
            
            [self.navigationController pushViewController:[XXTaskViewController new] animated:YES];
            
        }
            break;
        case 2017+2:
        {
            
            [self.navigationController pushViewController:[XXWarningViewController new] animated:YES];
            
        }
            break;
        case 2017+3:
        {
            
            [self.navigationController pushViewController:[XXHistoryViewController new] animated:YES];
            
            
        }
            break;
        case 2017+4:
        {
           
            [self.navigationController pushViewController:[XXBillViewController new] animated:YES];

            
            
        }
            break;
        case 2017+5:
        {
            [self.navigationController pushViewController:[XXExchangeViewController new] animated:YES];

        }
            break;
                default:
            break;
    }
    
}

-(void)setupTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView=[[UIView alloc] init];
    
}
#pragma mark --> UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *imageArry1 = @[@"tools_task",@"tools_notice",@"tools_alert"];
    NSArray *imageArry2 = @[@"tools_history",@"tools_bille"];//,@"tools_exchange"];
    NSArray *titleArry1 = @[@"任务",@"通知",@"警告"];
    NSArray *titleArry2 = @[@"历史备货单",@"月账单"];//,@"撤机换线"];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:imageArry1[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",titleArry1[indexPath.row]];
        return cell;
    }else{
        cell.imageView.image = [UIImage imageNamed:imageArry2[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",titleArry2[indexPath.row]];
    }
    
    
    
     //cell.textLabel.text = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65*UISCALE;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return @"通知信息";
    }
    return @"其他信息";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        NSLog(@"%ld%ld",(long)indexPath.section,(long)indexPath.row);
     NSInteger row = indexPath.row;
    if ( indexPath.section == 0) {
        if ( row == 0)
        {
            [self.navigationController pushViewController:[XXNotificationViewController new] animated:YES];
            
            return;
        }
        else if (row == 1)
        {
            
            [self.navigationController pushViewController:[XXTaskViewController new] animated:YES];
            return;
        }
        else if (row == 2)
        {
            [self.navigationController pushViewController:[XXWarningViewController new] animated:YES];
            
            return;
        }
        
    }else  if ( indexPath.section == 1){
        
        if ( row == 0)
        {
            [self.navigationController pushViewController:[XXHistoryViewController new] animated:YES];
            
            
            return;
        }
        else if (row == 1)
        {
            
            [self.navigationController pushViewController:[XXBillViewController new] animated:YES];

            return;
        }
        else if (row == 2)
        {
            [self.navigationController pushViewController:[XXExchangeViewController new] animated:YES];
            return;
            
            
        }
    
    }
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
