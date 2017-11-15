//
//  XXHomeHandle.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXHomeHandle : NSObject
#pragma mark - 首页请求
+ (void)requestMachineCountWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(NSMutableArray *countArray, NSMutableArray *sectionArray, NSMutableArray *machineArray,NSMutableArray *coffeeMachineArray, NSString *replenishmentCount, NSString *lossAmount, BOOL isSuccess))callback;

#pragma mark - 故障列表请求
+ (void)requestFailListWithManagerId:(NSString *)managerId routeId:(NSString *)routeId machineType:(NSInteger)macineType callback:(void(^)(NSMutableArray *dataArray, NSString *machineCount, BOOL isSuccess))callback;
#pragma mark - 咖啡机温度
+(void)requestCoffeeTemperatureListWithManagerId:(NSString *)managerId routeId:(NSString *)routeId  callback:(void(^)(NSMutableArray *dataArray, NSString *machineCount, BOOL isSuccess))callback;
#pragma mark - 机器缺货请求
+ (void)requestMachineGoodsWithMachineSn:(NSString *)machineSn callback:(void(^)(id machine, BOOL isSuccess))callback;
#pragma mark - coffee机器货料使用详情
+ (void)requestCoffeeMachineGoodsWithMachineSn:(NSString *)machineSn callback:(void(^)(id machine, BOOL isSuccess))callback;


#pragma mark - 多选机器缺货请求
+ (void)requestMachineGoodsListWithMachineSn:(NSString *)machineSns callback:(void(^)(NSMutableArray *typeArray, BOOL isSuccess))callback;

#pragma mark - 搜索请求
+ (void)requestSearchWithManagerId:(NSString *)managerId text:(NSString *)text callback:(void(^)(NSMutableArray *dataArray))callback;

#pragma mark - 指定路线机器搜索
+ (void)requestSearchWithRouteId:(NSString *)routeId text:(NSString *)text callback:(void(^)(id route))callback;

#pragma mark - 次日备货请求

//stockupdetail
//stockupFlg = True;
+ (void)requestStockupdetailWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess))callback;

// stockupFlg = False;
+ (void)requestNextDayGoodsWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess))callback;

#pragma mark - 今日运营报告请求
+ (void)requestReportWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(id report, BOOL isSuccess))callback;

#pragma mark - 路线列表请求
+ (void)requestRouteListWidthManagerId:(NSString *)managerId callback:(void(^)(NSMutableArray *routeArray, BOOL isSuccess))callback;

#pragma mark - 发送次日备货单到邮箱
+ (void)sendGoodsWithManagerId:(NSString *)managerId routeId:(NSString *)routeId goodsInfoStr:(NSString *)goodsInfoStr callback:(void(^)(BOOL isSuccess))callback;

#pragma mark - 补货
+ (void)completeGoodsWithManagerId:(NSString *)managerId alarmId:(NSString *)alarmId callback:(void(^)(BOOL isSuccess))callback;


@end
