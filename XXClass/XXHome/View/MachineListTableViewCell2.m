//
//  MachineListTableViewCell2.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/4.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "MachineListTableViewCell2.h"

@implementation MachineListTableViewCell2

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
    
    [self.contentView addSubview:self.machineView];
    self.contentView.backgroundColor =[UIColor colorHexToBinaryWithString:@"#2da9ff"];
    //     self.machineView.backgroundColor =[UIColor colorHexToBinaryWithString:@"#2da9ff"];
    //    self.machineView.backgroundColor = RGB(239, 239, 244);
    [self.machineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(kCellHeight * UISCALE);
    }];
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

@end
