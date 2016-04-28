//
//  RoomHttp.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomHttp.h"
#include "HttpMessage.pb.h"
#import <objc/runtime.h>

@implementation RoomHttp

- (id)initWithData:(void *)data
{
    self = [super init];
    Team *_team = (Team *)data;
    _roomid = NSStringFromInt(_team->roomid());
    _teamid = NSStringFromInt(_team->teamid());
    _teamname = [NSString stringWithUTF8String:_team->teamname().c_str()];
    _teamicon = [NSString stringWithUTF8String:_team->teamicon().c_str()];
    _introduce = [NSString stringWithUTF8String:_team->introduce().c_str()];
    _onlineusercount = NSStringFromInt(_team->onlineusercount());
    _locked = NSStringFromInt(_team->locked());
    _alias = [NSString stringWithUTF8String:_team->alias().c_str()];
    
    return self;
}

NSArray * getPropertyNameList(id object)
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

+ (RoomHttp*)resultWithDict:(NSDictionary* )dict
{
    RoomHttp *result = [[RoomHttp alloc] init];
    if ([dict isKindOfClass:[NSString class]])
    {
        return result;
    }
    NSArray* propertyArray = getPropertyNameList(result);
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