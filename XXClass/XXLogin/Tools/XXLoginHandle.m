//
//  XXLoginHandle.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/9/5.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXLoginHandle.h"
#import "NetWorkManager.h"
#import "CountModel.h"
#import "RouteModel.h"
#import "AMMachineTypeModel.h"
#import "MachineModel.h"
#import "YinliaoModel.h"
#import "AMTodayReportModel.h"
#import "AMDataBaseTool.h"

@implementation XXLoginHandle
#pragma mark - 自动登录
+ (void)autoLoginWithManagerId:(NSString *)managerId loginId:(NSString *)loginId callback:(callback)callback {
    //    NSString *url = [NSString stringWithFormat:@"%@/api/user/%@/identifier/%@", API_IP, managerId, loginId];
    [NetWorkManager GET:LOGIN_AUTOMATE parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        if ([responseObject[@"error_code"] integerValue] == 00000&&[responseObject[@"hasRoutes"] integerValue]==1) {
            NSDictionary *user = responseObject[@"routeManager"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"managerEmail"] forKey:@"managerEmail"];
            callback(YES);
        } else {
            //            [SVProgressHUD showErrorWithStatus:@"该账号下无线路"];
            callback(NO);
        }
    } failure:^(NSError *error) {
        callback(NO);
    }];
}

#pragma mark - 登陆请求
+ (void)requestLoginWithAccount:(NSString *)account password:(NSString *)password callback:(callback)callback
{
    ///api/user/13346159465/password/123456
    //    NSString *url = [NSString stringWithFormat:@"%@/api/user/%@/password/%@", API_IP, account, password];
    [NetWorkManager GET:LOGIN parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"登录信息=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000&&[responseObject[@"hasRoutes"] integerValue]==1) {
            NSDictionary *user = responseObject[@"routeManager"];
            [USER_DEFAULTS setObject:user[@"managerId"] forKey:@"managerId"];
            [USER_DEFAULTS setObject:user[@"loginIdentifier"] forKey:@"loginIdentifier"];
            [USER_DEFAULTS setObject:user[@"managerEmail"] forKey:@"managerEmail"];
            [USER_DEFAULTS setObject:account forKey:@"managerAccount"];
            [USER_DEFAULTS setObject:responseObject[@"token"] forKey:@"requestToken"];
            
            [USER_DEFAULTS setObject:user[@"managerName"] forKey:@"managerName"];
            [USER_DEFAULTS setObject:user[@"managerTel"] forKey:@"managerTel"];
            //信鸽推送更新
            [XXToolHandle getChangeXGTokenWith:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
            // 创建表
            [AMDataBaseTool createWorningNotificationSqlite];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            callback(YES);
        } else {
            if ([responseObject[@"hasRoutes"] integerValue]==0) {
                [SVProgressHUD showErrorWithStatus:@"该账号下无线路"];
                callback(NO);
                
            }
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];//responseObject[@"error"]
            callback(NO);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        callback(NO);
    }];
}


@end
