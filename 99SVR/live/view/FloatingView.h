//
//  FloatingView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingView : UIView

@property (nonatomic,strong) UIImageView *imgGift;
@property (nonatomic,strong) UILabel *lblNumber;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,copy) NSString *strName;
@property (nonatomic,copy) NSString *strNumber;


- (void)showGift:(CGFloat)time;

- (id)initWithFrame:(CGRect)frame color:(int)nColor name:(NSString *)strName number:(NSString *)strNumber;

@end
