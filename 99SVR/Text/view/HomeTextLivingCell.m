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

@property (nonatomic, strong) UIView *leftRootView;                 //!<左侧底view
@property (nonatomic, strong) UIView *rightRootView;                //!<右侧底view

@property (nonatomic, copy) void(^leftViewTapCallBack)(CJHomeListTypeLivingCellType viewType);
@property (nonatomic, copy) void(^rightViewTapCallBack)(CJHomeListTypeLivingCellType viewType);

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
- (void)createInfoShowingUI:(TextRoomModel *)dataModel viewType:(CJHomeListTypeLivingCellType)viewType tapCallBack:(void(^)(CJHomeListTypeLivingCellType viewType))tapCallBack
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
        
        ///添加单击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapFunction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [backgroundImageView addGestureRecognizer:tapGesture];
        
    }
    
    ///讲师名字
    UILabel *teactherNameLabel = [[UILabel alloc] initWithFrame:Rect(10.0f, 10.0f, 80.0f, 30.0f)];
    teactherNameLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    teactherNameLabel.textColor = UIColorFromRGB(0x343434);
    teactherNameLabel.text = dataModel.roomname;
    [tempRootView addSubview:teactherNameLabel];
    
    ///热度指示图片
    UIImageView *hotIndicatorImageView = [[UIImageView alloc] initWithFrame:Rect(CGRectGetMaxX(teactherNameLabel.frame) + 10.0f, CGRectGetMinY(teactherNameLabel.frame) + 10.0f, 14.0f, 17.0f)];
    hotIndicatorImageView.image = [UIImage imageNamed:@"home_hot_indicator_img"];
    [tempRootView addSubview:hotIndicatorImageView];
    
    ///执度信息
    UILabel *hotNumberLabel = [[UILabel alloc] initWithFrame:Rect(CGRectGetMaxX(hotIndicatorImageView.frame) + 2.0f, CGRectGetMinY(teactherNameLabel.frame) + 10.0f, 80.0f, 20.0f)];
    hotNumberLabel.font = XCFONT(22);
    hotNumberLabel.textColor = UIColorFromRGB(0xFF7A1E);
    hotNumberLabel.text = dataModel.ncount;
    [tempRootView addSubview:hotNumberLabel];
    
    ///讲师简介
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:Rect(10.0f, CGRectGetMaxY(hotNumberLabel.frame) + 8.0f, CGRectGetWidth(backgroundImageView.frame), 50.0f)];
    descriptionLabel.font = XCFONT(17);
    descriptionLabel.textColor = UIColorFromRGB(0x555555);
    descriptionLabel.text = dataModel.clabel;
    [tempRootView addSubview:descriptionLabel];
    
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
#pragma mark - Refresh text living cell with latest data
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
- (void)setTextRoomModel:(TextRoomModel *)dataModel viewType:(CJHomeListTypeLivingCellType)viewType tapCallBack:(void(^)(CJHomeListTypeLivingCellType viewType))tapCallBack
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
