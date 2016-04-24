//
//  TextHistroyViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 3/5/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@class TextTcpSocket;

@interface TextHistoryViewController : CustomViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket;

@end
