//
//  TitleAndCountView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "TitleAndCountView.h"
//#import "DayHeader.h"

@implementation TitleAndCountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupSubviewsProperty];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat halfHeader = SCREEN_WIDTH / 2;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 88 * UISCALE - 0.5, SCREEN_WIDTH, 0.5)];
    [self addSubview:bottomLine];
    bottomLine.tag = 1000;
    bottomLine.backgroundColor = RGB(210, 210, 210);
    
    self.leftTitleLabel = [[UILabel alloc] init];
    [self addSubview:self.leftTitleLabel];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.width.mas_equalTo(halfHeader - 32 * UISCALE);
        make.top.mas_equalTo(self.mas_top).offset(12 * UISCALE);
        make.height.mas_equalTo(16 * UISCALE);
    }];
    
    self.leftCountLabel = [[UILabel alloc] init];
    [self addSubview:self.leftCountLabel];
    [self.leftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTitleLabel.mas_left);
        make.right.mas_equalTo(self.leftTitleLabel.mas_right);
        make.top.mas_equalTo(self.leftTitleLabel.mas_bottom).offset(14 * UISCALE);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-14 * UISCALE);
    }];
    
    self.rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * UISCALE, 12 * UISCALE, halfHeader - 32 * UISCALE, 20 * UISCALE)];
    [self addSubview:self.rightTitleLabel];
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
        make.width.mas_equalTo(halfHeader - 32 * UISCALE);
        make.top.mas_equalTo(self.mas_top).offset(12 * UISCALE);
        make.height.mas_equalTo(16 * UISCALE);
    }];
    
    // 不补货损失label布局
    self.rightCountLabel = [[UILabel alloc] init];
    [self addSubview:self.rightCountLabel];
    [self.rightCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightTitleLabel.mas_left);
        make.right.mas_equalTo(self.rightTitleLabel.mas_right);
        make.top.mas_equalTo(self.rightTitleLabel.mas_bottom).offset(14 * UISCALE);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-14 * UISCALE);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor =RGB(210, 210, 210);
    lineView.tag = 1001;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.left.mas_equalTo(halfHeader);
        make.top.mas_equalTo(self.mas_top).offset(12 * UISCALE);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-11 * UISCALE);
    }];
}

- (void)setupSubviewsProperty {
    self.leftTitleLabel.font = FontNotoSansLightWithSafeSize(15);
//    self.leftTitleLabel.textColor = [UIColor grayColor];
    
    self.leftCountLabel.textAlignment = NSTextAlignmentCenter;
    self.leftCountLabel.font = FontNotoSansLightWithSafeSize(24);
//    self.leftCountLabel.textColor = RGB(245, 166, 35);
    
    self.rightTitleLabel.font = FontNotoSansLightWithSafeSize(15);
//    self.rightTitleLabel.textColor = [UIColor grayColor];
    
    self.rightCountLabel.textAlignment = NSTextAlignmentCenter;
    self.rightCountLabel.font = FontNotoSansLightWithSafeSize(24);
//    self.rightCountLabel.textColor = RGB(245, 166, 35);
}

- (void)setHideLine:(BOOL)hideLine {
    UIView *line = [self viewWithTag:1001];
    line.hidden = hideLine;
    UIView *bottomLine = [self viewWithTag:1000];
    bottomLine.hidden = hideLine;
}

- (void)setTitleColor:(UIColor *)color {
    self.leftTitleLabel.textColor = color;
    self.rightTitleLabel.textColor = color;
}

- (void)setCountColor:(UIColor *)color {
    self.leftCountLabel.textColor = color;
    self.rightCountLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font {
    self.leftTitleLabel.font = font;
    self.rightTitleLabel.font = font;
}

- (void)setCountFont:(UIFont *)font {
    self.leftCountLabel.font = font;
    self.rightCountLabel.font = font;
}

- (void)setTitleAlignment:(NSTextAlignment)alignment {
    self.leftTitleLabel.textAlignment = alignment;
    self.rightTitleLabel.textAlignment = alignment;
}

@end
