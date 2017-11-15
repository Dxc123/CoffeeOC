//
//  XXCreateShopInfoTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXCreateShopInfoTableViewCell : UITableViewCell
typedef void(^shopCellSelectedBlock)(BOOL select);
//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;

@property (nonatomic,retain) UILabel * machineID;
@property (nonatomic,retain)UILabel *address;
- (void)cellSelectedWithBlock:(shopCellSelectedBlock)block;

@end
