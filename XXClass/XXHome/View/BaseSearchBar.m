//
//  BaseSearchBar.m
//  Liuyoupai
//
//  Created by 岳杰 on 16/7/4.
//  Copyright © 2016年 NOE. All rights reserved.
//

#import "BaseSearchBar.h"

@implementation BaseSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(248, 248, 248);
        self.backgroundImage = [[UIImage alloc]init];
//        self.bgImage = IMAGE(@"navigationbar_textfiled_active-1");
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    if (self.bgImage) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextDrawImage(context, self.bounds, self.bgImage.CGImage);
        
        CGContextStrokePath(context);
    }
}

- (void)hidenKeyBoard
{
    [self resignFirstResponder];
}


@end
