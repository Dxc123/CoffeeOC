//
//  AMTodayReportModel.h
//  ZSAgencyManage
//
//  Created by 岳杰 on 2016/12/23.
//  Copyright © 2016年 宗盛商业. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTodayReportModel : NSObject

@property (nonatomic, copy) NSString *replenishCount;

@property (nonatomic, copy) NSString *noReplenishCount;

@property (nonatomic, copy) NSString *allRouteCount;

@property (nonatomic, copy) NSString *currentRouteCount;

@property (nonatomic, copy) NSString *replenishedCount;


@property (nonatomic, strong) NSArray *noReplenishMachineList;

@property (nonatomic, strong) NSArray *replenishMachineList;

@end
