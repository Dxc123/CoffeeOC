//
//  XXNextGoodsListTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/6/4.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXNextGoodsListTableViewCell.h"

@implementation XXNextGoodsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.numlab];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.numBtn.tag = self.btnTag;
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(11 * UISCALE);
        make.height.mas_equalTo(42 * UISCALE);
        make.width.mas_equalTo(210 * UISCALE);
    }];
    
    [self.numlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(0 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(17 * UISCALE);
        make.height.mas_equalTo(28 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
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

-(UILabel *)numlab{
    if (_numlab == nil) {
        self.numlab = [[UILabel alloc] init];
        self.numlab.font = FontNotoSansLightWithSafeSize(14);
        self.numlab.numberOfLines = 2;
    }
    return _numlab;
    
}
//- (PPNumberButton *)numBtn
//{
//    if (_numBtn == nil) {
//        self.numBtn = [[PPNumberButton alloc] init];
//        self.numBtn.maxValue = 99;
//        self.numBtn.minValue = 0;
//        self.numBtn.increaseImage = IMAGE(@"add++");
//        self.numBtn.decreaseImage = IMAGE(@"add--");
//        self.numBtn.editing = NO;
//        self.numBtn.decreaseHide=YES;
//    }
//    return _numBtn;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}







@end
