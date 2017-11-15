//
//  MachineCountCollectionViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "MachineCountCollectionViewCell.h"
#import <Masonry.h>


@implementation MachineCountCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupSubviewsProperty];
//        self.contentView.backgroundColor=[UIColor orangeColor];
    }
    return self;
}

- (void)setupSubviews
{
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"four_noNet_icon"]];
    [self.contentView addSubview:self.imgView];
    self.imgView.sd_layout.leftSpaceToView(self.contentView, 28*UISCALE).topSpaceToView(self.contentView, 20*UISCALE).widthIs(self.imgView.width*1.2*UISCALE).heightIs(self.imgView.height*1.5*UISCALE);
//    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(28 * UISCALE);
//        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-28 * UISCALE);
//        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(16 * UISCALE);
//        make.height.mas_equalTo(self.imgView.mas_width);
//    }];
    
    self.itemTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.itemTitleLabel];
    [self.itemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.frame.size.width);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(25 * UISCALE);
         make.left.mas_equalTo(self.contentView.mas_left).offset(-3 * UISCALE);
    }];
    
    self.countLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgView.mas_top).offset(-10 * UISCALE);
        make.right.mas_equalTo(self.imgView.mas_right).offset(10 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
}

- (void)setupSubviewsProperty {
    self.itemTitleLabel.textColor = [UIColor blackColor];
    self.itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.itemTitleLabel.font = FontNotoSansLightWithSafeSize(15);
    
    self.countLabel.backgroundColor = RGB(247, 76, 49);
    self.countLabel.font = FontNotoSansLightWithSafeSize(12);
    self.countLabel.layer.cornerRadius = 10 * UISCALE;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.alpha = 0.5;
    }else{
        self.alpha = 1;
    }
}

#pragma mark setters and getters
- (void)setCountText:(NSString *)countText
{
    self.countLabel.text = countText;
    if ([self.countLabel.text integerValue] > 99) {
        self.countLabel.hidden = NO;
        self.countLabel.text = @"99+";
    } else if ([self.countLabel.text integerValue] == 0) {
        self.countLabel.hidden = YES;
    } else {
        self.countLabel.hidden = NO;
    }
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([self.countLabel.text integerValue] > 0 && [self.countLabel.text integerValue] < 10) {
            make.width.mas_equalTo(20 * UISCALE);
        } else {
            make.width.mas_equalTo(30 * UISCALE);
        }
    }];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
