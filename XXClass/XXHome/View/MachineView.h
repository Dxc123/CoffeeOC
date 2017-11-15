//
//  MachineView.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface MachineView : UIView

@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, copy) NSString *detailText;

@property (nonatomic, copy) NSString *wenduText;//温度

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;

@property (nonatomic, assign) BOOL IsCoffeeMachine;
// 故障
@property (nonatomic, strong) UILabel *guzhangLabel;
// 补货
@property (nonatomic, strong) UILabel *buhuoLabel;
// 缺币
@property (nonatomic, strong) UILabel *quebiLabel;
// 断网
@property (nonatomic, strong) UILabel *duanwangLabel;

@end
