//
//  UITextView+PlaceHolderOfTexeView.h
//  带PlaceHolder的UITextView
//
//  Created by Dxc_iOS on 2017/5/16.
//  Copyright © 2017年 代星创. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolderOfTexeView)
@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//字数限制
@end
