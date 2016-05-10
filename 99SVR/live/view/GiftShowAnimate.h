//
//  GiftShowAnimate.h
//  99SVR
//
//  Created by xia zhonglin  on 5/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftShowAnimate : UIView

@property (nonatomic,strong) UILabel *sendName;
@property (nonatomic,strong) UIImageView *giftImg;
@property (nonatomic,strong) UIView *viewNumber;
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIImageView *rigtImg;

- (id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict;
- (void)addrightViewAnimation;

@end
