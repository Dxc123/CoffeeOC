//
//  XXQueHuoView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/26.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXQueHuoView.h"

/** 告警类型 00:缺货;01:缺币(5角);02:缺币(1元);03:断网;
 04:故障(主控);05:故障(纸币器);06:故障(硬币器) */
/** 告警级别 0:普通;1:重要;2:严重  */
@interface XXQueHuoView ()
@property (nonatomic, strong) UIImageView *bgimage;
@property (nonatomic, strong) UILabel *machineSnLabel;

@property (nonatomic, strong) MarqueeLabel *positionLabel;

@end

@implementation XXQueHuoView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupSubviewsProperty];
    }
    return self;
}

- (void)setupSubviews {
    
    //背景图
    self.bgimage=[[UIImageView alloc] init];
    [self addSubview:self.bgimage];
    self.bgimage.image=IMAGE(@"noshopbg_icon1");
//    self.bgimage.sd_layout.widthIs(SCREEN_WIDTH).heightIs(130*UISCALE).leftSpaceToView(self, 0*UISCALE).topSpaceToView(self, 0*UISCALE);
//    self.bgimage.userInteractionEnabled=YES;
    [self.bgimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0 * UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(0 * UISCALE);
        make.top.mas_equalTo(self.mas_top).offset(0 * UISCALE);
        make.height.mas_equalTo(self.mas_height);
    }];

   //机器编号
    self.machineSnLabel = [[UILabel alloc] init];
    [self addSubview:self.machineSnLabel];
    [self.machineSnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25 * UISCALE);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(35 * UISCALE);
    }];
    
    //机器地址
    self.positionLabel = [[MarqueeLabel alloc] init];
    [self addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.machineSnLabel.mas_left);
        make.top.mas_equalTo(self.machineSnLabel.mas_bottom).offset(15* UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-10 * UISCALE);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    
    //中间水平分隔线
    self.lineView = [[UIView alloc] init];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.positionLabel.mas_bottom).offset(10 * UISCALE );
        make.height.mas_equalTo(0.5);
    }];
 //////////////////////////////////////////////////////////////
    //故障
    self.guzhangLabel = [[UILabel alloc] init];
    self.guzhangLabel.text = @"故障";
    [self addSubview:self.guzhangLabel];
    [self.guzhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.lineView.mas_bottom).offset(10*UISCALE);
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    self.guzhangLevelLabel = [[UILabel alloc] init];
    self.guzhangLevelLabel.text = @"严重";
    self.guzhangLevelLabel.textColor=[UIColor redColor];
    self.guzhangLevelLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.guzhangLevelLabel];
    [self.guzhangLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.guzhangLabel.mas_right).offset(100 * UISCALE);
        make.top.mas_equalTo(self.guzhangLabel.mas_top);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.guzhangLabelNum = [[UILabel alloc] init];
    self.guzhangLabelNum .text = @"0小时";
    self.guzhangLabelNum.textColor=[UIColor whiteColor];
    [self addSubview:self.guzhangLabelNum];
    [self.guzhangLabelNum  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.lineView.mas_bottom).offset(10*UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];

    


    //缺货
    self.buhuoLabel = [[UILabel alloc] init];
    self.buhuoLabel.text = @"缺货";
    [self addSubview:self.buhuoLabel];

    [self.buhuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.guzhangLabel.mas_bottom).offset(10*UISCALE);
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);

        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.buhuoLevelLabel = [[UILabel alloc] init];
    self.buhuoLevelLabel.text = @"普通";
    self.buhuoLevelLabel.textColor=[UIColor whiteColor];
    [self addSubview:self.buhuoLevelLabel];
    [self.buhuoLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.buhuoLabel.mas_right).offset(30 * UISCALE);
        make.top.mas_equalTo(self.buhuoLabel.mas_top);
        
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.buhuoLabelNum = [[UILabel alloc] init];
    self.buhuoLabelNum.text = @"0小时";
    self.buhuoLabelNum.textColor=[UIColor clearColor];
    [self addSubview:self.buhuoLabelNum];
    [self.buhuoLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.guzhangLabelNum.mas_bottom).offset(10*UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
        
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];

    //缺币
    self.quebiLabel = [[UILabel alloc] init];
    self.quebiLabel.text = @"缺币";
    [self addSubview:self.quebiLabel];
    [self.quebiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.buhuoLabel.mas_bottom).offset(10*UISCALE);
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.quebiLevelLabel = [[UILabel alloc] init];
    self.quebiLevelLabel.text = @"普通";
    self.quebiLevelLabel.textColor=[UIColor whiteColor];
    [self addSubview:self.quebiLevelLabel];
    [self.quebiLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.quebiLabel.mas_right).offset(30 * UISCALE);
        make.top.mas_equalTo(self.quebiLabel.mas_top);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.quebiLabelNum = [[UILabel alloc] init];
    self.quebiLabelNum.text = @"0小时";
    self.quebiLabelNum.textColor=[UIColor clearColor];
    [self addSubview:self.quebiLabelNum];
    [self.quebiLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.buhuoLabelNum.mas_bottom).offset(10*UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    

    

    //断网
    self.duanwangLabel = [[UILabel alloc] init];
    self.duanwangLabel.text = @"断网";
    self.duanwangLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.duanwangLabel];
    [self.duanwangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.quebiLabel.mas_bottom).offset(10*UISCALE);
        make.left.mas_equalTo(self.mas_left).offset(16 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.duanwangLevelLabel = [[UILabel alloc] init];
    self.duanwangLevelLabel.text = @"重要";
    self.duanwangLevelLabel.textColor=[UIColor clearColor];
    [self addSubview:self.duanwangLevelLabel];
    [self.duanwangLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.duanwangLabel.mas_right).offset(30 * UISCALE);
        make.top.mas_equalTo(self.duanwangLabel.mas_top);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];
    
    self.duanwangLabelNum = [[UILabel alloc] init];
    self.duanwangLabelNum.text = @"0小时";
    self.duanwangLabelNum.backgroundColor = [UIColor clearColor];
    [self addSubview:self.duanwangLabelNum];
    [self.duanwangLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( self.quebiLabelNum.mas_bottom).offset(10*UISCALE);
        make.right.mas_equalTo(self.mas_right).offset(-16 * UISCALE);
        make.width.mas_equalTo(50 * UISCALE);
        make.height.mas_equalTo(0 * UISCALE);
    }];


    
}

- (void)setupSubviewsProperty {
    self.machineSnLabel.textColor = [UIColor whiteColor];
    self.machineSnLabel.font = FontNotoSansLightWithSafeSize(25);
    
    self.positionLabel.textColor = [UIColor whiteColor];
    self.positionLabel.font = FontNotoSansLightWithSafeSize(17);
    self.positionLabel.scrollDuration = 6;
    self.positionLabel.marqueeType = MLLeftRight;//滚动样式
    
    self.lineView.backgroundColor = [UIColor whiteColor];//LINE_COLOR;
    
    self.guzhangLabel.layer.borderColor = GUZHANG_COLOR.CGColor;
    self.guzhangLabel.textColor = GUZHANG_COLOR;
    self.guzhangLabel.backgroundColor=[UIColor clearColor];
    [self setLabelProperty:self.guzhangLabel];
    
    self.buhuoLabel.layer.borderColor = BUHUO_COLOR.CGColor;
    self.buhuoLabel.textColor = BUHUO_COLOR;
    self.buhuoLabel.backgroundColor=[UIColor clearColor];

    [self setLabelProperty:self.buhuoLabel];
    
    self.quebiLabel.layer.borderColor = QUEBI_COLOR.CGColor;
    self.quebiLabel.textColor = QUEBI_COLOR;
    [self setLabelProperty:self.quebiLabel];
    
    self.duanwangLabel.layer.borderColor = DUANWANG_COLOR.CGColor;
    self.duanwangLabel.textColor = DUANWANG_COLOR;
    [self setLabelProperty:self.duanwangLabel];
    self.buhuoLabel.backgroundColor=[UIColor clearColor];
    
}

#pragma mark - private method
- (void)setLabelProperty:(UILabel *)label {
    label.font = FontNotoSansLightWithSafeSize(15);
    label.textAlignment = NSTextAlignmentCenter;
//    label.layer.borderWidth = 0.5;
//    label.layer.cornerRadius = 2;
//    label.layer.masksToBounds = YES;
}

#pragma mark setters and getters
- (void)setTitleText:(NSString *)titleText {
    self.machineSnLabel.text = titleText;
//    CGSize size = [titleText sizeWithAttributes:@{NSFontAttributeName : FontNotoSansLightWithSafeSize(17)}];
    [self.machineSnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.width);
    }];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setDetailText:(NSString *)detailText {
    self.positionLabel.text = detailText;
}
//-(void)setGuzhangLabelNum:(UILabel *)guzhangLabelNum{
//    self.guzhangLabelNum=guzhangLabelNum;
//}
//-(void)setBuhuoLabelNum:(UILabel *)buhuoLabelNum{
//    
//}
//-(void)setQuebiLabelNum:(UILabel *)quebiLabelNum{
//    self.quebiLabelNum=quebiLabelNum;
//}
//-(void)setDuanwangLabelNum:(UILabel *)duanwangLabelNum{
//    self.duanwangLabelNum=duanwangLabelNum;
//}
//
- (void)setIsGuzhang:(BOOL)isGuzhang {
    if (isGuzhang) {
        [self.guzhangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.lineView.mas_bottom).offset(10* UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
            
        }];
        
        [self.guzhangLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.lineView.mas_bottom).offset(10* UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
            
        }];
        
        [self.guzhangLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(10* UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
            
        }];

        
    }else{
        [self.guzhangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.lineView.mas_bottom).offset(0* UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        [self.guzhangLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.lineView.mas_bottom).offset(0* UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
            
        }];
        [self.guzhangLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(0* UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
            
        }];

        
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setIsQuehuo:(BOOL)isQuehuo {
    if (isQuehuo) {
        [self.buhuoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guzhangLabel.mas_bottom).offset(10 * UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];
        [self.buhuoLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guzhangLevelLabel.mas_bottom).offset(10 * UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];
        
        
        [self.buhuoLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guzhangLabelNum.mas_bottom).offset(10 * UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];

        
    }else{
        [self.buhuoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guzhangLabel.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        
        [self.buhuoLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guzhangLevelLabel.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        [self.buhuoLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guzhangLabelNum.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        

        
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setIsQuebi:(BOOL)isQuebi {
    if (isQuebi) {
        [self.quebiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buhuoLabel.mas_bottom).offset(10* UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];
        
        [self.quebiLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buhuoLevelLabel.mas_bottom).offset(10* UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];
        [self.quebiLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buhuoLabelNum.mas_bottom).offset(10* UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];

    }else{
        [self.quebiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buhuoLabel.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        
        [self.quebiLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buhuoLevelLabel.mas_bottom).offset(0* UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        [self.quebiLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buhuoLabelNum.mas_bottom).offset(0* UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];

    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setIsDuanwang:(BOOL)isDuanwang {
    if (isDuanwang) {
        [self.duanwangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quebiLabel.mas_bottom).offset(10 * UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];
        [self.duanwangLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quebiLevelLabel.mas_bottom).offset(10 * UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];
        [self.duanwangLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quebiLabelNum.mas_bottom).offset(10 * UISCALE);
            make.height.mas_equalTo(25 * UISCALE);
        }];

    }else{
        [self.duanwangLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quebiLabel.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        
        [self.duanwangLevelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quebiLevelLabel.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
        [self.duanwangLabelNum mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quebiLabelNum.mas_bottom).offset(0 * UISCALE);
            make.height.mas_equalTo(0 * UISCALE);
        }];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
