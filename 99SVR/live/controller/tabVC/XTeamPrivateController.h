//
//  XTeamPrivateController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
#import "RoomHttp.h"

@interface XTeamPrivateController : UIViewController

- (id)initWithModel:(RoomHttp*)room;

- (void)setModel:(RoomHttp *)room;

@end
