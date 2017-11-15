//
//  AMDataBaseTool.m
//  Created by xuxiwen on 2017/3/31.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

#import "AMDataBaseTool.h"
#import <FMDatabase.h>
#import "AMNotificationModel.h"


static FMDatabase *__db;

@implementation AMDataBaseTool

//创建数据库
+ (void)createWorningNotificationSqlite{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data.sqlite"];
    __db = [FMDatabase databaseWithPath:path];
    [__db open];
    if ([__db open]) {
        NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
        [__db executeUpdate:[NSString stringWithFormat:@"create table if not exists notification%@(id integer primary key autoincrement,problem text not null,adress text not null,date text not null,isRead text not null);",managerID]];
    }
    [__db close];
}

//插入数据库新的数据        date格式 "2017-02-17 18:04:27"
+ (void)insertDataWithName:(NSString *)title Andtime:(NSString *)date andAdress:(NSString *)adress{
    [__db open];
     NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    [__db executeUpdate:[NSString stringWithFormat:@"insert into notification%@(problem,adress,date,isRead) values ('%@','%@','%@','0');",managerID,title,adress,date]];
    [__db close];
    
}
//查询所有的数据库，读取所有数据
+ (NSMutableArray *)queryAllSqlite{
    NSMutableArray *dataArr = [NSMutableArray array];
    [__db open];
     NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    FMResultSet *set = [__db executeQuery:[NSString stringWithFormat:@"select * from notification%@ order by id desc;",managerID]];
    while (set.next) {
        AMNotificationModel *model = [[AMNotificationModel alloc]init];
        model.isRead = [set stringForColumn:@"isRead"];
        model.adressStr = [set stringForColumn:@"adress"];
        model.timeStr = [set stringForColumn:@"date"];
        model.titleStr = [set stringForColumn:@"problem"];
        model.ID = [set stringForColumn:@"id"];
        model.isSelect = NO;
        model.isChoose = NO;
        [dataArr addObject:model];
    }
    
    return dataArr;
}

//更新已读消息的标记
+ (BOOL)updateToAleradyReadWithID:(int)ID{
    
    [__db open];
    NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    [__db executeUpdate:[NSString stringWithFormat:@"update notification%@ set isRead = '1' where id = '%d';",managerID,ID]];
    [__db close];
    
    return YES;
}

//查询所有未读消息条数
+ (int)queryWithNoRead{
    
    int i = 0;
    [__db open];
    NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    FMResultSet *set = [__db executeQuery:[NSString stringWithFormat:@"select * from notification%@ where isRead = '0';",managerID]];
    while (set.next) {
        i = i+1;
    }
    [__db close];
    return i;
    
}

//全部已读状态
+ (void)reMarkAllDataWithReaded{
    
    [__db open];
    NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    [__db executeUpdate:[NSString stringWithFormat:@"update notification%@ set isRead = '1';",managerID]];
    [__db close];
    
}


+ (void)cleanAllDate{
    [__db open];
    NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    [__db executeUpdate:[NSString stringWithFormat:@"delete from notification%@;",managerID]];
    [__db close];
}

+ (void)cleanDataForAleardyReadWithID:(int)ID{
    [__db open];
    NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    [__db executeUpdate:[NSString stringWithFormat:@"delete from notification%@ where id = '%d';",managerID,ID]];
    [__db close];
}





#pragma mark------添加30mine之后接收到通知，(别的消息只会触发一次，这个主要是针对断网的提示)-------------

//根据路线点位查询本地数据的记录的时间字符串
+ (NSString *)queryWithAdress:(NSString *)adress{
    NSString *timeStr;
    [__db open];
    NSString *managerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"managerId"];
    FMResultSet *set = [__db executeQuery:[NSString stringWithFormat:@"select * from notification%@ where adress = '%@';",managerID,adress]];
    while (set.next) {
        timeStr = [set stringForColumn:@"adress"];
    }
    return timeStr;
}

//读取现在的时间
+ (NSString *)dateStrForNow{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeNowStr = [df stringFromDate:now];
    
    
    return timeNowStr;
}

//比较时间间隔是否为30min  NO表示不大于，YES表示大于
+ (BOOL)compareWithOldTime:(NSString *)oldTime{
    
    BOOL istimeIntervalBig;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* toDate   = [dateFormatter dateFromString:oldTime];
    
    NSDate*  startDate    = [ [ NSDate alloc] init ];
    
    NSCalendar* chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute  | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    
    NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:toDate  toDate:startDate  options:0];
    NSInteger timeInterval = ((([cps year]*12+[cps month])*30+[cps day])*24+[cps hour])*60+[cps minute];
    if (timeInterval>30) {
        istimeIntervalBig = YES;
    }else{
        istimeIntervalBig = NO;
    }
    
    return istimeIntervalBig;
    
}



@end
