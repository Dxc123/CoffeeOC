//
//  XXOrderLine.h
//  OrderListStatus
//
//  Created by 代星创 on 2017/3/12.
//  Copyright © 2017年 Dxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXHeaderSliderMenu : UIView
//外部决定有多少模块
@property (nonatomic,strong) NSArray * items;

//内部选中某一个模块，传递给外部
@property (nonatomic,copy) void(^itemClickAtIndex)(NSInteger index);

//由外部决定选中哪一个模块
-(void)setSelectAtIndex:(NSInteger)index;
-(void)buttonClick:(UIButton*)button;

@end
