//
//  BannerModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "BannerModel.h"
#import <objc/runtime.h>

@implementation BannerModel

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
    if ([dict objectForKey:@"action"]) {
        result.action = dict[@"action"];
        for (NSString *strAction in result.action.allKeys) {
            if ([strAction isEqual:@"type"]) {
                [result setValue:result.action[strAction] forKey:strAction];
            }
            else
            {
                result.params = result.action[strAction];
            }
        }
        for (NSString *strParams in result.params.allKeys) {
            [result setValue:result.params[strParams] forKey:strParams];
        }
    }
    if ([dict objectForKey:@"url"]) {
        [result setValue:dict[@"url"] forKey:@"url"];
    }
    return result;
}



@end
