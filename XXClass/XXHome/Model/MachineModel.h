//
//  MachineModel.h
//  test
//
//  Created by Dxc_iOS on 2017/4/28.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachineModel : NSObject
//机器信息
@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *machineName;

@property (nonatomic, copy) NSString *routeId;

@property (nonatomic, copy) NSString *routeName;

@property (nonatomic, copy) NSString *positionId;

@property (nonatomic, copy) NSString *positionName;
//四个故障信息
@property (nonatomic, copy) NSString *isQuehuo;

@property (nonatomic, copy) NSString *isQuebi;

@property (nonatomic, copy) NSString *isDuanwang;

@property (nonatomic, copy) NSString *isGuzhang;


// 错误信息
@property (nonatomic, strong) NSMutableArray *alarmInfoList;
// 饮料
@property (nonatomic, copy) NSString *yinliaoOutStockCount;

@property (nonatomic, strong) NSArray *yinliaoRoadList;
// 食品
@property (nonatomic, copy) NSString *shipinOutStockCount;

@property (nonatomic, strong) NSArray *shipinRoadList;
// 其他
@property (nonatomic, copy) NSString *qitaOutStockCount;

@property (nonatomic, strong) NSArray *qitaRoadList;

@end
