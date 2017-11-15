//
//  XXTableViewCell.m
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/11/14.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import "XXTableViewCell.h"
#import "MLMSegmentPageView.h"
#import "XXViewController1.h"
#import "XXViewController2.h"
#import "XXHeaderSliderMenu.h"
#import "view1.h"
#import "view2.h"
#import "XXViewController.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
@interface XXTableViewCell()<UIScrollViewDelegate>
{
    NSArray *list;
    UIScrollView *bgScroll;
}
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property(nonatomic,strong)XXHeaderSliderMenu *headerLine;
@property (nonatomic, strong) view1               *views1;
@property (nonatomic, strong) view2               *views2;

@property (nonatomic, assign) CGRect views1Frame;
@property (nonatomic, assign) CGRect views2Frame;
@end
@implementation XXTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    //    list = @[@"综合机",
    //             @"咖啡机"
    //             ];
    //
    //    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:list headStyle:SegmentHeadStyleArrow layoutStyle: MLMSegmentLayoutDefault];
    //    _segHead.fontScale = 1.1;
    //    _segHead.deSelectColor = [UIColor blackColor];
    //    _segHead.selectColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];
    //    _segHead.arrowColor = [UIColor colorHexToBinaryWithString:@"#2da9ff"];
    //    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, self.contentView.frame.size.height) vcOrViews:[self vcArr:list.count]];
    //    _segScroll.loadAll = YES;
    //    _segScroll.showIndex = 0;
    //
    ////    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
    ////        [self.contentView addSubview:_segHead];
    ////        [self.contentView addSubview:_segScroll];
    ////    }];
    //    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:NO completion:^{
    //        [self.contentView addSubview:_segHead];
    //        [self.contentView addSubview:_segScroll];
    //    } selectEnd:^(NSInteger index) {
    //        NSLog(@"第%ld个视图,有什么操作?",index);
    //    }];
    //
    //
    
    
    
    
    
    
    //自定义
    self.contentView.backgroundColor = RGB(249, 249, 249);
    _headerLine = [[XXHeaderSliderMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    _headerLine.items = @[@"综合机",@"咖啡机"];
    
    __weak typeof(self) weakSelf = self;
    _headerLine.itemClickAtIndex = ^(NSInteger index){
        [weakSelf adjustScrollView:index];
    };
    [self.contentView addSubview: _headerLine];
    
    
    //设置Scroll
    bgScroll = [[UIScrollView alloc]init];
    bgScroll.frame = CGRectMake(0,CGRectGetMaxY(_headerLine.frame)+20,ScreenW ,240*UISCALE);
    bgScroll.delegate = self;
    bgScroll.pagingEnabled = YES;
    bgScroll.directionalLockEnabled = YES;
    //    bgScroll.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:bgScroll];
    
    
    //        //设置Scroll上的俩bgView
    //    for (int i = 0; i<2; i++) {
    //        UIView *bgView = [[UIView alloc]init];
    //        bgView.frame = CGRectMake(ScreenW*i, 0, ScreenH, bgScroll.frame.size.height);
    //        //        bgView.backgroundColor=BLUE;
    //        bgView.tag = 2017+i;
    //        [bgScroll addSubview:bgView];
    //    }
    
    
    //
    //    UIView *view1 = [self viewWithTag:2017+0];
    //    XXViewController1 *vc1 = [[XXViewController1 alloc] init];
    //    [view1  addSubview:vc1.view];
    
    
    
    
    //    UIView *view2 = [self viewWithTag:2017+1];
    //   XXViewController2 *vc2 = [[XXViewController2 alloc] init];
    //    [view2 addSubview:vc2.view];
    //    [self addSubview:view2];
    
    _views1Frame = CGRectMake(0, 0, SCREEN_WIDTH, bgScroll.frame.size.height);
    _views2Frame = CGRectMake(SCREEN_WIDTH, 0,SCREEN_WIDTH, bgScroll.frame.size.height);
    
    _views1 = [[view1 alloc] initWithFrame:_views1Frame withSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        
    }];
    //    _views1.backgroundColor = [UIColor redColor];
    [bgScroll addSubview:_views1];
    
    _views2 = [[view2 alloc] initWithFrame:_views2Frame withSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath, NSArray *dataArray) {
        
    }];
    //    _views2.backgroundColor = [UIColor purpleColor];
    [bgScroll addSubview:_views2];
    
    
}



#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        XXViewController *vc = [XXViewController new];
        vc.index = i;
        [arr addObject:vc];
    }
    return arr;
}


- (NSArray *)viewArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        UIView *view = [NSClassFromString(@"View") new];
        [arr addObject:view];
    }
    return arr;
}

- (NSArray *)viewNameArr {
    return @[@"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View"
             ];
}

- (NSArray *)vcnameArr {
    return @[@"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController",
             @"XXViewController"
             ];
}

- (void)dealloc {
    NSLog(@"释放");
}
#pragma mark-通过点击button来改变scrollview的偏移量
-(void)adjustScrollView:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        bgScroll.contentOffset = CGPointMake(index*bgScroll.bounds.size.width, 0);
    }];
}

#pragma mark-选中scorllview来调整headvie的选中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_headerLine setSelectAtIndex:index];
    
    
}


#pragma mark
-(void)changeScrollview:(NSInteger)index{
    
    [UIView animateWithDuration:0 animations:^{
        bgScroll.contentOffset = CGPointMake(index*bgScroll.bounds.size.width, 0);
    }];
    
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
