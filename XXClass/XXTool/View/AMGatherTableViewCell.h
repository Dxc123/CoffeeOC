//
//  GatherTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGatherModel.h"
#import "AMShipModel.h"

@interface AMGatherTableViewCell : UITableViewCell

@property(strong,nonatomic)AMGatherModel *model;
@property(strong,nonatomic)AMShipModel *shipModel;


@property(assign,nonatomic)int selectIndex;
@end
