//
//  AMSearchTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//
#import "AMSearchTableViewCell.h"

#import "MachineView.h"

@interface AMSearchTableViewCell ()

@property (nonatomic, strong) MachineView *machineView;

@end

@implementation AMSearchTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.machineView];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15 * UISCALE);
        make.width.mas_equalTo(24 * UISCALE);
        make.height.mas_equalTo(24 * UISCALE);
    }];
    
    [self.machineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(MACHINE_CELL_HEIGHT * UISCALE);
    }];
    
    self.machineView.titleText = self.machineSn;
    self.machineView.detailText = self.position;
    self.machineView.isQuebi = self.isQuebi;
    self.machineView.isQuehuo = self.isQuehuo;
    self.machineView.isGuzhang = self.isGuzhang;
    self.machineView.isDuanwang = self.isDuanwang;
    
}


#pragma mark setters and getters
- (MachineView *)machineView
{
    if (_machineView == nil) {
        self.machineView = [[MachineView alloc] init];
    }
    return _machineView;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        self.imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}


@end
