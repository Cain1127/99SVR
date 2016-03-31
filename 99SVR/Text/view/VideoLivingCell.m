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

@property (nonatomic, strong) UIView *leftRootView;                 //!<左侧底view
@property (nonatomic, strong) UIView *rightRootView;                //!<右侧底view

@property (nonatomic, copy) void(^leftViewTapCallBack)(CJHomeListTypeLivingCellType viewType);
@property (nonatomic, copy) void(^rightViewTapCallBack)(CJHomeListTypeLivingCellType viewType);

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
    CGFloat middleGap = 10.0f;
    CGFloat defaultWidth = kScreenWidth - 3.0f * middleGap;
    
    ///添加左右底view
    self.leftRootView = [[UIView alloc] initWithFrame:CGRectMake(middleGap, 0.0f, defaultWidth / 2.0f, defaultHeight - 10.0f)];
    [self.contentView addSubview:self.leftRootView];
    
    self.rightRootView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftRootView.frame) + middleGap, 0.0f, defaultWidth / 2.0f, defaultHeight - 10.0f)];
    [self.contentView addSubview:self.rightRootView];

}

#pragma mark -
#pragma mark - create info show UI
- (void)createInfoShowingUI:(RoomHttp *)dataModel viewType:(CJHomeListTypeLivingCellType)viewType tapCallBack:(void(^)(CJHomeListTypeLivingCellType viewType))tapCallBack
{
    
    UIView *tempRootView = cCJHomeListTypeLivingCellTypeLeft == viewType ? self.leftRootView : self.rightRootView;
    
    ///清除原UI
    for (UIView *subView in tempRootView.subviews)
    {
        
        [subView removeFromSuperview];
        
    }

    ///背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:Rect(0.0f, 0.0f, CGRectGetWidth(tempRootView.frame), CGRectGetHeight(tempRootView.frame))];
    backgroundImageView.userInteractionEnabled = YES;
    [backgroundImageView setImage:[UIImage imageNamed:@"default"]];
    [tempRootView addSubview:backgroundImageView];
    
    ///加载图片
    if (0 < dataModel.croompic.length)
    {
        
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_HOME_URL,dataModel.croompic];
        [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"home_room_default_img"]];
        
        ///添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapFunction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [backgroundImageView addGestureRecognizer:tapGesture];
        
    }
    
    ///信息前透明底图
    UIImageView *infoRootImageView = [[UIImageView alloc]  initWithFrame:Rect(0.0f, CGRectGetHeight(backgroundImageView.frame) - 30.0f, CGRectGetWidth(backgroundImageView.frame), 30.0f)];
    [infoRootImageView setImage:[UIImage imageNamed:@"video_info_background"]];
    infoRootImageView.userInteractionEnabled = YES;
    [backgroundImageView addSubview:infoRootImageView];
    
    ///直播间名字:在房间号之后创建，方便计算位置
    UILabel *roomNameLabel = [[UILabel alloc] init];
    roomNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    roomNameLabel.textColor = UIColorFromRGB(0xFFFFFF);
    roomNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    roomNameLabel.text = dataModel.roomname;
    [infoRootImageView addSubview:roomNameLabel];
    
    ///直播间房号
    UILabel *roomChannelNumberLabel = [[UILabel alloc] init];
    roomChannelNumberLabel.font = XCFONT(12);
    roomChannelNumberLabel.textColor = UIColorFromRGB(0xFFFFFF);
    roomChannelNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    roomChannelNumberLabel.text = dataModel.nvcbid;
    [infoRootImageView addSubview:roomChannelNumberLabel];
    
    ///阅读指示图片
    UIImageView *readIndicatorImageView = [[UIImageView alloc] init];
    readIndicatorImageView.image = [UIImage imageNamed:@"eye"];
    readIndicatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [infoRootImageView addSubview:readIndicatorImageView];
    
    ///阅读数量信息
    UILabel *readAccountLabel = [[UILabel alloc] init];
    readAccountLabel.font = XCFONT(12);
    readAccountLabel.textColor = UIColorFromRGB(0xFFFFFF);
    readAccountLabel.textAlignment = NSTextAlignmentRight;
    readAccountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    readAccountLabel.text = dataModel.ncount;
    [infoRootImageView addSubview:readAccountLabel];
    
    ///约束
    NSDictionary *___allDictionary = NSDictionaryOfVariableBindings(roomNameLabel, roomChannelNumberLabel, readIndicatorImageView, readAccountLabel);
    
    NSString *___allHorizalSring = @"H:|-5-[roomNameLabel]-2-[roomChannelNumberLabel]-(>=1)-[readIndicatorImageView]-2-[readAccountLabel]-5-|";
    NSString *___roomNameVertical = @"V:|-5-[roomNameLabel]-5-|";
    
    NSArray *___allConstrainsArray = [NSLayoutConstraint constraintsWithVisualFormat:___allHorizalSring options:NSLayoutFormatAlignAllCenterY metrics:nil views:___allDictionary];
    NSArray *___roomNameConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:___roomNameVertical options:NSLayoutFormatAlignAllCenterY metrics:nil views:___allDictionary];
    [infoRootImageView addConstraints:___allConstrainsArray];
    [infoRootImageView addConstraints:___roomNameConstraintsArray];
    
    ///保存回调
    if (tapCallBack)
    {
        
        if (cCJHomeListTypeLivingCellTypeLeft == viewType)
        {
            
            self.leftViewTapCallBack = tapCallBack;
            
        }
        
        if (cCJHomeListTypeLivingCellTypeRight == viewType)
        {
            
            self.rightViewTapCallBack = tapCallBack;
            
        }
        
    }
    else
    {
        
        if (cCJHomeListTypeLivingCellTypeLeft == viewType)
        {
            
            self.leftViewTapCallBack = nil;
            
        }
        
        if (cCJHomeListTypeLivingCellTypeRight == viewType)
        {
            
            self.rightViewTapCallBack = nil;
            
        }
        
    }

}

/**
 *  @author yangshengmeng, 16-03-30 13:03:59
 *
 *  @brief  左右侧view点击时的回调
 *
 *  @param  viewType 当前点击的是哪个view
 *
 *  @since  v1.0.0
 */
- (void)viewTapFunction:(UITapGestureRecognizer *)tap
{
    
    UIView *rootView = tap.view.superview;
    
    if (!rootView)
    {
        
        return;
        
    }
    
    ///单击左侧view
    if (rootView == self.leftRootView)
    {
        
        if (self.leftViewTapCallBack)
        {
            
            self.leftViewTapCallBack(cCJHomeListTypeLivingCellTypeLeft);
            
        }
        
    }
    
    ///单击右侧view
    if (rootView == self.rightRootView)
    {
        
        if (self.rightViewTapCallBack)
        {
            
            self.rightViewTapCallBack(cCJHomeListTypeLivingCellTypeRight);
            
        }
        
    }
    
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
- (void)setVideoLivingRoomModel:(RoomHttp *)dataModel viewType:(CJHomeListTypeLivingCellType)viewType tapCallBack:(void(^)(CJHomeListTypeLivingCellType viewType))tapCallBack
{
    
    ///左侧UI刷新
    if (cCJHomeListTypeLivingCellTypeLeft == viewType)
    {
        
        [self createInfoShowingUI:dataModel viewType:cCJHomeListTypeLivingCellTypeLeft tapCallBack:tapCallBack];
        
    }
    
    ///右侧UI刷新
    if (cCJHomeListTypeLivingCellTypeRight == viewType)
    {
        [self createInfoShowingUI:dataModel viewType:cCJHomeListTypeLivingCellTypeRight tapCallBack:tapCallBack];
    }

}

@end
