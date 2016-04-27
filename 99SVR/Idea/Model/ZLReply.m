//
//  ZLReply.m
//  99SVR
//
//  Created by xia zhonglin  on 4/27/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLReply.h"
#import "DecodeJson.h"

@implementation ZLReply

- (NSString *)strContent
{
    if (_strContent) {
        return _strContent;
    }
    char cFrom[200];
    memset(cFrom, 0, 200);
    sprintf(cFrom,"<span style=\"color:#0078DD\">%s</span>",[_authorname UTF8String]);
    NSString *strFrom = [NSString stringWithUTF8String:cFrom];
    NSString *strContentInfo = nil;
    if (_parentreplyid!=0) {
        strContentInfo = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@ 回复 <span style=\"color:#919191\">%@</span><p>%@</p></p>",
                       strFrom,_fromauthorname,_content];
    }else{
        strContentInfo = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@<p>%@</p></p>",strFrom,_content];
    }
    _strContent = [DecodeJson replaceEmojiNewString:strContentInfo];
    return _strContent;
}

@end
