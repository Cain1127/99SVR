//
//  ZLLoginServer.h
//  99SVR
//
//  Created by xia zhonglin  on 3/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  新登录登录器类，里面保存C++类
 */
@interface ZLLogonServerSing : NSObject

DEFINE_SINGLETON_FOR_HEADER(ZLLogonServerSing)

- (void)loginSuccess:(NSString *)username pwd:(NSString *)password;


@end
