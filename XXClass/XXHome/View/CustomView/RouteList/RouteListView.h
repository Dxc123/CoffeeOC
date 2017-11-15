//
//  RouteListView.h
//  test
//
//  Created by 岳杰 on 2016/12/14.
//  Copyright © 2016年 岳杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteListView : UIView

/**
 *  @param routeId 当前线路id
 *  @param action 返回block
 **/
+ (id) routeId:(NSString *)routeId action:(void(^)(NSString *route_id, NSString *route_name))action;

@end
