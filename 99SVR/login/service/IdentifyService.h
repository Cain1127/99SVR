//
//  IdentifyService.h
//  99SVR
//  请求session id  验证码
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IdentifierQequest)(int nStatus,NSString *strId,UIImage *strImgPath);

@interface IdentifyService : NSObject

@property (nonatomic,copy) IdentifierQequest identiBlock;

- (void)requestIdentifier;

@end
