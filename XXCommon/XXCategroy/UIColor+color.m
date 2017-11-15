//
//  UIColor+color.m
//  UIColor
//
//  Created by zp on 16/6/27.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "UIColor+color.h"

@implementation UIColor (color)
+(UIColor *)colorHexToBinaryWithString:(NSString *)color{
    NSString *hex = [color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].uppercaseString;
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    if (hex.length != 6) {
        return [UIColor blackColor];
    }
    NSString *redStr = [hex substringToIndex:2];
    NSString *greenStr = [[hex substringFromIndex:2]substringToIndex:2];
    NSString *blueStr = [[hex substringFromIndex:4]substringToIndex:2];
    
    unsigned int r = 0;
    unsigned int g = 0;
    unsigned int b = 0;
    
    [[NSScanner scannerWithString:redStr]scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr]scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr]scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}
@end
