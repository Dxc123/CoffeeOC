//
//  XXTemperatureCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/10.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineView.h"


@interface XXTemperatureCell : UITableViewCell

@property (nonatomic, strong) MachineView *machineView;

@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *wendu;//咖啡机温度
@property (nonatomic, strong) UILabel *wenduLab;
@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;

@property (nonatomic, assign) BOOL isCoffeeMachine;

@end
