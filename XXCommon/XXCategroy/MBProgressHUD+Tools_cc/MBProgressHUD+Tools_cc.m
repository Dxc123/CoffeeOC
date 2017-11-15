//
//  MBProgressHUD+Tools_cc.m
//  MBProgressHUD_CC
//
//  Created by perfectcjh on 2017/5/10.
//  Copyright © 2017年 perfectcjh. All rights reserved.
//

#import "MBProgressHUD+Tools_cc.h"

@implementation MBProgressHUD (Tools_cc)


/**
 文字提示
 */
+ (void)showMessage:(NSString *)message
{
    [self showMessage:message hudImage:nil toView:nil];
}


/**
 成功提示
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}


/**
 成功提示（指定view）
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self showMessage:success hudImage:@"success.png" toView:view];
}


/**
 错误提示
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}


/**
 错误提示（指定view）
 */
+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self showMessage:error hudImage:@"error.png" toView:view];
}


/**
 不带文字的菊花
 */
+ (MBProgressHUD *)showProgress
{
    return [self showProgressToView:nil];
}


/**
 不带文字的菊花（指定view）
 */
+ (MBProgressHUD *)showProgressToView:(UIView *)view
{
    return [self showProgressMessage:@"" toView:view];
}


/**
 带文字的菊花
 */
+ (MBProgressHUD *)showProgressMessage:(NSString *)message
{
    return [self showProgressMessage:message toView:nil];
}


/**
 带文字的菊花（指定view）
 */
+ (MBProgressHUD *)showProgressMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
//    hud.animationType = MBProgressHUDAnimationFade;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    return hud;
}


/**
 隐藏所有提示
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


/**
 隐藏指定view的提示
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}


/**
 隐藏所有提示
 */
+ (NSUInteger)hideAllHUD
{
    return [self hideAllHUDForView:nil];
}


/**
 隐藏指定view的所有提示

 */
+ (NSUInteger)hideAllHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    for (MBProgressHUD *hud in huds) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES];
    }
    return huds.count;
}



#pragma mark - 统一调用
+ (void)showMessage:(NSString *)message hudImage:(NSString *)hudImage toView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD_Tools_cc.bundle/%@", hudImage]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}




@end
