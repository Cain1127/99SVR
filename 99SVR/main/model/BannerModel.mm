//
//  BannerModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "BannerModel.h"
#import <objc/runtime.h>
#include "HttpMessage.pb.h"

@implementation BannerModel

- (id)initWithData:(void *)pData
{
    self = [super init];
    BannerItem *item = (BannerItem *)pData;
    _url = [[NSString alloc] initWithUTF8String:item->croompic().c_str()];
    _type = [[NSString alloc] initWithUTF8String:item->type().c_str()];
    _webUrl = [[NSString alloc] initWithUTF8String:item->url().c_str()];
    return self;
}

- (NSMutableArray*)getPropetName
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([BannerModel class], &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

+ (BannerModel*)resultWithDict:(NSDictionary* )dict
{
    BannerModel *result = [[BannerModel alloc] init];
    if ([dict isKindOfClass:[NSString class]])
    {
        return result;
    }
    if ([dict objectForKey:@"params"]) {
        result.params = dict[@"params"];
        for (NSString *strParams in result.params.allKeys) {
            if ([strParams rangeOfString:@"url"].location != NSNotFound) {
                [result setValue:result.params[strParams] forKey:@"webUrl"];
            }
            else{
                [result setValue:result.params[strParams] forKey:strParams];
            }
        }
    }
    if ([dict objectForKey:@"type"]) {
        [result setValue:dict[@"type"] forKey:@"type"];
    }
    if ([dict objectForKey:@"url"]) {
        [result setValue:dict[@"url"] forKey:@"url"];
    }
    return result;
}



@end
