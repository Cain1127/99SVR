//
//  RoomTitle.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomGroup.h"
#import <objc/runtime.h>

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
    return propertyNames;
}

+ (RoomGroup*)resultWithDict:(NSDictionary* )dict
{
    RoomGroup *result = [[RoomGroup alloc] init];
    NSArray* propertyArray = [result getPropetName];
    for (NSString* key in propertyArray) {
        @try
        {
//            NSLog(@"%@:%@,%@",key,dict[key],NSStringFromClass([dict[key] class]));
            if ([key isEqual:@"groupArr"])
            {
                [result setValue:dict[key] forKey:key];
            }
            else if([key isEqual:@"aryRoomHttp"])
            {
                
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
