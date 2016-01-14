//
//  SVRSocket.h
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVRSocket : NSObject

@property (nonatomic,copy) NSString *strAddress;

-(int)XzlConnect;

-(int)loginServerInfo:(NSString *)strUser pwd:(NSString *)strPwd;

@end
