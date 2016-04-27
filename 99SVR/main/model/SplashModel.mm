//
//  SplashModel.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 Jiangys . All rights reserved.
//  闪屏

#import "SplashModel.h"

@implementation SplashModel

- (id)initWithSplash:(Splash *)splash
{
    self = [super init];
    _imageUrl = [NSString stringWithUTF8String:splash->imageurl().c_str()];
    _url = [NSString stringWithUTF8String:splash->url().c_str()];
    _text = [NSString stringWithUTF8String:splash->text().c_str()];
    return self;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.url forKey:@"url"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.url = [decoder decodeObjectForKey:@"url"];
    }
    return self;
}

@end
