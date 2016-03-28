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
/**
 *  账号登录
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 */
- (void)loginSuccess:(NSString *)username pwd:(NSString *)password;
/**
 *  修改密码
 *
 *  @param old      <#old description#>
 *  @param password <#password description#>
 */
- (void)updatePwd:(NSString *)old cmd:(NSString *)password;
/**
 *  修改昵称
 *
 *  @param strNick <#strNick description#>
 */
- (void)updateNick:(NSString *)strNick;

@end
