//
//  NoMessageView.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/29.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^RefreshBlock)(void);

@interface XXNoNetView : UIView

@property(copy,nonatomic)RefreshBlock refresh;

//重新排布，给定位的高度缓解
- (void)againConfigurationWithHeight:(CGFloat)height;

- (void)refreshForNewMessage:(RefreshBlock)block;

- (void)dismiss;

@end
