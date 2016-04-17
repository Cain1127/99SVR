//
//  VedioCellView.h
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RoomHttp;

@protocol VideoViewDelegate <NSObject>

- (void)joinRoomSuccess;

- (void)joinRoomErr;

@end

@interface VideoCellView : UIView

@property (nonatomic,assign) id<VideoViewDelegate> delegate;

@property (nonatomic,strong) RoomHttp *room;

@end
