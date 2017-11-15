//
//  AccountModel.h
//  ZSAgencyManage
//
//  Created by CSX on 2016/12/24.
//  Copyright © 2016年 宗盛商业. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMAccountModel : NSObject

//这个属性在撤机换线中使用
@property(assign,nonatomic)BOOL isSelect;

@property(copy,nonatomic)NSString *machineType;
@property(copy,nonatomic)NSString *moneyAccount;
@property(copy,nonatomic)NSString *adressStr;

@end
