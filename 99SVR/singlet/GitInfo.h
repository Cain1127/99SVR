//
//  GitInfo.h
//  99SVR
//
//  Created by xia zhonglin  on 2/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLAnimatedImage;

@interface GitInfo : NSObject

DEFINE_SINGLETON_FOR_HEADER(GitInfo)

@property (nonatomic,strong) NSMutableDictionary *dictIcon;

- (void)removeAllIcon;

- (FLAnimatedImage *)findFLAnimated:(NSString *)strName;

@end
