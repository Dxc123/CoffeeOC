//
//  XXAMNextGoodsListTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/6/8.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

@protocol ShopcatCellDelegate <NSObject>

@optional

//- (void)addProductCountActionWithIndex:(NSIndexPath *)indexPath;
//- (void)subProductCountActionWithIndex:(NSIndexPath *)indexPath;

-(void)ChangeGoodsNumberCell:(UITableViewCell *)cell Number:(NSInteger)num;
@end

@interface XXAMNextGoodsListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *infoLabel;


@property (nonatomic, strong) PPNumberButton *numBtn;

@property (nonatomic, assign) NSInteger btnTag;

//@property (nonatomic, strong) UIButton *subBtn;
//@property (nonatomic, strong) UITextField *conutText;
//@property (nonatomic, strong) UIButton *addBtn;
//@property (strong, nonatomic) NSIndexPath *indexPath;
//
@property (assign ,nonatomic) id<ShopcatCellDelegate> delegate;
@end
