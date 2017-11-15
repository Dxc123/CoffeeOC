//
//  XXShopListDetailTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/20.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXShopListDetailTableViewCell.h"

@interface XXShopListDetailTableViewCell ()
{
    ShopNumberChangedBlock numberAddBlock;
    ShopNumberChangedBlock numberCutBlock;
    ShopCellSelectedBlock cellSelectedBlock;
}

@end



@implementation XXShopListDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGB(245, 246, 248);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景·
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 50);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(10, 10, SCREEN_HEIGHT, 40);
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    

    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.width - 35, bgView.height - 35, 25, 25);
    [addBtn setImage:[UIImage imageNamed:@"add++"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"ad++"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(addBtn.left - 30, addBtn.top, 30, 25);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(numberLabel.left - 25, addBtn.top, 25, 25);
    [cutBtn setImage:[UIImage imageNamed:@"add--"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"ad--"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];

}
#pragma mark - 重写setter方法
- (void)setShopNumber:(NSInteger)shopNumber {
    _shopNumber = shopNumber;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)shopNumber];
}
#pragma mark - 按钮点击方法
- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberLabel.text integerValue];
    count++;
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}
- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }
    
    if (numberCutBlock) {
        numberCutBlock(count);
    }
}

- (void)numberAddWithBlock:(ShopNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(ShopNumberChangedBlock)block {
    numberCutBlock = block;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
