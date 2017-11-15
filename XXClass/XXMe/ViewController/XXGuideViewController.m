//
//  XXGuideViewController.m
//  
//
//  Created by Dxc_iOS on 2017/4/12.
//
//

#import "XXGuideViewController.h"
#import <WebKit/WebKit.h>


@interface XXGuideViewController ()
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation XXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户指南";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
    
//    [self cfy_setNavigationBarBackgroundColor:RGB(248, 248, 248)];
    [self setupPageSubviews];
}
- (void)setTitleStr:(NSString *)titleStr{
    if (_titleStr!=titleStr) {
        _titleStr = titleStr;
    }
    self.navigationItem.title = _titleStr;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.url == nil) {
//    self.url = [[NSBundle mainBundle] URLForResource:@"userguide" withExtension:@"html"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)setupPageSubviews
{
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT -40)];
    [self.view addSubview:self.webView];
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
