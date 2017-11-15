//
//  TaskModel.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/27.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTaskModel : NSObject


@property(copy,nonatomic)NSString *machineTypoe;

//0:撤机。 1:换线
@property(copy,nonatomic)NSString *applyType;
@property(copy,nonatomic)NSString *adressStr;
@property(copy,nonatomic)NSString *oldadressLine;
@property(copy,nonatomic)NSString *oldadressPoint;
@property(copy,nonatomic)NSString *newadressLine;
@property(copy,nonatomic)NSString *newadressPoint;

@end
