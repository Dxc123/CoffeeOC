//
//  MachineListTableViewCell2.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/4.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MachineView.h"

static const CGFloat kCellHeight = 76;

@interface MachineListTableViewCell2 : UITableViewCell

@property (nonatomic, strong) MachineView *machineView;

@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;


//首先在tableViewCell.h中定义block
typedef void(^tiaozhuan)(void);
//并将block定义成属性
@property(nonatomic,copy)tiaozhuan tiaozhuan;
@end
