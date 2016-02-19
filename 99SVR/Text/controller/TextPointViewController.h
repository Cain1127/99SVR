//
//  TextPointViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 2/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@class TextTcpSocket;

@interface TextPointViewController : CustomViewController

- (id)initWithSocket:(TextTcpSocket *)socket;

@end
