//
//  XXChageViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXChageViewController.h"
#import "XXLoginViewController.h"
#import "AppDelegate.h"
@interface XXChageViewController ()
<UITextFieldDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITextField *oldTextField;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextField *sureTextField;

@property (nonatomic, strong) UIButton *doneBtn;


@end

@implementation XXChageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textField.text = nil;
    self.oldTextField.text = nil;
    self.sureTextField.text = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    [self.sureTextField resignFirstResponder];
    [self.oldTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor=RGB(248, 248, 248);
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;

    //    self.navigationController.navigationBar.barTintColor=RGB(249, 249, 249);
//    [self cfy_setNavigationBarBackgroundColor:RGB(248, 248, 248)];
    
    [self setupUI];
   

}

- (void)setupUI
{
    self.oldTextField = [[UITextField alloc] init];
    [self.view addSubview:self.oldTextField];
    [self.oldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(70*UISCALE);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(SECTION_HEIGHT * UISCALE);
    }];
    
    self.oldTextField.backgroundColor = [UIColor whiteColor];
    UILabel *oldLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120 * UISCALE, SECTION_HEIGHT * UISCALE)];
    oldLeftLabel.text = @"    旧密码";
    oldLeftLabel.font = FontNotoSansLightWithSafeSize(16);
    self.oldTextField.leftView = oldLeftLabel;
    self.oldTextField.leftViewMode = UITextFieldViewModeAlways;
    self.oldTextField.placeholder = @"请输入原密码";
    self.oldTextField.font = FontNotoSansLightWithSafeSize(16);
    self.oldTextField.secureTextEntry = YES;
    self.oldTextField.layer.borderWidth = 0.25;
    self.oldTextField.layer.borderColor = LINE_COLOR.CGColor;
    self.oldTextField.delegate = self;

    
    
    
    
    self.textField = [[UITextField alloc] init];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldTextField.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(SECTION_HEIGHT * UISCALE);
    }];
    
    self.textField.backgroundColor = [UIColor whiteColor];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120 * UISCALE, SECTION_HEIGHT * UISCALE)];
    leftLabel.text = @"    新密码";
    leftLabel.font = FontNotoSansLightWithSafeSize(16);
    self.textField.leftView = leftLabel;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"请输入新密码";
    self.textField.font = FontNotoSansLightWithSafeSize(16);
    self.textField.secureTextEntry = YES;
    self.textField.layer.borderWidth = 0.25;
    self.textField.layer.borderColor = LINE_COLOR.CGColor;
    self.textField.delegate = self;
    
    

    self.sureTextField = [[UITextField alloc] init];
    [self.view addSubview:self.sureTextField];
    [self.sureTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(SECTION_HEIGHT * UISCALE);
    }];
    self.sureTextField.backgroundColor = [UIColor whiteColor];
    UILabel *sureLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120 * UISCALE, SECTION_HEIGHT * UISCALE)];
    sureLeftLabel.text = @"    确认密码";
    sureLeftLabel.font = FontNotoSansLightWithSafeSize(16);
    self.sureTextField.leftView = sureLeftLabel;
    self.sureTextField.leftViewMode = UITextFieldViewModeAlways;
    self.sureTextField.placeholder = @"请再次输入新密码";
    self.sureTextField.font = FontNotoSansLightWithSafeSize(16);
    self.sureTextField.secureTextEntry = YES;
    self.sureTextField.layer.borderWidth = 0.25;
    self.sureTextField.layer.borderColor = LINE_COLOR.CGColor;
    self.sureTextField.delegate = self;

    
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(30 * UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(-30 * UISCALE);
        make.top.mas_equalTo(self.sureTextField.mas_bottom).offset(40 * UISCALE);
        make.height.mas_equalTo(44 * UISCALE);
    }];
    
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = FontNotoSansLightWithSafeSize(17);
    [self.doneBtn setTintColor:[UIColor whiteColor]];
    [self.doneBtn setBackgroundColor:RGB(57, 142, 235)];
    self.doneBtn.layer.cornerRadius = 16;
    [self.doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

}


// 修改请求
- (void)netWorking
{
    [SVProgressHUD show];
    self.doneBtn.userInteractionEnabled = NO;
    // api/user/put/{managerId}/newpwd/{newPassword}/oldpwd/{oldPassword}/loginidentifier/{loginIdentifier}
    [XXNetWorkHandle changePasswordWithManagerId:MANAGER_ID loginId:LOGIN_IDENTIFIER newPwd:self.textField.text oldPwd:self.oldTextField.text callback:^(BOOL isSuccess) {
        if (isSuccess) {
             [self hudDismiss:isSuccess];
        }else{
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            [self hudDismiss:NO];

        }
       
        
    }];
    
    
    [USER_DEFAULTS removeObjectForKey:@"loginIdentifier"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    
//    [XWAlert showAlertWithTitle:@"提示" message:@"密码已修改，请退出" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle: Alert confirmHandle:^{
//        NSLog(@"确定");
        
//            XXLoginViewController *loginVC=[[XXLoginViewController alloc] init];
//          
//
//            self.view.window.rootViewController = loginVC;
            
        
//            //退出程序
//            AppDelegate *app = [UIApplication sharedApplication].delegate;
//            UIWindow *window = app.window;
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                window.alpha = 0;
//                CGFloat y = window.bounds.size.height;
//                CGFloat x = window.bounds.size.width / 2;
//                window.frame = CGRectMake(x, y, 0, 0);
//            } completion:^(BOOL finished) {
//                exit(0);
//            }];
//
//            [self exitApplication];

      
        
//    } cancleHandle:^{
//        NSLog(@"取消");
//    }];
    });
//
    

}
//- (void)exitApplication {
//    [UIView beginAnimations:@"exitApplication" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
//    self.window.bounds = CGRectMake(0, 0, 0, 0);
//    [UIView commitAnimations];
//}
//- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//    if ([animationID compare:@"exitApplication"] == 0) {
//        exit(0);
//    }
//}
- (void)textFieldDidEndEditing:(UITextField *)textField;{
    if (textField==self.textField) {
        if (self.textField.text.length>20 ) {
            [XWAlert showAlertWithTitle:@"提示" message:@"密码不能超过20" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
                
            } cancleHandle:^{
            
            }];
        }else if (self.textField.text.length<6){
            [XWAlert showAlertWithTitle:@"提示" message:@"密码至少6位" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
                
            } cancleHandle:^{
                
            }];

        }
    }
  
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    if (textField == self.oldTextField) {
        [self.textField becomeFirstResponder];
    } else if (textField == self.textField) {
        [self.sureTextField becomeFirstResponder];
    } else {
        [self done];
    }
    return YES;
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

- (BOOL)equalWidthText:(NSString *)texta Text:(NSString *)textb
{
    if ([texta isEqualToString:textb]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isCorrectInput:(NSString *)password {
    NSString *regex = @"^([\u4e00-\u9fa5]+|[a-zA-Z0-9]+)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate  evaluateWithObject:password];
}

#pragma mark - event response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    [self.sureTextField resignFirstResponder];
    [self.oldTextField resignFirstResponder];
}

- (void)done
{
    [self.textField resignFirstResponder];
    [self.sureTextField resignFirstResponder];
    [self.oldTextField resignFirstResponder];
    if (self.textField.text.length != 0 && self.oldTextField.text.length != 0 && self.sureTextField.text.length != 0) {
        if ([self equalWidthText:self.textField.text Text:self.sureTextField.text]) {
            if ([self isCorrectInput:self.textField.text] && [self isCorrectInput:self.oldTextField.text] && [self isCorrectInput:self.sureTextField.text]) {
                [self netWorking];
            } else {
                [SVProgressHUD showErrorWithStatus:@"密码只能为数字或字母"];
                [self hudDismiss:NO];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"两次密码不相同"];
            [self hudDismiss:NO];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [self hudDismiss:NO];
    }
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
