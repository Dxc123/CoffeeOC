//
//  UIColor+color.h
//  UIColor
//
//  Created by zp on 16/6/27.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
// view.backgroundColor = [UIColor colorHexToBinaryWithString:@"#f0f0f0"];
@interface UIColor (color)
+ (UIColor *)colorHexToBinaryWithString:(NSString *)color;
@end
