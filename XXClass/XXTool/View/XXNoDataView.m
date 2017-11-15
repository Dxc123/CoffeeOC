//
//  AMNoDataView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/6.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXNoDataView.h"

@interface XXNoDataView ()
{
    UIImageView *contentImage;
    UILabel *titleLabel;
}
@end



@implementation XXNoDataView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    contentImage = [[UIImageView alloc]init];
    contentImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-60);
    contentImage.bounds = CGRectMake(0, 0, 68, 68);
    [self addSubview:contentImage];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+10);
    titleLabel.font = FONT_OF_SIZE(14);
    titleLabel.textColor = RGBACOLOR(188, 188, 188, 1);
    [self addSubview:titleLabel];
    
}

- (void)reloadWithPicName:(NSString *)picName AndTitle:(NSString *)titleStr{
    
    contentImage.image = [UIImage imageNamed:picName];
    titleLabel.text = titleStr;
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(0, 40)];
    titleLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    
}












/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
