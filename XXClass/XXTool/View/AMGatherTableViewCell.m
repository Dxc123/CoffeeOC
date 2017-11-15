//
//  GatherTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMGatherTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    cellLabelTags = 10,
}tags;

@interface AMGatherTableViewCell ()
{
    NSMutableArray *dateArr;
}
@end

@implementation AMGatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dateArr = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.contentView.bounds = CGRectMake(0, 0,SCREEN_WIDTH, 60*UISCALE);
        [self createView];
    }
    return self;
}
- (void)setModel:(AMGatherModel *)model{
    if (_model!= model) {
        _model = model;
    }
    dateArr = @[_model.paiming,_model.goodsName,_model.saleCount,_model.xiaoliangTai].mutableCopy;
    [self setNeedsLayout];
}
- (void)setShipModel:(AMShipModel *)shipModel{
    if (_shipModel!=shipModel) {
        _shipModel = shipModel;
    }
    dateArr = @[_shipModel.timeDetail,_shipModel.goodsName,_shipModel.price,_shipModel.pricrType].mutableCopy;
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    switch (self.selectIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
            //销量排行
            [self refreshXiaoLiang];
        }
            break;
        case 2:
        {
            //出货日志
            [self refreshChuHuoRiZhi];
        }
            break;
            
        default:
            break;
    }
}

- (void)refreshChuHuoRiZhi{
    for (int i = 0; i<4; i++) {
        UILabel *label = [self.contentView viewWithTag:cellLabelTags+i];
        label.font = FONT_OF_SIZE(12);
        label.text = dateArr[i];
    }
}

- (void)refreshXiaoLiang{
    for (int i = 0; i<4; i++) {
        UILabel *label = [self.contentView viewWithTag:cellLabelTags+i];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, SCREEN_WIDTH/5, self.contentView.frame.size.height);
        }else if (i == 1){
            label.frame = CGRectMake(SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5*2, self.contentView.frame.size.height);
        }else if (i == 2){
            label.frame = CGRectMake(SCREEN_WIDTH/5*3, 0, SCREEN_WIDTH/5, self.contentView.frame.size.height);
        }else if (i == 3){
            label.frame = CGRectMake(SCREEN_WIDTH/5*4, 0, SCREEN_WIDTH/5, self.contentView.frame.size.height);
        }
        label.text = dateArr[i];
        label.font = FONT_OF_SIZE(14);
        if (i == 0) {
            label.font = FONT_OF_SIZE(16);
            if ([_model.paiming isEqualToString:@"1"]) {
                label.textColor = RGBACOLOR(245, 166, 35, 1);
            }else if ([_model.paiming isEqualToString:@"2"]){
                label.textColor = RGBACOLOR(119, 178, 247, 1);
            }else if ([_model.paiming isEqualToString:@"3"]){
                label.textColor = RGBACOLOR(141, 200, 72, 1);
            }else{
                label.textColor = [UIColor blackColor];
            }
        }
        
    }
}
- (void)createView{

    //label字体的型号；
    int fontSize = 14;    //出货日志字号13
    
    UILabel *paiming = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5, self.contentView.frame.size.height)];
    paiming.tag = cellLabelTags+0;
    paiming.font = FONT_OF_SIZE(fontSize);
    paiming.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:paiming];
    UILabel *goodName = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5*2, self.contentView.frame.size.height)];
    goodName.font = FONT_OF_SIZE(fontSize);
    goodName.tag = cellLabelTags+1;
    goodName.numberOfLines = 0;
    goodName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:goodName];
    UILabel *xiaoliang = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*3, 0, SCREEN_WIDTH/5, self.contentView.frame.size.height)];
    xiaoliang.font = FONT_OF_SIZE(fontSize);
    xiaoliang.textAlignment = NSTextAlignmentCenter;
    xiaoliang.tag = cellLabelTags+2;
    [self.contentView addSubview:xiaoliang];
    UILabel *tai = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*4, 0, SCREEN_WIDTH/5, self.contentView.frame.size.height)];
    tai.tag = cellLabelTags+3;
    tai.font = FONT_OF_SIZE(fontSize);
    tai.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tai];
    
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
