//
//  XXLoginHandle.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/9/5.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^callback)(BOOL isSuccess);

@interface XXLoginHandle : NSObject

@property (nonatomic, copy) callback callback;

#pragma mark - 自动登录
+ (void)autoLoginWithManagerId:(NSString *)managerId loginId:(NSString *)loginId callback:(callback)callback;

#pragma mark - 登陆请求
+ (void)requestLoginWithAccount:(NSString *)account password:(NSString *)password callback:(callback)callback;

@end
