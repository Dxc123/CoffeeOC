//
//  MachineListTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineView.h"

static const CGFloat kCellHeight = 76;

@interface MachineListTableViewCell : UITableViewCell

@property (nonatomic, strong) MachineView *machineView;

@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;

@property (nonatomic, assign) BOOL isCoffeeMachine;

@end
