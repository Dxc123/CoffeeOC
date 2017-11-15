//
//  XXToolHandle.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXToolHandle : NSObject
#pragma mark-->工具模块

#pragma mark -->工具模块小红点数

+ (void)getRedCountwithBlock:(void(^)(NSInteger *taskCount,NSInteger *messageListCount,NSInteger *alarmCount))block;



//工具首页（没有空数据提示）
+ (void)getTaWithTaskType:(NSString *)type WithBlock:(void(^)(NSDictionary *Dic,BOOL LossConnect))block;

//1.获取任务列表
+ (void)getTaskContentWithTaskType:(NSString *)type WithBlock:(void(^)(NSDictionary *Dic,BOOL LossConnect))block;

//2.获取未接收的通知的消息信息
+ (void)getMessagewithBlock:(void(^)(NSMutableArray *dataArr))block;

//3.告警
//获得告警信息的数量
+ (void)getWorningNumberWithBlock:(void(^)(NSInteger number,BOOL LossConnect))block;


//获得告警列表信息（显示机器列表）
+ (void)getAlermMessageWithIndex:(NSString *)index andBackBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block;

//获得警告类型列表
+ (void)getAlertTypeMeaasgeBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block;

//根据机器号获得告警详情
+ (void)getDetailMessageWithMachineID:(NSString *)machineID WithBlock:(void(^)(NSMutableArray *arr,NSString *machineID,NSString *adressStr,NSMutableArray *errorMarkArr,BOOL LossConnect))block;

//获得告警列表（根据警告类型）
+ (void)getWorningDetailByType:(NSString *)typeId AndIndex:(NSString *)index WithBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block;
//4.历史备货单
//获取历史备货单列表
+ (void)getHistoryStockupInfoListWithIndex:(NSString *)index andBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block;

//获取历史备货单的详情
+ (void)getHistoryDetailStockupInfoListWithStockID:(NSString *)stockID andBlock:(void(^)(NSMutableDictionary *dic,BOOL LossConnect))block;
//5.获取月账单
+ (void)getMonthDetailMessageWithTime:(NSString *)monthType WithBlock:(void(^)(NSString *totalMoney,NSString *money,NSString *online,BOOL LossConnect))block;
//6.申请撤机或者换线
+ (void)getCheJiOrHuanXianWithmachineType:(NSString *)machine AndServiceType:(NSString *)type AndReason:(NSString *)reason WithBack:(void(^)(BOOL isArchive,BOOL LossConnect))block;

//获取所有线路
+ (void)getAllRoutesWithBlock:(void(^)(NSString *allRoutes,BOOL LossConnect))block;

//根据线路获取机器信息列表 （换线）
+ (void)getChejiOrHuanXianWithRouteId:(NSString *)routeid WithBlock:(void(^)(NSMutableArray *dataArr,BOOL LossConnect))block;


//更换设备token
+ (void)getChangeXGTokenWith:(NSString *)tokenID;

//机器补满,没有空货道也可以补货处理
+ (void)fillUpGoodsWithMachineId:(NSString *)machineStr WithBlock:(void(^)(BOOL isArchive))block;


@end
