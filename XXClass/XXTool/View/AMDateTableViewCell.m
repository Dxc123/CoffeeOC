//
//  DateTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMDateTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    dateTags = 10,
}tags;

@interface AMDateTableViewCell ()
{
    NSMutableArray *arr;
}
@end

@implementation AMDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        arr = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       [self createView];
        
    }
    return self;
}
- (void)setModel:(AMDateModel *)model{
    if (_model != model) {
        _model = model;
    }
    arr = @[_model.dateStr,_model.xiaoshoueStr,_model.xiaoshoujianStr].mutableCopy;
    [self setNeedsLayout];
}
- (void)setDetailModel:(AMDetailModel *)detailModel{
    if (_detailModel != detailModel) {
        _detailModel = detailModel;
    }
    arr = @[_detailModel.machineType,_detailModel.xiaoshoue,_detailModel.xiaoshoujian,_detailModel.adressPart].mutableCopy;
    [self setNeedsLayout];
}
- (void)setAccountModel:(AMAccountModel *)accountModel{
    if (_accountModel!=accountModel) {
        _accountModel = accountModel;
    }
    
    arr = @[_accountModel.machineType,_accountModel.moneyAccount,_accountModel.adressStr].mutableCopy;
    [self setNeedsLayout];
}
- (void)setAccHisModel:(AMAccHisModel *)accHisModel{
    if (_accHisModel!=accHisModel) {
        _accHisModel = accHisModel;
    }
    arr = @[_accHisModel.machineID,_accHisModel.replenishmentTime,_accHisModel.shouldAccountMoney,_accHisModel.adressStr].mutableCopy;
    [self setNeedsLayout];
}
//修改布局的时候
- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (self.selectChoose) {
        case 1:
            //昨日查看更多（报告界面）
            [self refreshDateTable];
            break;
        case 2:
            //销售详情（各点位的销售详情）
            [self refreshDetailTable];
            break;
        case 3:
             //应收款列表cell
            [self refreshAccountTable];
            break;
        case 4:
            //历史应收款列表cell
            [self refreshHistoryAccountTable];
            break;
            
        default:
            break;
    }
    
}
- (void)refreshHistoryAccountTable{
    for (int i = 0; i<4; i++) {
        UILabel *label = [self.contentView viewWithTag:dateTags+i];
        if (i == 0||i == 3) {
            label.textAlignment = NSTextAlignmentLeft;
        }else{
            label.textAlignment = NSTextAlignmentCenter;
        }
        if (i == 0) {
//            label.frame = CGRectMake(16, self.contentView.frame.size.height/2, W_WIDTH-32, 20);
            label.font = FONT_OF_SIZE(13);
        }else if (i == 2){
            label.font = FONT_OF_SIZE(15);
        }else{
//            label.frame = CGRectMake(16+(W_WIDTH-32)/3*i, self.contentView.frame.size.height/2-20, (W_WIDTH-32)/3, 20);
            label.font = FONT_OF_SIZE(12);
        }
        label.text = arr[i];
    }
}
- (void)refreshAccountTable{
    UILabel *machineLabel = [self.contentView viewWithTag:dateTags+0];
    machineLabel.textAlignment = NSTextAlignmentLeft;
    machineLabel.frame = CGRectMake(16, self.contentView.frame.size.height/2-20, (SCREEN_WIDTH-32)/3, 20);
    machineLabel.font = FONT_OF_SIZE(15);
    machineLabel.text = arr[0];
    UILabel *totalMoneyLabel = [self.contentView viewWithTag:dateTags+2];
    totalMoneyLabel.frame = CGRectMake(16+(SCREEN_WIDTH-32)/3*2, self.contentView.frame.size.height/2-20, (SCREEN_WIDTH-32)/3, 20);
    totalMoneyLabel.text = arr[1];
    totalMoneyLabel.font = FONT_OF_SIZE(17);
    UILabel *adressLabel = [self.contentView viewWithTag:dateTags+3];
    adressLabel.textAlignment = NSTextAlignmentLeft;
    adressLabel.frame = CGRectMake(16, self.contentView.frame.size.height/2, SCREEN_WIDTH-32, 20);
    adressLabel.font = FONT_OF_SIZE(14);
    adressLabel.text = arr[2];
}
- (void)refreshDetailTable{
    for (int i = 0; i<4; i++) {
        UILabel *label = [self.contentView viewWithTag:dateTags+i];
        if (i == 0||i == 3) {
            label.textAlignment = NSTextAlignmentLeft;
        }else{
            label.textAlignment = NSTextAlignmentCenter;
        }
        if (i == 3) {
            label.frame = CGRectMake(16, self.contentView.frame.size.height/2, SCREEN_WIDTH-32, 20);
            label.font = FONT_OF_SIZE(14);
        }else{
            label.frame = CGRectMake(16+(SCREEN_WIDTH-32)/3*i, self.contentView.frame.size.height/2-20, (SCREEN_WIDTH-32)/3, 20);
            label.font = FONT_OF_SIZE(15);
        }
        label.text = arr[i];
    }
}
- (void)refreshDateTable{
    for (int i = 0; i<3; i++) {
        UILabel *label = [self.contentView viewWithTag:dateTags+i];
        label.center = CGPointMake(16+((SCREEN_WIDTH-32)/6)+(SCREEN_WIDTH-32)/3*i, self.contentView.frame.size.height/2);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_OF_SIZE(14);
        label.text = arr[i];
    }
}
- (void)createView{
    
    for (int i = 0; i<3; i++) {
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.frame = CGRectMake(16+(SCREEN_WIDTH-32)/3*i, self.contentView.frame.size.height/2-20, (SCREEN_WIDTH-32)/3, 20);
        dateLabel.tag = dateTags+i;
        dateLabel.font = FONT_OF_SIZE(17);
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:dateLabel];
    }
    UILabel *adressLabel = [[UILabel alloc]init];
    adressLabel.frame = CGRectMake(16, self.contentView.frame.size.height/2, SCREEN_WIDTH-32, 20);
    adressLabel.tag = dateTags+3;
    adressLabel.font = FONT_OF_SIZE(14);
    [self.contentView addSubview:adressLabel];
    
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        self.backgroundColor = SELECTHIGHTCOLOR;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
