//
//  NetWorkManager.h
//
//  Created by Dxc_iOS on 16/5/26.
//  Copyright © 2016年 FEIYUE. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求成功回调block
typedef void(^SuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^FailureBlock)(NSError *error);
//网络监测回调Block
typedef void(^netStateBlock)(NSInteger netState);
//请求方法define
typedef enum {
    GET,
    POST
} HTTPMethod;




@interface NetWorkManager : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

/**
 GET网络请求
 @param urlString  url地址
 @param parameters url参数  NSDictionary类型
 @param successBlock 请求成功 返回NSDictionary或NSArray
 @param failureBlock 请求失败 返回NSError
 */
+ (void)getWithURLString:(NSString *)urlString
              parameters:(id)parameters
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/**
 POST网络请求
 @param urlString    url地址
 @param parameters   url参数  NSDictionary类型
 @param successBlock 请求成功 返回NSDictionary或NSArray
 @param failureBlock 请求失败 返回NSError
 */

+ (void)postWithURLString:(NSString *)urlString
               parameters:(id)parameters
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;
/**
 自主选择的带菊花的post请求
 @param urlString     url地址
 @param hud           是否显示菊花圈圈
 @param parameters    url参数  NSDictionary类型
 @param successBlock  请求成功 返回NSDictionary或NSArray
 @param failureBlock  请求失败 返回NSError
 */
//+(void)postWithURLString:(NSString *)urlString hud:(BOOL)hud
//              parameters:(id)parameters
//                 success:(SuccessBlock)successBlock
//                 failure:(FailureBlock)failureBlock;
//

/***************************************************/
// 原生网络请求
/**
 原生网络请求GET

 @param urlString url地址
 @param parameters url参数  NSDictionary类型
 @param successBlock 请求成功 返回NSDictionary或NSArray
 @param failureBlock 请求失败 返回NSError
 */
//+(void)getIOSWithURLString:(NSString *)urlString
//              parameters:(id)parameters
//                   success:(SuccessBlock)successBlock
//                   failure:(FailureBlock)failureBlock;


/**
 原生网络请求POST
 @param urlString   url地址
 @param parameters  url参数  NSDictionary类型
 @param successBlock   请求成功 返回NSDictionary或NSArray
 @param failureBlock    请求失败 返回NSError
 */

//+(void)postIOSWithURLString:(NSString *)urlString
//                 parameters:(id)parameters
//                    success:(SuccessBlock)successBlock
//                    failure:(FailureBlock)failureBlock;


//

/***************************************************
 网络请求

 @param URLString url地址
 @param parameters url参数
 @param progress   。。。。。
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(id downloadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;



+ (void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(id downloadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
