//
//  RegisterService.h
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RegisterBlock)(int nStatus);

@interface RegisterService : NSObject

@property (nonatomic,copy) RegisterBlock regBlock;

- (void)registerServer:(NSString *)strName pwd:(NSString *)strPwd seesionId:(NSString *)strSession codeId:(NSString *)strCodeId;

@end
