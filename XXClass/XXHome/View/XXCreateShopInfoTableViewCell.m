//
//  XXCreateShopInfoTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXCreateShopInfoTableViewCell.h"

@interface XXCreateShopInfoTableViewCell ()
{
    shopCellSelectedBlock cellSelectedBlock;
}
@end
@implementation XXCreateShopInfoTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGB(245, 246, 248);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
- (void)cellSelectedWithBlock:(shopCellSelectedBlock)block {
    cellSelectedBlock = block;

}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(10, 10, SCREEN_WIDTH, 80);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(20, bgView.height/2.0);
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:@"unselect_icon"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;

    UILabel* machineID = [[UILabel alloc]init];
    machineID.frame = CGRectMake(50, 0, SCREEN_WIDTH, 40);
    machineID.font = [UIFont systemFontOfSize:17];
    machineID.textAlignment=NSTextAlignmentLeft;
    machineID.text=@"10086";
    [bgView addSubview:machineID];
    self.machineID = machineID;


    UILabel* address = [[UILabel alloc]init];
    address.frame = CGRectMake(50, CGRectGetMaxY(machineID.frame), SCREEN_WIDTH, 30);
    address.textAlignment = NSTextAlignmentLeft;
    address.text = @"西溪谷国际商务中心";
    address.textColor=[UIColor blackColor];
    address.font = [UIFont systemFontOfSize:17];
    address.tintColor=[UIColor blackColor];
    [bgView addSubview:address];
    self.address = address;

    
    
    
}

#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    if (cellSelectedBlock) {
        cellSelectedBlock (button.selected);
    }
    
    }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
