//
//  AlarmInfoTableViewCell.m
//  test
//
//  Created by 岳杰 on 2016/12/20.
//  Copyright © 2016年 岳杰. All rights reserved.
//

#import "AlarmInfoTableViewCell.h"


/** 告警类型 00:缺货;01:缺币(5角);02:缺币(1元);03:断网;
 04:故障(主控);05:故障(纸币器);06:故障(硬币器) */

/** 告警级别 0:普通;1:重要;2:严重  */

@interface AlarmInfoTableViewCell ()

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *levelLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) NSString *alarmLevel;
@end

@implementation AlarmInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.levelLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10 * UISCALE);
        make.width.mas_equalTo(120 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).offset(10 * UISCALE);
        make.top.mas_equalTo(self.typeLabel.mas_top);
        make.width.mas_equalTo(100 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    if ([self.alarmLevel isEqualToString:@"0"] || [self.alarmLevel isEqualToString:@""]) {
        self.levelLabel.text = @"普通";
        self.levelLabel.textColor = [UIColor blackColor];
    } else if ([self.alarmLevel isEqualToString:@"1"]) {
        self.levelLabel.text = @"重要";
        self.levelLabel.textColor = RGB_COLOR(245, 166, 35);
    } else if ([self.alarmLevel isEqualToString:@"2"]) {
        self.levelLabel.text = @"严重";
        self.levelLabel.textColor = RGB_COLOR(255, 107, 121);
    }
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16 * UISCALE);
        make.top.mas_equalTo(self.typeLabel.mas_top);
        make.width.mas_equalTo(100 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
}


#pragma mark setters and getters
- (void)setAIModel:(AlarmInfoModel *)aIModel{
    if (_aIModel != aIModel) {
        _aIModel = aIModel;
    }
    self.typeLabel.text = _aIModel.typeName;
    self.alarmLevel = _aIModel.alarmLevel;
    self.timeLabel.text = [NSString stringWithFormat:@"%@小时", _aIModel.distanceHour];
    if (![_aIModel.alarmType isEqualToString:@"00"]&&![_aIModel.alarmType isEqualToString:@"03"]&&_aIModel.alarmReason.length>0) {
        UILabel *label = [[UILabel alloc]init];
//         label.text = [NSString stringWithFormat:@"详情：%@",_aIModel.alarmReason];
        label.numberOfLines = 0;
        label.textColor = RGB_COLOR(148, 148, 148);
        label.font = FONT_OF_SIZE(14);
        CGSize size = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-46*UISCALE, 0)];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(30 * UISCALE);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-16 * UISCALE);
            make.top.mas_equalTo(self.typeLabel.mas_bottom);
//            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
        }];
    }
}
- (UILabel *)typeLabel
{
    if (_typeLabel == nil) {
        self.typeLabel = [[UILabel alloc] init];
        self.typeLabel.font = FontNotoSansLightWithSafeSize(14);
    }
    return _typeLabel;
}

- (UILabel *)levelLabel
{
    if (_levelLabel == nil) {
        self.levelLabel = [[UILabel alloc] init];
        self.levelLabel.font = FontNotoSansLightWithSafeSize(14);
    }
    return _levelLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = FontNotoSansLightWithSafeSize(14);
    }
    return _timeLabel;
}

@end
