//
//  XXHistoryTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXHistoryTableViewCell.h"

@implementation XXHistoryTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.roadLine=[[UILabel alloc] init];
        self.roadLine.text=@"文一路线";
        self.roadLine.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.roadLine];
        self.data=[[UILabel alloc] init];
        self.data.text=@"2017/4/26";
        self.data.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.data];
        
    }
    return self;
}
-(void)layoutSubviews{
    self.roadLine.frame=CGRectMake(30, 0, 100, 50);
     self.data.frame=CGRectMake(CGRectGetMaxX(self.roadLine.frame), 0, 100, 50);
    
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
