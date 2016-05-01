//
//  ZLShareView.h
//  99SVR
//
//  Created by xia zhonglin  on 5/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareDelegate <NSObject>

@optional
- (void)shareIndex:(NSInteger)index;
- (void)hiddenView;

@end

@interface ZLShareView : UIView

@property (nonatomic,assign) id<ShareDelegate> delegate;
@property (nonatomic,copy) UIImage *giftImage;
@property (nonatomic,strong) UIImageView *selectView;
@property (nonatomic,strong) UIView *hiddenView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *btnNumber;

@property (nonatomic,strong) UIImageView *numberImgView;
@property (nonatomic,copy) UIImage *frameImage;
@property (nonatomic,strong) UIView *numberView;
@property (nonatomic,strong) UILabel *lblPrice;

@property (nonatomic,strong) UIView *btnPar;


@end
