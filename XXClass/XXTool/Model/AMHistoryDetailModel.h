//
//  AMHistoryDetailModel.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/27.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AMHistoryDetailModel : NSObject


@property(copy,nonatomic)NSString *goodsName;
//缺货箱数
@property(copy,nonatomic)NSString *outStockBoxCount;
//缺货数
@property(copy,nonatomic)NSString *outStockCount;


@end
