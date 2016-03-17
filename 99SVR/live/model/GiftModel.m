//
//  GitfModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "GiftModel.h"
#import <objc/runtime.h>

@implementation GiftModel


- (NSArray*)getPropetName
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([GiftModel class], &propertyCount);
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

+ (GiftModel*)resultWithDict:(NSDictionary* )dict
{
    GiftModel *result = [[GiftModel alloc] init];
    if ([dict isKindOfClass:[NSString class]])
    {
        return result;
    }
    NSArray* propertyArray = [result getPropetName];
    for (NSString* key in propertyArray) {
        @try
        {
            [result setValue:dict[key] forKey:key];
            DLog(@"except:%@:%@",key,dict[key]);
        }@catch(NSException *exception)
        {
            NSLog(@"except:%@:%@",key,dict[key]);
        }
    }
    return result;
}



@end
