//
//  AMCheJiTableViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMAccountModel.h"
@protocol TestCellDelegate <NSObject>

- (void)SelectedCell:(UIButton*)sender;

@end

@interface AMCheJiTableViewCell : UITableViewCell

@property(strong,nonatomic)AMAccountModel *model;

/**
*  点击按钮（可以换成imageView不过点击事件就要改成手势了）
*/
@property (strong,nonatomic) UIButton *testBtn;
/**
 *  cell选项文本
 */
@property (strong,nonatomic) UILabel *testLb;

@property (weak,nonatomic) id<TestCellDelegate>delegate;

@end
