//
//  XXNetWorkHandle.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/15.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^callback)(BOOL isSuccess);

@interface XXNetWorkHandle : NSObject

@property (nonatomic, copy) callback callback;





#pragma mark - 更改邮箱
+ (void)changeEmailWithManagerId:(NSString *)managerId loginId:(NSString *)loginId email:(NSString *)email callback:(void(^)(BOOL isSuccess))callback;

#pragma mark - 修改密码
+ (void)changePasswordWithManagerId:(NSString *)managerId loginId:(NSString *)loginId newPwd:(NSString *)newPwd oldPwd:(NSString *)oldPwd callback:(void(^)(BOOL isSuccess))callback;

#pragma mark - 反馈意见
+ (void)feedbackWithManagerId:(NSString *)managerId feedbackInfo:(NSString *)info callback:(void(^)(BOOL isSuccess))callback;

@end
