//
//  XXSuppleTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/15.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXSuppleTableViewCell.h"

@implementation XXSuppleTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        UILabel *gradeLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 40)];
        [self.contentView addSubview:gradeLab];
        gradeLab.textColor=[UIColor blackColor];
        gradeLab.text=@"运营评分";
        gradeLab.font=[UIFont systemFontOfSize:18];
        gradeLab.textAlignment=NSTextAlignmentCenter;
        
        UILabel *gradeNum=[[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(gradeLab.frame), 150, 40)];
        [self.contentView addSubview:gradeNum];
        gradeNum.textColor=RGB(64, 146, 239);
        gradeNum.text=@"50.0分";
        gradeNum.font=[UIFont systemFontOfSize:26];
        gradeNum.textAlignment=NSTextAlignmentCenter;
        self.gradeNum=gradeNum;
        
        UILabel *gradeLab2=[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(gradeNum.frame), 180, 40)];
        [self.contentView addSubview:gradeLab2];
        gradeLab2.textColor=[UIColor blackColor];
        gradeLab2.text=@"5台未处理机器，损失33221.0元";
        gradeLab2.font=[UIFont systemFontOfSize:12];
        gradeLab2.textAlignment=NSTextAlignmentCenter;
        
        
        
        
        /*****分界线*******/
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeLab2.frame)+20, 20, 1.25, self.frame.size.height-40)];
        lineView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:lineView];
        
        
        UILabel *suppleLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+40, CGRectGetMinY(gradeLab.frame), 100, 40)];
        [self.contentView addSubview:suppleLab];
        suppleLab.textColor=[UIColor blackColor];
        suppleLab.text=@"补货台数";
        suppleLab.font=[UIFont systemFontOfSize:18];
        suppleLab.textAlignment=NSTextAlignmentCenter;
        
        UILabel *suppleNum=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+40, CGRectGetMaxY(suppleLab.frame)+20, 100, 40)];
        [self.contentView addSubview:suppleNum];
        suppleNum.textColor=RGB(64, 146, 239);
        suppleNum.text=@"4";
        suppleNum.font=[UIFont systemFontOfSize:26];
        suppleNum.textAlignment=NSTextAlignmentCenter;
        self.suppleNum=suppleNum;

    
    }
    return self;
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
