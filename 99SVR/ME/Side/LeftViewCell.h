//
//  LeftViewCell.h
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLeftViewBgColor UIColorFromRGB(0x006DC9)

@class LeftCellModel;

@interface LeftBtn : UIButton

@end

@interface LeftViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblRight;
@property (nonatomic,strong) UILabel *headLine;
@property (nonatomic,strong) UILabel *endLine;

- (void)setHeadLineFrame:(CGRect )frame;

- (void)setEndLineFrame:(CGRect) frame;


- (void)setModel:(LeftCellModel *)cellModel;

- (void)setrightInfo:(NSString *)strInfo;

@end
