//
//  VideoLivingCell.m
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "VideoLivingCell.h"

#import "RoomHttp.h"

#import "UIImageView+WebCache.h"

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
    
    ///默认的高度
    CGFloat defaultHeight = 155.0f;

    ///背景图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:Rect(15.0f, 0.0f, kScreenWidth - 30.0f, defaultHeight)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView setImage:[UIImage imageNamed:@"default"]];
    [self.contentView addSubview:self.backgroundImageView];
    
    ///信息前透明底图
    UIImageView *infoRootImageView = [[UIImageView alloc]  initWithFrame:Rect(0.0f, 0.0f, 0.0f, 0.0f)];
    [infoRootImageView setImage:[UIImage imageNamed:@"video_info_background"]];
    [self.backgroundImageView addSubview:infoRootImageView];
    
    ///直播间房号
    self.roomChannelNumberLabel = [[UILabel alloc] initWithFrame:Rect(10.0f, defaultHeight - 10.0f - 16.0f, 80.0f, 16.0f)];
    self.roomChannelNumberLabel.font = XCFONT(12);
    self.roomChannelNumberLabel.textColor = UIColorFromRGB(0xFFFFFF);
    [self.backgroundImageView addSubview:self.roomChannelNumberLabel];
    
    ///直播间名字:在房间号之后创建，方便计算位置
    self.roomNameLabel = [[UILabel alloc] initWithFrame:Rect(10.0f, defaultHeight - 10.0f - 16.0f - 25.0f, 120.0f, 25.0f)];
    self.roomNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.roomNameLabel.textColor = UIColorFromRGB(0xFFFFFF);
    [self.backgroundImageView addSubview:self.roomNameLabel];
    
    ///阅读数量信息
    self.readAccountLabel = [[UILabel alloc] initWithFrame:Rect(CGRectGetWidth(self.backgroundImageView.frame) - 80.0f - 10.0f, self.roomChannelNumberLabel.frame.origin.y, 80.0f, CGRectGetHeight(self.roomChannelNumberLabel.frame))];
    self.readAccountLabel.font = XCFONT(12);
    self.readAccountLabel.textColor = UIColorFromRGB(0xFFFFFF);
    self.readAccountLabel.textAlignment = NSTextAlignmentRight;
    [self.backgroundImageView addSubview:self.readAccountLabel];
    
    ///阅读指示图片
    self.readIndicatorImageView = [[UIImageView alloc] initWithFrame:Rect(CGRectGetMaxX(self.readAccountLabel.frame) - 10.0f - 25.0f, self.roomChannelNumberLabel.frame.origin.y, 25.0f, CGRectGetHeight(self.readAccountLabel.frame))];
    self.readIndicatorImageView.image = [UIImage imageNamed:@"eye"];
    [self.backgroundImageView addSubview:self.readIndicatorImageView];

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

    self.roomNameLabel.text = 0 < dataModel.roomname.length ? dataModel.roomname : nil;
    self.roomChannelNumberLabel.text = dataModel.nvcbid;
    self.readAccountLabel.text = dataModel.ncount;
    
    ///加载图片
    if (0 >= dataModel.croompic.length)
    {
        
        return;
        
    }
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_HOME_URL,dataModel.croompic];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"home_room_default_img"]];

}

@end
