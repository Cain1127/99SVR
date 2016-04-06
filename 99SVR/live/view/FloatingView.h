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
@property (nonatomic,assign) int nNumber;
@property (nonatomic,assign) int nGid;
@property (nonatomic,assign) int nUserId;

- (void)showGift:(CGFloat)time;

//- (id)initWithFrame:(CGRect)frame color:(int)nColor name:(NSString *)strName number:(int)nNumber gid:(int)ngid;
- (id)initWithFrame:(CGRect)frame color:(int)nColor name:(NSString *)strName number:(int)nNumber gid:(int)ngid userid:(int)nUserid;

@end
