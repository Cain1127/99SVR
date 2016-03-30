//
//  HomeTextLivingCell.m
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "HomeTextLivingCell.h"

#import "TextRoomModel.h"

#import "UIImageView+WebCache.h"

@interface HomeTextLivingCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;     //!<背景图片
@property (nonatomic, strong) UILabel *teactherNameLabel;           //!<讲师名
@property (nonatomic, strong) UIImageView *hotIndicatorImageView;   //!<当前讲师热度指示图片
@property (nonatomic, strong) UILabel *hotNumberLabel;              //!<当前讲师热度值
@property (nonatomic, strong) UILabel *descriptionLabel;            //!<当前讲师简介

@end

@implementation HomeTextLivingCell

#pragma mark -
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        ///init default UI
        [self initTextLivingCustomCellUI];
        
    }
    
    return self;

}

#pragma mark -
#pragma mark - init custom text list cell UI
- (void)initTextLivingCustomCellUI
{

    ///默认的高度
    CGFloat defaultHeight = 155.0f;
    
    ///背景图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:Rect(15.0f, 0.0f, kScreenWidth - 30.0f, defaultHeight)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView setImage:[UIImage imageNamed:@"default"]];
    [self.contentView addSubview:self.backgroundImageView];
    
    ///讲师名字
    self.teactherNameLabel = [[UILabel alloc] initWithFrame:Rect(10.0f, 10.0f, 80.0f, 30.0f)];
    self.teactherNameLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    self.teactherNameLabel.textColor = UIColorFromRGB(0x343434);
    [self.backgroundImageView addSubview:self.teactherNameLabel];
    
    ///热度指示图片
    self.hotIndicatorImageView = [[UIImageView alloc] initWithFrame:Rect(CGRectGetMaxX(self.teactherNameLabel.frame) + 10.0f, CGRectGetMinY(self.teactherNameLabel.frame) + 10.0f, 14.0f, 17.0f)];
    self.hotIndicatorImageView.image = [UIImage imageNamed:@"home_hot_indicator_img"];
    [self.backgroundImageView addSubview:self.hotIndicatorImageView];
    
    ///执度信息
    self.hotNumberLabel = [[UILabel alloc] initWithFrame:Rect(CGRectGetMaxX(self.hotIndicatorImageView.frame) + 2.0f, CGRectGetMinY(self.teactherNameLabel.frame) + 10.0f, 80.0f, 20.0f)];
    self.hotNumberLabel.font = XCFONT(22);
    self.hotNumberLabel.textColor = UIColorFromRGB(0xFF7A1E);
    [self.backgroundImageView addSubview:self.hotNumberLabel];
    
    ///讲师简介
    self.descriptionLabel = [[UILabel alloc] initWithFrame:Rect(10.0f, CGRectGetMaxY(self.hotNumberLabel.frame) + 8.0f, CGRectGetWidth(self.backgroundImageView.frame), 50.0f)];
    self.descriptionLabel.font = XCFONT(17);
    self.descriptionLabel.textColor = UIColorFromRGB(0x555555);
    [self.backgroundImageView addSubview:self.descriptionLabel];
    
}

#pragma mark -
#pragma mark - Refresh text living cell with latest data
/**
 *  @author             yangshengmeng, 16-03-29 17:03:44
 *
 *  @brief              根据给定的最新文字直播数据模型，刷新首页的文字直播cell信息
 *
 *  @param tempObject   文字直播列表使用的信息数据模型
 *
 *  @since              v1.0.0
 */
- (void)setTextRoomModel:(TextRoomModel *)dataModel
{

    self.teactherNameLabel.text = dataModel.roomname;
    self.hotNumberLabel.text = dataModel.ncount;
    self.descriptionLabel.text = dataModel.clabel;
    
    ///加载图片
    if (0 >= dataModel.croompic.length)
    {
        
        return;
        
    }
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_HOME_URL,dataModel.croompic];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"home_room_default_img"]];

}

@end
