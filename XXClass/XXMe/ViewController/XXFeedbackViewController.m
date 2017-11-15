//
//  XXFeedbackViewController.m
//  
//
//  Created by Dxc_iOS on 2017/4/12.
//
//

#import "XXFeedbackViewController.h"
#import "UITextView+PlaceHolderOfTexeView.h"
@interface XXFeedbackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation XXFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title=@"意见反馈";
    self.view.backgroundColor=RGB(238, 238, 238);;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
//  [self cfy_setNavigationBarBackgroundColor:RGB(248, 248, 248)];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
  [self setupUI];
}

-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets=NO;//防止textView光标会显示在中间

    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(20, 70, SCREEN_WIDTH-40, 200);
    textView.backgroundColor=[UIColor whiteColor];
//    textView.center = self.view.center;
    textView.delegate=self;
    textView.placeholder = @"请简要描述你的问题和意见";
    textView.limitLength = @120;
    [self.view addSubview:textView];
    self.textView=textView;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.doneBtn];
    self.doneBtn.frame=CGRectMake(30*UISCALE, CGRectGetMaxY(textView.frame)+100*UISCALE, SCREEN_WIDTH-60*UISCALE, 44 * UISCALE);
    [self.doneBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = FontNotoSansLightWithSafeSize(17);
    [self.doneBtn setTintColor:[UIColor whiteColor]];
    [self.doneBtn setBackgroundColor:RGB(57, 142, 235)];
    self.doneBtn.layer.cornerRadius = 16;
    [self.doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
#pragma mark - private method
- (void)hudDismiss:(BOOL)success
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.doneBtn.userInteractionEnabled = YES;
    });
}

- (NSString *)changeCode:(NSString *)text {
    return [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - event response
// 空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

- (void)done
{
    [self.textView resignFirstResponder];
    if (self.textView.text.length > 0) {
        [self netWorking];
    } else {
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"];
        [self hudDismiss:NO];
    }
}

- (void)netWorking
{
    [SVProgressHUD showWithStatus:@"提交中..."];
    self.doneBtn.userInteractionEnabled = NO;
    [XXNetWorkHandle feedbackWithManagerId:MANAGER_ID feedbackInfo:[self changeCode:self.textView.text] callback:^(BOOL isSuccess) {
        
        [self hudDismiss:isSuccess];
    }];
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
