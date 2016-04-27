//
//  SplashModel.h
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HttpMessage.pb.h"

@interface SplashModel : NSObject
/** 图片链接 */
@property (nonatomic, copy) NSString *imageUrl;
/**  */
@property (nonatomic, copy) NSString *text;
/** 跳转链接 */
@property (nonatomic, copy) NSString *url;
/**  */
@property (nonatomic, assign) NSUInteger startTime;
/**  */
@property (nonatomic, assign) NSUInteger endtime;

- (id)initWithSplash:(Splash *)splash;
@end
