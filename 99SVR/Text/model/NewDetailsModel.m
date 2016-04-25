//
//  NewDetailsModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NewDetailsModel.h"
#import <objc/runtime.h>

@implementation NewDetailsModel

- (NSArray *)getPropertyNameList:(id)object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

+ (NewDetailsModel*)resultWithDict:(NSDictionary* )dict
{
    NewDetailsModel *result = [[NewDetailsModel alloc] init];
    NSArray* propertyArray = [result getPropertyNameList:result];
    
    if ([dict isKindOfClass:[NSString class]])
    {
        return result;
    }
    for (NSString* key in propertyArray) {
        @try
        {
            [result setValue:dict[key] forKey:key];
        }@catch(NSException *exception)
        {
            NSLog(@"except:%@:%@",key,dict[key]);
        }
    }
    return result;
}
@end
