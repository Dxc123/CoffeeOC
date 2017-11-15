//
//  XXReportHandle.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXReportHandle.h"
#import "NetWorkManager.h"
#import "AMDateModel.h"
#import "AMDetailModel.h"
#import "AMGatherModel.h"
#import "AMShipModel.h"
#import "AMAccountModel.h"
#import "AMTaskModel.h"
#import "AMMachWorModel.h"
#import "AMWorTypeModel.h"
#import "AMWornDetailModel.h"
#import "AMHistoryModel.h"
#import "AMHistoryDetailModel.h"
#import "AMNotificationModel.h"
#import "AMAccHisModel.h"

#define DELAYTIME 1
#define DUANWANG @"当前网络不可用"
#define managerID [[NSUserDefaults standardUserDefaults] objectForKey:@"managerId"]

@implementation XXReportHandle
#pragma mark-->获得报告页面数据
+ (void)getReportDetailDateWithRouteID:(NSString *)routeId withBlock:(void(^)(NSString *todayMoney,NSString *monthMoney,NSString *todOnlineMon,NSString *todOffLineMon,NSString *monthOnlineMon,NSString *monthOfflineMon,NSString *yesterMon,NSString *typePic,NSString *yesOnlineMon,NSString *yesOffLineMon,NSString *typePicOnline,NSString *typePicOffline,NSString *yunying,NSString *yunyingDetail,NSString *lossMoney,NSString *buhuo,NSString *shoukuan,NSString *shoukuanDetail,NSMutableArray *dateArr,NSMutableArray *totalMoneyArr))block{
    
    //   获得报告页面数据 api/report/manager/{managerId}/route/{routeId}/reportinfo
       [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/route/%@/reportinfo",API_IP,managerID,routeId] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获得报告页面数据=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
            if (block) {
                block(nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil);
            }
        }else{
            if ([[responseObject allKeys]containsObject:@"reportInfo"]) {
                
                NSDictionary *tempDic = responseObject[@"reportInfo"];
                //所有日期
                NSMutableArray *dateArr = tempDic[@"dateList"];
                NSArray *tempArr = tempDic[@"saleInfoList"];
                //所有日期对应的数据
                NSMutableArray *totalMoneyArr = @[].mutableCopy;
                for (NSDictionary *infoDic in tempArr) {
                    NSString *totalSalePrice = infoDic[@"totalSalePrice"];
                    [totalMoneyArr addObject:totalSalePrice];
                }
                //应收款
                NSString *yingshoukuan = tempDic[@"ReceivaleMoney"];
                //应收款机器
                NSString *yingshoukuanMashine = tempDic[@"gatherMachine"];
                //补货tai
                NSString *buhuo = tempDic[@"replenishMachine"];
                //运营评分
                NSString *yunying = tempDic[@"operatScore"];
                //运营未处理台数
                NSString *untreatMachine = tempDic[@"untreatMachine"];
                //损失钱数
                NSString *lossMoney = tempDic[@"loseMoney"];
                //本月累计销售额
                NSString *monthMoney = tempDic[@"monthSaleInfo"][@"totalSalePrice"];
                //本月销售额在线
                NSString *monthMoneyOnline = tempDic[@"monthSaleInfo"][@"onlineSalePrice"];
                //本月销售额现金
                NSString *monthMoneyOffline = tempDic[@"monthSaleInfo"][@"offlineSalePrice"];
                //今日销售额
                NSString *todayMoney = tempDic[@"todaySaleInfo"][@"totalSalePrice"];
                //今日销售额在线
                NSString *todayMoneyOnline = tempDic[@"todaySaleInfo"][@"onlineSalePrice"];
                //今日销售额现金
                NSString *todayMoneyOffline = tempDic[@"todaySaleInfo"][@"offlineSalePrice"];
                //昨日销售额
                NSString *ytdMoney = tempDic[@"yesterDaySaleInfo"][@"totalSalePrice"];
                //昨日销售额在线
                NSString *ytdMoneyOnline = tempDic[@"yesterDaySaleInfo"][@"onlineSalePrice"];
                //昨日销售额现金
                NSString *ytdMoneyOffline = tempDic[@"yesterDaySaleInfo"][@"offlineSalePrice"];
                //昨日销售件
                NSString *ytdType = tempDic[@"yesterDaySaleInfo"][@"totalSaleCount"];
                //昨日销售件在线
                NSString *ytdTypeOnline = tempDic[@"yesterDaySaleInfo"][@"onlineSaleCount"];
                //昨日销售件线下
                NSString *ytdTypeOffline = tempDic[@"yesterDaySaleInfo"][@"offlineSaleCount"];
                
                if (block) {
                    block(todayMoney,monthMoney,todayMoneyOnline,todayMoneyOffline,monthMoneyOnline,monthMoneyOffline,ytdMoney,ytdType,ytdMoneyOnline,ytdMoneyOffline,ytdTypeOnline,ytdTypeOffline,yunying,untreatMachine,lossMoney,buhuo,yingshoukuan,yingshoukuanMashine,dateArr,totalMoneyArr);
                }
            }
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
        if (block) {
            block(nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil);
        }
    }];
}

#pragma mark -->昨日 查看更多=（获得销售信息列表（从昨天开始））
+ (void)getDateArrWithRouteID:(NSString *)routes andBegainIndex:(NSString *)index andCount:(NSString *)Count WithBlock:(void(^)(NSMutableArray *dateArr,BOOL LossConnect))block{
    if (routes == nil||index == nil||Count == nil) {
        return;
    }
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/routes/saleinfolist/%@/%@?routeIds=%@",API_IP,managerID,index,Count,routes] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        //     api/report/manager/{managerId}/routes/saleinfolist/{index}/{count}?routeIds={routeIds}
             NSLog(@"昨日 查看更多（获得销售信息列表（从昨天开始））=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"saleInfoList"]) {
                NSMutableArray *dateArr = [NSMutableArray array];
                NSArray *tempArr = responseObject[@"saleInfoList"];
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        AMDateModel *model = [[AMDateModel alloc]init];
                        model.dateStr = tempDic[@"date"];
                        model.xiaoshoueStr = tempDic[@"totalSalePrice"];
                        model.xiaoshoujianStr = tempDic[@"totalSaleCount"];
                        [dateArr addObject:model];
                    }
                    if (block) {
                        block(dateArr,NO);
                    }
                }else{
                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                    if (block) {
                        block(nil,NO);
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
        if (block) {
            block(nil,YES);
        }
    }];
}
#pragma make -->获取销售明细列表（列表中第一个为总的销售信息）
+ (void)getAllPointDetailGetMoneyWithDate:(NSString *)date AndRoutes:(NSString *)route WithBlock:(void(^)(NSMutableArray *dataArr,NSString *machineNumbe,NSString *xiaoshoue,NSString *xiaoshouliang,BOOL LossConnect))block{
    //GET api/report/manager/{managerId}/saledetaillist/date/{saledate}?routeIds={routeIds}
    
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/saledetaillist/date/%@?routeIds=%@",API_IP,managerID,date,route] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获取销售明细列表（列表中第一个为总的销售信息%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"saleDetailList"]){
                NSArray *tempArr = responseObject[@"saleDetailList"];
                NSDictionary *totalDic = tempArr[0];
                NSString *machineNum = totalDic[@"machineCount"];
                NSString *xiaoshouE = totalDic[@"salePrice"];
                NSString *xiaoShouLiang = totalDic[@"saleCount"];
                NSMutableArray *dateArr = [NSMutableArray array];
                if (tempArr.count>0) {
                    for (int i = 1; i<tempArr.count; i++) {
                        NSDictionary *tempDic = tempArr[i];
                        AMDetailModel *model = [[AMDetailModel alloc]init];
                        model.machineType = tempDic[@"machine_id"];
                        model.xiaoshoue = tempDic[@"salePrice"];
                        model.xiaoshoujian = tempDic[@"saleCount"];
                        NSString *lineName = tempDic[@"routeName"];
                        NSString *pointName = tempDic[@"positionName"];
                        model.adressPart = [NSString stringWithFormat:@"%@.%@",lineName,pointName];
                        [dateArr addObject:model];
                    }
                    if (block) {
                        block(dateArr,machineNum,xiaoshouE,xiaoShouLiang,NO);
                    }
                }else{
                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            }
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
            if (block) {
                block(nil,nil,nil,nil,YES);
            }
        }
    }];
}
#pragma mark -->商品销售汇总

+ (void)getGatherGoodsSaleMessageWithDate:(NSString *)date AndRoutes:(NSString *)route WithBlock:(void(^)(NSMutableArray *dataArr,BOOL LossConnect))block{
    // 商品销售汇总GET api/report/manager/{managerId}/routes/goodsalecountlist/date/{saledate}?routeIds={routeIds}
       [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/routes/goodsalecountlist/date/%@?routeIds=%@",API_IP,managerID,date,route] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"商品销售汇总=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"goodsSaleCountList"]){
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *tempArr = responseObject[@"goodsSaleCountList"];
                if (tempArr.count>0) {
                    for (int i = 0; i<tempArr.count; i++) {
                        NSDictionary *tempDic = tempArr[i];
                        AMGatherModel *model = [[AMGatherModel alloc]init];
                        model.paiming = [NSString stringWithFormat:@"%d",i+1];
                        model.goodsName = tempDic[@"goodsName"];
                        model.saleCount = tempDic[@"saleCount"];
                        model.xiaoliangTai = tempDic[@"averageSaleCount"];
                        [arr addObject:model];
                    }
                    if (block) {
                        block(arr,NO);
                    }
                }else{
                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
            }
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
            if (block) {
                block(nil,YES);
            }
        }
    }];
}
#pragma mark -->出货日志列表
+ (void)getOutLogInfoListWithmachineID:(NSString *)machStr andDate:(NSString *)dateStr WithDataStr:(NSString *)routeStr AndIndex:(NSString *)index WithBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block{
    //    api/report/manager/{managerId}/machine/{machineId}/outloginfolist/{index}/{count}/date/{outdate}?routeId={routeId}
    
   
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/machine/%@/outloginfolist/%@/%@/date/%@?routeId=%@",API_IP,managerID,machStr,index,@"10",dateStr,routeStr] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"出货日志列表=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"orderInfoList"]){
                NSMutableArray *dateArr = [NSMutableArray array];
                NSArray *tempArr = responseObject[@"orderInfoList"];
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        AMShipModel *model = [[AMShipModel alloc]init];
                        model.timeDetail = tempDic[@"orderTime"];
                        model.goodsName = tempDic[@"goodsName"];
                        model.price = tempDic[@"goodsPrice"];
                        NSString *payType = tempDic[@"payType"];
                        if ([payType isEqualToString:@"0"]) {
                            model.pricrType = @"现金支付";
                        }else if ([payType isEqualToString:@"1"]){
                            model.pricrType = @"微信支付";
                        }else if ([payType isEqualToString:@"2"]){//2
                            model.pricrType = @"支付宝支付";
                        }else if ([payType isEqualToString:@"3"]){
                            model.pricrType = @"支付宝支付";
                        }
                        [dateArr addObject:model];
                    }
                    if (block) {
                        block(dateArr,NO);
                    }
                }else{
                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                    if (block) {
                        block(nil,NO);
                    }
                }
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
            if (block) {
                block(nil,YES);
            }
        }
    }];
}
+ (void)getMoneyForAccountDetailWithRouteIDS:(NSString *)route WithBlock:(void(^)(NSMutableArray *arr,NSString *totalMachineNum,NSString *totalMoney,BOOL LossConnect))block{
    if (route == nil) {
        return;
    }
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/routes/logreplenishment?routeIds=%@",API_IP,managerID,route] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        if (![responseObject[@"error_code"] isEqual:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"logReplenishmentList"]){
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *tempArr = responseObject[@"logReplenishmentList"];
                NSString *totoalMachine = responseObject[@"machineCount"];
                NSString *totalMoney = responseObject[@"totalReceivable"];
                for (NSDictionary *tempDic in tempArr) {
                    AMAccountModel *model = [[AMAccountModel alloc]init];
                    model.machineType = tempDic[@"machineSn"];
                    model.moneyAccount = tempDic[@"receivable"];
                    model.adressStr = [NSString stringWithFormat:@"%@.%@",tempDic[@"routeName"],tempDic[@"positionName"]];
                    [arr addObject:model];
                }
                if (block) {
                    block(arr,totoalMachine,totalMoney,NO);
                }
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
            if (block) {
                block(nil,nil,nil,YES);
            }
        }
    }];
}





+ (void)historyAccountMoneyWithChartStr:(NSString *)machIDStr andRouteId:(NSString *)routeid andIndex:(int)index WithBack:(void(^)(NSMutableArray *Arr,BOOL isSuccess))block{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i<16; i++) {
        AMAccHisModel *model = [[AMAccHisModel alloc]init];
        model.machineID = @"9001000003";
        model.replenishmentTime = @"2017/05/04 11:12:45";
        model.shouldAccountMoney = @"12345";
        model.adressStr = @"xxxxxxxx";
        [tempArr addObject:model];
    }
    if (block) {
        block(tempArr,YES);
    }
    
    
    [NetWorkManager GET:[NSString stringWithFormat:@""] parameters:nil progress:^(id downloadProgress) {
        
    } success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}


@end
