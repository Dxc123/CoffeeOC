//
//  AMTodayReportTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MACHINE_CELL_HEIGHT 76

@interface AMTodayReportTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) UIButton *freeBtn;

@property (nonatomic, strong) UILabel *timeStyleLabel;

@property (assign , nonatomic)BOOL isTimeShow;

@end
