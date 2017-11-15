//
//  XXTaskDetailViewController.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/18.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBaseViewController.h"
#import "AMTaskModel.h"
@interface XXTaskDetailViewController : XXBaseViewController
@property(nonatomic,assign)BOOL isArchive;
@property(strong,nonatomic)AMTaskModel *model;

@property(assign,nonatomic)int markID;
@property(copy,nonatomic)NSString *machineID;
@end
