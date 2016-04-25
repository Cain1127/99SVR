//
//  TextRoomGroup.m
//  99SVR
//
//  Created by xia zhonglin  on 2/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextRoomModel.h"
#import <objc/runtime.h>

@implementation TextRoomModel


- (NSArray*)getPropetName
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([TextRoomModel class], &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    return propertyNames;
}

+ (TextRoomModel *)resultWithDict:(NSDictionary* )dict
{
    TextRoomModel *result = [[TextRoomModel alloc] init];
    NSArray* propertyArray = [result getPropetName];
    for (NSString* key in propertyArray) {
        @try
        {
            [result setValue:dict[key] forKey:key];
        }
        @catch(NSException *exception)
        {
            NSLog(@"except:%@:%@",key,dict[key]);
        }
    }
    return result;
}

@end
