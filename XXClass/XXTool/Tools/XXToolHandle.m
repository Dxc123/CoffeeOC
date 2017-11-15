//
//  XXToolHandle.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXToolHandle.h"
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


@implementation XXToolHandle

#pragma mark -->工具

#pragma mark -->工具模块小红点数）
+ (void)getRedCountwithBlock:(void(^)(NSInteger *taskCount,NSInteger *messageListCount,NSInteger *alarmCount))block{
    NSString *managerId = managerID;
    if (managerId.length>0) {
        
        [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/system/manager/%@/messageinfolist/%@/%@",API_IP,managerID,@"0",@"1000"] parameters:nil progress:^(id downloadProgress) {
            
        } success:^(id responseObject) {
            
            // http://app-yy-api.zjxfyb.com/api/system/manager/3/messageinfolist/0/1000
            NSLog(@"取得用户消息信息列表(工具模块小红点数)=%@",responseObject);

            
                        if ([responseObject[@"messageList"] isEqual:[NSNull null]]) {
                            return ;
                        }
            
                        NSArray *tempArr = responseObject[@"messageList"];
                        NSInteger messageListCount = 0;
                        if (tempArr.count>0) {
//                            NSMutableArray *dataArr = [NSMutableArray array];
//                            for (NSDictionary *tempDic in tempArr) {
//                                AMNotificationModel *model = [[AMNotificationModel alloc]init];
//                                model.titleStr = tempDic[@"messageTitle"];
//                                model.timeStr = tempDic[@"createTime"];
//                                model.adressStr = tempDic[@"messageContent"];
//                                [dataArr addObject:model];
                            messageListCount=tempArr.count;
                        
                            }
            
                         NSInteger taskCount=[responseObject[@"taskCount"] integerValue];
                         NSInteger alarmCount=[responseObject[@"alarmCount"] integerValue];
            
                            if (block) {
                                block(&taskCount,&messageListCount,&alarmCount);

                            }
            

            
        } failure:^(NSError *error) {
            
        }];
        
        
    
    }
       
}



#pragma mark -->取得用户消息信息列表（还有工具模块小红点数） 推送消息
+ (void)getMessagewithBlock:(void(^)(NSMutableArray *dataArr))block{
    NSString *managerId = managerID;
    if (managerId.length>0) {
        [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/system/manager/%@/messageinfolist/%@/%@",API_IP,managerID,@"0",@"1000"] parameters:nil progress:^(id downloadProgress) {
        } success:^(id responseObject) {
            
            NSLog(@"取得用户消息信息列表%@",responseObject);
            if ([responseObject[@"messageList"] isEqual:[NSNull null]]) {
                return ;
            }
            NSArray *tempArr = responseObject[@"messageList"];
            if (tempArr.count>0) {
                NSMutableArray *dataArr = [NSMutableArray array];
                for (NSDictionary *tempDic in tempArr) {
                    AMNotificationModel *model = [[AMNotificationModel alloc]init];
                    model.titleStr = tempDic[@"messageTitle"];
                    model.timeStr = tempDic[@"createTime"];
                    model.adressStr = tempDic[@"messageContent"];
                    [dataArr addObject:model];
                }
                if (block) {
                    block(dataArr);
                }
            }
        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark-->获取任务 列表
+ (void)getTaWithTaskType:(NSString *)type WithBlock:(void(^)(NSDictionary *Dic,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/system/manager/%@/tasklist/applystatus/%@",API_IP,managerID,type] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获取任务列表=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"taskInfoList"]){
                NSArray *tempArr = responseObject[@"taskInfoList"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        NSString *key = [NSString stringWithFormat:@"%@(共%@台)",tempDic[@"taskName"],tempDic[@"machineCount"]];
                        NSMutableArray *arr = [NSMutableArray array];
                        NSArray *valueArr = tempDic[@"changeApplyList"];
                        if (valueArr.count>0) {
                            for (NSDictionary *valueDic in valueArr) {
                                AMTaskModel *model = [[AMTaskModel alloc]init];
                                model.machineTypoe = valueDic[@"machineSn"];
                                model.applyType = valueDic[@"applyType"];
                                model.adressStr = [NSString stringWithFormat:@"%@.%@",valueDic[@"routeName"],valueDic[@"positionName"]];
                                model.oldadressLine = valueDic[@"routeName"];
                                model.oldadressPoint = valueDic[@"positionName"];
                                model.newadressLine = valueDic[@"newRouteName"];
                                model.newadressPoint = valueDic[@"newPositionName"];
                                [arr addObject:model];
                            }
                            [dic setValue:arr forKey:key];
                            if (block) {
                                block(dic,NO);
                            }
                        }
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



#pragma mark-->获得告警信息的数量
+ (void)getWorningNumberWithBlock:(void(^)(NSInteger number,BOOL LossConnect))block{
    //
    //[NSString stringWithFormat:@"%@/api/alarm/manager/%@/alarminfolist/%@/%@",API_IP,managerID,@"0",@"10000"]
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/alarm/manager/%@/alarmtypelist",API_IP,managerID] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"获得告警信息的数量%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"alarmTypeList"]){////alarmInfoList
                NSInteger number = 0;
                NSArray *tempArr = responseObject[@"alarmTypeList"];//alarmInfoList
                NSLog(@"%lu",(unsigned long)tempArr.count);
                if (tempArr.count>0) {
                    //                    number=tempArr.count;
                    
                    for (NSDictionary *tempDic in tempArr) {
                        NSString *wornTypeStr = tempDic[@"typeName"];//typeName//alarmType
                        if (wornTypeStr.length > 0) {
                            number++;
                            
                        }
                    }
                }
                if (block) {
                    block(number,NO);
                
                }
            }else{
                if (block) {
                    block(0,NO);
                }
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
            if (block) {
                block(0,YES);
            }
        }
    }];
}












#pragma mark -->任务详情
+ (void)getTaskContentWithTaskType:(NSString *)type WithBlock:(void(^)(NSDictionary *Dic,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/system/manager/%@/tasklist/applystatus/%@",API_IP,managerID,type] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"taskInfoList"]){
                NSArray *tempArr = responseObject[@"taskInfoList"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        NSString *key = [NSString stringWithFormat:@"%@(共%@台)",tempDic[@"taskName"],tempDic[@"machineCount"]];
                        NSMutableArray *arr = [NSMutableArray array];
                        NSArray *valueArr = tempDic[@"changeApplyList"];
                        if (valueArr.count>0) {
                            for (NSDictionary *valueDic in valueArr) {
                                AMTaskModel *model = [[AMTaskModel alloc]init];
                                model.machineTypoe = valueDic[@"machineSn"];
                                model.applyType = valueDic[@"applyType"];
                                model.adressStr = [NSString stringWithFormat:@"%@.%@",valueDic[@"routeName"],valueDic[@"positionName"]];
                                model.oldadressLine = valueDic[@"routeName"];
                                model.oldadressPoint = valueDic[@"positionName"];
                                model.newadressLine = valueDic[@"newRouteName"];
                                model.newadressPoint = valueDic[@"newPositionName"];
                                [arr addObject:model];
                            }
                            [dic setValue:arr forKey:key];
                            if (block) {
                                block(dic,NO);
                            }
                        }
                    }
                }else{
                    if (block) {
                        block(nil,NO);
                    }
//                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
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

#pragma mark -->获得告警列表（根据机器编号） alarminfolist
+ (void)getAlermMessageWithIndex:(NSString *)index andBackBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/alarm/manager/%@/alarminfolist/%@/%@",API_IP,managerID,index,@"10"] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        //        api/alarm/manager/{managerId}/alarminfolist/{index}/{count}
        //        http://app-yy-api.zjxfyb.com/api/alarm/manager/3/alarminfolist/0/10
//        http://39.108.188.180:8080/api/alarm/manager/1/alarminfolist/0/10
        NSLog(@"获得告警列表（根据机器编号）=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"alarmInfoList"]){
                NSArray *tempArr = responseObject[@"alarmInfoList"];
                if (tempArr.count>0) {
                    NSMutableArray *dateArr = [NSMutableArray array];
                    for (NSDictionary *tempDic in tempArr) {
                        AMMachWorModel *model = [[AMMachWorModel alloc]init];
                        model.machineType = tempDic[@"machineSn"];
                        NSString *wornTypeStr = tempDic[@"alarmType"];
                        if (wornTypeStr.length > 0) {
                            NSString *str = [[NSString alloc]init];
                            if ([wornTypeStr isEqualToString:@"00"]) {
                                str = @"缺货";
                            }else if ([wornTypeStr isEqualToString:@"01"]) {
                                str = @"缺币(5角)";
                            }else if ([wornTypeStr isEqualToString:@"03"]) {
                                str = @"断网";
                            }else if ([wornTypeStr isEqualToString:@"02"]) {
                                str = @"缺币(1元)";
                            }else if ([wornTypeStr isEqualToString:@"04"]) {
                                str = @"故障(主控)";
                            }else if ([wornTypeStr isEqualToString:@"05"]) {
                                str = @"故障(纸币器)";
                            }else if ([wornTypeStr isEqualToString:@"06"]) {
                                str = @"故障(硬币器)";
                            }
                            model.worningType =str;
                            NSString *routeStr = tempDic[@"routeName"];
                            NSString *lineStr = tempDic[@"positionName"];
                            model.adressStr = [NSString stringWithFormat:@"%@.%@",routeStr,lineStr];
                            NSString *strTemp = tempDic[@"alarmLevel"];
                            model.alermLevel = strTemp;
                            [dateArr addObject:model];
                        }
                    }
                    if (block) {
                        block(dateArr,NO);
                    }
                }else{
                    if (block) {
                        block(nil,NO);
                    }
//                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];//
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
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


#pragma mark -->告警类型 列表 alarmtypelist
+ (void)getAlertTypeMeaasgeBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/alarm/manager/%@/alarmtypelist",API_IP,managerID] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"警告类型列表=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"alarmTypeList"]){
                NSMutableArray *dateArr = [NSMutableArray array];
                NSArray *arr = responseObject[@"alarmTypeList"];
                for (NSDictionary *tempDic in arr) {
                    AMWorTypeModel *model = [[AMWorTypeModel alloc]init];
                    NSString *wornTypeStr = tempDic[@"typeId"];
                    NSString *str = [[NSString alloc]init];
                    if ([wornTypeStr isEqualToString:@"00"]) {
                        str = @"缺货";
                    }else if ([wornTypeStr isEqualToString:@"01"]) {
                        str = @"缺币(5角)";
                    }else if ([wornTypeStr isEqualToString:@"03"]) {
                        str = @"断网";
                    }else if ([wornTypeStr isEqualToString:@"02"]) {
                        str = @"缺币(1元)";
                    }else if ([wornTypeStr isEqualToString:@"04"]) {
                        str = @"故障(主控)";
                    }else if ([wornTypeStr isEqualToString:@"05"]) {
                        str = @"故障(纸币器)";
                    }else if ([wornTypeStr isEqualToString:@"06"]) {
                        str = @"故障(硬币器)";
                    }
                    model.typeStr = str;
                    model.typeId = tempDic[@"typeId"];
                    model.alermLavel = tempDic[@"typeLevel"];
                    [dateArr addObject:model];
                }
                if (block) {
                    block(dateArr,NO);
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


#pragma mark -->获得告警详情  列表 alarmdetail
+ (void)getDetailMessageWithMachineID:(NSString *)machineID WithBlock:(void(^)(NSMutableArray *arr,NSString *machineID,NSString *adressStr,NSMutableArray *errorMarkArr,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/alarm/manager/%@/machine/%@/alarmdetail",API_IP,managerID,machineID] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        //GET api/alarm/manager/{managerId}/machine/{machineId}/alarmdetail
        
        //http://app-yy-api.zjxfyb.com/api/alarm/manager/3/machine/1002000059/alarmdetail
        NSLog(@"获得告警详情  列表=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"machineInfo"]){
                NSDictionary *machineInfoDic  = responseObject[@"machineInfo"];
                NSString *machineId = machineInfoDic[@"machineSn"];
                NSString *adressLine = machineInfoDic[@"routeName"];
                NSString *adressPint = machineInfoDic[@"positionName"];
                NSString *adress = [NSString stringWithFormat:@"%@.%@",adressLine,adressPint];
                NSMutableArray *errorTypeArr = [NSMutableArray array];
                
                NSArray *errArr = @[@"isDuanwang",@"isGuzhang",@"isQuebi",@"isQuehuo"];
                for (int i = 0; i<errArr.count; i++) {
                    NSString *errStr = machineInfoDic[errArr[i]];
                    if ([errStr isEqualToString:@"1"]) {
                        [errorTypeArr addObject:errArr[i]];
                    }
                }
                NSMutableArray *detailArr = [NSMutableArray array];
                NSArray *tempArr = machineInfoDic[@"alarmInfoList"];
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        AMWornDetailModel *detailModel = [[AMWornDetailModel alloc]init];
                        detailModel.alarmType = tempDic[@"alarmType"];
                        detailModel.alarmLevel = tempDic[@"alarmLevel"];
                        detailModel.distanceHour = tempDic[@"distanceHour"];
                        [detailArr addObject:detailModel];
                    }
                }
                if (block) {
                    block(detailArr,machineId,adress,errorTypeArr,NO);
                }
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
            if (block) {
                block(nil,nil,nil,nil,YES);
            }
        }
    }];
}

#pragma mark -->获得告警列表（根据警告类型）
+ (void)getWorningDetailByType:(NSString *)typeId AndIndex:(NSString *)index WithBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/alarm/manager/%@/alarmtypelist/%@/%@/%@",API_IP,managerID,typeId,index,@"10"] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        
        //    GET api/alarm/manager/{managerId}/alarmtypelist/{alarmTypeId}/{index}/{count}
        //       http://app-yy-api.zjxfyb.com/api/alarm/manager/3/alarmtypelist/02/0/10
        NSLog(@"获得告警列表（根据警告类型）=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"alarmInfoList"]){
                NSMutableArray *dataArr = [NSMutableArray array];
                NSArray *tempArr = responseObject[@"alarmInfoList"];
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        AMMachWorModel *model = [[AMMachWorModel alloc]init];
                        model.machineType = tempDic[@"machineSn"];
                        NSString *wornTypeStr = tempDic[@"alarmType"];
                        NSString *str = [[NSString alloc]init];
                        if ([wornTypeStr isEqualToString:@"00"]) {
                            str = @"缺货";
                        }else if ([wornTypeStr isEqualToString:@"01"]) {
                            str = @"缺币(5角)";
                        }else if ([wornTypeStr isEqualToString:@"03"]) {
                            str = @"断网";
                        }else if ([wornTypeStr isEqualToString:@"02"]) {
                            str = @"缺币(1元)";
                        }else if ([wornTypeStr isEqualToString:@"04"]) {
                            str = @"故障(主控)";
                        }else if ([wornTypeStr isEqualToString:@"05"]) {
                            str = @"故障(纸币器)";
                        }else if ([wornTypeStr isEqualToString:@"06"]) {
                            str = @"故障(硬币器)";
                        }
                        model.worningType = str;
                        model.alermLevel = tempDic[@"alarmLevel"];
                        [dataArr addObject:model];
                    }
                    if (block) {
                        block(dataArr,NO);
                    }
                }else{
//                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
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
#pragma mark-->历史备货单
+ (void)getHistoryStockupInfoListWithIndex:(NSString *)index andBlock:(void(^)(NSMutableArray *arr,BOOL LossConnect))block{
    // api/home/manager/{managerId}/{index}/{count}
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/home/manager/%@/%@/%@",API_IP,managerID,index,@"12"] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"历史备货单InfoList=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"stockupInfoList"]){
                NSArray *tempArr = responseObject[@"stockupInfoList"];
                NSMutableArray *dataArr = [NSMutableArray array];
                if (tempArr.count>0) {
                    for (NSDictionary *tempDic in tempArr) {
                        AMHistoryModel *model = [[AMHistoryModel alloc]init];
                        model.stockup_id = tempDic[@"stockupId"];
                        model.timeStr = tempDic[@"createTime"];
                        model.routeName = tempDic[@"routeName"];
                        model.stockupTime = tempDic[@"stockupTime"];
                        [dataArr addObject:model];
                    }
                    if (block) {
                        block(dataArr,NO);
                    }
                }else{
                    if (block) {
                        block(nil,NO);
                    }
//                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAYTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
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
#pragma mark-->历史备货单详情列表
+ (void)getHistoryDetailStockupInfoListWithStockID:(NSString *)stockID andBlock:(void(^)(NSMutableDictionary *dic,BOOL LossConnect))block{
    //   http://app-yy-api.zjxfyb.com/api/home/stockupinfo/{stockupId}
    //     http://app-yy-api.zjxfyb.com/api/home/stockupinfo/158
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/home/stockupinfo/%@",API_IP,stockID] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"历史备货单详情列表%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"machineRoadDetailList"]){
                NSArray *tempArr = responseObject[@"machineRoadDetailList"];
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
                for (NSDictionary *tempDic in tempArr) {
                    NSString *needCount = tempDic[@"outStockCount"];
                    NSString *titleStr = tempDic[@"goodsTypeName"];
                    //按照一定格式将title和所需要的商品数量
                    NSString *key = [NSString stringWithFormat:@"%@-%@",titleStr,needCount];
                    NSArray *goodsArr = tempDic[@"machineRoadList"];
                    NSMutableArray *goodsDataArr = [NSMutableArray array];
                    if (goodsArr.count>0) {
                        for (NSDictionary *goosDic in goodsArr) {
                            AMHistoryDetailModel *model = [[AMHistoryDetailModel alloc]init];
                            model.goodsName = goosDic[@"goodsName"];
                            model.outStockCount = goosDic[@"outStockCount"];
                            model.outStockBoxCount = goosDic[@"outStockBoxCount"];
                            [goodsDataArr addObject:model];
                        }
                    }
                    [dataDic setValue:goodsDataArr forKey:key];
                }
                if (block) {
                    block(dataDic,NO);
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

#pragma mark-->月账单
+ (void)getMonthDetailMessageWithTime:(NSString *)monthType WithBlock:(void(^)(NSString *totalMoney,NSString *money,NSString *online,BOOL LossConnect))block{
    if (monthType == nil) {
        return;
    }
    //月账单api/report/manager/{managerId}/saleinfo/date/{saledate}
//    http://app-yy-api.zjxfyb.com/api/report/manager/24/saleinfo/date/2017-06
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/report/manager/%@/saleinfo/date/%@",API_IP,managerID ,monthType] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"月账单=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"saleInfo"]){
                NSDictionary *saleInfoDic = responseObject[@"saleInfo"];
                if (block) {
                    block(saleInfoDic[@"totalSalePrice"],saleInfoDic[@"offlineSalePrice"],saleInfoDic[@"onlineSalePrice"],NO);
                }
            }
        }
    }failure:^(NSError *error) {
        if (block) {
            block(nil,nil,nil,YES);
        }
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }else{
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }
    }];
}

#pragma mark -->撤机换线-根据线路获取机器信息列表
+ (void)getChejiOrHuanXianWithRouteId:(NSString *)routeid WithBlock:(void(^)(NSMutableArray *dataArr,BOOL LossConnect))block{
    if (routeid == nil) {
        if (block) {
            block(@[@"没有可选择的线路，请先分配线路"].mutableCopy,YES);
        }
        return;
    }
    
    //api/change/manager/{managerId}/routes/positionlist?routeIds={routeIds}
    //    http://118.190.44.110:7776/api/change/manager/100000/routes/positionlist?routeIds=100000
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/change/manager/%@/routes/positionlist?routeIds=%@",API_IP,managerID,routeid] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"换线-根据线路获取机器信息列表=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"machineInfoList"]){
                NSArray *tempArr = responseObject[@"machineInfoList"];
                if (tempArr.count>0) {
                    NSMutableArray *dataArr = [NSMutableArray array];
                    for (NSDictionary *tempDic in tempArr) {
                        AMAccountModel *model = [[AMAccountModel alloc]init];
                        model.machineType = tempDic[@"machineSn"];
                        NSString *routeName = tempDic[@"routeName"];
                        NSString *positionName = tempDic[@"positionName"];
                        model.adressStr = [NSString stringWithFormat:@"%@.%@",routeName,positionName];
                        model.isSelect = NO;
                        
                        [dataArr addObject:model];
                    }
                    if (block) {
                        block(dataArr,NO);
                    }
                }else{
//                    [SVProgressHUD showImage:nil status:@"没有更多数据了"];
                    if (block) {
                        block(nil,NO);
                    }
                }
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
        if (block) {
            block(@[error.localizedDescription].mutableCopy,YES);
        }
    }];
}
#pragma mark-->换线-申请撤机或者换线
+ (void)getCheJiOrHuanXianWithmachineType:(NSString *)machine AndServiceType:(NSString *)type AndReason:(NSString *)reason WithBack:(void(^)(BOOL isArchive,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/change/put/manager/%@/machine/%@/servicetype/%@?applyReason=%@",API_IP,managerID,machine,type,reason] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        // api/change/put/manager/{managerId}/machine/{machineId}/servicetype/{serviceType}?applyReason={applyReason}
        NSLog(@"换线-申请撤机或者换线=%@",responseObject);
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            if (block) {
                block(NO,NO);
            }
        }else{
            if (block) {
                block(YES,NO);
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
        if (block) {
            block(YES,YES);
        }
    }];
}


+ (void)getAllRoutesWithBlock:(void(^)(NSString *allRoutes,BOOL LossConnect))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/home/routelist/%@",API_IP,managerID] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
        }else{
            if ([[responseObject allKeys]containsObject:@"RouteList"]){
                NSArray *tempArr = responseObject[@"RouteList"];
                NSString *routes;
                if (tempArr.count>0) {
                    routes = tempArr[0][@"routeId"];
                    for (int i = 1; i<tempArr.count; i++) {
                        NSDictionary *tempDic  = tempArr[i];
                        routes = [NSString stringWithFormat:@"%@;%@",routes,tempDic[@"routeId"]];
                    }
                    if (block) {
                        block(routes,NO);
                    }
                }else{
                    if (block) {
                        block(nil,NO);
                    }
                }
            }
        }
    }failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
        if (block) {
            block(nil,YES);
        }
        
    }];
}


#pragma mark-->信鸽推送更新
+ (void)getChangeXGTokenWith:(NSString *)tokenID{
    if (tokenID == nil) {
        return;
    }
    //token_type : 设备类型1:安卓 2:苹果
    //ios_type : IOS版本类型2:HOUSE 1:APPSTROE
    NSString *appCurVersionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/token/post/user/%@/tokeninfo/%@?tokenType=2&iosType=1&versionNum=%@",API_IP,managerID,tokenID,appCurVersionNum];
    [NetWorkManager GET:urlStr parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
    }];
}

+ (void)fillUpGoodsWithMachineId:(NSString *)machineStr WithBlock:(void(^)(BOOL isArchive))block{
    [NetWorkManager GET:[NSString stringWithFormat:@"%@/api/home/put/manager/%@/replenishmentmachine/%@",API_IP,managerID,machineStr] parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        if (![responseObject[@"error_code"] isEqualToString:@"00000"]) {
            [SVProgressHUD showImage:nil status:responseObject[@"error"]];
            if (block) {
                block(NO);
            }
        }else{
            if (block) {
                block(YES);
            }
        }
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [SVProgressHUD showImage:nil status:DUANWANG];
        }
        if (block) {
            block(NO);
        }
    }];
}


@end
