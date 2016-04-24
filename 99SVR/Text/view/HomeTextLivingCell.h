//
//  HomeTextLivingCell.h
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 16-03-29 17:03:42
 *
 *  @brief  自定义的主页列表，文字直播cell
 *
 *  @since  v1.0.0
 */
@class TextRoomModel;
@interface HomeTextLivingCell : UITableViewCell

/**
 *  @author             yangshengmeng, 16-03-29 17:03:44
 *
 *  @brief              根据给定的最新文字直播数据模型，刷新首页的文字直播cell信息
 *
 *  @param tempObject   文字直播列表使用的信息数据模型
 *  @param viewType     视图类型
 *  @param tapCallBack  点击时的回调
 *
 *  @since              v1.0.0
 */
- (void)setTextRoomModel:(TextRoomModel *)dataModel viewType:(CJHomeListTypeLivingCellType)viewType tapCallBack:(void(^)(CJHomeListTypeLivingCellType viewType))tapCallBack;

@end
