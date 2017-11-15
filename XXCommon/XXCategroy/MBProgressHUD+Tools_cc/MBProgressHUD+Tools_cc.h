//
//  MBProgressHUD+Tools_cc.h
//  MBProgressHUD_CC
//
//  Created by perfectcjh on 2017/5/10.
//  Copyright © 2017年 perfectcjh. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Tools_cc)

/**
 文字提示

*/
+ (void)showMessage:(NSString *)message;


/**
 成功提示

 */
+ (void)showSuccess:(NSString *)success;


/**
 成功提示（指定view）
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;


/**
 错误提示
*/
+ (void)showError:(NSString *)error;


/**
 错误提示（指定view）
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;


/**
 不带文字的菊花
*/
+ (MBProgressHUD *)showProgress;


/**
 不带文字的菊花（指定view）
 */
+ (MBProgressHUD *)showProgressToView:(UIView *)view;

/**
 带文字的菊花
 */
+ (MBProgressHUD *)showProgressMessage:(NSString *)message;


/**
 带文字的菊花（指定view）
 */
+ (MBProgressHUD *)showProgressMessage:(NSString *)message toView:(UIView *)view;


/**
 隐藏提示
 */
+ (void)hideHUD;


/**
 隐藏指定view的提示
 */
+ (void)hideHUDForView:(UIView *)view;


/**
 隐藏所有提示
 */
+ (NSUInteger)hideAllHUD;


/**
 隐藏指定view的所有提示
 */
+ (NSUInteger)hideAllHUDForView:(UIView *)view;


@end
