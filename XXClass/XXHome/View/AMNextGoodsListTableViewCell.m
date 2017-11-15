//
//  AMNextGoodsListTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMNextGoodsListTableViewCell.h"


@implementation AMNextGoodsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.numBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.numBtn.tag = self.btnTag;
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(11 * UISCALE);
        make.height.mas_equalTo(42 * UISCALE);
        make.width.mas_equalTo(210 * UISCALE);
    }];
    
    [self.numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(17 * UISCALE);
        make.height.mas_equalTo(28 * UISCALE);
        make.width.mas_equalTo(90 * UISCALE);
    }];
    
    

}


#pragma mark - setters and getters
- (UILabel *)infoLabel
{
    if (_infoLabel == nil) {
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = FontNotoSansLightWithSafeSize(14);
        self.infoLabel.numberOfLines = 2;
    }
    return _infoLabel;
}

- (PPNumberButton *)numBtn
{
    if (_numBtn == nil) {
        self.numBtn = [[PPNumberButton alloc] init];
        self.numBtn.maxValue = 99;
        self.numBtn.minValue = 0;
        self.numBtn.increaseImage = IMAGE(@"add++");
        self.numBtn.decreaseImage = IMAGE(@"add--");
        self.numBtn.editing = NO;
        self.numBtn.decreaseHide=YES;
    }
    return _numBtn;
}
//-(void)withData:(NSDictionary *)info
//{
//    [_Goods_Circle setImage:Image(info[@"SelectedType"]) forState:UIControlStateNormal];
//    
//    [_Goods_Icon sd_setImageWithURL:[NSURL URLWithString:info[@"GoodsIcon"]] placeholderImage:Image(@"share_sina")];
//    _Goods_Desc.text = info[@"GoodsDesc"];
//    _Goods_NBCount.currentNumber = [info[@"GoodsNumber"] integerValue];
//    
//    
//    Selected = info[@"Type"];
//}

@end
