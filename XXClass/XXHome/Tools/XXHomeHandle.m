//
//  XXHomeHandle.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXHomeHandle.h"
#import "NetWorkManager.h"
#import "CountModel.h"
#import "RouteModel.h"
#import "AMMachineTypeModel.h"
#import "MachineModel.h"
#import "YinliaoModel.h"
#import "AMTodayReportModel.h"
#import "AMDataBaseTool.h"
#import "CoffeeMachineModel.h"

@implementation XXHomeHandle
#pragma mark - 首页请求
+ (void)requestMachineCountWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(NSMutableArray *countArray, NSMutableArray *sectionArray, NSMutableArray *machineArray,NSMutableArray *coffeeMachineArray ,NSString *replenishmentCount, NSString *lossAmount, BOOL isSuccess))callback
{
    NSMutableArray *countArray = [NSMutableArray array];
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSMutableArray *machineArray = [NSMutableArray array];
    NSMutableArray *coffeeMachineArray = [NSMutableArray array];
    
    __block NSString *replenishmentCount = [NSString string];
    __block NSString *lossAmount = [NSString string];
    __block BOOL isSuccess = YES;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [NetWorkManager GET:MACHINE_COUNT parameters:nil progress:^(id downloadProgress) {
        } success:^(id responseObject) {
            NSLog(@"获取首页个数=%@",responseObject);
            if ([responseObject[@"error_code"] integerValue] == 00000) {
                CountModel *model = [[CountModel alloc] init];
                [model yy_modelSetWithJSON:responseObject[@"homeMachineCountModel"]];
                [countArray addObject:model.replenishmentCount];
                [countArray addObject:model.lackCurrencyCount];
                [countArray addObject:model.netOffCount];
                [countArray addObject:model.failCount];
                replenishmentCount = model.replenishmentCount;
                lossAmount = model.lossAmount;
            } else {
                isSuccess = NO;
            }
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            isSuccess = NO;
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    // 将第二个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [NetWorkManager GET:MACHINE_LIST parameters:nil progress:^(id downloadProgress) {
        } success:^(id responseObject) {
    //获取首页线路售货机列表 api/home/manager/{managerId}/route/{routeId}/machinelist

            NSLog(@"获取首页线路售货机列表=%@",responseObject);
        
            if ([responseObject[@"error_code"] integerValue] == 00000) {
                for (NSDictionary *list in responseObject[@"RouteList"]) {
                    RouteModel *route = [[RouteModel alloc] init];
                    [route yy_modelSetWithJSON:list];
                    [sectionArray addObject:route];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
                isSuccess = NO;
            }
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            isSuccess = NO;
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        callback(countArray, sectionArray, machineArray,coffeeMachineArray, replenishmentCount, lossAmount, isSuccess);
    });
}

#pragma mark - 故障列表请求
+ (void)requestFailListWithManagerId:(NSString *)managerId routeId:(NSString *)routeId machineType:(NSInteger)machineType callback:(void(^)(NSMutableArray *dataArray, NSString *machineCount, BOOL isSuccess))callback
{
    // api/home/manager/{managerId}/route/{routeId}/machineinfolist/type/{machineType}
    NSMutableArray *dataArray = [NSMutableArray array];
    __block NSString *machineCount = [NSString string];
    [NetWorkManager GET:FAIL_LIST parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"故障列表请求=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *dic in responseObject[@"machineInfoList"]) {
                MachineModel *machine = [[MachineModel alloc] init];
                [machine yy_modelSetWithJSON:dic];
                [dataArray addObject:machine];
            }
            machineCount = responseObject[@"machineCount"];
            callback(dataArray, machineCount, YES);
        } else {
            callback(dataArray, machineCount, NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        callback(dataArray, machineCount, NO);
        [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
    }];
}
#pragma mark - 咖啡机温度
//api/home/manager/86/route/0/boilertemperature
+(void)requestCoffeeTemperatureListWithManagerId:(NSString *)managerId routeId:(NSString *)routeId  callback:(void(^)(NSMutableArray *dataArray, NSString *machineCount, BOOL isSuccess))callback{
    NSMutableArray *dataArray = [NSMutableArray array];
    __block NSString *machineCount = [NSString string];
    [NetWorkManager GET:CoffeeTemperature  parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) { 
        NSLog(@"咖啡机温度请求=%@",responseObject);
        
        
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *dic in responseObject[@"machineInfoList"]) {
                CoffeeMachineModel *machine = [[CoffeeMachineModel alloc] init];
                [machine yy_modelSetWithJSON:dic];
                [dataArray addObject:machine];
            }
            machineCount = responseObject[@"machineCount"];
            callback(dataArray, machineCount, YES);
        } else {
            callback(dataArray, machineCount, NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        callback(dataArray, machineCount, NO);
        [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
        NSLog(@"%@",error);
    }];
    
    
    
    
    
    
}

#pragma mark - 机器缺货请求
+ (void)requestMachineGoodsWithMachineSn:(NSString *)machineSn callback:(void(^)(id machine, BOOL isSuccess))callback
{
    // api/home/machine/{machineSn}/goodsdetial?decryptFlg={decryptFlg}
    MachineModel *machine = [[MachineModel alloc] init];
    [NetWorkManager GET:MACHINE_GOODS parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"机器缺货查询%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            [machine yy_modelSetWithJSON:responseObject[@"machineInfo"]];
            callback(machine, YES);
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
            callback(machine, NO);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(machine, NO);
    }];
}
#pragma mark - coffee机器货料使用详情
+ (void)requestCoffeeMachineGoodsWithMachineSn:(NSString *)machineSn callback:(void(^)(id machine, BOOL isSuccess))callback{
    
    //api/home/machine/{machineSn}/materialdetail
    CoffeeMachineModel * machine = [[CoffeeMachineModel alloc] init];
    [NetWorkManager GET:CoffeeMachine_Goods parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"咖啡机物料缺货查询%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            [machine yy_modelSetWithJSON:responseObject[@"machineInfo"]];
            callback(machine, YES);
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
            callback(machine, NO);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(machine, NO);
    }];
    
}





#pragma mark - 多选机器缺货请求==获取实时备货信息
+ (void)requestMachineGoodsListWithMachineSn:(NSString *)machineSns callback:(void(^)(NSMutableArray *typeArray, BOOL isSuccess))callback
{
    // api/home/machine/stockupinfos?machineSns={machineSns}&decryptFlg={decryptFlg}
   
    NSMutableArray *machineTypeArray = [NSMutableArray array];
    [NetWorkManager GET:MACHINE_GOODS_LIST parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"多选机器缺货请求=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *typeDic in responseObject[@"machineTypeList"]) {
                AMMachineTypeModel *typeModel = [[AMMachineTypeModel alloc] init];
                [typeModel yy_modelSetWithJSON:typeDic];
                [machineTypeArray addObject:typeModel];
            }
            callback(machineTypeArray, YES);
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
            callback(machineTypeArray, NO);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(machineTypeArray, NO);
    }];
}

#pragma mark - 搜索请求==获取下拉售货机信息列表
+ (void)requestSearchWithManagerId:(NSString *)managerId text:(NSString *)text callback:(void(^)(NSMutableArray *dataArray))callback
{
    // api/home/machineinfolist/{managerId}-{machineSn}
      NSMutableArray *dataArray = [NSMutableArray array];
    [NetWorkManager GET:SEARCH parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"搜索请求=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *machineInfo in responseObject[@"machineInfoList"]) {
                MachineModel *machine = [[MachineModel alloc] init];
                [machine yy_modelSetWithJSON:machineInfo];
                [dataArray addObject:machine];
                
            }
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
        callback(dataArray);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
    }];
}
#pragma mark - 获取生成指定机器的备货信息列表
+ (void)requestSearchWithRouteId:(NSString *)routeId text:(NSString *)text callback:(void(^)(id route))callback
{
    // api/home/route/{routeId}/machine/stockupinfos/{checkInfo}?decryptFlg={decryptFlg}
    __block RouteModel *route = [[RouteModel alloc] init];
    [NetWorkManager GET:MACHINE_SEARCH parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            route = [RouteModel yy_modelWithJSON:responseObject];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
        callback(route);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(route);
    }];
}

#pragma mark - 次日备货请求

//stockupFlg = True;
//stockupdetail

+ (void)requestStockupdetailWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess))callback{
    
    NSMutableArray *goodsArray = [NSMutableArray array];
    NSMutableArray *sendNumberArray = [NSMutableArray array];
    __block NSString *statisticsMachineCount = [NSString string];
    __block NSString *noStatisticsMachineCount = [NSString string];
    [NetWorkManager GET:NEXT_DAY_Stockupdetail parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获取备货单详细=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *goodsDic in responseObject[@"machineRoadList"]) {
                YinliaoModel *yinliao = [[YinliaoModel alloc] init];
                [yinliao yy_modelSetWithJSON:goodsDic];
                [goodsArray addObject:yinliao];
                [sendNumberArray addObject:yinliao.outStockBoxCount];
            }
            statisticsMachineCount = responseObject[@"statisticsMachineCount"];
            noStatisticsMachineCount = responseObject[@"noStatisticsMachineCount"];
            callback(goodsArray, sendNumberArray, statisticsMachineCount, noStatisticsMachineCount, YES);
        } else {
            callback(goodsArray, sendNumberArray, statisticsMachineCount, noStatisticsMachineCount, NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(goodsArray, sendNumberArray, statisticsMachineCount, noStatisticsMachineCount, NO);
    }];

    
    
    
}


// stockupFlg = False;nextdaypickinglist
+ (void)requestNextDayGoodsWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(NSMutableArray *goodsArray, NSMutableArray *sendNumberArray, NSString *statisticsMachineCount, NSString *noStatisticsMachineCount, BOOL isSuccess))callback
{
    //     api/home/manager/{managerId}/route/{routeId}/nextdaypickinglist
       NSMutableArray *goodsArray = [NSMutableArray array];
    NSMutableArray *sendNumberArray = [NSMutableArray array];
    __block NSString *statisticsMachineCount = [NSString string];
    __block NSString *noStatisticsMachineCount = [NSString string];
    [NetWorkManager GET:NEXT_DAY_GOODS parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获取生成次日备货单列表=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *goodsDic in responseObject[@"machineRoadList"]) {
                YinliaoModel *yinliao = [[YinliaoModel alloc] init];
                [yinliao yy_modelSetWithJSON:goodsDic];
                [goodsArray addObject:yinliao];
                [sendNumberArray addObject:yinliao.outStockBoxCount];
            }
            statisticsMachineCount = responseObject[@"statisticsMachineCount"];
            noStatisticsMachineCount = responseObject[@"noStatisticsMachineCount"];
            callback(goodsArray, sendNumberArray, statisticsMachineCount, noStatisticsMachineCount, YES);
        } else {
            callback(goodsArray, sendNumberArray, statisticsMachineCount, noStatisticsMachineCount, NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(goodsArray, sendNumberArray, statisticsMachineCount, noStatisticsMachineCount, NO);
    }];
}
#pragma mark - 发送次日备货单
+ (void)sendGoodsWithManagerId:(NSString *)managerId routeId:(NSString *)routeId goodsInfoStr:(NSString *)goodsInfoStr callback:(void(^)(BOOL isSuccess))callback
{
    // api/home/put/manager/{managerId}/route/{routeId}/nextdaypickinglist?goodsInfos={goodsInfos}
    //
    //    machine_sn1,road_no1,goods_num1;machine_sn2,road_no2,goods_num2;....
    
    //  http://app-yy-api.zjxfyb.com/api/home/put/manager/35/route/101034/nextdaypickinglist?goodsInfos=3434344545,1,12;
    
//
    [NetWorkManager GET:SEND_GOODS parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"发送次日备货单=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            NSString *str = [NSString stringWithFormat:@"已发送备货单到%@", MANAGER_EMAIL];
            NSLog(@"MANAGER_EMAIL=%@",MANAGER_EMAIL);
            [SVProgressHUD showSuccessWithStatus:str];
            callback(YES);
        } else {
            callback(NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
        callback(NO);
    }];
}


#pragma mark - 今日运营报告请求

+ (void)requestReportWithManagerId:(NSString *)managerId routeId:(NSString *)routeId callback:(void(^)(id report, BOOL isSuccess))callback
{
    
    //    api/home/manager/{managerId}/route/{routeId}/todayoperationalreport
    //    获取今日运营报告信息
    AMTodayReportModel *reportModel = [[AMTodayReportModel alloc] init];
    [NetWorkManager GET:TODAY_REPORT parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获取今日运营报告信息=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            [reportModel yy_modelSetWithJSON:responseObject[@"todayOperationalReportModel"]];
            callback(reportModel, YES);
        } else {
            callback(reportModel, NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(reportModel, NO);
    }];
}

#pragma mark - 路线列表请求
+ (void)requestRouteListWidthManagerId:(NSString *)managerId callback:(void(^)(NSMutableArray *routeArray, BOOL isSuccess))callback
{
    // api/home/routelist/{managerId}?decryptFlg={decryptFlg}
    NSMutableArray *routeArray = [NSMutableArray array];
    [NetWorkManager GET:ROUTE_LIST parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"路线列表请求=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            for (NSDictionary *dic in responseObject[@"RouteList"]) {
                RouteModel *model = [[RouteModel alloc] init];
                [model yy_modelSetWithJSON:dic];
                [routeArray addObject:model];
            }
            callback(routeArray, YES);
        } else {
            callback(routeArray, NO);
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败, 请重试"];
        callback(routeArray, NO);
    }];
}

#pragma mark - 补货
+ (void)completeGoodsWithManagerId:(NSString *)managerId alarmId:(NSString *)alarmId callback:(void(^)(BOOL isSuccess))callback
{
    // api/home/put/manager/{managerId}/replenishment/{alarmId}?decryptFlg={decryptFlg}
    [NetWorkManager GET:COMPLETE_GOODS parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            [SVProgressHUD showSuccessWithStatus:@"补货成功"];
            callback(YES);
        } else {
            callback(NO);
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"补货失败"];
        callback(NO);
    }];
}


@end
