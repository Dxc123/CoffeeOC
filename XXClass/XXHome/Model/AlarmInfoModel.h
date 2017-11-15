//
//  AlarmInfoModel.h
//  test
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 告警类型 00:缺货;01:缺币(5角);02:缺币(1元);03:断网;
 04:故障(主控);05:故障(纸币器);06:故障(硬币器) */
/** 告警级别 0:普通;1:重要;2:严重  */
@interface AlarmInfoModel : NSObject

@property (nonatomic, copy) NSString *typeName;//告警类型名称

@property (nonatomic, copy) NSString *distanceHour;//告警时间

@property (nonatomic, copy) NSString *alarmLevel;//告警级别

@property (nonatomic, copy) NSString *alarmReason;//告警原因

@property (nonatomic, copy) NSString *alarmType;//告警类型名称

@property (nonatomic, assign)float addHig;

@end
