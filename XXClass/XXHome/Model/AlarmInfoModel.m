//
//  AlarmInfoModel.m
//  test
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "AlarmInfoModel.h"
#import <UIKit/UIKit.h>
//#import "AMConfig.h"

@implementation AlarmInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return NULL;
}

- (float)addHig{
    static float height;
    if (![self.alarmType isEqualToString:@"00"]&&![self.alarmType isEqualToString:@"03"]&&self.alarmReason.length>0) {
        UILabel *label = [[UILabel alloc]init];
        label.text = [NSString stringWithFormat:@"详情：%@",self.alarmReason];
        label.numberOfLines = 0;
        label.font = FONT_OF_SIZE(14);
        CGSize size = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-46*UISCALE, 0)];
        height = size.height;
    }else{
        height = 0;
    }
    return height;
}


@end
