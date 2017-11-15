//
//  MachineModel.m
//  test
//
//  Created by Dxc_iOS on 2017/4/28.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "MachineModel.h"
#import "YinliaoModel.h"
#import "AlarmInfoModel.h"
@implementation MachineModel

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
             @"yinliaoRoadList":[YinliaoModel class],
             @"shipinRoadList":[YinliaoModel class],
             @"qitaRoadList":[YinliaoModel class]};
}

@end
