//
//  XXOrderLine.m
//  OrderListStatus
//
//  Created by 代星创 on 2017/3/12.
//  Copyright © 2017年 Dxc. All rights reserved.
//

#import "XXHeaderSliderMenu.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIView+EasyFrame.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
#define Button_Origin_Tag 50

static CGFloat arrow_H = 15;//箭头高
static CGFloat arrow_W = 20;//箭头宽

@implementation XXHeaderSliderMenu
{
    UIView * _lineView ;//下划线view
     CAShapeLayer *arrow_layer;//箭头layer
    UIButton *buton;
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    
    //先清空当前视图上的所有子视图
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加按钮
    CGFloat itemWidth = ScreenW/4+20;
    CGFloat itemHeight = self.frame.size.height-5;
    
    NSArray *imags = @[@"buddy_header_arrow_down1",@"buddy_header_arrow_right1"];

    
    for (int i = 0; i< items.count;i++ ) {
       buton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buton];
        
        buton.frame = CGRectMake((SCREEN_WIDTH/8-10+i*SCREEN_WIDTH/8*4)*UISCALE, 0, itemWidth, itemHeight);
        buton.layer.cornerRadius = 6;
        buton.layer.masksToBounds= YES;
        buton.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];
        [buton setImage:[UIImage imageNamed:imags[i]] forState:UIControlStateNormal];
        [buton setTitle:items[i] forState:UIControlStateNormal];
        buton.titleLabel.font=[UIFont systemFontOfSize:14];
//        [buton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//        [buton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [buton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        buton.tag = Button_Origin_Tag+i;

        [buton layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleLeft) imageTitleSpace:10];
        
       //分割线
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake((ScreenW/2)*UISCALE, 8, 2, 22*UISCALE)];
        view.backgroundColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];
        [self addSubview:view];
        
        if (i == 0) {
            buton.selected = YES;
        }
    }
    
    
    
    //分割线
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(ScreenW/8, self.frame.size.height+10, ScreenW/4, 2);
    _lineView.backgroundColor = [UIColor clearColor];//[UIColor orangeColor];
    [self addSubview:_lineView];
    //画箭头arrow
    [self drawArrowLayer];
    arrow_layer.position = CGPointMake(_lineView.width/2-25, _lineView.height/2);
    [_lineView.layer addSublayer:arrow_layer];
}
#pragma mark - drow arrow
- (void)drawArrowLayer {
    arrow_layer = [[CAShapeLayer alloc] init];
    arrow_layer.bounds = CGRectMake(0, 0, arrow_W, arrow_H);
    [arrow_layer setFillColor:[UIColor colorHexToBinaryWithString:@"#2da9ff"].CGColor];
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(arrow_W/2, 0)];
    [arrowPath addLineToPoint:CGPointMake(arrow_W, arrow_H)];
    [arrowPath addLineToPoint:CGPointMake(0, arrow_H)];
    [arrowPath closePath];
    arrow_layer.path = arrowPath.CGPath;
}
-(void)buttonClick:(UIButton*)button
{
    //获取点击的是第几个button
    NSInteger index = button.tag - Button_Origin_Tag;
    [self setSelectAtIndex:index];
    
    //2、把事件传递出去
    if (self.itemClickAtIndex) {
        _itemClickAtIndex(index);
    }
}
-(void)setSelectAtIndex:(NSInteger)index
{
    //1、先调整自身的视图显示
    for (int i = 0; i < self.items.count; i++) {
        UIButton * bt = [self viewWithTag:i+Button_Origin_Tag];
        
        if (bt.tag-Button_Origin_Tag == index) {
            bt.selected = YES;
            [bt setImage:[UIImage imageNamed:@"buddy_header_arrow_down1"] forState:UIControlStateNormal];

        }else{
            bt.selected = NO;
            [bt setImage:[UIImage imageNamed:@"buddy_header_arrow_right1"] forState:UIControlStateNormal];
        }
    }
    //调整分割线的位置
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _lineView.frame;
        rect.origin.x =(SCREEN_WIDTH/8+index*(rect.size.width+SCREEN_WIDTH/8*2))*UISCALE;
        _lineView.frame = rect;
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
