//
//  XXSetEmailViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXSetEmailViewController.h"

@interface XXSetEmailViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *doneBtn;

@end

@implementation XXSetEmailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textField.text = nil;
    NSString *mail = MANAGER_EMAIL;
    if (mail.length != 0) {
        self.tipLabel.text = mail;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(248, 248, 248);
    self.navigationItem.title=@"设置邮箱";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;

//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
//     [self cfy_setNavigationBarBackgroundColor:RGB(248, 248, 248)];
    
   [self setUI];

    
}

- (void)setUI
{
    //显示邮箱
    self.tipLabel = [[UILabel alloc] init];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(80* UISCALE);
        make.left.mas_equalTo(self.view.mas_left).offset(50 * UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(50 * UISCALE);
        make.height.mas_equalTo(40* UISCALE);
    }];
    self.tipLabel.font = FontNotoSansLightWithSafeSize(15);
    self.tipLabel.textColor=BLUE;
    self.tipLabel.textAlignment=NSTextAlignmentLeft;
    
//    显示提示
    self.alertLabel = [[UILabel alloc] init];
    [self.view addSubview:self.alertLabel];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(50 * UISCALE);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(20 * UISCALE);
        make.height.mas_equalTo(50 * UISCALE);
    }];

    self.alertLabel.font=FontNotoSansLightWithSafeSize(14);
    self.alertLabel.textAlignment=NSTextAlignmentLeft;
    self.alertLabel.text=@"请设置备货单邮箱(建议添加QQ邮箱)";
    self.alertLabel.textColor=RGB(57, 142, 235);
    
    
//输入新邮箱
    self.textField = [[UITextField alloc] init];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(50 * UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(-50 * UISCALE);;
        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(40 * UISCALE);
        make.height.mas_equalTo(50 * UISCALE);
    }];
    //设置显示模式为永远显示(默认不显示)
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.delegate = self;
    self.textField.font = FontNotoSansLightWithSafeSize(16);
    self.textField.layer.cornerRadius = 6;
    self.textField.placeholder = @"输入新邮箱";
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    

//    确定按钮
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(50 * UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(-50 * UISCALE);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(40 * UISCALE);
        make.height.mas_equalTo(44 * UISCALE);
    }];
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = FontNotoSansLightWithSafeSize(17);
    [self.doneBtn setTintColor:[UIColor whiteColor]];
    [self.doneBtn setBackgroundColor:RGB(57, 142, 235) ];
    self.doneBtn.layer.cornerRadius = 16;
    [self.doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    

}

#pragma mark - custom delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self done];
    return YES;
}


#pragma mark - private method
- (void)hudDismiss:(BOOL)success
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
            [USER_DEFAULTS setObject:self.textField.text forKey:@"managerEmail"];
        }
        self.doneBtn.userInteractionEnabled = YES;
    });
}

// 正则表达式验证邮箱
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - event response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

- (void)done
{
    [self.textField resignFirstResponder];
    if ([self isValidateEmail:self.textField.text]) {
        [SVProgressHUD show];
        self.doneBtn.userInteractionEnabled = NO;
        // api/user/put/{managerId}/email/{managerEmail}/loginidentifier/{loginIdentifier}
        [XXNetWorkHandle changeEmailWithManagerId:MANAGER_ID
                                          loginId:LOGIN_IDENTIFIER
                                            email:self.textField.text callback:^(BOOL isSuccess) {
                                                [self hudDismiss:isSuccess];
                                            }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确邮箱"];
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
