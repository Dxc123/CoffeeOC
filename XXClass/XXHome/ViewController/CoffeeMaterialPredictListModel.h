//
//  CoffeeMaterialPredictListModel.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/13.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
//咖啡机物料使用情况

@interface CoffeeMaterialPredictListModel : NSObject
@property (nonatomic, copy) NSString *roadNo;//货道号

@property (nonatomic, copy) NSString *roadNum;//货道容量

@property (nonatomic, copy) NSString *roadName;//货道货物名称

@property (nonatomic, copy) NSString *materialName;//物料名称

@property (nonatomic, copy) NSString *amount;//出货总量

@end
