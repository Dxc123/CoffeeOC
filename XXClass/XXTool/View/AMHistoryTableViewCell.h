//
//  HistoryTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/27.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMHistoryDetailModel.h"
#import "AMHistoryModel.h"

@interface AMHistoryTableViewCell : UITableViewCell

@property(strong,nonatomic)AMHistoryDetailModel *detailModel;
@property(strong,nonatomic)AMHistoryModel *hisModel;
@property(assign,nonatomic)int markID;


@end
