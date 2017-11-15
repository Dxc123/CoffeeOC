//
//  AMMachineTypeModel.h
//  ZSAgencyManage
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMMachineTypeModel : NSObject

@property (nonatomic, copy) NSString *machineGroup;

@property (nonatomic, copy) NSString *totalOutStockCount;

@property (nonatomic, strong) NSArray *machineRoadList;

@end
