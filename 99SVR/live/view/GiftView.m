//
//  GiftView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "GiftView.h"
#import "GiftModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Touch.h"
#import "UserInfo.h"
#import "DecodeJson.h"

#define kGiftHeight 100
#define kNumberGift 105
@implementation GiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createGiftImage];
        [self initHiddenView];
    }
    return self;
}

- (void)createGiftImage
{
    UIImage *gift_frame = [UIImage imageNamed:@"gift_frame"];
    UIEdgeInsets insets = UIEdgeInsetsMake(2,2,gift_frame.size.height-4,gift_frame.size.height-4);
    _giftImage = [DecodeJson stretchImage:gift_frame capInsets:insets resizingMode:UIImageResizingModeStretch];
    
    UIImage *frame_number = [UIImage imageNamed:@"video_present_number_bg"];
    UIEdgeInsets number = UIEdgeInsetsMake(2,2,frame_number.size.height-6,2);
    _frameImage  = [DecodeJson stretchImage:frame_number capInsets:number resizingMode:UIImageResizingModeStretch];
}

- (void)setGestureHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:Rect(0, kScreenHeight, kScreenWidth, 0)];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)initHiddenView
{
    _hiddenView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    [self addSubview:_hiddenView];
    [_hiddenView setUserInteractionEnabled:YES];
    [_hiddenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setGestureHidden)]];
    [_hiddenView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setGestureHidden)]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, kScreenHeight-(kGiftHeight*2+80), kScreenWidth,kGiftHeight*2+30)];
    [self addSubview:_scrollView];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGFloat width = kScreenWidth/5;
    NSArray *aryIndex = [UserInfo sharedUserInfo].aryGift;
    NSInteger count = aryIndex.count;
    
    for (int i=0; i< count ; i++){
        UIView *singGift = [[UIView alloc] initWithFrame:Rect((i/10*kScreenWidth)+i%5*width,i/5%2*kGiftHeight, width, kGiftHeight-2)];
        [_scrollView addSubview:singGift];
        singGift.tag = i;
        
        GiftModel *model = [aryIndex objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(singGift.width/2-22, 5, 44, 44)];
        [singGift addSubview:imgView];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s/%@",kGif_Image_URL,model.pic]]];
        singGift.tag = [model.gid intValue];
        UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0,55, singGift.width, 18)];
        [singGift addSubview:lblName];
        [lblName setFont:XCFONT(15)];
        [lblName setTextColor:UIColorFromRGB(0x343434)];
        [lblName setTextAlignment:NSTextAlignmentCenter];
        [lblName setText:model.name];
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:Rect(lblName.x,lblName.y+lblName.height+5,singGift.width,18)];
        [lblPrice setFont:XCFONT(12)];
        [lblPrice setTextColor:UIColorFromRGB(0xB8B8B8)];
        [singGift addSubview:lblPrice];
        [lblPrice setText:model.price];
        [lblPrice setTextAlignment:NSTextAlignmentCenter];
        if(i==0)
        {
            [self selectView:singGift];
        }
        __weak GiftView *__self = self;
        [singGift clickWithBlock:^(UIGestureRecognizer *gesture) {
            [__self selectView:gesture.view];
        }];
    }
     _pageControl = [[UIPageControl alloc] init];
     _pageControl.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight - 70);
     _pageControl.bounds = CGRectMake(0, 0, 150, 50);
     _pageControl.numberOfPages = 2;
     _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xa8a8a8);
     _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xff7a1e);
     _pageControl.enabled = NO;
    [self addSubview:_pageControl];
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(10,99.5, kScreenWidth-20, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    [_scrollView addSubview:line];
    line = nil;
    line = [[UILabel alloc] initWithFrame:Rect(kScreenWidth+10,99.5, kScreenWidth-20, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    [_scrollView addSubview:line];
    line = nil;
    
    line = [[UILabel alloc] initWithFrame:Rect(10,_scrollView.height-1, kScreenWidth-20, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xCFCFCF)];
    [_scrollView addSubview:line];
    line = nil;
    
    line = [[UILabel alloc] initWithFrame:Rect(kScreenWidth+10,_scrollView.height-1, kScreenWidth-20, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xCFCFCF)];
    [_scrollView addSubview:line];
    [_scrollView setContentSize:CGSizeMake(kScreenWidth*2,120)];
    
    _scrollView.delegate = self;
    //底部View
    UIView *downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
    [self addSubview:downView];
    [downView setBackgroundColor:UIColorFromRGB(0xffffff)];
    _lblPrice = [[UILabel alloc] initWithFrame:Rect(10,10,100,30)];
    [downView addSubview:_lblPrice];
    [_lblPrice setFont:XCFONT(15)];
    [_lblPrice setTextColor:UIColorFromRGB(0xFF7A1E)];
    
    char cBuffer[100]={0};
    sprintf(cBuffer, "余额:%.01f",[UserInfo sharedUserInfo].goldCoin);
    [_lblPrice setText:[NSString stringWithUTF8String:cBuffer]];
    CGSize lblPriceSize = [_lblPrice.text sizeMakeWithFont:_lblPrice.font];
    _lblPrice.width = lblPriceSize.width;
    
    
    
    //赠送按钮
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSend setTitle:@"赠送" forState:UIControlStateNormal];
    [btnSend setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnSend setBackgroundColor:UIColorFromRGB(0xFF7A1E)];
    [downView addSubview:btnSend];
    btnSend.frame = Rect(kScreenWidth - 68, 3, 60,44);
    btnSend.layer.masksToBounds = YES;
    btnSend.layer.cornerRadius = 3;
    [btnSend addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPay setTitle:@"充值" forState:UIControlStateNormal];
    [btnPay setTitleColor:UIColorFromRGB(0xFF7A1E) forState:UIControlStateNormal];
    [btnPay setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    [downView addSubview:btnPay];
    btnPay.frame = Rect(btnSend.x-140, 3, 60,44);
    btnPay.layer.masksToBounds = YES;
    btnPay.layer.cornerRadius = 3;
    [btnPay addTarget:self action:@selector(paySelect) forControlEvents:UIControlEventTouchUpInside];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
    
    _btnNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnNumber setTitle:@"1" forState:UIControlStateNormal];
    UIImage *imgArrow = [UIImage imageNamed:@"video_present_number_point"];
    [_btnNumber setImage:imgArrow forState:UIControlStateNormal];
    [downView addSubview:_btnNumber];
    _btnNumber.frame = Rect(btnSend.x-75, btnSend.y+4,70, 36);
    [_btnNumber setBackgroundColor:UIColorFromRGB(0xE5E5E5)];
    [_btnNumber setTitleColor:UIColorFromRGB(0xff7a1e) forState:UIControlStateNormal];
    _btnNumber.titleLabel.font = XCFONT(15);
    [_btnNumber setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_btnNumber setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [_btnNumber addTarget:self action:@selector(selectNumber) forControlEvents:UIControlEventTouchUpInside];
    
    _numberView = [[UIView alloc] initWithFrame:self.bounds];
    _numberView.userInteractionEnabled = YES;
    [self addSubview:_numberView];
    __weak UIView *__numberview = _numberView;
    [_numberView clickWithBlock:^(UIGestureRecognizer *gesture) {
        __numberview.hidden = YES;
    }];
    _numberImgView = [[UIImageView alloc] initWithFrame:Rect(_btnNumber.x+_btnNumber.width/2-52.5,_scrollView.y,105,_scrollView.height+5)];
    [_numberImgView setImage:_frameImage];
    [_numberView addSubview:_numberImgView];
    _numberImgView.userInteractionEnabled = YES;
    
    _numberView.hidden = YES;
    CGFloat height = _scrollView.height/7;
    
    [self createButton:@"1314" frame:Rect(0, 0, kNumberGift, height)];
    [self createButton:@"888" frame:Rect(0,height, kNumberGift, height)];
    [self createButton:@"520" frame:Rect(0,height*2, kNumberGift, height)];
    [self createButton:@"88" frame:Rect(0,height*3, kNumberGift, height)];
    [self createButton:@"66" frame:Rect(0,height*4, kNumberGift, height)];
    [self createButton:@"16" frame:Rect(0,height*5, kNumberGift, height)];
    [self createButton:@"1" frame:Rect(0,height*6, kNumberGift, height)];
}

- (void)paySelect
{
    if(_delegate && [_delegate respondsToSelector:@selector(showPayView)])
    {
        [_delegate showPayView];
    }
}

- (void)updateGoid
{
    char cBuffer[100]={0};
    sprintf(cBuffer, "余额:%.01f",[UserInfo sharedUserInfo].goldCoin);
    [_lblPrice setText:[NSString stringWithUTF8String:cBuffer]];
    CGSize lblPriceSize = [_lblPrice.text sizeMakeWithFont:_lblPrice.font];
    _lblPrice.width = lblPriceSize.width;
}

- (void)selectView:(UIView *)view
{
    if (_selectView == nil) {
        _selectView = [[UIImageView alloc] initWithFrame:view.bounds];
        [_selectView setImage:_giftImage];
        [_scrollView addSubview:_selectView];
    }
    _selectView.frame = view.frame;
    _selectView.tag = view.tag;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
}


- (void)createButton:(NSString *)title frame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:UIColorFromRGB(0xFF87A1E) forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"video_tallk_bg_p"] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = frame;
    [_numberImgView addSubview:btn];
    [btn addTarget:self action:@selector(clickNumber:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNumber:(UIButton *)button
{
    [_btnNumber setTitle:button.titleLabel.text forState:UIControlStateNormal];
    _numberView.hidden=!_numberView.hidden;
}

- (void)selectNumber
{
    _numberView.hidden=!_numberView.hidden;
}

- (void)sendGift
{
    DLog(@"发送礼物");
    if (_delegate && [_delegate respondsToSelector:@selector(sendGift:num:)]) {
        int number = [_btnNumber.titleLabel.text intValue];
        if (_selectView.tag>0)
        {
            [_delegate sendGift:(int)_selectView.tag num:number];
        }
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
