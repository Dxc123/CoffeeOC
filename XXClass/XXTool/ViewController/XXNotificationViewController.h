//
//  XXNoticeViewController.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBaseViewController.h"
#import "AMTaskModel.h"

typedef void (^ReturnTaskTurnBlock)(AMTaskModel *model);
//告警界面 返回一个机器错误类型
typedef void (^WorningTypeReturnBlock)(NSString *typeLevel);

typedef void (^RefreshForSaleDetail)(void);

@interface XXNotificationViewController : XXBaseViewController
@property(nonatomic,copy)ReturnTaskTurnBlock returnTaskBlock;
@property(nonatomic,copy)WorningTypeReturnBlock typeBlock;
@property(nonatomic,copy)RefreshForSaleDetail refresh;
/*标记是哪一个
 1表示报表里面的销售详情
 2表示任务列表未完成列表信息
 3表示告警信息列表
 */
@property(assign,nonatomic)int markID;

- (void)returnForRefreash:(RefreshForSaleDetail)block;
- (void)refreshWithDateArr:(NSMutableArray *)arr WithIsLossCnnect:(BOOL)LossConnect;

- (void)contentViewFrameBounds:(CGRect )bounds;


//返回2标记的
- (void)returnModelForTask:(ReturnTaskTurnBlock)taskBlock;
//返回3标记的
- (void)returnWorningTypeForTask:(WorningTypeReturnBlock)worningTypeBlock;


@end
