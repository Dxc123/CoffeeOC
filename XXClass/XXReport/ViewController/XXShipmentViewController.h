//
//  XXShipmentViewController.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/2.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBaseViewController.h"

@interface XXShipmentViewController : XXBaseViewController
@property(copy,nonatomic)NSString *machineType;
@property(copy,nonatomic)NSString *dateType;
//线路端的名称线路+点位
@property(copy,nonatomic)NSString *routeStr;
//线路id拼接的形式，所有线路也是这样拼接在一起的以;隔开
@property(copy,nonatomic)NSString *routeId;

@end
