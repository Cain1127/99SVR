//
//  XIdeaViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomHttp;

@interface XIdeaViewController : UIViewController

- (id)initWihModel:(RoomHttp *)room;

- (void)setModel:(RoomHttp *)room;

@end
