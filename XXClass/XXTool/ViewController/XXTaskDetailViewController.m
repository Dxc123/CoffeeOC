//
//  XXTaskDetailViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/18.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXTaskDetailViewController.h"
#import "AMWornDetailModel.h"
#import "XXNoNetView.h"

typedef enum :NSInteger{
    labelTags = 10,
    adressLabelTags = 20,
}tags;


@interface XXTaskDetailViewController ()
{
UIView *bgView;

XXNoNetView *netView;
}
@property(nonatomic,strong) UILabel *machineLabel;
@property(nonatomic,strong) UILabel *adressLabel;


@end

@implementation XXTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self createView];
}
- (void)createView{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100*UISCALE)];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [RGBACOLOR(236, 236, 236, 1) CGColor];
    [self.view addSubview:bgView];
    //机器编号
    UILabel *machineLabel = [[UILabel alloc]init];
    //#warning 这里机器编号测试使用12位数字，防止后期机器型号修改
    machineLabel.frame = CGRectMake(10*UISCALE, 30*UISCALE, 140*UISCALE, 30*UISCALE);
    machineLabel.tag = labelTags+0;
    machineLabel.font = FONT_OF_SIZE(17);
    [bgView addSubview:machineLabel];
    self.machineLabel=machineLabel;
    //机器地址
    UILabel *adressLabel = [[UILabel alloc]init];
    adressLabel.frame = CGRectMake(16*UISCALE, CGRectGetMaxY(machineLabel.frame), SCREEN_WIDTH, 30*UISCALE);
    adressLabel.tag = labelTags+2;
    adressLabel.font = FONT_OF_SIZE(14);
    adressLabel.textColor = RGBACOLOR(117, 117, 117, 1);
    [bgView addSubview:adressLabel];
    self.adressLabel=adressLabel;
    
    switch (self.markID) {
        case 0:
        {
            self.navigationItem.title = @"任务详情";
            [self taskDetail];
        }
            break;
        case 1:
        {
            self.navigationItem.title = @"告警详情";
            [self worningDetail];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

- (void)worningDetail{
    
    [self loadData];
    
    __weak typeof(self) weakself = self;
    netView = [[XXNoNetView alloc]initWithFrame:self.view.frame];
    [netView refreshForNewMessage:^{
        [weakself loadData];
    }];
    [self.view addSubview:netView];
    
}
- (void)loadData{
    UILabel *machineLabel = [self.view viewWithTag:labelTags+0];
    UILabel *adressLabel = [self.view viewWithTag:labelTags+2];
    
    [XXToolHandle getDetailMessageWithMachineID:self.machineID WithBlock:^(NSMutableArray *arr,NSString *machineID,NSString *adressStr,NSMutableArray *errorMarkArr,BOOL LossConnect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [netView dismiss];
            machineLabel.text = machineID;
            CGSize size = [machineLabel sizeThatFits:CGSizeMake(0, 20)];
            machineLabel.frame = CGRectMake(16, bgView.frame.size.height/2-20, size.width, 20);
            adressLabel.text = adressStr;
            
            for (int i = 0; i<errorMarkArr.count; i++) {
                UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(machineLabel.frame)+40*i+12,30*UISCALE, 35*UISCALE, 20)];
                errorLabel.font = FONT_OF_SIZE(13);
                errorLabel.textAlignment = NSTextAlignmentCenter;
//                errorLabel.layer.borderWidth = 0.5;
                errorLabel.layer.cornerRadius = 6;
                errorLabel.layer.masksToBounds = YES;
                errorLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:errorLabel];
                NSString *contentStr = errorMarkArr[i];
                if ([contentStr isEqualToString:@"isQuehuo"]) {
                    errorLabel.text = @"缺货";
                    errorLabel.textColor = [UIColor whiteColor];//RGBACOLOR(68, 232, 198, 1);
                    errorLabel.backgroundColor=BLUE;
                    //errorLabel.layer.borderColor = [RGBACOLOR(68, 232, 198, 1) CGColor];
                }else if ([contentStr isEqualToString:@"isQuebi"]){
                    errorLabel.text = @"缺币";
                    errorLabel.textColor = [UIColor whiteColor];//RGBACOLOR(245, 166, 35, 1);
                    errorLabel.backgroundColor=RGB(240, 193, 46);
                    //errorLabel.layer.borderColor = [RGBACOLOR(245, 166, 35, 1) CGColor];
                }else if ([contentStr isEqualToString:@"isDuanwang"]){
                    errorLabel.text = @"断网";
                    errorLabel.textColor = [UIColor whiteColor];//RGBACOLOR(255, 117, 75, 1);
                    errorLabel.backgroundColor=RGB(95, 223, 236);
//                    errorLabel.layer.borderColor = [RGBACOLOR(255, 117, 75, 1) CGColor];
                }else if ([contentStr isEqualToString:@"isGuzhang"]){
                    errorLabel.text = @"故障";
                    errorLabel.textColor = [UIColor whiteColor];;//RGBACOLOR(255, 107, 121, 1);
                    errorLabel.backgroundColor=[UIColor redColor];
//                    errorLabel.layer.borderColor = [RGBACOLOR(255, 107, 121, 1) CGColor];
                    
                }
                
                
                //下半部分
                UIView *bView = [[UIView alloc]init];
                //                bView.layer.borderWidth = 0.5;
                //                bView.layer.borderColor = [RGBACOLOR(236, 236, 236, 1) CGColor];
                bView.frame = CGRectMake(0, 100*UISCALE, SCREEN_WIDTH, 24+28*arr.count);
                [self.view addSubview:bView];
                for (int i = 0; i<arr.count; i++) {
                    AMWornDetailModel *model = arr[i];
                    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(self.adressLabel.frame)+30*UISCALE*i, (SCREEN_WIDTH-32)/3, 20)];
                    nameLabel.font = FONT_OF_SIZE(14);
                    nameLabel.textColor = RGBACOLOR(51, 51, 51, 1);
                    NSString *name = [[NSString alloc]init];
                    if ([model.alarmType isEqualToString:@"00"]) {
                        name = @"缺货";
                    }else if ([model.alarmType isEqualToString:@"01"]){
                        name = @"5角缺币";
                    }else if ([model.alarmType isEqualToString:@"02"]){
                        name = @"1元缺币";
                    }else if ([model.alarmType isEqualToString:@"03"]){
                        name = @"断网";
                    }else if ([model.alarmType isEqualToString:@"04"]){
                        name = @"故障";
                    }else if ([model.alarmType isEqualToString:@"05"]){
                        name = @"纸币器故障";
                    }else if ([model.alarmType isEqualToString:@"06"]){
                        name = @"硬币器故障";
                    }
                    nameLabel.text = name;
                    [bView addSubview:nameLabel];
                    
                    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+(SCREEN_WIDTH-32)/3, CGRectGetMaxY(self.adressLabel.frame)+30*UISCALE*i, (SCREEN_WIDTH-32)/3, 20)];
                    typeLabel.textAlignment = NSTextAlignmentCenter;
                    typeLabel.font = FONT_OF_SIZE(14);
                    NSString *type;
                    UIColor *color;
                    if ([model.alarmLevel isEqualToString:@"0"]) {
                        type = @"普通";
                        color = RGBACOLOR(51, 51, 51, 1);
                    }else if ([model.alarmLevel isEqualToString:@"1"]){
                        type = @"重要";
                        color = RGBACOLOR(245, 166, 35, 1);
                    }else if ([model.alarmLevel isEqualToString:@"2"]){
                        type = @"严重";
                        color = RGBACOLOR(255, 107, 121, 1);
                    }
                    typeLabel.text = type;
                    typeLabel.textColor = color;
                    [bView addSubview:typeLabel];
                    //时间
                    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+(SCREEN_WIDTH-32)/3*2, CGRectGetMaxY(self.adressLabel.frame)+30*UISCALE*i, (SCREEN_WIDTH-32)/3, 20)];
                    timeLabel.font = FONT_OF_SIZE(14);
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    timeLabel.textColor = RGBACOLOR(51, 51, 51, 1);
                    timeLabel.text = [NSString stringWithFormat:@"%@小时",model.distanceHour];
                    [bView addSubview:timeLabel];
                }
                
            }
        });
    }];
}


- (void)taskDetail{
    
    
    UILabel *machineTypeLabel = [[UILabel alloc]init];
    machineTypeLabel.frame = CGRectMake(155, bgView.frame.size.height/2-20, 34,20);
    machineTypeLabel.tag = labelTags+1;
    machineTypeLabel.textAlignment = NSTextAlignmentCenter;
    machineTypeLabel.layer.borderWidth = 0.5;
    machineTypeLabel.font = FONT_OF_SIZE(13);
    machineTypeLabel.layer.cornerRadius = 2;
    [bgView addSubview:machineTypeLabel];
    
    if (self.isArchive) {
        NSArray *arr = @[@"原线路点位",@"新线路点位"];
        for (int i = 0; i<2; i++) {
            UIView *contentView = [[UIView alloc]init];
            contentView.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame)+76*UISCALE*i, SCREEN_WIDTH, 76*UISCALE);
            contentView.layer.borderWidth = 0.5;
            contentView.layer.borderColor = [RGBACOLOR(236, 236, 236, 1) CGColor];
            [self.view addSubview:contentView];
            UILabel *titlelabel = [[UILabel alloc]init];
            titlelabel.center = CGPointMake(66, contentView.frame.size.height/2);
            titlelabel.bounds = CGRectMake(0, 0, 100, 40);
            titlelabel.text = arr[i];
            titlelabel.font = FONT_OF_SIZE(14);
            titlelabel.textColor = RGBACOLOR(117, 117, 117, 1);
            [contentView addSubview:titlelabel];
            
            UILabel *detailLabel = [[UILabel alloc]init];
            detailLabel.frame = CGRectMake(SCREEN_WIDTH-150, 0, 140, contentView.frame.size.height);
            detailLabel.numberOfLines = 2;
            detailLabel.font = FONT_OF_SIZE(14);
            detailLabel.textAlignment = NSTextAlignmentRight;
            detailLabel.tag = adressLabelTags+i;
            [contentView addSubview:detailLabel];
        }
    }
}
- (void)setModel:(AMTaskModel *)model{
    if (_model!=model) {
        _model = model;
    }
    [self getData];
}
- (void)getData{
    
    UILabel *machineLabel = [self.view viewWithTag:labelTags+0];
    machineLabel.text = _model.machineTypoe;
    CGSize size = [machineLabel sizeThatFits:CGSizeMake(0, 20)];
    machineLabel.frame = CGRectMake(16, bgView.frame.size.height/2-20, size.width,20);
    UILabel *machineTypeLabel = [self.view viewWithTag:labelTags+1];
    machineTypeLabel.frame = CGRectMake(CGRectGetMaxX(machineLabel.frame)+12, bgView.frame.size.height/2-20, 34,20);
    if ([_model.applyType isEqualToString:@"0"]) {
        machineTypeLabel.text = @"撤机";
        machineTypeLabel.textColor = RGBACOLOR(68, 138, 255, 1);
        machineTypeLabel.layer.borderColor = [RGBACOLOR(68, 138, 255, 1) CGColor];
    }else if ([_model.applyType isEqualToString:@"1"]){
        machineTypeLabel.text = @"换线";
        machineTypeLabel.textColor = RGBACOLOR(144, 19, 254, 1);
        machineTypeLabel.layer.borderColor = [RGBACOLOR(144, 19, 254, 1) CGColor];
    }
    UILabel *adressLabel = [self.view viewWithTag:labelTags+2];
    adressLabel.text = _model.adressStr;
    
    if (self.isArchive) {
        UILabel *oldAdressLabel = [self.view viewWithTag:adressLabelTags + 0];
        oldAdressLabel.text = [NSString stringWithFormat:@"%@\n%@",_model.oldadressLine,_model.oldadressPoint];
        
        UILabel *newAdressLabel = [self.view viewWithTag:adressLabelTags + 1];
        newAdressLabel.text = [NSString stringWithFormat:@"%@\n%@",_model.newadressLine,_model.newadressPoint];
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
