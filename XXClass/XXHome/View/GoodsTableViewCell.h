//
//  GoodsTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell

// 货物状态
@property (nonatomic, strong) UILabel *goodsStateLabel;

// 货物信息
@property (nonatomic, strong) UILabel *goodsInfoLabel;

// 缺货数
@property (nonatomic, strong) UILabel *numLabel;


@property (nonatomic, assign) BOOL isLive;

@end
