//
//  TextHomeViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@class TextRoomModel;

@interface TextHomeViewController : UIViewController

- (id)initWithRoom:(int32_t)roomid;

- (id)initWithModel:(TextRoomModel *)model;

@end
