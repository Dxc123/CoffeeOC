//
//  XXTemperatureCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/10.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXTemperatureCell.h"

@implementation XXTemperatureCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    //自定义的View
    self.machineView = [[MachineView alloc] init];
//    self.machineView.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:self.machineView];
    [self.machineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(-100*UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(75 * UISCALE);
    }];
    self.wenduLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.wenduLab];
    [self.wenduLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.machineView.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(50 * UISCALE);
        make.width.mas_equalTo(80);
    }];
//    self.wenduLab.backgroundColor = [UIColor redColor];
    self.wenduLab.textColor =  [UIColor grayColor];
    self.wenduLab.textAlignment = NSTextAlignmentCenter;
    self.wenduLab.font  = [UIFont systemFontOfSize:18];
}
//解决：cell为可选中状态，contentView上所有的view的背景颜色被清除了，或者说被设置成透明
//重写cell的setSelected方法
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.machineView.lineView.backgroundColor = LINE_COLOR;
    
    
    self.machineView.guzhangLabel.textColor = [UIColor whiteColor];//GUZHANG_COLOR;
    self.machineView.guzhangLabel.backgroundColor=[UIColor redColor];
    
    
    self.machineView.buhuoLabel.textColor = [UIColor whiteColor];//BUHUO_COLOR;
    self.machineView.buhuoLabel.backgroundColor=BLUE;
    
    
    self.machineView.quebiLabel.textColor = [UIColor whiteColor];//QUEBI_COLOR;
    self.machineView.quebiLabel.backgroundColor=RGB(240, 193, 46);
    
    self.machineView.duanwangLabel.textColor = [UIColor whiteColor];//DUANWANG_COLOR;
    self.machineView.duanwangLabel.backgroundColor=RGB(95, 223, 236);
    
    
}
- (void)setMachineSn:(NSString *)machineSn {
    self.machineView.titleText = machineSn;
}

- (void)setPosition:(NSString *)position {
    self.machineView.detailText = position;
}
-(void)setWendu:(NSString *)wendu{
    self.wenduLab.text= wendu;
}
- (void)setIsQuebi:(BOOL)isQuebi {
    self.machineView.isQuebi = isQuebi;
}

- (void)setIsQuehuo:(BOOL)isQuehuo {
    self.machineView.isQuehuo = isQuehuo;
}

- (void)setIsGuzhang:(BOOL)isGuzhang {
    self.machineView.isGuzhang = isGuzhang;
}

- (void)setIsDuanwang:(BOOL)isDuanwang {
    self.machineView.isDuanwang = isDuanwang;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
