//
//  XXBaseTabBarViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBaseTabBarViewController.h"
#import "XXHomeViewController.h"
#import "XXToolViewController.h"
#import "XXReportViewController.h"
#import "XXMeViewController.h"
#import "XXBaseNavViewController.h"
@interface XXBaseTabBarViewController ()

@end

@implementation XXBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildViewControllers];

    
}
/***  添加所有子控制器*/

-(void)setUpChildViewControllers{
    XXHomeViewController *homeVc=[[XXHomeViewController alloc] init];
    [self setUpOneChildViewController:homeVc image:[UIImage imageNamed:@"iv_home_unselected"]  selectedImage:[UIImage imageNamed:@"iv_home_selected"]  title:@"日常"];
    XXReportViewController *gradeVC=[[XXReportViewController alloc] init];
    [self setUpOneChildViewController:gradeVC image:[UIImage imageNamed:@"iv_report_unselected"] selectedImage:[UIImage imageNamed:@"iv_report_selected"] title:@"报告"];
    XXToolViewController *friendsVC=[[XXToolViewController alloc] init];
    [self setUpOneChildViewController:friendsVC image:[UIImage imageNamed:@"tabbar_tools"] selectedImage:[UIImage imageNamed:@"tabbar_tools_active"] title:@"工具"];
//    XXMeViewController *meVC=[[XXMeViewController alloc] init];
//    [self setUpOneChildViewController:meVC image:[UIImage imageNamed:@"tabBar_setup"] selectedImage:[UIImage imageNamed:@"tabBar_setup_active"] title:@"设置"];

    

}

/**添加一个子控制器的方法*/
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage  title:(NSString *)title{
    XXBaseNavViewController *BaseNav=[[XXBaseNavViewController alloc] initWithRootViewController:viewController];
    viewController.title = title;
    viewController.tabBarItem.title=title;
    
    
    //    tabBarItem 的选中和不选中文字属性
    [viewController .tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [viewController .tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:64/255.0 green:146/255.0 blue:239/255.0 alpha:1.0]} forState:UIControlStateSelected];
    
    //    tabBarItem 的选中和不选中图片属性
    [viewController.tabBarItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [viewController.tabBarItem setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
       //    viewController.navigationItem.title = title;
    [self addChildViewController:BaseNav];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
