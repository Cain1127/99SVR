//
//  GitInfo.m
//  99SVR
//
//  Created by xia zhonglin  on 2/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "GitInfo.h"
#import "UIImage+animatedGIF.h"

@implementation GitInfo

DEFINE_SINGLETON_FOR_CLASS(GitInfo)


- (UIImage *)findIconImage:(NSString *)number
{
    if(_dictIcon==nil)
    {
        _dictIcon = [NSMutableDictionary dictionary];
    }
    UIImage *image = nil;
    if ([_dictIcon objectForKey:number])
    {
        image = [_dictIcon objectForKey:number];
    }
    else
    {
        image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:number withExtension:@"gif"]];
        [_dictIcon setObject:image forKey:number];
    }
    return image;
}

- (void)removeAllIcon
{
    if(_dictIcon)
    {
        [_dictIcon removeAllObjects];
    }
}

@end
