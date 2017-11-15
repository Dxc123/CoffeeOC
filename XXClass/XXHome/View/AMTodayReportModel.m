//
//  AMTodayReportModel.m
//  ZSAgencyManage
//
//  Created by 岳杰 on 2016/12/23.
//  Copyright © 2016年 宗盛商业. All rights reserved.
//

#import "AMTodayReportModel.h"
#import "AMReportAlarmModel.h"

@implementation AMTodayReportModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return NULL;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"noReplenishMachineList":[AMReportAlarmModel class],
             @"replenishMachineList":[AMReportAlarmModel class]};
}

@end
