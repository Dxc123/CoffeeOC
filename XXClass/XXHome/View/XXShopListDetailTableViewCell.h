//
//  XXShopListDetailTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/20.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShopNumberChangedBlock)(NSInteger number);
typedef void(^ShopCellSelectedBlock)(BOOL select);
@interface XXShopListDetailTableViewCell : UITableViewCell
//商品数量
@property (assign,nonatomic)NSInteger shopNumber;
@property (assign,nonatomic)BOOL shopSelected;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//数量
@property (nonatomic,retain)UILabel *numberLabel;


- (void)numberAddWithBlock:(ShopNumberChangedBlock)block;
- (void)numberCutWithBlock:(ShopNumberChangedBlock)block;

@end
