//
//  XXRouteListModel.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/28.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXRouteListModel : NSObject
@property (nonatomic, assign) NSInteger  companyId;

@property (nonatomic, strong) NSString * createTime;

@property (nonatomic, assign) NSInteger dayReplenishCount;

@property (nonatomic, assign) NSInteger routeId;

@property (nonatomic, strong) NSString * image;

@property (nonatomic, assign) NSInteger routeManager ;

@property (nonatomic, strong) NSString * routeName;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
//companyId = 100000;
//createTime = "2016/10/10 11:47:31";
//dayReplenishCount = 0;
//machineCount = "<null>";
//machineInfoList = "<null>";
//routeDesc = "";
//routeId = 0;
//routeManager = 100000;
//routeName = "\U534e\U4e1a\U7ebf\U8def";
//stockupFlg = False;

//error = "\U8bf7\U6c42\U5df2\U7ecf\U6b63\U5e38\U5904\U7406";
//"error_code" = 00000;
//request = "api/home/routelist/100000";
