//
//  MachineView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "MachineView.h"


@interface MachineView ()
@property (nonatomic, strong) UIImageView *bgimage;
@property (nonatomic, strong) UILabel *machineSnLabel;

@property (nonatomic, strong) MarqueeLabel *positionLabel;

@end

@implementation MachineView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupSubviewsProperty];
    }
    return self;
}


//四个故障lab位置 缺货 缺币 断网 故障 （温度）
- (void)setupSubviews {
    
    self.bgimage=[[UIImageView alloc] init];
//    [self addSubview:self.bgimage];
    self.bgimage.image=IMAGE(@"noshopbg_icon");
    self.bgimage.sd_layout.widthIs(SCREEN_WIDTH).heightIs(self.frame.size.height-100*UISCALE).leftSpaceToView(self, 0).topSpaceToView(self, 0);
    
//    self.backgroundColor=BLUE;
    //机器编号
    self.machineSnLabel = [[UILabel alloc] init];
    [self addSubview:self.machineSnLabel];
    [self.machineSnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.mas_top).offset(16 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    //地址
    self.positionLabel = [[MarqueeLabel alloc] init];
    
    [self addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.machineSnLabel.mas_left);
        make.top.mas_equalTo(self.machineSnLabel.mas_bottom).offset(4 * UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-10 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
   
    
    //故障
    self.guzhangLabel = [[UILabel alloc] init];
    self.guzhangLabel.text = @"故障";
    [self addSubview:self.guzhangLabel];
    [self.guzhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.machineSnLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    //缺货
    self.buhuoLabel = [[UILabel alloc] init];
    self.buhuoLabel.text = @"缺货";
    [self addSubview:self.buhuoLabel];
    [self.buhuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.guzhangLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    //缺币
    self.quebiLabel = [[UILabel alloc] init];
    self.quebiLabel.text = @"缺币";
    [self addSubview:self.quebiLabel];
    [self.quebiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.buhuoLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    //断网
    self.duanwangLabel = [[UILabel alloc] init];
    self.duanwangLabel.text = @"断网";
    [self addSubview:self.duanwangLabel];
    [self.duanwangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineSnLabel.mas_top);
        make.left.mas_equalTo(self.quebiLabel.mas_right);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
   
    
    //分割线
    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.mas_top).offset(76 * UISCALE - 0.5);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setupSubviewsProperty {
    self.machineSnLabel.font = FontNotoSansLightWithSafeSize(16);
    
    self.positionLabel.textColor = [UIColor grayColor];
    self.positionLabel.font = FontNotoSansLightWithSafeSize(14);
    self.positionLabel.scrollDuration = 6;
    self.positionLabel.marqueeType = MLLeftRight;//滚动样式
    
    self.lineView.backgroundColor = LINE_COLOR;
    
//    self.guzhangLabel.layer.borderColor = GUZHANG_COLOR.CGColor;
    self.guzhangLabel.textColor = [UIColor whiteColor];//GUZHANG_COLOR;
    self.guzhangLabel.backgroundColor=[UIColor redColor];
      [self setLabelProperty:self.guzhangLabel];
    
//    self.buhuoLabel.layer.borderColor = BUHUO_COLOR.CGColor;
    self.buhuoLabel.textColor = [UIColor whiteColor];//BUHUO_COLOR;
    self.buhuoLabel.backgroundColor=BLUE;
       [self setLabelProperty:self.buhuoLabel];
    
//    self.quebiLabel.layer.borderColor = QUEBI_COLOR.CGColor;
    self.quebiLabel.textColor = [UIColor whiteColor];//QUEBI_COLOR;
    self.quebiLabel.backgroundColor=RGB(240, 193, 46);
    [self setLabelProperty:self.quebiLabel];
    
//    self.duanwangLabel.layer.borderColor = DUANWANG_COLOR.CGColor;
    self.duanwangLabel.textColor = [UIColor whiteColor];//DUANWANG_COLOR;
    self.duanwangLabel.backgroundColor=RGB(95, 223, 236);
    [self setLabelProperty:self.duanwangLabel];
    
    
   
}


#pragma mark - private method
- (void)setLabelProperty:(UILabel *)label {
    label.font = FontNotoSansLightWithSafeSize(13);
    label.textAlignment = NSTextAlignmentCenter;
//    label.layer.borderWidth = 0.5;
    label.layer.cornerRadius = 6;
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

//1缺货
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
//2缺币
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
//3断网
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
//4故障
- (void)setIsGuzhang:(BOOL)isGuzhang {
    if (isGuzhang) {
        [self.guzhangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.machineSnLabel.mas_right).offset(8 * UISCALE);
            make.width.mas_equalTo(34 * UISCALE);
        }];
        self.machineSnLabel.textColor = RGB_COLOR(245, 56, 36);
    }else{
        [self.guzhangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.machineSnLabel.mas_right).offset(0 * UISCALE);
            make.width.mas_equalTo(0 * UISCALE);
        }];
        self.machineSnLabel.textColor = [UIColor blackColor];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
