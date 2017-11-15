//
//  AMDataBaseTool.h

//
///  Created by xuxiwen on 2017/3/31.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMDataBaseTool : NSObject

//创建数据库
+ (void)createWorningNotificationSqlite;

//插入数据
+ (void)insertDataWithName:(NSString *)title Andtime:(NSString *)date andAdress:(NSString *)adress;

//查询数据
+ (NSMutableArray *)queryAllSqlite;

//修改数据变为已查看状态
+ (BOOL)updateToAleradyReadWithID:(int)ID;

//查询有多少未读；
+ (int)queryWithNoRead;

//编辑全部的数据状态未已读
+ (void)reMarkAllDataWithReaded;

//清除所有数据库数据
+ (void)cleanAllDate;

//清除所有已读数据
+ (void)cleanDataForAleardyReadWithID:(int)ID;


@end
