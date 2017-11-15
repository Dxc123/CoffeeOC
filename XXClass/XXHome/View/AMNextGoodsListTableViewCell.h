//
//  AMNextGoodsListTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

@interface AMNextGoodsListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) PPNumberButton *numBtn;

@property (nonatomic, assign) NSInteger btnTag;



@end
