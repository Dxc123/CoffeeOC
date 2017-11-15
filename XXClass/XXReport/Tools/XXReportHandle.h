//
//  XXReportHandle.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXReportHandle : NSObject

#pragma mark-->报告模块
//获取报告首界面的数据
+ (void)getReportDetailDateWithRouteID:(NSString *)routeId withBlock:(void(^)(NSString *todayMoney,NSString *monthMoney,NSString *todOnlineMon,NSString *todOffLineMon,NSString *monthOnlineMon,NSString *monthOfflineMon,NSString *yesterMon,NSString *typePic,NSString *yesOnlineMon,NSString *yesOffLineMon,NSString *typePicOnline,NSString *typePicOffline,NSString *yunying,NSString *yunyingDetail,NSString *lossMoney,NSString *buhuo,NSString *shoukuan,NSString *shoukuanDetail,NSMutableArray *dateArr,NSMutableArray *totalMoneyArr))block;

//报告查看更多（点击进去的日期选择）
+ (void)getDateArrWithRouteID:(NSString *)routes andBegainIndex:(NSString *)index andCount:(NSString *)Count WithBlock:(void(^)(NSMutableArray *dateArr,BOOL LossConnect))block;

//各点位的销售详情
+ (void)getAllPointDetailGetMoneyWithDate:(NSString *)date AndRoutes:(NSString *)route WithBlock:(void(^)(NSMutableArray *dataArr,NSString *machineNumbe,NSString *xiaoshoue,NSString *xiaoshouliang,BOOL LossConnect))block;

//商品销售汇总
+ (void)getGatherGoodsSaleMessageWithDate:(NSString *)date AndRoutes:(NSString *)route WithBlock:(void(^)(NSMutableArray *dataArr,BOOL LossConnect))block;

//出货日志
+ (void)getOutLogInfoListWithmachineID:(NSString *)machStr andDate:(NSString *)dateStr WithDataStr:(NSString *)routeStr AndIndex:(NSString *)index WithBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block;

//应收款请求
+ (void)getMoneyForAccountDetailWithRouteIDS:(NSString *)route WithBlock:(void(^)(NSMutableArray *arr,NSString *totalMachineNum,NSString *totalMoney,BOOL LossConnect))block;

//历史应收款查询
+ (void)historyAccountMoneyWithChartStr:(NSString *)machIDStr andRouteId:(NSString *)routeid andIndex:(int)index WithBack:(void(^)(NSMutableArray *Arr,BOOL isSuccess))block;



@end
