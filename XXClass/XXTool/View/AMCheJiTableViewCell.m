//
//  AMCheJiTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMCheJiTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    labelTags = 10,
    imageTags = 20,
}tags;

@implementation AMCheJiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 72*UISCALE);
        [self createView];
    }
    return self;
}

- (void)setModel:(AMAccountModel *)model{
    if (_model!=model) {
        _model=model;
    }
    [self setNeedsLayout];
}


- (void)createView{
    
    UILabel *machineLabel = [[UILabel alloc]init];
    machineLabel.frame = CGRectMake(60, self.contentView.frame.size.height/2-20, 140, 20);
    machineLabel.tag = labelTags+0;
    machineLabel.font = FONT_OF_SIZE(16);
    [self.contentView addSubview:machineLabel];
    
    UILabel *adressLabel = [[UILabel alloc]init];
    adressLabel.frame = CGRectMake(60, self.contentView.frame.size.height/2, self.contentView.frame.size.width-50, 20);
    adressLabel.tag = labelTags+2;
    adressLabel.font = FONT_OF_SIZE(12);
    [self.contentView addSubview:adressLabel];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.center = CGPointMake(30, self.contentView.frame.size.height/2);
    image.bounds = CGRectMake(0, 0, 30, 30);
    image.tag = imageTags;
    image.image = [UIImage imageNamed:@"unselect_icon"];
    [self.contentView addSubview:image];
    
    
//    _testBtn = [[UIButton alloc]init];
//        _testBtn.center = CGPointMake(30, self.contentView.frame.size.height/2);
//        _testBtn.bounds = CGRectMake(0, 0, 30, 30);
//
//    [self addSubview:_testBtn];
//    _testBtn.layer.cornerRadius = 10;
////    _testBtn.backgroundColor  = [UIColor lightGrayColor];
//    [_testBtn addTarget:self action:@selector(choose:) forControlEvents: UIControlEventTouchUpInside];
//    

    
    //分割线
    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    separView.backgroundColor = separeLineColor;
    [self.contentView addSubview:separView];
}

- (void)layoutSubviews{
    UILabel *machinaLabel = [self.contentView viewWithTag:labelTags+0];
    machinaLabel.text = _model.machineType;
    UILabel *adressLabel = [self.contentView viewWithTag:labelTags+2];
    adressLabel.text = _model.adressStr;
    
        UIImageView *typeImage = [self.contentView viewWithTag:imageTags];
        if (_model.isSelect) {
            typeImage.image = [UIImage imageNamed:@"select_icon"];
        }else{
            typeImage.image = [UIImage imageNamed:@"unselect_icon"];
    
        }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (selected) {
////        self.contentView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//        [_testBtn setImage:IMAGE(@"select_icon") forState:UIControlStateSelected];
//    }else{
////        self.contentView.backgroundColor = [UIColor whiteColor];
//        [_testBtn setImage:IMAGE(@"unselect_icon") forState:UIControlStateNormal];
//    }
//     Configure the view for the selected state
    
    if (selected) {
        self.contentView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }

}

//- (void)choose:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    [self.delegate  SelectedCell:sender];
//
//    
//    if (sender.selected) {
////        sender.backgroundColor = [UIColor orangeColor];
//        [sender setImage:IMAGE(@"select_icon") forState:UIControlStateSelected];
//    }else{
////        sender.backgroundColor = [UIColor lightGrayColor];
//        [sender setImage:IMAGE(@"unselect_icon") forState:UIControlStateNormal];
//    }
//}



@end
