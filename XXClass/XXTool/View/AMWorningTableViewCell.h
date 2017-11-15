//
//  WorningTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMMachWorModel.h"
#import "AMWorTypeModel.h"

@interface AMWorningTableViewCell : UITableViewCell

@property(strong,nonatomic)AMMachWorModel *model;
@property(strong,nonatomic)AMWorTypeModel *typeModel;

/*
 0代表机器cell
 1代表类型cell
 */
@property(assign,nonatomic)int markID;

@end
