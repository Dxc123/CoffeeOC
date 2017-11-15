//
//  CheckNewVersion.h
//  CheckNewVersion
//
//  Created by lalala on 2017/4/20.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AppleStoreModelInfo;

typedef void(^CheckNewVersionBlock)(AppleStoreModelInfo * appInfomation);

@interface CheckNewVersion : NSObject
/**
 *  检测新版本(使用系统默认提示框)
 *
 *  appID:应用在Store里面的ID (应用的AppStore地址里面可获取)
 *  viewController: 提示框显示在哪个控制器上
 */
+(void)checkNewVersionWithAppID:(NSString *)appID controller:(UIViewController *)viewController;
/**
 *  检测新版本(使用自定义提示框)
 *
 *  @param appID (应用的AppStore地址里面可获取)appID应用在Store里面的ID
 *  @param checkVersionBlock AppStore上版本信息回调block
 */
+(void)checkNewVersionWithAppID:(NSString *)appID customAlert:(CheckNewVersionBlock)checkVersionBlock;
@end
