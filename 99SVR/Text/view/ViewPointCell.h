//
//  ViewPointCell.h
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 16-03-29 13:03:16
 *
 *  @brief  自定义的精彩观点cell
 *
 *  @since  v1.0.0
 */
@class WonderfullView;
@interface ViewPointCell : UITableViewCell

/**
 *  @author             yangshengmeng, 16-03-29 13:03:33
 *
 *  @brief              根据给定的精彩观点刷新观点cellUI，展现给定的信息
 *
 *  @param dataModel    精彩视点的数据模型
 *
 *  @since              v1.0.0
 */
- (void)setViewPointModel:(WonderfullView *)dataModel;

@end
