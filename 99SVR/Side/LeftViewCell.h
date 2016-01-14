//
//  LeftViewCell.h
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLeftViewBgColor RGB(61, 120, 201)

@class LeftCellModel;

@interface LeftBtn : UIButton

@end

@interface LeftViewCell : UITableViewCell

//@property(nonatomic, strong) LeftCellModel *cellModel;
- (void)setModel:(LeftCellModel *)cellModel;

@end
