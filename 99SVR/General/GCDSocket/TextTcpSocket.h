//
//  TextTcpSocket.h
//  99SVR
//
//  Created by xia zhonglin  on 1/11/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextTcpSocket : NSObject

- (void)connectTextServer:(NSString *)strIp port:(NSInteger)nPort;

@end
