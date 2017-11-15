//
//  XXBaseViewController.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPlacehoderView.h"

@protocol XXBaseViewControllerDelegate <NSObject>

- (void)refreshPageData;

@end

@interface XXBaseViewController : UIViewController


// 断网下的占位图
@property (nonatomic, strong) XXPlacehoderView *holderView;

@property (nonatomic, assign) BOOL loadDataSuccess;
@end
