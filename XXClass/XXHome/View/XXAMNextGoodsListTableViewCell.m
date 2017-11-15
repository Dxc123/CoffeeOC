//
//  XXAMNextGoodsListTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/6/8.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXAMNextGoodsListTableViewCell.h"

@implementation XXAMNextGoodsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.infoLabel];
         [self.contentView addSubview:self.numBtn];
        
//        [self.contentView addSubview:self.conutText];
//        [self.contentView addSubview:self.subBtn];
//        [self.contentView addSubview:self.addBtn];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(11 * UISCALE);
        make.height.mas_equalTo(42 * UISCALE);
        make.width.mas_equalTo(210 * UISCALE);
    }];
    [self.numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * UISCALE);
        make.top.mas_equalTo(self.contentView.mas_top).offset(17 * UISCALE);
        make.height.mas_equalTo(28 * UISCALE);
        make.width.mas_equalTo(90 * UISCALE);
    }];

    
//    
//        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.contentView.mas_right).offset(-10 * UISCALE);
//            make.top.mas_equalTo(self.contentView.mas_top).offset(17 * UISCALE);
//            make.height.mas_equalTo(28 * UISCALE);
//            make.width.mas_equalTo(30 * UISCALE);
//        }];
//        
//
//    
//    
//    [self.conutText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.addBtn.mas_left).offset(0 * UISCALE);
//        make.top.mas_equalTo(self.contentView.mas_top).offset(17 * UISCALE);
//        make.height.mas_equalTo(28 * UISCALE);
//        make.width.mas_equalTo(30 * UISCALE);
//    }];
//
//    [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.conutText.mas_left).offset(0 * UISCALE);
//        make.top.mas_equalTo(self.contentView.mas_top).offset(17 * UISCALE);
//        make.height.mas_equalTo(28 * UISCALE);
//        make.width.mas_equalTo(30 * UISCALE);
//    }];
//    
//    
    
}


#pragma mark - setters and getters
- (UILabel *)infoLabel
{
    if (_infoLabel == nil) {
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = FontNotoSansLightWithSafeSize(14);
        self.infoLabel.numberOfLines = 2;
    }
    return _infoLabel;
}


- (PPNumberButton *)numBtn
{
    if (_numBtn == nil) {
        self.numBtn = [[PPNumberButton alloc] init];
        self.numBtn.maxValue = 99;
        self.numBtn.minValue = 0;
        self.numBtn.increaseImage = IMAGE(@"add++");
        self.numBtn.decreaseImage = IMAGE(@"add--");
        self.numBtn.editing = NO;
        self.numBtn.decreaseHide=YES;
        __weak typeof (self) weakSelf =self;
        self.numBtn.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            NSLog(@"%@",increaseStatus ? @"加运算":@"减运算");
            NSLog(@"number=%ld",(long)num);
            [weakSelf.delegate ChangeGoodsNumberCell:weakSelf  Number:num];
        };

    }
    return _numBtn;
}


//-(UITextField *)conutText{
//    if (_conutText==nil) {
//        self.conutText=[[UITextField alloc] init];
//        self.conutText.layer.borderWidth = 0.5;
//        self.conutText.layer.borderColor = [RGB_COLOR(200, 200, 200) CGColor];
//        self.conutText.textAlignment=NSTextAlignmentCenter;
//        
//    }
//    return _conutText;
//    
//}
//-(UIButton *)addBtn{
//    if (_addBtn==nil) {
//        self.addBtn=[[UIButton alloc] init];
//        [self.addBtn setImage:IMAGE(@"add++") forState:UIControlStateNormal];
//        [self.addBtn setImage:IMAGE(@"add++") forState:UIControlStateSelected];
//        [self.addBtn setBackgroundColor:[UIColor orangeColor]];
//        [self.addBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _addBtn;
//}
//-(UIButton *)subBtn{
//    if (_subBtn==nil) {
//        self.subBtn=[[UIButton alloc] init];
//         [self.subBtn setImage:IMAGE(@"add--") forState:UIControlStateNormal];
//         [self.subBtn setImage:IMAGE(@"add--") forState:UIControlStateSelected];
//        [self.subBtn setBackgroundColor:[UIColor orangeColor]];
//        [self.subBtn addTarget:self action:@selector(sub:) forControlEvents:UIControlEventTouchUpInside];
//        
//
//    }
//    return _subBtn;
//}

//-(void)add:(UIButton *)btn{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(addProductCountActionWithIndex:)]) {
//        [self.delegate addProductCountActionWithIndex:self.indexPath];
//    }
//
//    
//}
//
//-(void)sub:(UIButton *)btn{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(subProductCountActionWithIndex:)]) {
//        [self.delegate subProductCountActionWithIndex:self.indexPath];
//    }
//
//    
//    
//}
//






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
