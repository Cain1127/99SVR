//
//  PrivateServiceForTeam.h
//  99SVR
//
//  Created by xia zhonglin  on 6/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PrivateBlock)(NSDictionary *dict);

@interface PrivateTeamService : NSObject

@property (nonatomic,copy) PrivateBlock block;

- (void)responseHttp:(NSDictionary *)dict;
- (void)requestTeamService:(int)teamid;

@end
