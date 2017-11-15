///Users/dxc/Desktop/米克屋/mikewu运营/CoffeeOC/XXNetwork
//  APIConfig.h
//  PersonAPP
//
//  Created by Dxc_iOS on 2017/4/8.
//  Copyright © 2017年 Dxc. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h


//叮咚屋补货员接口域名：http://app-yy-api.zjxfyb.com/help

//#define API_IP @"http://appapi.zongs365.com" // 宗盛

//#define API_IP @"http://118.190.44.110:7776"
//http://app-yy-api.zjxfyb.com   //叮咚屋 yuji1 123456
//http://39.108.188.180:8080  //米克屋 admin1 123456
//http://47.96.50.94:8080    //咖啡机
#define API_IP @"http://47.96.50.94"





#define MANAGER_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"managerId"]

#define LOGIN_IDENTIFIER [[NSUserDefaults standardUserDefaults] objectForKey:@"loginIdentifier"]

#define MANAGER_EMAIL [[NSUserDefaults standardUserDefaults] objectForKey:@"managerEmail"]
#define MANAGER_Name [[NSUserDefaults standardUserDefaults] objectForKey:@"managerName"]
#define MANAGER_Tel [[NSUserDefaults standardUserDefaults] objectForKey:@"managerTel"]





//首页数据

#define MACHINE_COUNT [NSString stringWithFormat:@"%@/api/home/macount/%@-%@", API_IP, managerId, routeId]//获取首页个数

#define MACHINE_LIST [NSString stringWithFormat:@"%@/api/home/manager/%@/route/%@/machinelist", API_IP, managerId, routeId]//获取首页线路售货机列表

#define FAIL_LIST [NSString stringWithFormat:@"%@/api/home/manager/%@/route/%@/machineinfolist/type/%ld", API_IP, managerId,routeId, machineType]//获取补货、缺币、断网、故障售货机列表

//api/home/manager/86/route/0/boilertemperature
//http://47.96.50.94/api/home/manager/86/route/0/boilertemperature
#define CoffeeTemperature [NSString stringWithFormat:@"%@/api/home/manager/%@/route/%@/boilertemperature", API_IP, managerId,routeId]//获取咖啡机温度

#define MACHINE_GOODS [NSString stringWithFormat:@"%@/api/home/machine/%@/goodsdetial", API_IP, machineSn]//获取售货机商品详细 - 缺货查询

//api/home/machine/{machineSn}/materialdetail
#define CoffeeMachine_Goods [NSString stringWithFormat:@"%@/api/home/machine/%@/materialdetail", API_IP, machineSn]
//获取咖啡机物料使用情况，截止上次补货



#define MACHINE_GOODS_LIST [NSString stringWithFormat:@"%@/api/home/machine/stockupinfos?machineSns=%@", API_IP, machineSns]//获取实时备货信息

#define MACHINE_SEARCH [NSString stringWithFormat:@"%@/api/home/route/%@/machine/stockupinfos/%@", API_IP, routeId, text]//获取生成指定机器的备货信息列表

#define SEARCH [NSString stringWithFormat:@"%@/api/home/machineinfolist/%@-%@", API_IP, managerId, text]//获取下拉售货机信息列表（搜索）
//stockupFlg = False
#define NEXT_DAY_GOODS [NSString stringWithFormat:@"%@/api/home/manager/%@/route/%@/nextdaypickinglist", API_IP, managerId, routeId]//获取生成次日备货单列表
//stockupdetail   //stockupFlg = True;
#define NEXT_DAY_Stockupdetail [NSString stringWithFormat:@"%@/api/home/manager/%@/route/%@/stockupdetail", API_IP, managerId, routeId]//获取备货单详细


#define TODAY_REPORT [NSString stringWithFormat:@"%@/api/home/manager/%@/route/%@/todayoperationalreport", API_IP, managerId, routeId]//获取今日运营报告信息

#define ROUTE_LIST [NSString stringWithFormat:@"%@/api/home/routelist/%@", API_IP, managerId]//获取用户线路列表
// http://app-yy-api.zjxfyb.com/api/home/manager/35/route/101034/nextdaypickinglist?goodsInfos=3434344545,1,12;
#define SEND_GOODS [NSString stringWithFormat:@"%@/api/home/put/manager/%@/route/%@/nextdaypickinglist?goodsInfos=%@", API_IP, managerId, routeId, goodsInfoStr]//发送次日备货单


#define COMPLETE_GOODS [NSString stringWithFormat:@"%@/api/home/put/manager/%@/replenishment/%@", API_IP, managerId, alarmId]//完成补货





//设置

#define LOGIN [NSString stringWithFormat:@"%@/api/user/%@/password/%@", API_IP, account, password]//用户登录
#define LOGIN_AUTOMATE [NSString stringWithFormat:@"%@/api/user/%@/identifier/%@", API_IP, managerId, loginId] //自动登录
#define MAIL_CHANGE [NSString stringWithFormat:@"%@/api/user/put/%@/email/%@/loginidentifier/%@", API_IP, managerId, email, loginId]//设置备货单接收邮箱

#define PASSWORD_CHANGE [NSString stringWithFormat:@"%@/api/user/put/%@/newpwd/%@/oldpwd/%@/loginidentifier/%@", API_IP, managerId, newPwd, oldPwd, loginId]//修改登录密码



#define FEEDBACK [NSString stringWithFormat:@"%@/api/system/post/feedbackinfo/user/%@?feedbackContent=%@", API_IP, managerId, info]//意见反馈








//gggggg   123456
//zhouxiang 123456
//yujie1   123456
//liangshengxi 123456




#endif /* APIConfig_h */
