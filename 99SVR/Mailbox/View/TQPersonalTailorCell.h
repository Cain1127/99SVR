//
//  TQPersonalTailorCell.h
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQPersonalModel;
@interface TQPersonalTailorCell : UITableViewCell
/** 模型 */
@property (nonatomic ,weak)TQPersonalModel *personalModel;
/** <#desc#> */
@property (nonatomic ,assign)CGFloat cellHeight;
@end
