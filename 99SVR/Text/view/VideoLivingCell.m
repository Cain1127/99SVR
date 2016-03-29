//
//  VideoLivingCell.m
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "VideoLivingCell.h"

@interface VideoLivingCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;     //!<直播房间背景图片
@property (nonatomic, strong) UILabel *roomNameLabel;               //!<直播房间名
@property (nonatomic, strong) UILabel *roomChannelNumberLabel;      //!<直播房间号
@property (nonatomic, strong) UIImageView *readIndicatorImageView;  //!<阅读数量指示图片
@property (nonatomic, strong) UILabel *readAccountLabel;            //!<阅读数量信息

@end

@implementation VideoLivingCell

#pragma mark -
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        ///create default UI
        [self initVideoLivingCustomCellUI];
        
    }
    
    return self;

}

#pragma mark -
#pragma mark - init default UI
- (void)initVideoLivingCustomCellUI
{

    ///背景图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:Rect(0.0f, 0.0f, 0.0f, 0.0f)];

}

#pragma mark -
#pragma mark - Refresh video custom cell UI with base info
/**
 *  @author             yangshengmeng, 16-03-29 13:03:24
 *
 *  @brief              根据视频直播信息的基本信息数据模型，刷新Cell
 *
 *  @param dataModel    视频直播的数据模型
 *
 *  @since              v1.0.0
 */
- (void)setVideoLivingRoomModel:(RoomHttp *)dataModel
{

    

}

@end
