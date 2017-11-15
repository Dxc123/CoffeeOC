//
//  AMTodayReportTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMTodayReportTableViewCell.h"
#import "MachineView.h"

@interface AMTodayReportTableViewCell ()
@property (nonatomic, strong) MachineView *machineView;
@end

@implementation AMTodayReportTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.machineView];
        [self.contentView addSubview:self.freeLabel];//机器地址
        [self.contentView addSubview:self.timeStyleLabel];//显示的补货类型啊
            }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.machineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-100 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(MACHINE_CELL_HEIGHT * UISCALE);
    }];
    
    self.machineView.titleText = self.machineSn;
    self.machineView.detailText = self.position;
    
    if (self.isTimeShow) {
        [self.freeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10 * UISCALE);
            make.width.mas_equalTo(150 * UISCALE);
            make.top.mas_equalTo(self.mas_top).offset(16 * UISCALE);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-16 * UISCALE);
        }];
        
        [self.timeStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.freeLabel.mas_left);
            make.width.mas_equalTo(80 * UISCALE);
            make.top.mas_equalTo(self.mas_top).offset(16 * UISCALE);
            make.height.mas_equalTo(20 * UISCALE);
        }];
    }else{
        [self.freeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
            make.width.mas_equalTo(80 * UISCALE);
            make.top.mas_equalTo(self.mas_top).offset(16 * UISCALE);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-16 * UISCALE);
        }];
        
        [self.timeStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.freeLabel.mas_left).offset(0 * UISCALE);
            make.width.mas_equalTo(100 * UISCALE);
            make.top.mas_equalTo(self.mas_top).offset(16 * UISCALE);
            make.height.mas_equalTo(20 * UISCALE);
        }];
    }
   

}


#pragma mark setters and getters
- (MachineView *)machineView
{
    if (_machineView == nil) {
        self.machineView = [[MachineView alloc] init];
    }
    return _machineView;
}

- (UIButton *)freeLabel
{
    if (_freeBtn == nil) {
        self.freeBtn = [[UIButton alloc] init];
        self.freeBtn.layer.cornerRadius = 4;
        self.freeBtn.layer.masksToBounds = YES;
        self.freeBtn.titleLabel.font = FontNotoSansLightWithSafeSize(13);
        self.freeBtn.userInteractionEnabled = YES;
    }
    return _freeBtn;
}

- (UILabel *)timeStyleLabel
{
    if (_timeStyleLabel == nil) {
        self.timeStyleLabel = [[UILabel alloc] init];
        self.timeStyleLabel.font = FontNotoSansLightWithSafeSize(14);
        self.timeStyleLabel.textColor = [UIColor grayColor];
    }
    return _timeStyleLabel;
}

@end
