//
//  XXBillViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBillViewController.h"
#import "YLCyclicChart.h"
typedef enum :NSInteger{
    labelTags = 10,
}tags;

@interface XXBillViewController ()
{
    UIView *progressView;
    UIView *trackView;
    int year;
    int month;
    UIButton *chooBtn;
    NSString *dateStr;
    NSNumber *totalLabeNum;
    NSNumber  *onlineLabelNum;
    NSNumber *offLineLabelNum;


}
@property(nonatomic,strong)UIView *totalView;
@end

@implementation XXBillViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"月账单";

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self setupUI];
    [self getData];

}
- (void)setupUI{
    //背景View
    UIScrollView *bgScroll = [[UIScrollView alloc]init];
    bgScroll.frame = self.view.frame;
    bgScroll.backgroundColor = RGBACOLOR(238, 238, 238, 1);
    [self.view addSubview:bgScroll];
    
    //日期选择
    UIView *chooseMonthView = [[UIView alloc]init];
    chooseMonthView.backgroundColor = [UIColor whiteColor];
    chooseMonthView.frame = CGRectMake(0, 5, SCREEN_WIDTH, 40);
    [bgScroll addSubview:chooseMonthView];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.center = CGPointMake(chooseMonthView.frame.size.width/2, chooseMonthView.frame.size.height/2);
    timeLabel.bounds = CGRectMake(0, 0, 180, 40);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = BLUE;;

    dateStr = [self getDataTimeNow];
    NSArray *timeArr = [dateStr componentsSeparatedByString:@"-"];
    year = [[timeArr firstObject] intValue];
    month = [[timeArr lastObject] intValue];
    timeLabel.tag = labelTags+0;
    timeLabel.text = [NSString stringWithFormat:@"%d年%2d月账单(元)",year,month];
    
    timeLabel.font = FONT_OF_SIZE(15);
//    timeLabel.textColor = [UIColor whiteColor];
    [chooseMonthView addSubview:timeLabel];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(CGRectGetMinX(timeLabel.frame)-55, 0, 50, chooseMonthView.frame.size.height);
    [chooseBtn setImage:[UIImage imageNamed:@"left_icon"] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(minusChoose) forControlEvents:UIControlEventTouchUpInside];
    [chooseMonthView addSubview:chooseBtn];
    chooBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooBtn.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame)+5, 0, 50, chooseMonthView.frame.size.height);
    [chooBtn setImage:[UIImage imageNamed:@"left_icon"] forState:UIControlStateNormal];
    chooBtn.transform = CGAffineTransformMakeRotation(M_PI);
    chooBtn.hidden = YES;
    [chooBtn addTarget:self action:@selector(maxChoose) forControlEvents:UIControlEventTouchUpInside];
    [chooseMonthView addSubview:chooBtn];
    
    
    UIView *totalView = [[UIView alloc]init];
    totalView.backgroundColor = [UIColor whiteColor];
    totalView.frame = CGRectMake(0, CGRectGetMaxY(chooseMonthView.frame)+5, SCREEN_WIDTH, 280*UISCALE);
    [bgScroll addSubview:totalView];
    self.totalView=totalView;
    ;
      // 设置圆状图
    NSArray* colors = @[[UIColor grayColor],[UIColor grayColor]];
    YLCyclicChart* cyclicChart = [[YLCyclicChart alloc] initWithFrame:CGRectMake(85*UISCALE,  20, 200*UISCALE, 200*UISCALE) dataValue:@[@1,@0] colors:colors duration:1.0 startAngle:-90 radius:80*UISCALE lineWidth:10*UISCALE cyclicChartType:YLCyclicChartType_sequence];
    [self.totalView addSubview:cyclicChart];
   
//    销售总额数字
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.frame = CGRectMake(0, 0,100, 40);
//    contentLabel.backgroundColor=[UIColor orangeColor];
    contentLabel.center=cyclicChart.center;
    contentLabel.text = @"0";
    contentLabel.textAlignment=NSTextAlignmentCenter ;
    contentLabel.tag = labelTags+1;
    contentLabel.textAlignment = 1;
    contentLabel.font = FONT_OF_SIZE(25);
    contentLabel.textColor = [UIColor redColor];
    [totalView addSubview:contentLabel];

   UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(contentLabel.frame), CGRectGetMaxY(contentLabel.frame)-10*UISCALE, 100, 50)];
    nameLabel.text = @"销售总额";
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font = FONT_OF_SIZE(15);
    [totalView addSubview:nameLabel];
    NSArray *titleArr = @[@"在线销售额",@"现金销售额"];
    for (int i = 0; i<2; i++) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(20+150*i+50*UISCALE, CGRectGetMaxY(cyclicChart.frame)+30*UISCALE, 20, 20)];
        titleView.backgroundColor = i<1? [UIColor greenColor]:BLUE;
        [totalView addSubview:titleView];
        titleView.layer.cornerRadius=6;
        UILabel *showLabel = [[UILabel alloc]init];
        showLabel.frame = CGRectMake(50+150*i+50*UISCALE, CGRectGetMaxY(cyclicChart.frame)+30*UISCALE, 80, 20);
        showLabel.font = FONT_OF_SIZE(14);
        showLabel.textColor = RGBACOLOR(102, 102, 102, 1);
        showLabel.text = titleArr[i];
        [totalView addSubview:showLabel];
    }
    

    /*********/
    for (int i = 0; i<2; i++) {
        UIView *contentView = [[UIView alloc]init];
        contentView.frame = CGRectMake(SCREEN_WIDTH/2*i, CGRectGetMaxY(totalView.frame)+10, SCREEN_WIDTH/2-3, 120);
        contentView.backgroundColor = [UIColor whiteColor];
        [bgScroll addSubview:contentView];
    
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(20, 5, 150, 40);
        label.font = FONT_OF_SIZE(12);
        label.textColor = COLOR_GRAY;
        label.text = titleArr[i];
        label.textAlignment=NSTextAlignmentCenter;
        [contentView addSubview:label];
        //显示数字lab
        UILabel *Label = [[UILabel alloc]init];
        Label.frame = CGRectMake(20, 30, SCREEN_WIDTH/2-30, 80);
        Label.textColor = i<1? [UIColor greenColor]:BLUE;
        Label.textAlignment=NSTextAlignmentCenter;
        Label.font = FONT_OF_SIZE(40);
        Label.textAlignment = 1;
        Label.tag = labelTags+2+i;
        Label.text = @"0";
        [contentView addSubview:Label];
        
         }
    
    UILabel *textView = [[UILabel alloc]init];
    textView.frame = CGRectMake(20, CGRectGetMaxY(totalView.frame)+10+130*UISCALE,SCREEN_WIDTH-40, 100);
    textView.font = FONT_OF_SIZE(13);
    textView.backgroundColor = [UIColor clearColor];
    textView.numberOfLines = 0;
    textView.textColor = COLOR_GRAY;
    textView.text = @"友情提示\n由于售货机网络延迟，少量上月末销售记录可能会在本月初才上传至服务器，因此每月账单中的收益可能会与实际收益略有不同，但总量并无差异。";
    [bgScroll addSubview:textView];
    
    bgScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(textView.frame)+64+40);
    
}



- (void)minusChoose{
    chooBtn.hidden = NO;
    if (month == 1) {
        year = year-1;
        month = 12;
    }else{
        month = month-1;
    }
    UILabel *titleLabel = [self.view viewWithTag: labelTags+0];
    titleLabel.text = [NSString stringWithFormat:@"%d年%2d月账单(元)",year,month];
    
    [self getData];
}
- (void)maxChoose{
    
    if (month ==12) {
        year++;
        month = 1;
    }else{
        month++;
    }
    UILabel *titleLabel = [self.view viewWithTag: labelTags+0];
    titleLabel.text = [NSString stringWithFormat:@"%d年%2d月账单(元)",year,month];
    NSString *showStr = [NSString stringWithFormat:@"%d-%02d",year,month];
    if ([showStr isEqualToString:dateStr]) {
        chooBtn.hidden = YES;
    }
    
    [self getData];
}

- (void)getData{
    [SVProgressHUD showWithStatus:@"加载中..."];
    UILabel *totalLabel = [self.view  viewWithTag:labelTags+1];
    UILabel *onlineLabel = [self.view viewWithTag:labelTags+2];
    UILabel *offLineLabel = [self.view viewWithTag:labelTags+3];
    
    [XXToolHandle getMonthDetailMessageWithTime:[NSString stringWithFormat:@"%d-%02d",year,month] WithBlock:^(NSString *totalMoney,NSString *money,NSString *onli,BOOL LossConnect) {
        if (!LossConnect) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                float total = [totalMoney floatValue];
                float offLine = [money floatValue];
                float online = [onli floatValue];
                
                totalLabel.text = totalMoney;
                offLineLabel.text = money;
                onlineLabel.text = onli;
             NSLog(@"总额=%@现金销售额=%@在线销售额=%@",totalLabel.text,offLineLabel.text,onlineLabel.text);
                if (offLine == 0&&online == 0) {
                    // 设置圆状图
                    NSArray* colors = @[[UIColor grayColor],[UIColor grayColor]];
                    YLCyclicChart* cyclicChart = [[YLCyclicChart alloc] initWithFrame:CGRectMake(85*UISCALE,  20, 200*UISCALE, 200*UISCALE) dataValue:@[@1,@0] colors:colors duration:1.0 startAngle:-90 radius:80*UISCALE lineWidth:10*UISCALE cyclicChartType:YLCyclicChartType_sequence];
                    [self.totalView addSubview:cyclicChart];

                }else{
                    onlineLabelNum=[NSNumber numberWithFloat:[onlineLabel.text floatValue]/[totalLabel.text floatValue] ];
                      NSLog(@"onlineLabelNum=%@",onlineLabelNum);
            
                    offLineLabelNum=[NSNumber numberWithFloat:[offLineLabel.text floatValue]/[totalLabel.text floatValue]];
                    NSLog(@"offLineLabelNum=%@",offLineLabelNum);
                    // 设置圆状图
                    NSArray* dataValue = @[offLineLabelNum,onlineLabelNum];
                    NSArray* colors = @[BLUE,[UIColor greenColor]];
                    YLCyclicChart* cyclicChart = [[YLCyclicChart alloc] initWithFrame:CGRectMake(85*UISCALE,  20, 200*UISCALE, 200*UISCALE) dataValue:dataValue colors:colors duration:1.0 startAngle:-90 radius:80*UISCALE lineWidth:10*UISCALE cyclicChartType:YLCyclicChartType_sequence];
                    
                    [self.totalView addSubview:cyclicChart];
                    
                    


                }
                
                
                
            });
        }
        //延迟
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
         [SVProgressHUD dismissWithDelay:0.25];
            }];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD  dismiss];
}

- (NSString *)getDataTimeNow{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}
/**************************************/
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
