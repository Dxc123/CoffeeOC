//
//  MachineCountCollectionViewCell.h
//  CoffeeOC
//
//  Created by Dxc_iOS on 2017/4/24.
//  Copyright © 2017年 Dxc_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineCountCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *itemTitleLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, copy) NSString *countText;

@end
