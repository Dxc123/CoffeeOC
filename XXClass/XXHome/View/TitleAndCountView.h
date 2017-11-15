//
//  TitleAndCountView.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleAndCountView : UIView

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) UILabel *rightTitleLabel;

@property (nonatomic, strong) UILabel *leftCountLabel;

@property (nonatomic, strong) UILabel *rightCountLabel;

@property (nonatomic, assign) BOOL hideLine;

- (void)setTitleColor:(UIColor *)color;

- (void)setCountColor:(UIColor *)color;

- (void)setTitleFont:(UIFont *)font;

- (void)setCountFont:(UIFont *)font;

- (void)setTitleAlignment:(NSTextAlignment)alignment;

@end
