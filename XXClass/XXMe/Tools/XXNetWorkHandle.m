//
//  XXNetWorkHandle.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/15.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXNetWorkHandle.h"
#import "NetWorkManager.h"
#import "CountModel.h"
#import "RouteModel.h"
#import "AMMachineTypeModel.h"
#import "MachineModel.h"
#import "YinliaoModel.h"
#import "AMTodayReportModel.h"
#import "AMDataBaseTool.h"

@implementation XXNetWorkHandle


#pragma mark - 更改邮箱
+ (void)changeEmailWithManagerId:(NSString *)managerId loginId:(NSString *)loginId email:(NSString *)email callback:(void (^)(BOOL))callback
{
    // api/user/put/{managerId}/email/{managerEmail}/loginidentifier/{loginIdentifier}?decryptFlg={decryptFlg}
    [NetWorkManager GET:MAIL_CHANGE parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            callback(YES);
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
            callback(NO);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
        callback(NO);
    }];
}

#pragma mark - 修改密码
+ (void)changePasswordWithManagerId:(NSString *)managerId loginId:(NSString *)loginId newPwd:(NSString *)newPwd oldPwd:(NSString *)oldPwd callback:(void (^)(BOOL))callback
{
    // 修改密码api/user/put/{managerId}/newpwd/{newPassword}/oldpwd/{oldPassword}/loginidentifier/{loginIdentifier}
    
    [NetWorkManager GET:PASSWORD_CHANGE parameters:nil progress:^(id downloadProgress) {
    } success:^(id responseObject) {
        NSLog(@"修改密码=%@",responseObject);
        if ([responseObject[@"error_code"] integerValue] == 00000) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            callback(YES);
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
            callback(NO);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
        callback(NO);
    }];
    
}

#pragma mark - 反馈意见

+ (void)feedbackWithManagerId:(NSString *)managerId feedbackInfo:(NSString *)info callback:(void (^)(BOOL))callback
{
    // api/system/post/feedbackinfo/user/{feedbackUserId}?feedbackContent={feedbackContent}&decryptFlg={decryptFlg}
//    [NetWorkManager GET:FEEDBACK parameters:nil progress:^(id downloadProgress) {
//    } success:^(id responseObject) {
//        if ([responseObject[@"error_code"] integerValue] == 00000) {
//            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//            callback(YES);
//        } else {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
//            callback(NO);
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"提交失败"];
//        callback(NO);
//    }];
    
    [HYBNetworking getWithUrl:FEEDBACK refreshCache:YES success:^(id response) {
        if ([response[@"error_code"] integerValue] == 00000) {
                    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                    callback(YES);
                    } else {
                        [SVProgressHUD showErrorWithStatus:response[@"error"]];
                        callback(NO);
                    }

    } fail:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
                callback(NO);
    }];
    
    
    
    
    
}

@end
