//
//  AMNotificationTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/6.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//


#import "AMNotificationTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    Tag = 10,
}tags;

@interface AMNotificationTableViewCell ()
{
    NSArray *dateArr;
    UIImageView *chooseImage;
}
@end

@implementation AMNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 70*UISCALE);
        [self createView];
    }
    return self;
}

- (void)setModel:(AMNotificationModel *)model{
    if (_model!=model) {
        _model = model;
    }
//    NSArray *arr = [_model.timeStr componentsSeparatedByString:@" "];
    dateArr = @[_model.isRead,_model.titleStr,_model.timeStr,_model.adressStr];//[arr firstObject]
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    UIView *chooseView = [self.contentView viewWithTag:Tag+0];
    if ([_model.isRead isEqualToString:@"1"]) {
        chooseView.backgroundColor = [UIColor clearColor];
    }else if ([_model.isRead isEqualToString:@"0"]){
        chooseView.backgroundColor = COLOR_MAIN;;//COLOR_MAIN;
    }
    
    for (int i = 1; i<4; i++) {
        UILabel *label = [self.contentView viewWithTag:Tag+i];
        label.text = dateArr[i];
    }
    
    UILabel *titleLabel = [self.contentView viewWithTag:Tag+1];
    UILabel *adressLabel = [self.contentView viewWithTag:Tag+3];
    if (_model.isChoose) {
        chooseImage.frame = CGRectMake(10, self.contentView.frame.size.height/2-10, 20, 20);
    }else{
        chooseImage.frame = CGRectMake(0, 0, 0, 0);
    }
    chooseView.frame = CGRectMake(CGRectGetMaxX(chooseImage.frame)+10, self.contentView.frame.size.height/2-10, 10, 10);
    titleLabel.frame = CGRectMake(CGRectGetMaxX(chooseView.frame)+10, self.contentView.frame.size.height/2-20, SCREEN_WIDTH-CGRectGetMaxX(chooseView.frame)-20, 20);
    adressLabel.frame = CGRectMake(CGRectGetMaxX(chooseView.frame)+10, self.contentView.frame.size.height/2, SCREEN_WIDTH-100-CGRectGetMaxX(chooseView.frame), 20);
    
    
    if (_model.isSelect) {
        chooseImage.image = [UIImage imageNamed:@"ic_duigou"];
    }else{
        chooseImage.image = [UIImage imageNamed:@"ic_unchoose"];
    }
}

- (void)createView{
    chooseImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unchoose"]];
    chooseImage.frame = CGRectMake(0, 0,0, 0);
    [self.contentView addSubview:chooseImage];
    
    UIView *isReadView = [[UIView alloc]init];
    isReadView.frame = CGRectMake(CGRectGetMaxX(chooseImage.frame)+10, self.contentView.frame.size.height/2-10, 10, 10);
    isReadView.layer.cornerRadius = 5;
    isReadView.clipsToBounds = YES;
    isReadView.tag = Tag+0;
    [self.contentView addSubview:isReadView];
    
    //提醒
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(isReadView.frame)+10, self.contentView.frame.size.height/2-20, SCREEN_WIDTH-CGRectGetMaxX(isReadView.frame)-150*UISCALE, 20)];
    titleLabel.font = FONT_OF_SIZE(16);
    titleLabel.tag = Tag + 1;
    [self.contentView addSubview:titleLabel];
    
    
    //时间显示
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame ), self.contentView.frame.size.height/2-20, 150*UISCALE, 20)];
    timeLabel.font = FONT_OF_SIZE(12);
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
//    timeLabel.backgroundColor=[UIColor orangeColor];
    timeLabel.tag = Tag+2;
    [self.contentView addSubview:timeLabel];
    
    //地址
    UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(isReadView.frame)+10, self.contentView.frame.size.height/2, SCREEN_WIDTH-20-CGRectGetMaxX(isReadView.frame), 20)];
    adressLabel.font = FONT_OF_SIZE(13);
    adressLabel.textColor = [UIColor grayColor];
    adressLabel.tag = Tag+3;
    [self.contentView addSubview:adressLabel];
    
    
    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    separView.backgroundColor = separeLineColor;
    [self.contentView addSubview:separView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.contentView.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
