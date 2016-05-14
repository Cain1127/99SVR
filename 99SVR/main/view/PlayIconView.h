//
//  PlayIconView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayIconDelegate <NSObject>

- (void)exitPlay;
- (void)hidenPlay;
- (void)gotoPlay;

@end
@class PlayCurrentView;
@class RoomHttp;
@interface PlayIconView : UIView <PlayIconDelegate>

DEFINE_SINGLETON_FOR_HEADER(PlayIconView)
@property (nonatomic,strong) PlayCurrentView *playView;
@property (nonatomic,strong) UIImageView *btnPlay;

- (void)setRoom:(RoomHttp *)room;

@end

@interface PlayCurrentView : UIView

@property (nonatomic,assign) id<PlayIconDelegate> delegate;

@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblNumber;
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIButton *btnQuery;
@property (nonatomic,strong) UIButton *btnHidn;
@property (nonatomic,strong) UIButton *btnExit;

@end