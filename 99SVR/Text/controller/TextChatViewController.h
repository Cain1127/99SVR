//
//  TextChatViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
@class TextTcpSocket;

@interface TextChatViewController : UIViewController

- (id)initWithSocket:(TextTcpSocket *)textSocket;

@end
