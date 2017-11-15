//
//  GoodsTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "GoodsTableViewCell.h"


#define BLUE_COLOR [UIColor colorWithRed:68/255.0 green:138/255.0 blue:255/255.0 alpha:1] 

@implementation GoodsTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.goodsStateLabel];
        [self.contentView addSubview:self.goodsInfoLabel];
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.goodsStateLabel.text isEqualToString:@"正常"]) {
        self.goodsStateLabel.backgroundColor = BLUE_COLOR;
        self.goodsStateLabel.textColor = [UIColor whiteColor];

    }else{
        self.goodsStateLabel.backgroundColor = [UIColor whiteColor];
        self.goodsStateLabel.textColor = BLUE_COLOR;

    } 

    [self.goodsStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(22 * UISCALE);
        if (self.isLive) {
            make.width.mas_equalTo(0);
        } else {
            make.width.mas_equalTo(34 * UISCALE);
        }
        make.height.mas_equalTo(21 * UISCALE);
    }];
    
    [self.goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsStateLabel.mas_right).offset(10 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(11 * UISCALE);
        make.height.mas_equalTo(42 * UISCALE);
        make.width.mas_equalTo(209 * UISCALE);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20 * UISCALE);
        make.left.mas_equalTo(self.goodsStateLabel.mas_right);
        make.top.mas_equalTo(self.goodsStateLabel.mas_top);
        make.height.mas_equalTo(self.goodsStateLabel.mas_height);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = LINE_COLOR;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(64 * UISCALE - 0.4);
        make.height.mas_equalTo(0.4);
    }];
}

#pragma mark setters and getters
- (UILabel *)goodsStateLabel
{
    if (_goodsStateLabel == nil) {
        self.goodsStateLabel = [[UILabel alloc] init];
        self.goodsStateLabel.font = FontNotoSansLightWithSafeSize(13);
        self.goodsStateLabel.textAlignment = NSTextAlignmentCenter;
        self.goodsStateLabel.layer.borderColor = [BLUE_COLOR CGColor];
        self.goodsStateLabel.layer.borderWidth = 0.5;
        self.goodsStateLabel.layer.masksToBounds = YES;
        self.goodsStateLabel.layer.cornerRadius = 2;
    }
    return _goodsStateLabel;
}

- (UILabel *)goodsInfoLabel
{
    if (_goodsInfoLabel == nil) {
        self.goodsInfoLabel = [[UILabel alloc] init];
        self.goodsInfoLabel.font = FontNotoSansLightWithSafeSize(14);
        self.goodsInfoLabel.numberOfLines = 2;
    }
    return _goodsInfoLabel;
}

- (UILabel *)numLabel
{
    if (_numLabel == nil) {
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.font = FontNotoSansLightWithSafeSize(14);
        self.numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}

@end
