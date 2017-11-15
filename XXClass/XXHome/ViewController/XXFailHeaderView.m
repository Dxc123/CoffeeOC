//
//  XXNoMoneyheaderView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/21.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXFailHeaderView.h"

@implementation XXFailHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImage];
        [self addSubview:self.topLabel];
        [self addSubview:self.numLabel];
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 self.bgImage.sd_layout.widthIs(SCREEN_WIDTH).heightIs(self.frame.size.height).leftSpaceToView(self, 0).topSpaceToView(self, 0);
    
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15 * UISCALE);
    }];
    
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top).offset(60 * UISCALE);
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
    }];
    
    
    
    
    
    
}

#pragma mark setters and getters
- (UILabel *)topLabel
{
    if (_topLabel == nil) {
        self.topLabel = [[UILabel alloc] init];
        self.topLabel.font = FontNotoSansLightWithSafeSize(17);
        self.topLabel.textColor = [UIColor whiteColor];
        self.topLabel.textAlignment=NSTextAlignmentCenter;
        
    }
    return _topLabel;
}

- (UILabel *)numLabel
{
    if (_numLabel == nil) {
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.font = FontNotoSansLightWithSafeSize(48);
        self.numLabel.textColor = BLUE;//[UIColor whiteColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
-(UIImageView *)bgImage{
    
    if (!_bgImage) {
        _bgImage=[[UIImageView alloc] init];
//        _bgImage.image=IMAGE(@"wendu_icon");
    }
    return _bgImage;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
