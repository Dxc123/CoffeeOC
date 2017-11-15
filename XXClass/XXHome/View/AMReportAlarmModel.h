//
//  AMReportAlarmModel.h
//  ZSAgencyManage
//
//  Created by 岳杰 on 2016/12/23.
//  Copyright © 2016年 宗盛商业. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMReportAlarmModel : NSObject

@property (nonatomic, copy) NSString *alarmId;

@property (nonatomic, copy) NSString *machineSn;

@property (nonatomic, copy) NSString *distanceHour;

@property (nonatomic, copy) NSString *transactTime;

@property (nonatomic, copy) NSString *routeName;

@property (nonatomic, copy) NSString *positionName;

@property (nonatomic, copy) NSString *transactType;

@end
