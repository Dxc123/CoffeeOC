//
//  ReasonView.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/5.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "ReasonView.h"
//#import "AMConfig.h"
//#import "AMMacro.h"

@interface ReasonView ()<UITextViewDelegate>
{
    UITextView *texView;
    NSString *placeH;
    NSUInteger maxTextNumber;
}
@end

@implementation ReasonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        maxTextNumber = 100;
        [self createView];
       
    }
    return self;
}
- (void)createView{
    
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    UIView *showView = [[UIView alloc]init];
    showView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    showView.bounds = CGRectMake(0, 0, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)/330*240);
    showView.layer.cornerRadius = 8;
    showView.clipsToBounds = YES;
    showView.backgroundColor = [UIColor whiteColor];
    [self addSubview:showView];
    
    texView = [[UITextView alloc]init];
    texView.layer.borderWidth = 1;
    texView.layer.borderColor = [COLOR_GRAY CGColor];
    texView.frame = CGRectMake(10, 10, showView.frame.size.width-20, showView.frame.size.height-70);
    texView.delegate = self;
    texView.returnKeyType = UIReturnKeyDone;
    texView.font= FONT_OF_SIZE(14);
    texView.textColor = COLOR_GRAY;
    [showView addSubview:texView];
    NSArray *arr = @[@"确定",@"取消"];
    for (int i = 0; i<2; i++) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        typeBtn.frame = CGRectMake(showView.frame.size.width/2*i, showView.frame.size.height-50, showView.frame.size.width/2, 50);
        [typeBtn setTitle:arr[i] forState:UIControlStateNormal];
        typeBtn.tag = 10+i;
        [typeBtn setBackgroundColor:COLOR_MAIN];
        typeBtn.titleLabel.font = FONT_OF_SIZE(18);
        [typeBtn addTarget:self action:@selector(chooseTy:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:typeBtn];     
        [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(showView.frame.size.width/2, showView.frame.size.height-40, 1, 30)];
    centerView.backgroundColor = [UIColor whiteColor];
    [showView addSubview:centerView];
    
}


- (void)chooseTy:(UIButton *)sender{
    
    switch (sender.tag-10) {
        case 0:
        {
            if ([texView.text isEqualToString:placeH]||texView.text.length==0) {
                [SVProgressHUD showImage:nil status:@"请输入撤机或换线原因"];
            }else{
                if (self.returnBlock) {
                    self.returnBlock(texView.text);
                }
                [self removeFromSuperview];
            }
            break;
        }
            
        case 1:
        {
            [self removeFromSuperview];
            break;
        }
            
            
        default:
            break;
    }
}





- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>maxTextNumber) {
        textView.text = [textView.text substringToIndex:maxTextNumber];
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"字数超过%lu个字符",(unsigned long)maxTextNumber]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:placeH]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = placeH;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location>maxTextNumber) {
        return NO;
    }else if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self endEditing:YES];
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)getReasonPlaceHolderMessage:(NSString *)placeHolder FromView:(ReturnTurnBlock)block{
     
     self.returnBlock = block;
     placeH = [NSString stringWithFormat:@"请输入%@理由(最多输入%lu字)",placeHolder,(unsigned long)maxTextNumber];
     texView.text = placeH;
}


@end
