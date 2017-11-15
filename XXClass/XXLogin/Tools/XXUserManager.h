//
//  XXUserManager.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/18.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXUserManager : NSObject
+ (instancetype)sharedUser;

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;

@property (nonatomic, copy) NSString *  managerTel;

@property (nonatomic, copy) NSString * managerId;
@property (nonatomic, copy) NSString * loginIdentifier;

@property (nonatomic, copy) NSString * managerEmail;


+ (BOOL)isAutoLogin;

+ (void)saveUser;
+ (void)isAutoLogout;

@end
