//
//  HistoryTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/27.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AMHistoryTableViewCell.h"
//#import "AMConfig.h"

typedef enum :NSInteger{
    labelTags = 10,
}tags;

@implementation AMHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 60*UISCALE);
        [self createView];
    }
    return self;
}

- (void)setHisModel:(AMHistoryModel *)hisModel{
    if (_hisModel!=hisModel) {
        _hisModel=hisModel;
    }
    [self setNeedsLayout];
}
- (void)setDetailModel:(AMHistoryDetailModel *)detailModel{
    if (_detailModel!=detailModel) {
        _detailModel=detailModel;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    switch (self.markID) {
        case 0:
        {
            [self refreshHistory];
        }
            break;
        case 1:
        {
            [self refreshHistoryDetail];
        }
            break;
            
        default:
            break;
    }
}
- (void)refreshHistory{
    UILabel *titleLabel = [self.contentView viewWithTag:labelTags+0];
    titleLabel.text = [NSString stringWithFormat:@"[%@]%@备货单",_hisModel.routeName,_hisModel.stockupTime];
    
    // createTime = "05 11 2017  7:22PM";
    UILabel *detailLabel = [self.contentView viewWithTag:labelTags+1];
//    NSString *timeStr = _hisModel.timeStr;
//    NSArray *timeArr = [timeStr componentsSeparatedByString:@" "];
//    NSString *time = [NSString stringWithFormat:@"%@ %@ %@ %@",timeArr[0],timeArr[1],timeArr[2],timeArr[3]];
    detailLabel.text = [NSString stringWithFormat:@"%@",_hisModel.timeStr];;
   
    
}

- (void)refreshHistoryDetail{
     UILabel *titleLabel = [self.contentView viewWithTag:labelTags+0];
    titleLabel.text = _detailModel.goodsName;
    
    UILabel *detailLabel = [self.contentView viewWithTag:labelTags+1];
    detailLabel.text = [NSString stringWithFormat:@"需%@箱 %@",_detailModel.outStockBoxCount,_detailModel.outStockCount];
    detailLabel.textColor = RGBACOLOR(255, 107, 121, 1);
}



- (void)createView{
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(10, 0, (SCREEN_WIDTH-20)/3*2, self.contentView.frame.size.height);
    nameLabel.font = FONT_OF_SIZE(13);
    nameLabel.tag = labelTags+0;
    [self.contentView addSubview:nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.frame = CGRectMake(SCREEN_WIDTH-35*UISCALE-(SCREEN_WIDTH-20)/3, 0, (SCREEN_WIDTH-20)/3+50, self.contentView.frame.size.height);
    detailLabel.font = FONT_OF_SIZE(13);
    detailLabel.tag = labelTags+1;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:detailLabel];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(detailLabel.frame), 25*UISCALE, 10, 10)];
    imageView.image=[UIImage imageNamed:@"next_icon"];
    [self.contentView addSubview:imageView];
    
    
    
    UIView *separView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    separView.backgroundColor = separeLineColor;
    [self.contentView addSubview:separView];
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}

@end
