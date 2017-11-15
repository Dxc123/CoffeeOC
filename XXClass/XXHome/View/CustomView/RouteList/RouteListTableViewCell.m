//
//  RouteListTableViewCell.m
//  test
//
//  Created by 岳杰 on 2016/12/20.
//  Copyright © 2016年 岳杰. All rights reserved.
//

#import "RouteListTableViewCell.h"
//#import "DayHeader.h"

@implementation RouteListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
        //分割线
        UIView *linView=[[UIView alloc] init];
        [self.contentView addSubview:linView];
        linView.backgroundColor=separeLineColor;
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(1 * UISCALE);
        }];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(11 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(19 * UISCALE);
        make.width.mas_equalTo(26 * UISCALE);
        make.height.mas_equalTo(26 * UISCALE);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right).offset(11 * UISCALE);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-11 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20 * UISCALE);
        make.height.mas_equalTo(25 * UISCALE);
    }];
    
    

    
    
    
    
    
}



#pragma mark setters and getters
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = FontNotoSansLightWithSafeSize(17);
    }
    return _titleLabel;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.image = IMAGE(@"ic_duigou");
        self.imgView.hidden = YES;
    }
    return _imgView;
}

@end
