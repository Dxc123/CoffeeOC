//
//  XXBaseViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXBaseViewController.h"
#import "XXBaseTabBarViewController.h"
@interface XXBaseViewController ()

@end

@implementation XXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     self.view.backgroundColor=RandomColor;
//     去除navigation黑线
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

//    [self.navigationController.navigationBar setTintColor:[UIColor colorHexToBinaryWithString:@"#2da9ff"]];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorHexToBinaryWithString:@"#2da9ff"]];
    //所有的返回按钮的title都是“返回”
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
//     如果A控制器的view成为B控制器的view的子控件,那么A控制器成为B控制器的子控制器
    
    XXBaseTabBarViewController *tabBarVc = [[XXBaseTabBarViewController alloc] init];

    // 添加子控制器
    [self addChildViewController:tabBarVc];
    

    [self setNetworkStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setNetworkStatus {
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [SVProgressHUD showImage:nil status:@"未知网络状态"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showImage:nil status:@"当前网络不可用"];
                break;
            default:
                break;
        }
    }];
}

- (void)setLoadDataSuccess:(BOOL)loadDataSuccess {
    if (loadDataSuccess) {
        self.holderView.hidden = YES;
    } else {
        self.holderView.hidden = NO;
    }
}

#pragma mark - setter
- (XXPlacehoderView *)holderView {
    if (_holderView == nil) {
        self.holderView = [[XXPlacehoderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:self.holderView];
        [self.holderView.refreshBtn addTarget:self action:@selector(refreshPageData) forControlEvents:UIControlEventTouchUpInside];
        self.holderView.hidden = YES;
    }
    return  _holderView;
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
