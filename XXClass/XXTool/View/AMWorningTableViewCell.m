//
//  WorningTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMWorningTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    labelTags = 10,
}tags;

@implementation AMWorningTableViewCell

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
- (void)createView{
    //机器编号label
    UILabel *worningMesLabel = [[UILabel alloc]init];
    worningMesLabel.frame = CGRectMake(100, self.contentView.frame.size.height/2-20, 250,20);
    worningMesLabel.font = FONT_OF_SIZE(16);
    worningMesLabel.tag = labelTags+0;
    worningMesLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:worningMesLabel];
    //机器地址label
    UILabel *adressLabel = [[UILabel alloc]init];
    adressLabel.frame = CGRectMake(100, self.contentView.frame.size.height/2, SCREEN_WIDTH-100, 20);
    adressLabel.font = FONT_OF_SIZE(14);
    adressLabel.tag = labelTags+1;
    adressLabel.textColor = RGBACOLOR(117, 117, 117, 1);
    [self.contentView addSubview:adressLabel];

    
    //记录错误类型的label
    UILabel *typeContentLabel = [[UILabel alloc]init];
    typeContentLabel.frame = CGRectMake(100, self.contentView.frame.size.height/2-10, 130, 20);
    typeContentLabel.backgroundColor = [UIColor clearColor];
    typeContentLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    typeContentLabel.font = FONT_OF_SIZE(16);
    typeContentLabel.tag = labelTags+3;
    [self.contentView addSubview:typeContentLabel];
    
//    记录错误重要类别的label
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.frame = CGRectMake(20, self.contentView.frame.size.height/2-12, 48, 24);
    typeLabel.tag = labelTags+2;
    typeLabel.layer.borderWidth = 1;
    typeLabel.layer.cornerRadius = 5;
    typeLabel.font = FONT_OF_SIZE(12);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:typeLabel];

    
    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    separView.backgroundColor = RGBACOLOR(206, 206, 206, 1);
    [self.contentView addSubview:separView];
//
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W_WIDTH, 0.5)];
//    headView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:headView];
    
    
}
- (void)setModel:(AMMachWorModel *)model{
    if (_model!=model) {
        _model =model;
    }
    [self setNeedsLayout];
}
- (void)setTypeModel:(AMWorTypeModel *)typeModel{
    if (_typeModel!=typeModel) {
        _typeModel = typeModel;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    switch (self.markID) {
        case 0:
        {
           //给机器号cell赋值；
            [self refreshMachineType];
        }
            break;
        case 1:
        {
           //给类型cell赋值
            [self refreshType];
            
        }
            break;
            
        default:
            break;
    }
}
- (void)refreshMachineType{
    UILabel *machineLabel = [self.contentView viewWithTag:labelTags+0];
    machineLabel.text = [NSString stringWithFormat:@"%@  %@",_model.machineType,_model.worningType];
    UILabel *adressLabel = [self.contentView viewWithTag:labelTags+1];
    adressLabel.text = _model.adressStr;
    UILabel *typeLabel = [self.contentView viewWithTag:labelTags+2];

    if ([_model.alermLevel isEqualToString:@"0"]) {
        typeLabel.text = @"普通";
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    }else if ([_model.alermLevel isEqualToString:@"1"]){
        typeLabel.text = @"重要";
        typeLabel.textColor = RGBACOLOR(245,166,35,1);
        typeLabel.layer.borderColor = [RGBACOLOR(245,166,35,1) CGColor];
    }else if ([_model.alermLevel isEqualToString:@"2"]){
        typeLabel.text = @"严重";
        typeLabel.textColor = RGBACOLOR(255,107,121,1);
        typeLabel.layer.borderColor = [RGBACOLOR(255,107,121,1) CGColor];
    }
   

}
- (void)refreshType{
    
    UILabel *typeLab = [self.contentView viewWithTag:labelTags+3];
    typeLab.text = _typeModel.typeStr;
    
    UILabel *typeLabel = [self.contentView viewWithTag:labelTags+2];
    
    if ([_typeModel.alermLavel isEqualToString:@"0"]) {
        typeLabel.text = @"普通";
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    }else if ([_typeModel.alermLavel isEqualToString:@"1"]){
        typeLabel.text = @"重要";
        typeLabel.textColor = RGBACOLOR(245,166,35,1);
        typeLabel.layer.borderColor = [RGBACOLOR(245,166,35,1) CGColor];
    }else if ([_typeModel.alermLavel isEqualToString:@"2"]){
        typeLabel.text = @"严重";
        typeLabel.textColor = RGBACOLOR(255,107,121,1);
        typeLabel.layer.borderColor = [RGBACOLOR(255,107,121,1) CGColor];
    }
    
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
