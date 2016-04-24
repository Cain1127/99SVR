//
//  SecretViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 3/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
#import "TextTcpSocket.h"

@interface SecretViewController : CustomViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket secret:(int64_t)secretId;

@end
