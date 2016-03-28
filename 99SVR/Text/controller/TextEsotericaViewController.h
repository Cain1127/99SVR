//
//  TextEsotericaViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 3/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextTcpSocket.h"
@interface TextEsotericaViewController : UIViewController

- (id)initWithSocket:(TextTcpSocket *)socket;

@end
