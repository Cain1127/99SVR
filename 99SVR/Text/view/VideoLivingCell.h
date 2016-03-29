//
//  VideoLivingCell.h
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomHttp;
@interface VideoLivingCell : UITableViewCell

/**
 *  @author             yangshengmeng, 16-03-29 13:03:24
 *
 *  @brief              根据视频直播信息的基本信息数据模型，刷新Cell
 *
 *  @param dataModel    视频直播的数据模型
 *
 *  @since              v1.0.0
 */
- (void)setVideoLivingRoomModel:(RoomHttp *)dataModel;

@end
