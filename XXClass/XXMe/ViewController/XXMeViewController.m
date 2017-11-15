//
//  XXMeViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXMeViewController.h"
#import "XXSetEmailViewController.h"
#import "XXChageViewController.h"
#import "XXGuideViewController.h"
#import "XXFeedbackViewController.h"
#import "XXAboutViewController.h"
#import "XXBaseTabBarViewController.h"
#import "XXBaseNavViewController.h"
#import "XXHomeViewController.h"
#import "XXLoginViewController.h"
#import "XWAlert.h"
#import "XXUserManager.h"
#import "XXLoginViewController.h"
#import "UIImage+Extension.h"
#import "XXTodayReportViewController.h"
@interface XXMeViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, weak) UIImageView *coverImageView;
@property(nonatomic,strong)NSArray*titles;
@property(nonatomic,strong)NSArray*images;
@property (strong, nonatomic) UIView *headerView;//表头背景
@property (strong, nonatomic) UIView *FooterView;//表尾背景

@property (nonatomic,strong)UIImageView *myHeadPortraitist;//头像
@property (nonatomic,strong)UILabel *nikeLab;//名称

@end

@implementation XXMeViewController
//-(BOOL)prefersStatusBarHidden{
 //   return YES;
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置";
//     self.automaticallyAdjustsScrollViewInsets=NO;
    
//    self.navigationController.delegate = self;
//    self.nikeLab.text = nil;
    NSString *mail = [NSString stringWithFormat:@"%@",MANAGER_Name];
    if (mail.length != 0) {
        self.nikeLab.text = mail;
    }else{
        self.nikeLab.text = @"海燕";

    }

}


//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//       [self settingDrawerWhenPop];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    [self setUpMyTableView];
    self.titles = @[@"修改密码",@"用户指南",@"意见反馈",@"关于我们"];
    //@"检查更新",,@"setting_update"
 self.images=@[@"settingup_password",@"settingup_guide",@"settingup_feedback",@"settingup_about"];
    
}

-(void)setUpMyTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces=NO;
    [self.view addSubview:self.tableView];
    
    /*********表头背景View******/
    self.headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,210*UISCALE)];
    self.headerView.backgroundColor=[UIColor colorHexToBinaryWithString:@"#2da9ff"];
    self.headerView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapheader=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taphearer:)];
    [self.headerView addGestureRecognizer:tapheader];
    self.tableView .tableHeaderView=self.headerView;
    self.FooterView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.frame.size.width, self.view.frame.size.height-self.tableView.frame.size.height)];
    UIImageView *bgImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [bgImage1 setImage:[UIImage imageNamed:@"bg_icon"]];
    [self.FooterView addSubview:bgImage1];
    /********头像*******/
    self.myHeadPortraitist=[[UIImageView alloc] init];
    [self.headerView addSubview:self.myHeadPortraitist];
    self.myHeadPortraitist.sd_layout.leftSpaceToView(self.headerView,150*UISCALE).topSpaceToView(self.headerView,60*UISCALE).widthIs(90).heightIs(90);
    [self.myHeadPortraitist setImage:[UIImage imageNamed:@"152x152"]];
    self.myHeadPortraitist.layer.cornerRadius=self.myHeadPortraitist.frame.size.width/2;
    self.myHeadPortraitist.layer.masksToBounds=YES;
//    self.myHeadPortraitist.layer.borderWidth = 1.5f;//宽度
//    self.myHeadPortraitist.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
    self.myHeadPortraitist.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterHeadPortrait:)];
    [self.myHeadPortraitist addGestureRecognizer:singleTap];
    /*******姓名*******/
    UILabel *nikeLab=[[UILabel alloc] init ];
    [self.headerView addSubview:nikeLab];
    nikeLab.sd_layout.widthIs(100*UISCALE).heightIs(44*UISCALE).bottomSpaceToView(self.headerView, 25*UISCALE).leftSpaceToView(self.headerView, 140*UISCALE);
    nikeLab.text=@"海燕";
    nikeLab.textColor=[UIColor whiteColor];
    nikeLab.textAlignment=NSTextAlignmentCenter;
    self.nikeLab=nikeLab;
    
    UIButton *quitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:quitBtn];
    quitBtn.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).widthIs(SCREEN_WIDTH).heightIs(40*UISCALE);
    [quitBtn setTitle:@"退出" forState: UIControlStateNormal ];
    quitBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [quitBtn addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [quitBtn setImage:[UIImage imageNamed:@"bottomBg_icon"] forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:RGB(245, 245, 245)];
    
}

#pragma mark -->UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0*UISCALE;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [[UIColor alloc]initWithRed:220/255.0 green:230/255.0 blue:240/255.0 alpha:0.5];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image=[UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    cell.textLabel.font=FontNotoSansLightWithSafeSize(15);
//    cell.textLabel.highlightedTextColor = [UIColor greenColor];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.row) {
        case 0:
        {

        [self.navigationController pushViewController:[XXChageViewController new] animated:YES];}
            break;
        case 1:
        {
            [self.navigationController pushViewController:[XXGuideViewController new] animated:YES];

            
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:[XXFeedbackViewController new] animated:YES];
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[XXAboutViewController new] animated:YES];

        }
            break;
    
            
        default:
            break;
    }
    
    
}

-(void)taphearer:(UITapGestureRecognizer *)tap{
//    [self.sideMenuViewController setContentViewController:[XXBaseTabBarViewController new]
//                                                 animated:YES];
//    [self.sideMenuViewController hideMenuViewController];
//    

    
}
#pragma mark -->头像点击方法
//  方法：alterHeadPortrait
-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
    /********弹出提示框********/

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    //按钮：从相册选择，类型：UIAlertActionStyleDefault
//    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"相册");
//        //初始化UIImagePickerController
//        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
//        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
//        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
//        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
//        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        //允许编辑，即放大裁剪
//        PickerImage.allowsEditing = YES;
//        //自代理
//        PickerImage.delegate = self;
//        //页面跳转
//        [self presentViewController:PickerImage animated:YES completion:nil];
//    }]];
//    //按钮：拍照，类型：UIAlertActionStyleDefault
//    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//        NSLog(@"相机");
//        //        /**
//        //         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
//        //         */
//                UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
//                //获取方式:通过相机（只能真机测试）
//                PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
//                PickerImage.allowsEditing = YES;
//                PickerImage.delegate = self;
//                [self presentViewController:PickerImage animated:YES completion:nil];
//    }]];
//    //按钮：取消，类型：UIAlertActionStyleCancel
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -->btn点击方法
-(void)quitBtnClick{
    NSLog(@"退出");
    [XWAlert showAlertWithTitle:@"温馨提示" message:@"真的退出登录吗" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle: Alert confirmHandle:^{
        NSLog(@"确定----");
        
//        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"managerName"] ];
//        if ([str isEqualToString:@"(null)"]) {
//            [XWAlert showAlertWithTitle:@"提示" message:@"已经退出登录了，还点..." confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
//                 NSLog(@"确定----");
//            } cancleHandle:^{
//                NSLog(@"取消----");
//            }];
//
//        }else{
//            [XXUserManager isAutoLogout];
//            [self.navigationController pushViewController:[XXLoginViewController new] animated:YES];
//        }
       
//        [self.navigationController pushViewController:[XXLoginViewController new] animated:YES];
//    [USER_DEFAULTS removeObjectForKey:@"loginIdentifier"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XXLoginViewController *loginVC=[[XXLoginViewController alloc] init];
            
            self.view.window.rootViewController = loginVC;
        });

        [USER_DEFAULTS removeObjectForKey:@"loginIdentifier"];

        
    } cancleHandle:^{
        NSLog(@"取消----");
    }];
    
}


#pragma mark - Private

/// 添加当前页面的截屏
- (void)addCurrentPageScreenshot {
    
    UIImage *screenImage = [UIImage screenshot];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:screenImage];
    imgView.image = screenImage;
    [self.view addSubview:imgView];
    self.coverImageView = imgView;
    
}


//// 设置抽屉视图pop后的状态
//- (void)settingDrawerWhenPop {
//
//    self.mm_drawerController.maximumLeftDrawerWidth = 320;
//    self.mm_drawerController.showsShadow = YES;
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//    [self.coverImageView removeFromSuperview];
//    self.coverImageView = nil;
//
//}

/// 设置抽屉视图push后的状态
//- (void)settingDrawerWhenPush {
//
//    [self.mm_drawerController setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width];
//    self.mm_drawerController.showsShadow = NO;
//    // 这里一定要关闭手势，否则隐藏在屏幕右侧的drawer可以被拖拽出来
//    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
//
//}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[XXMeViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [navigationController setNavigationBarHidden:NO animated:YES];
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
