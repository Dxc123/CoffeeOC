//
//  ReasonView.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/5/5.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ReturnTurnBlock)(NSString *applyReason);

@interface ReasonView : UIView


@property(nonatomic,copy)ReturnTurnBlock returnBlock;

- (void)getReasonPlaceHolderMessage:(NSString *)placeHolder FromView:(ReturnTurnBlock)block;

@end
