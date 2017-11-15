//
//  NoMessageView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/29.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXNoNetView.h"
#import <AFNetworkReachabilityManager.h>
#import "XXNoNetView.h"


@interface XXNoNetView ()

@property(nonatomic,strong)UIImageView *NoNetImage;
@property(nonatomic,strong)UILabel *NoNetLabel;
@property(nonatomic,strong)UIButton *NoNetButton;
@end
@implementation XXNoNetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    self.backgroundColor = [UIColor whiteColor];
    //设置NoNetImage 无网络图片
    _NoNetImage = [[UIImageView alloc]init];
    _NoNetImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-108*UISCALE);
//    picImage.image = [UIImage imageNamed:@"ic_empty"];
    _NoNetImage.bounds = CGRectMake(0, 0, 68*UISCALE, 68*UISCALE);
    [self addSubview:_NoNetImage];
    
    //设置NoNetLabel 无网络提示语
    _NoNetLabel = [[UILabel alloc]init];
    _NoNetLabel.textColor = RGBACOLOR(188, 188, 188, 1);
    _NoNetLabel.font = FONT_OF_SIZE(15);
    _NoNetLabel.center = CGPointMake(self.frame.size.width/2, CGRectGetMaxY(_NoNetImage.frame)+25);
    [self addSubview:_NoNetLabel];
    _NoNetButton= [UIButton buttonWithType:UIButtonTypeSystem];
    _NoNetButton.frame = CGRectMake(self.frame.size.width/2-45*UISCALE, CGRectGetMaxY(_NoNetLabel.frame)+10, 90*UISCALE, 44*UISCALE);
     //设置NoNetButton 无网络重新加载按钮
    [_NoNetButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [_NoNetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _NoNetButton.titleLabel.font = FONT_OF_SIZE(15);
    _NoNetButton.backgroundColor = [UIColor whiteColor];
    _NoNetButton.layer.borderWidth = 0.5;
    _NoNetButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _NoNetButton.layer.cornerRadius = 3*UISCALE;
    _NoNetButton.hidden = YES;
    [_NoNetButton addTarget:self action:@selector(addRefresh) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_NoNetButton];
    
    [self getRefresh];

}
- (void)againConfigurationWithHeight:(CGFloat)height{
    _NoNetImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-108*UISCALE+height);
    _NoNetLabel.center = CGPointMake(self.frame.size.width/2, CGRectGetMaxY(_NoNetImage.frame)+25);
    _NoNetButton.frame = CGRectMake(self.frame.size.width/2-45*UISCALE, CGRectGetMaxY(_NoNetLabel.frame)+10, 90*UISCALE, 44*UISCALE);
}
- (void)getRefresh{
    _NoNetImage.image = nil;
    _NoNetButton.hidden = YES;
    _NoNetLabel.text = @"数据加载中...";
    
    CGSize size = [_NoNetLabel sizeThatFits:CGSizeMake(0, 50)];
    _NoNetLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    
    [self getReachAblity];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNetConnect) name:@"duanwangxianshi" object:nil];
}

- (void)showNetConnect{
    _NoNetImage.image = [UIImage imageNamed:@"empty_icon"];
    _NoNetLabel.text = @"网络出错啦，请点击按钮重新加载";
    _NoNetButton.hidden = NO;
    _NoNetLabel.textAlignment = 1;
    CGSize size = [_NoNetLabel sizeThatFits:CGSizeMake(0, 50)];
    _NoNetLabel.bounds = CGRectMake(0, 0, size.width, size.height);

}
- (void)addRefresh{
    [self getRefresh];
    if (self.refresh) {
        self.refresh();
    }
}

- (void)getReachAblity{
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger startMonitoring];
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"duanwangxianshi" object:nil userInfo:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                break;
            default:
                break;
        }
    }];
}

- (void)refreshForNewMessage:(RefreshBlock)block{
    self.refresh = block;
}

- (void)dismiss{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"duanwangxianshi" object:nil];
     [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
