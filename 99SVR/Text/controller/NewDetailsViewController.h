//
//  NewViewDetailsViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
#import "TextTcpSocket.h"
@class IdeaDetails;

@interface NewDetailsViewController : CustomViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket model:(IdeaDetails *)details;
- (id)initWithSocket:(TextTcpSocket *)tcpSocket viewID:(int64_t)viewId;


@end
