//
//  GroupListRequest.h
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GroupBlock)(int nStatus,NSArray *aryIndex);

@interface GroupListRequest : NSObject

@property (nonatomic,copy) GroupBlock groupBlock;

- (void)requestListRequest;

@end
