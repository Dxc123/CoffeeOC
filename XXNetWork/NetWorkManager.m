//
//  NetWorkManager.m

//
//  Created by Dxc_iOS on 16/5/26.
//  Copyright © 2016年 FEIYUE. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD.h"
#import "APIConfig.h"

#define SERVER_HOST @""
NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
static NSString * kBaseUrl = SERVER_HOST;

@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient {
    
    static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:configuration];
        //申明请求的数据是json类型
//        client.requestSerializer=[AFJSONRequestSerializer serializer];
        //接收参数类型 json
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 15;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    
    return client;
}

@end

@implementation NetWorkManager

#pragma mark--> GET网络请求

+(void)getWithURLString:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    
    //完整URL
    NSString *str = [NSString string];
    if (parameters) {
        NSString * url = [kBaseUrl stringByAppendingPathComponent:urlString];
        
        //参数拼接url
        str = [url stringByAppendingString:[self dealWithParam:parameters]];
        
        
    }else{
        str = urlString;
    }

  
    [[AFHttpClient sharedClient] GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];

            successBlock(dic);


        }
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
            NSLog(@"网络异常 - T_T%@", error);
        }
        
    }];
    
    
}


#pragma mark-->POST网络请求

+(void)postWithURLString:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    //获取完整的url路径
//    NSString * url = [kBaseUrl stringByAppendingPathComponent:urlString];
    [[AFHttpClient sharedClient] POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            successBlock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
            NSLog(@"网络异常 - T_T%@", error);
        }

    }];
    
    
}

/*
#pragma mark-->iOS  原生网络请求GET
+(void)getIOSWithURLString:(NSString *)urlString
                parameters:(id)parameters
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock{
   
    //完整URL
    NSString *str = [NSString string];
    if (parameters) {
//        //参数拼接url
//        NSString *paramStr = [self dealWithParam:parameters];
//        str = [urlString stringByAppendingString:paramStr];
        //获取完整的url路径
        NSString * url = [kBaseUrl stringByAppendingPathComponent:urlString];
        
        //参数拼接url
        str = [url stringByAppendingString:[self dealWithParam:parameters]];
        

    }else{
        str = urlString;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = 3;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                successBlock(dict);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failureBlock(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failureBlock(ErrorCode);
                }
            }
            
        });
    }];
    
    [task resume];

    
}
*/
/*
#pragma mark-->iOS 原生网络请求POST
+(void)postIOSWithURLString:(NSString *)urlString
                 parameters:(id)parameters
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{
    //将请求地址字符串转成NSData类型
    NSURL * URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // 因为参数是以字典的形式传进来的，所以用了一个 dealWithParam 方法拼接参数
    //    （特别注意使用的时候参数必须是以字典的形式）
    NSString *paramStr= [self dealWithParam:parameters];
    
    
    //将请求参数字符串转成NSData类型
    NSData * postData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    request.timeoutInterval = 20; // 设置本次请求的最长时间
    // 设置本次请求的提交数据格式
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
    [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"请求成功%@",data);
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                 successBlock(dic);
                
                
            }else{
                
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                     failureBlock(ResponseStr);
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                      failureBlock(ErrorCode);
                }
                
            }
            
            
        });
        
        
    }];
    
    
    [task resume];
    

}

*/




//iOS 原生网络请求
#pragma mark-->iOS 原生网络请求 ======= 拼接参数

// 处理字典参数
+ (NSString *)dealWithParam:(NSDictionary *)param
{
    NSArray *allkeys = [param allKeys];
    
    NSMutableString *result = [NSMutableString string];
    
    for (NSString *key in allkeys) {
        
//        NSString *str = [NSString stringWithFormat:@"%@=%@&",key,param[key]];
       // http://118.190.44.110:7776/api/user/zhouxiang/password/123456
        NSString *str = [NSString stringWithFormat:@"/%@/%@",key,param[key]];
        
        
        //将返回字符串去掉指定字符串：managerId
        NSString *strhtml =[str stringByReplacingOccurrencesOfString:@"managerId" withString:@""];
        
        
        [result appendString:strhtml];
    }
    
//    return [result substringWithRange:NSMakeRange(0, result.length-1)];
     return result;
   }


#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
    
    NSString *message = nil;
    switch (statusCode) {
        case 401: {
            
        }
            break;
            
        case 500: {
            message = @"服务器异常！";
        }
            break;
            
        case -1001: {
            message = @"网络请求超时，请稍后重试！";
        }
            break;
            
        case -1002: {
            message = @"不支持的URL！";
        }
            break;
            
        case -1003: {
            message = @"未能找到指定的服务器！";
        }
            break;
            
        case -1004: {
            message = @"服务器连接失败！";
        }
            break;
            
        case -1005: {
            message = @"连接丢失，请稍后重试！";
        }
            break;
            
        case -1009: {
            message = @"互联网连接似乎是离线！";
        }
            break;
            
        case -1012: {
            message = @"操作无法完成！";
        }
            break;
            
        default: {
            message = @"网络请求发生未知错误，请稍后再试！";
        }
            break;
    }
    return message;
    
}

  #pragma mark  /****************************************/


+(void)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(id))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    config.timeoutIntervalForRequest = 15.0;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    manager.requestSerializer = requestSerializer;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


+(void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(id))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 获取http请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}









@end
