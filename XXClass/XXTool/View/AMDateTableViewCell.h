//
//  DateTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDateModel.h"
#import "AMDetailModel.h"
#import "AMAccountModel.h"
#import "AMAccHisModel.h"

@interface AMDateTableViewCell : UITableViewCell

@property(strong,nonatomic)AMDateModel *model;
@property(strong,nonatomic)AMDetailModel *detailModel;
@property(strong,nonatomic)AMAccountModel *accountModel;
@property(strong,nonatomic)AMAccHisModel *accHisModel;

@property(assign,nonatomic)int selectChoose;
@end
