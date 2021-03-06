//
//  RouteModel.h
//  test
//
//  Created by 岳杰 on 2016/12/19.
//  Copyright © 2016年 岳杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteModel : NSObject

@property (nonatomic, copy) NSString *routeId;

@property (nonatomic, copy) NSString *routeName;

@property (nonatomic, copy) NSString *machineCount;

@property (nonatomic, strong) NSMutableArray *machineInfoList;

@property (nonatomic, strong) NSMutableArray *machineTypeList;

@property (nonatomic, strong) NSMutableArray *coffeeMachineInfoList;

@property (nonatomic, strong) NSString *stockupFlg;


/**是否展开标志*/
@property(nonatomic,assign) BOOL unfold;
@end
