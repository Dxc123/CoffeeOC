//
//  CheckNewVersion.m
//  CheckNewVersion
//
//  Created by lalala on 2017/4/20.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "CheckNewVersion.h"
#import "AppleStoreModelInfo.h"

@interface CheckNewVersion ()
//本地info文件
@property(nonatomic,strong) NSDictionary * infoDict;

@end

@implementation CheckNewVersion
#pragma mark -- 懒加载字典
-(NSDictionary *)infoDict{
    if (_infoDict == nil) {
        _infoDict = [NSBundle mainBundle].infoDictionary;
    }
    return _infoDict;
}
#pragma mark -- 创建单例
+(instancetype)shareManager {
    static CheckNewVersion * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
+(void)checkNewVersionWithAppID:(NSString *)appID controller:(UIViewController *)viewController{
    [[self shareManager] checkNewVersionAppID:appID controller:viewController];
}

+(void)checkNewVersionWithAppID:(NSString *)appID customAlert:(CheckNewVersionBlock)checkVersionBlock{
    [[self shareManager] getAppStoreVersion:appID success:^(AppleStoreModelInfo *model) {
        if (checkVersionBlock) {
            checkVersionBlock(model);
        }
    }];
}
//检查版本号
-(void)checkNewVersionAppID:(NSString *)appID controller:(UIViewController *)controller{
    [self getAppStoreVersion:appID success:^(AppleStoreModelInfo * model) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新的版本(%@)",model.version] message:model.releaseNotes preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * updateAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateRightNow:model];
        }];
        UIAlertAction * delayAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction * ignoreAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self ignoreNewVersion:model.version];
        }];
        
        [alertController addAction:updateAction];
        [alertController addAction:delayAction];
        [alertController addAction:ignoreAction];
        [controller presentViewController:alertController animated:YES completion:nil];
    }];
}
//立即升级到最新版本
-(void)updateRightNow:(AppleStoreModelInfo *)model {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.trackViewUrl]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.trackViewUrl] options:@{} completionHandler:nil];
    }
}
//忽略新版本
-(void)ignoreNewVersion:(NSString *)version {
    //保存忽略的版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ingoreVersion"];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取App Store上的版本信息
-(void)getAppStoreVersion:(NSString *)appID success:(void(^)(AppleStoreModelInfo*))success{
    [self getAppStoreInfo:appID success:^(NSDictionary * respDict) {
        NSInteger resultCount = [respDict[@"resultCount"] integerValue];
        if (resultCount == 1) {
            NSArray * results = respDict[@"results"];
            NSDictionary * appStoreInfo = [results firstObject];
            
            //字典转模型
            AppleStoreModelInfo * model = [[AppleStoreModelInfo alloc]init];
            [model setValuesForKeysWithDictionary:appStoreInfo];
            //提示是否更新
            BOOL result = [self isEqualUpdate:model.version];
            if (result) {
                if (success) {
                    success(model);
                }
            }
        } else {
#ifdef DEBUG
            NSLog(@"AppStore上面没有找到对应id的App");
#endif
        }
    }];
}
//返回是否提示更新
-(BOOL)isEqualUpdate:(NSString *)newVersion{
    NSString * ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ingoreVersion"];
    if ([self.infoDict[@"CFBundleShortVersionString"] compare:newVersion] == NSOrderedSame || [self.infoDict[@"CFBundleShortVersionString"] compare:newVersion] == NSOrderedDescending
        || [ignoreVersion isEqualToString:newVersion]) {
        return NO;
    } else {
        return YES;
    }
}
//获取App Store的info信息
// https://itunes.apple.com/us/app/%E7%B1%B3%E5%85%8B%E5%B1%8B%E8%BF%90%E8%90%A5/id1282951128?l=zh&ls=1&mt=8

-(void)getAppStoreInfo:(NSString *)appID success:(void(^)(NSDictionary *))success{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",appID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (error == nil && data != nil && data.length > 0) {
               NSDictionary * respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
#ifdef DEBUG
               NSLog(@"%@",respDict);
#endif
               if (success) {
                   success(respDict);
               }
           }
       });
    }] resume];
}
@end
