//
//  XXLoginViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXLoginViewController.h"
#import "XWAlert.h"
#import "XXUserManager.h"
#import "XXBaseTabBarViewController.h"
#import "XXMeViewController.h"
#import "XXBaseNavViewController.h"
#import "XXGuideViewController.h"
#import "XXUserAgreementViewController.h"
@interface XXLoginViewController ()<UITextFieldDelegate>
    {
        IQKeyboardReturnKeyHandler * _returnKeyHander;
    }
@property (strong, nonatomic) UIWindow *window;
@end

@implementation XXLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    是否显示键盘上方有一个tooBar
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    将键盘上Return键变为next键,点击进入下一个输入框,最后一个UITextField/UITextView的时候变为Done,点击收起键盘.
    _returnKeyHander = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    
    self.userName.text = [USER_DEFAULTS objectForKey:@"managerAccount"];
    self.passWord.text = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
 
    self.userName.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.userName.clearsOnBeginEditing = YES;
    self.userName.keyboardType =   UIKeyboardTypeNamePhonePad;;
    self.userName.tag=2017;
    
    self.passWord.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.passWord.clearsOnBeginEditing = YES;
    self.passWord.keyboardType=  UIKeyboardTypeNumberPad;
    self.passWord.secureTextEntry=YES;
    self.passWord.delegate=self;
    self.passWord.tag=2018;
    
    
//    self.logo.image=IMAGE(@"logo_icon_1");
    self.logo.layer.cornerRadius=self.logo.frame.size.width/2;
    self.logo.layer.masksToBounds=YES;
    self.logo.layer.borderWidth = 1.5f;//宽度
    self.logo.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
//    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logo.frame)+10*UISCALE, SCREEN_WIDTH, 40)];
//    lab.textAlignment=NSTextAlignmentCenter;
//    lab.text=@"叮咚屋补货端";
//    [self.view addSubview:lab];
    
//    UILabel *protocolLabel = [[UILabel alloc] init];
//    [self.view addSubview:protocolLabel];
//    protocolLabel.textColor = RGB_COLOR(168, 45, 27);
//    protocolLabel.textAlignment = NSTextAlignmentCenter;
//    protocolLabel.font = FontNotoSansLightWithSafeSize(12);
//    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left).offset(85 * UISCALE);
//        make.right.mas_equalTo(self.view.mas_right).offset(-85 * UISCALE);
//        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(10 * UISCALE);
//        make.height.mas_equalTo(20 * UISCALE);
//    }];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"登录即表示您同意《用户协议》"];
//    NSDictionary * attris = @{NSForegroundColorAttributeName:[UIColor grayColor]};
//    [str setAttributes:attris range:NSMakeRange(0, 9)];
////    protocolLabel.attributedText = str;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [protocolLabel addGestureRecognizer:tap];
//    protocolLabel.userInteractionEnabled = YES;


}
- (IBAction)LoginBtn:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        //支持是否为中文
        
        if ( [self isChinese:self.userName.text]){
            self.passWord.userInteractionEnabled=NO;
            [XWAlert showAlertWithTitle:@"提示" message:@"用户名只能为数字或字母" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
                self.passWord.text = @"";
                
            } cancleHandle:^{
                self.passWord.text = @"";
            }];
            self.passWord.userInteractionEnabled=YES;
        }


        
        [self loginWithUsername:self.userName.text password:self.passWord.text];
        

    }
   
}
 //判断是否是中文
- (BOOL)isCorrectInput:(NSString *)password {
    NSString *regex = @"^([\u4e00-\u9fa5]+|[a-zA-Z0-9]+)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate  evaluateWithObject:password];
}
- (BOOL)isChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}



//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password

{

    if ([self isCorrectInput:username]&&[self isCorrectInput:password]) {
        
        if (username.length != 0 && password.length != 0 ) {
            
            [SVProgressHUD showWithStatus:@"加载中..."];
//            [MBProgressHUD showProgressMessage:@"加载中..."];
            self.loginBtn.userInteractionEnabled = NO;
            
            [XXLoginHandle requestLoginWithAccount:username password:password callback:^(BOOL isSuccess) {
                
                [self hudDismiss:isSuccess];
                 [MBProgressHUD hideHUD];
                
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"账号或密码不正确"];
//            [MBProgressHUD showError:@"账号或密码不正确"];
            
            [self hudDismiss:NO];
            
        }
    }else{

        [SVProgressHUD showErrorWithStatus:@"账号和密码只能为数字或字母"];
//        [MBProgressHUD showError:@"账号或密码不正确"];
        [self hudDismiss:NO];
    }


    
    }

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    
    if (self.userName.text.length == 0 || self.passWord.text.length == 0) {
        ret = YES;
        
        [XWAlert showAlertWithTitle:@"温馨提示" message:@"请输入用户名和密码" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
            NSLog(@"确定-----");
        } cancleHandle:^{
            NSLog(@"取消-----");
        }];
        
 }    
    return ret;
}



#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.userName) {
        self.passWord.text = @"";
    }
    if (self.userName.text.length==0) {
         self.passWord.text = @"";
        return NO;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //支持是否为中文
    
    if ([self isChinese:self.userName.text]){
        self.passWord.userInteractionEnabled=NO;
        [XWAlert showAlertWithTitle:@"提示" message:@"用户名只能为数字或字母" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
            self.userName.text = @"";

            self.passWord.text = @"";
            
        } cancleHandle:^{
            self.userName.text = @"";

            self.passWord.text = @"";
        }];
         self.passWord.userInteractionEnabled=YES;
    }
    

}


//按回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userName) {
        [self.userName resignFirstResponder];
        [self.passWord becomeFirstResponder];
    } else if (textField == self.passWord) {
        [self.passWord resignFirstResponder];
        [self LoginBtn:nil];
//        [self loginWithUsername:self.userName.text password:self.passWord.text];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap用户协议");
    
    XXUserAgreementViewController *helpVC = [[XXUserAgreementViewController alloc] init];
    helpVC.url = [[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"html"];
    helpVC.title = @"用户协议";
    
    
    XXBaseNavViewController *nav=[[XXBaseNavViewController alloc] initWithRootViewController:helpVC];
//    [self.navigationController pushViewController:helpVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)hudDismiss:(BOOL)success {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            
//            MMDrawerController *drawerController=[[MMDrawerController alloc] initWithCenterViewController:[XXBaseTabBarViewController new] leftDrawerViewController:[[XXBaseNavViewController alloc] initWithRootViewController:[XXMeViewController new]]];
//            //            设置打开/关闭抽屉的手势
//            drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//            drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll
//            ;
//            //设置左边抽屉显示的多少
//            drawerController.maximumLeftDrawerWidth = 320.0;
//            self.view.window.rootViewController = drawerController;
            self.view.window.rootViewController = [XXBaseTabBarViewController new];
            
            
            
            
        }
    });
    self.loginBtn.userInteractionEnabled = YES;
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
