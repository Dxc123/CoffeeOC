//
//  XXUserManager.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/18.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXUserManager.h"

@implementation XXUserManager
+ (instancetype)sharedUser {
    
    static XXUserManager * userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[XXUserManager alloc] init];
    });
    return userManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _username = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerName"];
        _managerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerId"];
        _managerTel = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerTel"];
        _managerEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"managerEmail"];
        _loginIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginIdentifier"];
        
        
        
    }
    return self;
}

+ (BOOL)isAutoLogin {
    
    if ([XXUserManager sharedUser].username.length == 0) {
        return NO;
    }
    return YES;
}

+ (void)saveUser {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[XXUserManager sharedUser].username forKey:@"managerName"];
     [[NSUserDefaults standardUserDefaults] setObject:[XXUserManager sharedUser].managerId forKey:@"managerId"];
     [[NSUserDefaults standardUserDefaults] setObject:[XXUserManager sharedUser].managerTel forKey:@"managerTel"];
     [[NSUserDefaults standardUserDefaults] setObject:[XXUserManager sharedUser].managerEmail forKey:@"managerEmail"];
    [[NSUserDefaults standardUserDefaults] setObject:[XXUserManager sharedUser].loginIdentifier forKey:@"loginIdentifier"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)isAutoLogout{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"managerName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"managerId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"managerTel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"managerName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"managerEmail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginIdentifier"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
}

@end
