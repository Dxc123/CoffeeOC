//
//  TaskTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMTaskTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    labelTags = 110,
}tags;

@implementation AMTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 76*UISCALE);
        [self createView];
    }
    return self;
}

- (void)setTaskModel:(AMTaskModel *)taskModel{
    if (_taskModel!=taskModel) {
        _taskModel = taskModel;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    UILabel *machineLabel = [self.contentView viewWithTag:labelTags+0];
    machineLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    machineLabel.text = _taskModel.machineTypoe;
    CGSize size = [machineLabel sizeThatFits:CGSizeMake(0, 20)];
    machineLabel.frame = CGRectMake(16, self.contentView.frame.size.height/2-20, size.width, size.height);
    UILabel *machineTypeLabel = [self.contentView viewWithTag:labelTags+1];
    machineTypeLabel.center = CGPointMake(CGRectGetMaxX(machineLabel.frame)+16+12, self.contentView.frame.size.height/2-10);
    machineTypeLabel.bounds = CGRectMake(0, 0, 34, 20);
    if ([_taskModel.applyType isEqualToString:@"0"]) {
        machineTypeLabel.text = @"撤机";
        machineTypeLabel.textColor = RGBACOLOR(68, 138, 255, 1);
        machineTypeLabel.layer.borderColor = [RGBACOLOR(68, 138, 255, 1) CGColor];
    }else if ([_taskModel.applyType isEqualToString:@"1"]){
        machineTypeLabel.text = @"换线";
        machineTypeLabel.textColor = RGBACOLOR(144, 19, 254, 1);
        machineTypeLabel.layer.borderColor = [RGBACOLOR(144, 19, 254, 1) CGColor];
    }
    UILabel *adressLabel = [self.contentView viewWithTag:labelTags+2];
    adressLabel.textColor = RGBACOLOR(117, 117, 117, 1);
    adressLabel.text = _taskModel.adressStr;
    
}


- (void)createView{
    UILabel *machineLabel = [[UILabel alloc]init];
//#warning 这里机器编号测试使用12位数字，防止后期机器型号修改
    machineLabel.frame = CGRectMake(16, self.contentView.frame.size.height/2-20, 140, 20);
    machineLabel.tag = labelTags+0;
    machineLabel.font = FONT_OF_SIZE(17);
    [self.contentView addSubview:machineLabel];
    
    UILabel *machineTypeLabel = [[UILabel alloc]init];
    machineTypeLabel.center = CGPointMake(CGRectGetMaxX(machineLabel.frame)+14, self.contentView.frame.size.height/2-10);
    machineTypeLabel.bounds = CGRectMake(0, 0, 34, 20);
    machineTypeLabel.tag = labelTags+1;
    machineTypeLabel.textAlignment = NSTextAlignmentCenter;
    machineTypeLabel.layer.borderWidth = 0.5;
    machineTypeLabel.layer.cornerRadius = 2;
    machineTypeLabel.font = FONT_OF_SIZE(13);
    [self.contentView addSubview:machineTypeLabel];
    UILabel *adressLabel = [[UILabel alloc]init];
    adressLabel.frame = CGRectMake(16, self.contentView.frame.size.height/2, self.contentView.frame.size.width-32, 20);
    adressLabel.tag = labelTags+2;
    adressLabel.font = FONT_OF_SIZE(14);
    [self.contentView addSubview:adressLabel];
    
    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    separView.backgroundColor = separeLineColor;
    [self.contentView addSubview:separView];
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
