//
//  XTeamPrivateController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
#import "RoomHttp.h"

@protocol WhatIsDelegate  <NSObject>

- (void)showQuestion;

@end

@interface XTeamPrivateController : UIViewController

@property (nonatomic,assign) id<WhatIsDelegate> delegate;

- (id)initWithModel:(RoomHttp*)room;

- (void)setModel:(RoomHttp *)room;

@end
