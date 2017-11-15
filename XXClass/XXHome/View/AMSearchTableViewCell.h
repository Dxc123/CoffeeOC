//
//  AMSearchTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MACHINE_CELL_HEIGHT 76

@interface AMSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;

@end
