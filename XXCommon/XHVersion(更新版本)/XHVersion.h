//
//  XHVersion.h
//  XHVersionExample
//
//  Created by zhuxiaohui on 2016/11/22.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHVersion

#import <Foundation/Foundation.h>
#import "XHAppInfo.h"

typedef void(^NewVersionBlock)(XHAppInfo *appInfo);

@interface XHVersion : NSObject
/*
//请在你需要检测更新的位置添加下面代码(可首页添加)

//1.新版本检测(使用默认提示框)
[XHVersion checkNewVersion];

//2.如果你需要自定义提示框,请使用下面方法
[XHVersion checkNewVersionAndCustomAlert:^(XHAppInfo *appInfo) {
    
    //appInfo为新版本在AppStore相关信息
    //请在此处自定义您的提示框
    NSLog(@"新版本信息:\n 版本号 = %@ \n 更新时间 = %@\n 更新日志 = %@ \n 在AppStore中链接 = %@\n AppId = %@ \n bundleId = %@" ,appInfo.version,appInfo.currentVersionReleaseDate,appInfo.releaseNotes,appInfo.trackViewUrl,appInfo.trackId,appInfo.bundleId);
    
}];

*/



/**
 *  检测新版本(使用默认提示框)
 */
+(void)checkNewVersion;

/**
 *  检测新版本(自定义提示框)
 *
 *  @param newVersion 新版本信息回调
 */
+(void)checkNewVersionAndCustomAlert:(NewVersionBlock)newVersion;

@end
