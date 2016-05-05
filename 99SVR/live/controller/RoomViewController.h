//
//  RoomViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "GFBaseViewController.h"
@class  RoomHttp;

@interface RoomViewController : GFBaseViewController

DEFINE_SINGLETON_FOR_HEADER(RoomViewController)

- (void)setRoom:(RoomHttp*)room;

@property (nonatomic,strong) RoomHttp *room;

- (void)exitRoom;

- (void)removeNotice;

- (void)removeAllNotice;

- (void)addNotify;


@end


