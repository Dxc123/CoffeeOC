//
//  ImageBtn.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBtn : UIView

@property (nonatomic, strong) UILabel *lb_title;

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title Image:(UIImage *)image;

- (void)resetData:(NSString *)title Image:(UIImage *)image;

@end
