//
//  XXQueHuoView.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "AlarmInfoModel.h"
@interface XXQueHuoView : UIView
@property (nonatomic, copy) NSString *titleText;//机器编号

@property (nonatomic, copy) NSString *detailText;//机器点位位置
@property (nonatomic, strong) UIView *lineView;//分割线




// 故障（名称、标志、时间 )
@property (nonatomic, strong) UILabel *guzhangLabel;

@property (nonatomic, strong) UILabel *guzhangLevelLabel;

@property (nonatomic, strong) UILabel *guzhangLabelNum;

// 补货
@property (nonatomic, strong) UILabel *buhuoLabel;

@property (nonatomic, strong) UILabel *buhuoLabelNum;

@property (nonatomic, strong) UILabel *buhuoLevelLabel;
// 缺币
@property (nonatomic, strong) UILabel *quebiLabel;

@property (nonatomic, strong) UILabel *quebiLabelNum;
@property (nonatomic, strong) UILabel *quebiLevelLabel;

// 断网

@property (nonatomic, strong) UILabel *duanwangLabel;

@property (nonatomic, strong) UILabel *duanwangLevelLabel;

@property (nonatomic, strong) UILabel *duanwangLabelNum;





//
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *levelLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) NSString *alarmLevel;

@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;


@property (nonatomic, strong)AlarmInfoModel *aIModel;
@end
