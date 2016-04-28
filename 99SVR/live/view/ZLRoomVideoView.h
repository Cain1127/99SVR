//
//  ZLRoomVideoView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class XVideoModel;

@protocol ZLRoomVideoViewDelegate <NSObject>

- (void)connectModel;

@end

@interface ZLRoomVideoView : UIView

@property (nonatomic,assign) id<ZLRoomVideoViewDelegate> delegate;

@property (nonatomic,strong) XVideoModel *videoModel;



@end

