//
//  XXCoffeeQueHuoCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/13.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXCoffeeQueHuoCell.h"

@implementation XXCoffeeQueHuoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    //货物名称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/3, 40)];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
//    _nameLabel.font = [UIFont systemFontOfSize:15];
    
    //货物总量
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 0, 120, 40)];
    [self.contentView addSubview:_amountLabel];
    _amountLabel.textAlignment = NSTextAlignmentCenter;
//    _amountLabel.font = [UIFont systemFontOfSize:15];
    //货物出货量
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_amountLabel.frame), 0, 120, 40)];
    [self.contentView addSubview:_numLabel];
    _numLabel.textAlignment = NSTextAlignmentCenter;
//    _numLabel.font = [UIFont systemFontOfSize:15];
    
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
