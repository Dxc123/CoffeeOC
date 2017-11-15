//
//  CoffeeMachineModel.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/10/31.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "CoffeeMachineModel.h"
#import "AlarmInfoModel.h"
#import "CoffeeMaterialPredictListModel.h"
@implementation CoffeeMachineModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return NULL;
}
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"alarmInfoList":[AlarmInfoModel class],
             @"MaterialPredictList":[CoffeeMaterialPredictListModel class]
             };
}

@end
