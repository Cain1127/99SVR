//
//  GiftView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftView : UIView <UIScrollViewDelegate>

@property (nonatomic,copy) UIImage *giftImage;
@property (nonatomic,strong) UIImageView *selectView;
@property (nonatomic,strong) UIView *hiddenView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *btnNumber;

@end
