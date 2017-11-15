//
//  XXHostoryViewController.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBaseViewController.h"
#import "AMTaskModel.h"



typedef void (^ReturnTurnBlock)(NSString *machineID,NSString *routeStr);

typedef void (^ReturnTaskTurnBlock)(AMTaskModel *model);
//告警界面 返回一个机器号
typedef void (^WorningMachineReturnBlock)(NSString *machineID);

typedef void (^RefreshForSaleDetail)(void);

@interface XXHistoryViewController : XXBaseViewController

@property (nonatomic, copy) ReturnTurnBlock returnTurnBlock;
@property(nonatomic,copy)ReturnTaskTurnBlock returnTaskBlock;
@property(nonatomic,copy)WorningMachineReturnBlock machineReturnBlock;
@property(nonatomic,copy)RefreshForSaleDetail refresh;
/*标记是哪一个
 1表示报表里面的销售详情
 2表示任务列表未完成列表信息
 3表示告警信息列表
 */
@property(assign,nonatomic)int markID;

- (void)returnForRefreash:(RefreshForSaleDetail)block;
//输入数据刷新表
- (void)refreshWithDateArr:(NSMutableArray *)arr WithIsLossCnnect:(BOOL)LossConnect;
//修改table尺寸大小
- (void)contentViewFrameBounds:(CGRect )bounds;

//返回1标记的
- (void)ReturnTurnForOnLinePersonText:(ReturnTurnBlock)block;
//返回2标记的
- (void)returnModelForTask:(ReturnTaskTurnBlock)taskBlock;
//返回3标记的
- (void)returnMachineIDForTask:(WorningMachineReturnBlock)machineBlock;


@end
