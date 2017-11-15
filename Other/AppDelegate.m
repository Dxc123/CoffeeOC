//
//  AppDelegate.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "XXMeViewController.h"
#import "XXBaseTabBarViewController.h"
#import "XXBaseNavViewController.h"
#import "XXSetEmailViewController.h"
#import "XXLoginViewController.h"
#import "XXUserManager.h"
#import "AMDataBaseTool.h"
#import <WRNavigationBar/WRNavigationBar.h>
//信鸽推送
#import "XGPush.h"
#import "AMNotificationModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate,XGPushDelegate>

@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    
    //配置HYBNetworking 
    [HYBNetworking updateBaseUrl:API_IP];
    [HYBNetworking enableInterfaceDebug:YES];
    // 设置GET、POST请求都缓存
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
    

    
//      1.  初始化信鸽
    //打开debug开关
    [[XGPush defaultManager] setEnableDebug:YES];
    //查看debug开关是否打开
//    BOOL debugEnabled = [[XGPush defaultManager] isEnableDebug];
    [[XGPush defaultManager] startXGWithAppID:2200269635 appKey:@"IRBG3JE5292K" delegate:self];

    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];


//       2. 注册苹果推送服务
    [self registerAPNS];
    [self autoLogin];//自动登录
    [self setSVProgressHUD];//设置全局SVProgressHUD
    [self setNavBarAppearence];//设置全局NavBar
    
    return YES;
}

//3.向信鸽注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //注册设备并且设置账号
     NSLog(@"[XGDemo] device token is %@", [[XGPushTokenManager defaultTokenManager] deviceTokenString]);

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoappoteNotificationsWithError:(NSError *)error {
//     NSLog(@" register APNS fail.\n[XGDemo] reason : %@", error);
    NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceFailed" object:nil];
}

/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"[XGDemo] receive Notification");
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}


// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
     NSLog(@"[XGDemo] click notification");
    
    [[XGPush defaultManager] reportXGNotificationInfo:response.notification.request.content.userInfo];
    
    completionHandler();
}


//  App在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self NotificationMessageForNotGet];//推送的消息
    
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}

#endif

- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
//        [self registerPush8to9];
    } else {
        // before iOS 8
//        [self registerPushBefore8];
    }
#else
    if (sysVer < 8) {
        // before iOS 8
//        [self registerPushBefore8];
    } else {
        // iOS 8-9
//        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

//- (void)registerPush8to9{
//    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//}
//
//- (void)registerPushBefore8{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    //
    [self NotificationMessageForNotGet];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)NotificationMessageForNotGet{
    //通知消息
    [XXToolHandle getMessagewithBlock:^(NSMutableArray *dataArr) {
        for (AMNotificationModel *model in dataArr) {
            [AMDataBaseTool insertDataWithName:model.titleStr Andtime:model.timeStr andAdress:model.adressStr];
        }
        if (dataArr.count>0) {
                             }
        
    }];
}

#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"%s, 启动信鸽服务 %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
}

#pragma mark - private method
- (void)autoLogin
{
    NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginIdentifier"];
    NSString *managerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerId"];
    [XXLoginHandle autoLoginWithManagerId:managerId loginId:loginId callback:^(BOOL isSuccess) {
        if (isSuccess) {
            [XXToolHandle getChangeXGTokenWith:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
            [AMDataBaseTool createWorningNotificationSqlite];
        
            
            self.window.rootViewController = [XXBaseTabBarViewController new];
//
//            XXBaseTabBarViewController *homeVC = [XXBaseTabBarViewController new];
//            XXBaseNavViewController *homeNav= [[XXBaseNavViewController alloc] initWithRootViewController:homeVC];
//
//             XXMeViewController  *leftVC = [XXMeViewController new];
//            XXBaseNavViewController *leftNav= [[XXBaseNavViewController alloc] initWithRootViewController:leftVC];
//            SWRevealViewController *swVC = [[SWRevealViewController alloc] initWithRearViewController:leftNav frontViewController:homeNav];
//            swVC.view.backgroundColor = [UIColor whiteColor];
//            RightViewController *rightVC = [RightViewController new];
//            swVC.rightViewController = rightVC;
            
            
//            self.window.rootViewController = swVC;

            
            
            
        } else {
            self.window.rootViewController = [[XXLoginViewController alloc] init];
            
        }
    }];
}

- (void)setSVProgressHUD
{
    [SVProgressHUD setSuccessImage:IMAGE(@"ic_check")];
    [SVProgressHUD setErrorImage:IMAGE(@"ic_error")];
    [SVProgressHUD setInfoImage:IMAGE(@"loding_icon")];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.6]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 30)];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

- (void)setNavBarAppearence
{
    
    UIColor *MainNavBarColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
//    UIColor *MainViewColor   = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:MainNavBarColor];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
     [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
}





@end
