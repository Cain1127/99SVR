//
//  TextGroupList.m
//  99SVR
//
//  Created by xia zhonglin  on 3/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextGroupList.h"
#import <objc/runtime.h>
#import "TextRoomModel.h"
#import "TextLiveModel.h"

@implementation TextGroupList

- (NSArray*)getPropetName
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([TextGroupList class], &propertyCount);
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

+ (TextGroupList *)resultWithDict:(NSDictionary* )dict
{
    TextGroupList *result = [[TextGroupList alloc] init];
    NSArray *propertyArray = [result getPropetName];
    for (NSString* key in propertyArray) {
        @try
        {
            if ([key isEqual:@"rooms"])
            {
                NSArray *array = dict[key];
                NSMutableArray *aryCount = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in array)
                {
                    TextRoomModel *textModel = [TextRoomModel resultWithDict:dict];
                    [aryCount addObject:textModel];
                }
                result.rooms = aryCount;
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
