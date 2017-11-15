//
//  XXQuhuoHeaderView.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/21.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"


@interface XXQuhuoHeaderView : UIView
@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, copy) NSString *detailText;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL isQuehuo;

@property (nonatomic, assign) BOOL isQuebi;

@property (nonatomic, assign) BOOL isDuanwang;

@property (nonatomic, assign) BOOL isGuzhang;

@end
