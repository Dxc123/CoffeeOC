//
//  CoffeeMachineModel.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/10/31.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoffeeMachineModel : NSObject
//Coffee机器信息
@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *machineName;

@property (nonatomic, copy) NSString *routeId;

@property (nonatomic, copy) NSString *routeName;

@property (nonatomic, copy) NSString *positionId;

@property (nonatomic, copy) NSString *positionName;

//故障信息
@property (nonatomic, copy) NSString *isQuehuo;

@property (nonatomic, copy) NSString *isQuebi;

@property (nonatomic, copy) NSString *isDuanwang;

@property (nonatomic, copy) NSString *isGuzhang;
// 一系列故障错误信息
@property (nonatomic, strong) NSMutableArray *alarmInfoList;

//咖啡机物料缺货查询信息
@property (nonatomic, strong) NSMutableArray *MaterialPredictList;



@property (nonatomic, copy) NSString *isCoffeeMachine;

@property (nonatomic, copy) NSString *BoilerTemperature;//锅炉温度
@end
