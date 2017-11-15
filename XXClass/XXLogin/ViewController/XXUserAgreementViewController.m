//
//  XXUserAgreementViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/6/3.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXUserAgreementViewController.h"
#import <WebKit/WebKit.h>
@interface XXUserAgreementViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation XXUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户协议";
    self.extendedLayoutIncludesOpaqueBars = YES;//加载webView设置
//    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.navigationController.navigationBar.translucent=YES;
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Clear"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

  
    [self setupPageSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.url == nil) {
        self.url = [[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"html"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)setupPageSubviews
{
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    [self.view addSubview:self.webView];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
