//
//  XTraderViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@class RoomHttp;

@interface XTraderViewController : UIViewController

- (id)initWihModel:(RoomHttp *)room;

- (void)reloadModel:(RoomHttp *)room;

@end
