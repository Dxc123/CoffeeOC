//
//  RouteModel.m
//  test
//
//  Created by 岳杰 on 2016/12/19.
//  Copyright © 2016年 岳杰. All rights reserved.
//

#import "RouteModel.h"
#import "MachineModel.h"
#import "AMMachineTypeModel.h"
#import "CoffeeMachineModel.h"
@implementation RouteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return NULL;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"machineInfoList":[MachineModel class],
             @"machineTypeList":[AMMachineTypeModel class],
             @"coffeeMachineInfoList":[CoffeeMachineModel class]
             
             };
}

@end
