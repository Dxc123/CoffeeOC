//
//  AMNotificationModel.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/27.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AMNotificationModel : NSObject

@property(copy,nonatomic)NSString *isRead;
@property(copy,nonatomic)NSString *titleStr;
@property(copy,nonatomic)NSString *adressStr;
@property(copy,nonatomic)NSString *timeStr;
@property(copy,nonatomic)NSString *ID;
//数据库删除 是否出现对应cell的删除选择框
@property(assign,nonatomic)BOOL isChoose;
//数据库删除 点击选中
@property(assign,nonatomic)BOOL isSelect;

@end
