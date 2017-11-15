//
//  XXQuhuoHeaderView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/21.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXQuhuoHeaderView.h"

@interface XXQuhuoHeaderView ()
@property (nonatomic, strong) UIImageView *bgimage;
@property (nonatomic, strong) UILabel *machineSnLabel;

@property (nonatomic, strong) MarqueeLabel *positionLabel;
// 故障
@property (nonatomic, strong) UILabel *guzhangLabel;
// 补货
@property (nonatomic, strong) UILabel *buhuoLabel;
// 缺币
@property (nonatomic, strong) UILabel *quebiLabel;
// 断网
@property (nonatomic, strong) UILabel *duanwangLabel;


@end

@implementation XXQuhuoHeaderView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
        [self setupSubviewsProperty];
                

    }
    return self;
}

- (void)setupSubviews {
    
//    self.bgimage=[[UIImageView alloc] init];
//        [self addSubview:self.bgimage];
//    self.bgimage.image=IMAGE(@"noshopbg_icon");
//    self.bgimage.sd_layout.widthIs(SCREEN_WIDTH).heightIs(150*UISCALE).leftSpaceToView(self, 0*UISCALE).topSpaceToView(self, 0*UISCALE);
//    
    //    self.backgroundColor=BLUE;
    self.machineSnLabel = [[UILabel alloc] init];
    [self addSubview:self.machineSnLabel];
    [self.machineSnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.mas_top).offset(16 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    self.positionLabel = [[MarqueeLabel alloc] init];
    [self addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.machineSnLabel.mas_left);
        make.top.mas_equalTo(self.machineSnLabel.mas_bottom).offset(15* UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-10 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    self.guzhangLabel = [[UILabel alloc] init];
    self.guzhangLabel.text = @"故障";
    [self addSubview:self.guzhangLabel];
    [self.guzhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.machineSnLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    self.buhuoLabel = [[UILabel alloc] init];
    self.buhuoLabel.text = @"缺货";
    [self addSubview:self.buhuoLabel];
    [self.buhuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.guzhangLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    self.quebiLabel = [[UILabel alloc] init];
    self.quebiLabel.text = @"缺币";
    [self addSubview:self.quebiLabel];
    [self.quebiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.buhuoLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    self.duanwangLabel = [[UILabel alloc] init];
    self.duanwangLabel.text = @"断网";
    [self addSubview:self.duanwangLabel];
    [self.duanwangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.quebiLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.mas_top).offset(76 * UISCALE - 0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    

    
    
    
    
}

- (void)setupSubviewsProperty {
    self.machineSnLabel.textColor = [UIColor whiteColor];
    self.machineSnLabel.font = FontNotoSansLightWithSafeSize(17);
    
    self.positionLabel.textColor = [UIColor whiteColor];
    self.positionLabel.font = FontNotoSansLightWithSafeSize(17);
    self.positionLabel.scrollDuration = 6;
    self.positionLabel.marqueeType = MLLeftRight;//滚动样式
    
    self.lineView.backgroundColor = [UIColor whiteColor];//LINE_COLOR;
    
    self.guzhangLabel.layer.borderColor = GUZHANG_COLOR.CGColor;
    self.guzhangLabel.textColor = GUZHANG_COLOR;
    [self setLabelProperty:self.guzhangLabel];
    
    self.buhuoLabel.layer.borderColor = BUHUO_COLOR.CGColor;
    self.buhuoLabel.textColor = BUHUO_COLOR;
    [self setLabelProperty:self.buhuoLabel];
    
    self.quebiLabel.layer.borderColor = QUEBI_COLOR.CGColor;
    self.quebiLabel.textColor = QUEBI_COLOR;
    [self setLabelProperty:self.quebiLabel];
    
    self.duanwangLabel.layer.borderColor = DUANWANG_COLOR.CGColor;
    self.duanwangLabel.textColor = DUANWANG_COLOR;
    [self setLabelProperty:self.duanwangLabel];
}

#pragma mark - private method
- (void)setLabelProperty:(UILabel *)label {
    label.font = FontNotoSansLightWithSafeSize(13);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 0.5;
    label.layer.cornerRadius = 2;
    label.layer.masksToBounds = YES;
}

#pragma mark setters and getters
- (void)setTitleText:(NSString *)titleText {
    self.machineSnLabel.text = titleText;
    CGSize size = [titleText sizeWithAttributes:@{NSFontAttributeName : FontNotoSansLightWithSafeSize(17)}];
    [self.machineSnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width + 8 * UISCALE);
    }];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setDetailText:(NSString *)detailText {
    self.positionLabel.text = detailText;
}
- (void)setIsGuzhang:(BOOL)isGuzhang {
    if (isGuzhang) {
        [self.guzhangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.machineSnLabel.mas_right).offset(8 * UISCALE);
            make.width.mas_equalTo(34 * UISCALE);
        }];
        //        self.machineSnLabel.textColor = RGB_COLOR(245, 56, 36);
    }else{
        [self.guzhangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.machineSnLabel.mas_right).offset(0 * UISCALE);
            make.width.mas_equalTo(0 * UISCALE);
        }];
        //        self.machineSnLabel.textColor = [UIColor blackColor];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}



- (void)setIsQuehuo:(BOOL)isQuehuo {
    if (isQuehuo) {
        [self.buhuoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.guzhangLabel.mas_right).offset(8 * UISCALE);
            make.width.mas_equalTo(34 * UISCALE);
        }];
    }else{
        [self.buhuoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.guzhangLabel.mas_right).offset(0 * UISCALE);
            make.width.mas_equalTo(0 * UISCALE);
        }];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setIsQuebi:(BOOL)isQuebi {
    if (isQuebi) {
        [self.quebiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.buhuoLabel.mas_right).offset(8 * UISCALE);
            make.width.mas_equalTo(34 * UISCALE);
        }];
    }else{
        [self.quebiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.buhuoLabel.mas_right).offset(0 * UISCALE);
            make.width.mas_equalTo(0 * UISCALE);
        }];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setIsDuanwang:(BOOL)isDuanwang {
    if (isDuanwang) {
        [self.duanwangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.quebiLabel.mas_right).offset(8 * UISCALE);
            make.width.mas_equalTo(34 * UISCALE);
        }];
    }else{
        [self.duanwangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.quebiLabel.mas_right).offset(0 * UISCALE);
            make.width.mas_equalTo(0 * UISCALE);
        }];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
