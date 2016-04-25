//
//  XTeamViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/21/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "RoomHttp.h"

@interface XTeamViewController : CustomViewController

- (id)initWithModel:(RoomHttp *)room;

@end
