//
//  AMPlacehoderView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/29.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXPlacehoderView.h"


@interface XXPlacehoderView ()

@property (nonatomic, strong) UIImageView *emptyView;

@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation XXPlacehoderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.emptyView];
        [self addSubview:self.emptyLabel];
        [self addSubview:self.refreshBtn];
        self.isSearch = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.emptyView.frame = CGRectMake(0, 0, 68 * UISCALE, 68 * UISCALE);
    self.emptyView.center = CGPointMake(self.center.x, self.center.y - 64);
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.emptyView.mas_bottom).offset(25 * UISCALE);
        make.height.mas_equalTo(20);
    }];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(140 * UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-140 * UISCALE);
        make.top.mas_equalTo(self.emptyLabel.mas_bottom).offset(10 * UISCALE);
        make.height.mas_equalTo(44 * UISCALE);
    }];
}

#pragma mark - setters and getters
- (void)setIsSearch:(BOOL)isSearch
{
    if (isSearch) {
        self.emptyLabel.text = @"没找到符合条件的结果";
        self.refreshBtn.hidden = YES;
    } else {
        self.emptyLabel.text = @"网络出错啦，请点击按钮重新加载";
    }
}

- (UIImageView *)emptyView
{
    if (_emptyView == nil) {
        self.emptyView = [[UIImageView alloc] initWithImage:IMAGE(@"ic_empty")];
    }
    return _emptyView;
}

- (UILabel *)emptyLabel
{
    if (_emptyLabel == nil) {
        self.emptyLabel = [[UILabel alloc] init];
        self.emptyLabel.font = FontNotoSansLightWithSafeSize(14);
        self.emptyLabel.textAlignment = NSTextAlignmentCenter;
        self.emptyLabel.textColor = [UIColor lightGrayColor];
    }
    return _emptyLabel;
}

- (UIButton *)refreshBtn
{
    if (_refreshBtn == nil) {
        self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.refreshBtn.titleLabel.font = FontNotoSansLightWithSafeSize(15);
        self.refreshBtn.backgroundColor = [UIColor whiteColor];
        self.refreshBtn.layer.borderWidth = 0.5;
        self.refreshBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.refreshBtn.layer.cornerRadius = 3 * UISCALE;
    }
    return _refreshBtn;
}



@end
