//
//  XXReportTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/15.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXReportTableViewCell.h"

@implementation XXReportTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *saleMoneyLab=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 120, 30)];
        [self addSubview:saleMoneyLab];
        saleMoneyLab.textColor=[UIColor blackColor];
        saleMoneyLab.text=@"昨日销售额(元)";
        saleMoneyLab.font=[UIFont systemFontOfSize:16];
        saleMoneyLab.textAlignment=NSTextAlignmentCenter;
        
        
        UILabel *saleMoneyNum=[[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(saleMoneyLab.frame), 150, 40)];
        [self.contentView addSubview:saleMoneyNum];
        saleMoneyNum.textColor=RGB(64, 146, 239);
        saleMoneyNum.text=@"150.0";
        saleMoneyNum.font=[UIFont systemFontOfSize:26];
        saleMoneyNum.textAlignment=NSTextAlignmentCenter;
        self.saleMoneyNum=saleMoneyNum;
        
        UILabel *onlin=[[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(saleMoneyNum.frame), 100, 30)];
        [self.contentView addSubview:onlin];
        onlin.textColor=[UIColor blackColor];
        onlin.text=@"在线";
        onlin.font=[UIFont systemFontOfSize:14];
        onlin.textAlignment=NSTextAlignmentCenter;
        
        UILabel *onlinNm=[[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(onlin.frame), 100, 30)];
        [self.contentView addSubview:onlinNm];
        onlinNm.textColor=[UIColor blackColor];
        onlinNm.text=@"90";
        onlinNm.font=[UIFont systemFontOfSize:14];
        onlinNm.textAlignment=NSTextAlignmentCenter;
        self.onlinNm=onlinNm;
        
        UILabel *cash=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(onlin.frame), CGRectGetMaxY(saleMoneyNum.frame), 50, 30)];
        [self.contentView addSubview:cash];
        cash.textColor=[UIColor blackColor];
        cash.text=@"现金";
        cash.font=[UIFont systemFontOfSize:14];
        cash.textAlignment=NSTextAlignmentCenter;
        
        UILabel *cashNm=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(onlin.frame), CGRectGetMaxY(cash.frame), 50, 30)];
        [self.contentView addSubview:cashNm];
        cashNm.textColor=[UIColor blackColor];
        cashNm.text=@"103";
        cashNm.font=[UIFont systemFontOfSize:14];
        cashNm.textAlignment=NSTextAlignmentCenter;
        self.cashNm=cashNm;
        
        
    /******分界线********/
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(saleMoneyNum.frame)+20, 20, 1.25, self.frame.size.height-40)];
        lineView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:lineView];
        
        
        UILabel *saleNumLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+40, CGRectGetMinY(saleMoneyLab.frame), 120, 30)];
        [self.contentView addSubview:saleNumLab];
        saleNumLab.textColor=[UIColor blackColor];
        saleNumLab.text=@"昨日销售量(件)";
        saleNumLab.font=[UIFont systemFontOfSize:16];
        saleNumLab.textAlignment=NSTextAlignmentCenter;
        
        UILabel *saleNum=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+40, CGRectGetMaxY(saleNumLab.frame), 100, 40)];
        [self.contentView addSubview:saleNum];
        saleNum.textColor=RGB(64, 146, 239);
        saleNum.text=@"1600";
        saleNum.font=[UIFont systemFontOfSize:26];
        saleNum.textAlignment=NSTextAlignmentCenter;
        self.saleNum=saleNum;
        
        UILabel *onlin1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+40, CGRectGetMaxY(saleNum.frame), 50, 30)];
        [self.contentView addSubview:onlin1];
        onlin1.textColor=[UIColor blackColor];
        onlin1.text=@"在线";
        onlin1.font=[UIFont systemFontOfSize:14];
        onlin1.textAlignment=NSTextAlignmentCenter;
        
        UILabel *onlinNm1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+40, CGRectGetMaxY(onlin1.frame), 50, 30)];
        [self.contentView addSubview:onlinNm1];
        onlinNm1.textColor=[UIColor blackColor];
        onlinNm1.text=@"156";
        onlinNm1.font=[UIFont systemFontOfSize:14];
        onlinNm1.textAlignment=NSTextAlignmentCenter;
        self.onlinNm1=onlinNm1;
        
        UILabel *cash1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(onlinNm1.frame)+20, CGRectGetMaxY(saleNum.frame), 100, 30)];
        [self.contentView addSubview:cash1];
        cash1.textColor=[UIColor blackColor];
        cash1.text=@"现金";
        cash1.font=[UIFont systemFontOfSize:14];
        cash1.textAlignment=NSTextAlignmentCenter;
        
        UILabel *cashNm1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(onlin1.frame)+20, CGRectGetMaxY(cash1.frame), 100, 30)];
        [self.contentView addSubview:cashNm1];
        cashNm1.textColor=[UIColor blackColor];
        cashNm1.text=@"1325325";
        cashNm1.font=[UIFont systemFontOfSize:14];
        cashNm1.textAlignment=NSTextAlignmentCenter;
        self.cashNm1=cashNm1;
        
        

        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
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
