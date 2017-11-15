
//
//  ImageBtn.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "ImageBtn.h"
//#import "DayHeader.h"

@interface ImageBtn ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ImageBtn
//创建时直接确定好位置
- (id)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.5]}];
        
        if (size.width > 200 * UISCALE) {
            size.width = 200 * UISCALE;
        }
        
        self.lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, self.frame.size.height)];
        self.lb_title.font = [UIFont systemFontOfSize:17.5];
        self.lb_title.text = title;
        self.lb_title.textAlignment = NSTextAlignmentCenter;
        self.lb_title.textColor = [UIColor whiteColor];
        [self addSubview:self.lb_title];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.lb_title.frame.size.width+5, (self.frame.size.height - 11) / 2, 10, 10)];
        self.imgView.image = image;
        [self addSubview:self.imgView];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.imgView.frame.size.width + size.width, frame.size.height);
    }
    return self;
}

//更改title内容时可重新布局
- (void)resetData:(NSString *)title Image:(UIImage *)image
{
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : self.lb_title.font}];
    
    if (size.width > 200 * UISCALE) {
        size.width = 200 * UISCALE;
    }
    
    self.lb_title.frame = CGRectMake(0, 0, size.width, self.frame.size.height);
    self.lb_title.text = title;
    [self addSubview:self.lb_title];
    
    self.imgView.frame = CGRectMake(self.lb_title.frame.size.width+5, (self.frame.size.height - 11) / 2, 10, 10);
    self.imgView.image = image;
    [self addSubview:self.imgView];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.imgView.frame.size.width + size.width, self.frame.size.height);
}


@end
