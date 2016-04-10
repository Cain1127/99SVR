//
//  RoomTitle.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomGroup.h"
#import <objc/runtime.h>
#import "RoomHttp.h"

@implementation RoomGroup

- (NSArray*)getPropetName
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([RoomGroup class], &propertyCount);
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

+ (RoomGroup*)resultWithDict:(NSDictionary* )dict
{
    RoomGroup *result = [[RoomGroup alloc] init];
    if ([dict isKindOfClass:[NSString class]])
    {
        return result;
    }
    NSArray* propertyArray = [result getPropetName];
    for (NSString* key in propertyArray) {
        @try
        {
            if ([key isEqual:@"roomList"] && [dict[key] isKindOfClass:[NSArray class]])
            {
                NSArray *array = dict[key];
                
                NSMutableArray *aryCount = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in array)
                {
                    RoomHttp *textModel = [RoomHttp resultWithDict:dict];
                    [aryCount addObject:textModel];
                }
                result.roomList = aryCount;
            }
            else if ([key isEqual:@"groupList"] && [dict[key] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = dict[key];
                NSMutableArray *aryList = [NSMutableArray array];
                for (NSDictionary *roomlist in array)
                {
                    RoomGroup *group = [RoomGroup resultWithDict:roomlist];
                    [aryList addObject:group];
                }
                result.groupList = aryList;
            }
            else
            {
                [result setValue:dict[key] forKey:key];
            }
        }@catch(NSException *exception)
        {
            NSLog(@"except:%@:%@",key,dict[key]);
        }
    }
    return result;
}

@end
