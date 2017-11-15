//
//  XXAboutViewController.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/12.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXAboutViewController.h"
#import "XXGuideViewController.h"

#define CONTENT @" "
//#define CONTENT @"1.一切为了消费者\n\n2.为了一切消费者\n\n3.为了消费者一切"
@interface XXAboutViewController ()
{
    UIImageView*codeImage;
}
@end

@implementation XXAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于我们";
//    [self cfy_setNavigationBarBackgroundColor:RGB(248, 248, 248)];
    
    //二维码生成 实质:  把字符串转变为 图片
    // 需要 coreImage框架, 已经包含在了 UIKit框架里面
    [self setupUI];
    [self setupQR];
   

}

- (void)setupUI
{
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.view addSubview:iconView];
    iconView.image = IMAGE(@"152x152");
       [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(80*UISCALE);
        make.right.mas_equalTo(self.view.mas_right).offset(-147 * UISCALE);
        make.left.mas_equalTo(self.view.mas_left).offset(147 * UISCALE);
        make.height.mas_equalTo(iconView.mas_width);
    }];
    iconView.layer.cornerRadius=iconView.frame.size.width/2;
    iconView.layer.masksToBounds=YES;

    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"65度咖啡APP";
    titleLabel.font = FontNotoSansLightWithSafeSize(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).offset(15 * UISCALE);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(24 * UISCALE);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    [self.view addSubview:versionLabel];
//    NSString *str=@"当前版本信息：";
//    NSString *versionStr=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionLabel.text =[@"当前版本信息：" stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]; ;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = FontNotoSansLightWithSafeSize(14);
    versionLabel.textColor = RGB_COLOR(117, 117, 117);
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(6 * UISCALE);
        make.left.mas_equalTo(titleLabel.mas_left);
        make.right.mas_equalTo(titleLabel.mas_right);
        make.height.mas_equalTo(20 * UISCALE);
    }];
    
    
    //二维码图片
        codeImage = [[UIImageView alloc] init];
        [self.view addSubview:codeImage];
//        codeImage.image=IMAGE(@"code_icon");
        [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(versionLabel.mas_bottom).offset(30 * UISCALE);
            make.right.mas_equalTo(self.view.mas_right).offset(-120 * UISCALE);
            make.left.mas_equalTo(self.view.mas_left).offset(120 * UISCALE);
            make.height.mas_equalTo(120*UISCALE);
        }];

    //长按保存二维码
    codeImage.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    //属性设置
    //最小长按时间
    longPress.minimumPressDuration = 1;
    // 判断期间，允许用户移动的距离
    longPress.allowableMovement = 100;
    [codeImage addGestureRecognizer:longPress];
    
    
    

        UILabel *contentLabel = [[UILabel alloc] init];
        [self.view addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(codeImage.mas_bottom).offset(50 * UISCALE);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.height.mas_equalTo(40 * UISCALE);
        }];
        contentLabel.text = @"扫码下载";
        contentLabel.textColor=RGB_COLOR(117, 117, 117);
        contentLabel.font = FontNotoSansLightWithSafeSize(16);
        contentLabel.textAlignment=NSTextAlignmentCenter;
    
    
    
//    UILabel *contentLabel = [[UILabel alloc] init];
//    [self.view addSubview:contentLabel];
//    contentLabel.text = CONTENT;
//    contentLabel.font = FontNotoSansLightWithSafeSize(13);
//    contentLabel.textColor = RGB_COLOR(117, 117, 117);
//    contentLabel.numberOfLines = 0;
//    contentLabel.textAlignment=NSTextAlignmentCenter;
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(versionLabel.mas_bottom).offset(50 * UISCALE);
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.height.mas_equalTo(80 * UISCALE);
//    }];
    
//    UIImageView *codeView = [[UIImageView alloc] init];
//    [self.view addSubview:codeView];
//    
//    UILabel *copyrightLabel = [[UILabel alloc] init];
//    [self.view addSubview:copyrightLabel];
//    copyrightLabel.text = @"Copyright@杭州科技有限公司";
//    copyrightLabel.textColor = RGB_COLOR(117, 117, 117);
//    copyrightLabel.textAlignment = NSTextAlignmentCenter;
//    copyrightLabel.font = FontNotoSansLightWithSafeSize(10);
//    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.height.mas_equalTo(15 * UISCALE);
//        make.bottom.mas_equalTo(-30 * UISCALE);
//    }];
//    
//    UILabel *protocolLabel = [[UILabel alloc] init];
//    [self.view addSubview:protocolLabel];
//    protocolLabel.textColor = RGB_COLOR(168, 45, 27);
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"查看《用户协议》"];
//    NSDictionary * attris = @{NSForegroundColorAttributeName:[UIColor blackColor]};
//    [str setAttributes:attris range:NSMakeRange(0, 2)];
//    protocolLabel.attributedText = str;
//    protocolLabel.textAlignment = NSTextAlignmentCenter;
//    protocolLabel.font = FontNotoSansLightWithSafeSize(14);
//    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left).offset(100 * UISCALE);
//        make.right.mas_equalTo(self.view.mas_right).offset(-100 * UISCALE);
//        make.height.mas_equalTo(22 * UISCALE);
//        make.bottom.mas_equalTo(copyrightLabel.mas_top).offset(-6 * UISCALE);
//    }];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [protocolLabel addGestureRecognizer:tap];
//    protocolLabel.userInteractionEnabled = YES;
    
    
    
}

-(void)setupQR{
    
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
//  65度咖啡  https://itunes.apple.com/us/app/65%E5%BA%A6%E5%92%96%E5%95%A1/id1308221015?l=zh&ls=1&mt=8
//    叮咚屋运营 https://itunes.apple.com/cn/app/%E5%8F%AE%E5%92%9A%E5%B1%8B%E8%BF%90%E8%90%A5/id1244668622?mt=8
//    米克屋运营 https://itunes.apple.com/us/app/%E7%B1%B3%E5%85%8B%E5%B1%8B%E8%BF%90%E8%90%A5/id1282951128?l=zh&ls=1&mt=8
    NSString *string = @"https://itunes.apple.com/us/app/65%E5%BA%A6%E5%92%96%E5%95%A1/id1308221015?l=zh&ls=1&mt=8";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
//    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
//   codeImage.image = [UIImage imageWithCIImage:image];
    
    //取出图片
    CIImage *qrImage = [filter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(10, 10)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@"coffee_logo"];

    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    
    
    //设置图片
   codeImage.image = finalyImage;

    
}

#pragma mark langPress 长按手势事件
-(void)longPress:(UILongPressGestureRecognizer *)sender{
    //进行判断,在什么时候触发事件
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按状态");
    [XWAlert showAlertWithTitle:@"提示" message:@"您要保存当前图片到相册中吗？" confirmTitle:@"保存" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
            // 保存照片

        UIImageWriteToSavedPhotosAlbum(codeImage.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            

       

            
        } cancleHandle:^{
            
            
        }];
    }
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{

    if (!error) {
        
    [XWAlert showAlertWithTitle:@"提示" message:@"成功保存到相册" confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
        
        } cancleHandle:^{
            
            
        }];
        
    }else
        
    {
        [XWAlert showAlertWithTitle:@"提示" message:[error description] confirmTitle:@"确定" cancelTitle:@"取消" preferredStyle:Alert confirmHandle:^{
            
        } cancleHandle:^{
            
            
        }];
        
    }
    
}



#pragma mark - event response
- (void)tap
{
        XXGuideViewController *helpVC = [[XXGuideViewController alloc] init];
        helpVC.url = [[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"html"];
        helpVC.title = @"用户协议";
        [self.navigationController pushViewController:helpVC animated:YES];
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
