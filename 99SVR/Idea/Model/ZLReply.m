
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
    
    if (_parentreplyid!=0) {//回复
        strContentInfo = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@  <span style=\"color:#919191\">%@ <span style=\"color:#0078dd\">%@</span><p><span style=\"color:#919191\">%@<p style=\"color:#000000\">%@</p></p>",strFrom,@"回复",_fromauthorname,_publishtime,_content];
    }else{
        strContentInfo = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@<p style=\"color:#919191\">%@</p><p><span style=\"color:#000000\">%@</p></p>",strFrom,_publishtime,_content];
    }
    
    _strContent = [DecodeJson replaceEmojiNewString:strContentInfo];
    return _strContent;
}

@end
