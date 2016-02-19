//
//  RoomViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@class  RoomHttp;

@interface RoomViewController : UIViewController

- (id)initWithModel:(RoomHttp *)room;



@end


