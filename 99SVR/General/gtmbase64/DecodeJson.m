//
//  XCDecodeJson.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/6/10.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "DecodeJson.h"
#import "GTMBase64.h"
#import "GiftModel.h"
#import "DeviceUID.h"
#import "BaseService.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "UserInfo.h"
#import <netdb.h>
#import <fcntl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <string.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <unistd.h>
#import <stdlib.h>
#import <stdio.h>
#import <sys/wait.h>
#import <sys/types.h>
#import <sys/times.h>
#import <sys/time.h>
#import <sys/select.h>
#import <time.h>
#import <errno.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@implementation DecodeJson

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    // 利用 GTMBase64 解碼 Base64 字串
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024*10];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024*10,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
    return plainText;
}
+(NSString *)XCmdMd5String:(NSString *)str
{
    if (str==nil)
    {
        return @"";
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+(BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

// Get IP Address
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)replaceImageString:(NSString *)strInfo width:(CGFloat)width height:(CGFloat)height index:(NSInteger)nIndex strTemp:(NSString *)strTemp
{
    if(strInfo==nil)
    {
        return nil;
    }
    NSError *error= NULL;
    
    NSString *strTemplate = [NSString stringWithFormat:@"$1 style=\"float:left\" width=\"%d\" height=\"%d\"",
                             (int)width,(int)height];
    NSString *strTempPattern = [NSString stringWithFormat:@"(src=\"%@\"|SRC=\"%@\")",strTemp,strTemp];
    NSRegularExpression* regex1 = [NSRegularExpression regularExpressionWithPattern:strTempPattern
                                                                            options:0
                                                                              error:&error];
    NSString* result = [regex1 stringByReplacingMatchesInString:strInfo
                                                        options:0
                                                          range:NSMakeRange(0, strInfo.length)
                                                   withTemplate:strTemplate];
    return result;
}

+ (NSString *)replaceImageString:(NSString *)strInfo
{
    NSError *error= NULL;
    
    NSString *strTemplate = [NSString stringWithFormat:@"$1 width=\"%d\" height=\"%d\"",
                             (int)(kScreenWidth-20),(int)((kScreenWidth-20)*.5)];
    
    NSRegularExpression* regex1 = [NSRegularExpression regularExpressionWithPattern:@"(<img|<IMG)"
                                                                            options:0
                                                                              error:&error];
    NSString* result = [regex1 stringByReplacingMatchesInString:strInfo
                                                        options:0
                                                        range:NSMakeRange(0, strInfo.length)
                                                   withTemplate:strTemplate];
    return result;
}

+ (NSString *)replaceEmojiNewString:(NSString *)strInfo
{
    if (!strInfo){
        return @"";
    }
    BOOL finished  = NO;
    while (!finished) {
        NSRange tagRange = [strInfo rangeOfString:@"&nbsp;" options:NSRegularExpressionSearch];
        if (tagRange.location == NSNotFound)
        {
            finished = YES;
            break;
        }
        strInfo = [strInfo stringByReplacingCharactersInRange:tagRange withString:@" "];
    }
    finished = NO;
    NSUInteger nStart,nEnd;
    NSString *regx = @"[$\\d{1,3}$]";
	NSRange remainingRange = NSMakeRange(0, [strInfo length]);
    while (!finished) {
        NSRange tagRange = [strInfo rangeOfString:regx options:NSRegularExpressionSearch range:remainingRange];
        if (tagRange.location==NSNotFound) {
            break;
        }
        nStart = [strInfo rangeOfString:@"[$"].location != NSNotFound ? [strInfo rangeOfString:@"[$"].location :-1;
        nEnd = [strInfo rangeOfString:@"$]"].location!= NSNotFound ? [strInfo rangeOfString:@"$]"].location :-1;;
        if(nStart == -1 || nEnd == -1)
        {
            break;
        }
        NSString *strTemp = [strInfo substringWithRange:NSMakeRange(nStart+2,nEnd-nStart-2)];
        strInfo = [strInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[$%@$]",strTemp] withString:
                   [NSString stringWithFormat:@"<object value=%d width=30 height=30 ></object>",[strTemp intValue]]];
        remainingRange.location = tagRange.location;
        remainingRange.length = [strInfo length]-tagRange.location;
    }
    strInfo = [strInfo stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    strInfo = [strInfo stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    
    return strInfo;
}

+ (NSString *)replaceEmojiString:(NSString *)strInfo
{
    if (!strInfo)
    {
        return nil;
    }
    char cBuffer[2048],cEnd[2048];
    char cNumber[10];
    
    memset(cBuffer, 0, 2048);
    memset(cEnd, 0, 2048);
    memset(cNumber, 0, 10);
    
    NSUInteger nStart,nEnd;
    while ([strInfo rangeOfString:@"[$"].location != NSNotFound && [strInfo rangeOfString:@"$]"].location != NSNotFound)
    {
        nStart = [strInfo rangeOfString:@"[$"].location != NSNotFound ? [strInfo rangeOfString:@"[$"].location :-1;
        NSRange endRang = [strInfo rangeOfString:@"$]" options:NSCaseInsensitiveSearch range:NSMakeRange(nStart,[strInfo length]-nStart)];
        nEnd = endRang.location!= NSNotFound ? endRang.location :-1;;
        if(nStart == -1 || nEnd == -1)
        {
            return strInfo;
        }
        if(nStart<nEnd)
        {
            NSString *strTemp = [strInfo substringWithRange:NSMakeRange(nStart+2,nEnd-nStart-2)];
            strInfo = [strInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[$%@$]",strTemp] withString:
                       [NSString stringWithFormat:@"<object value=%d width=24 height=24 ></object>",[strTemp intValue]]];
        }
        else
        {
            break;
        }
    }
    
    strInfo = [strInfo stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    strInfo = [strInfo stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    
    return strInfo;
}

+ (NSArray *)getSrcPath:(NSString *)urlString
{
    if (!urlString) {
        return nil;
    }
    NSError *error;
    NSMutableArray *array = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"src=\"http:\"?(.*?)(\"|>|\\s+)" options:0 error:&error];
    if (regex != nil)
    {
        NSArray<NSTextCheckingResult*> *aryResult = [regex matchesInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        for (NSTextCheckingResult *textMatch in aryResult)
        {
            NSString *result=[urlString substringWithRange:NSMakeRange(textMatch.range.location+5,textMatch.range.length-6)];
            //输出结果
            [array addObject:result];
        }
    }
    return array;
}

+ (NSString *)replaceTextString:(NSString *)strInfo
{
    if (strInfo==nil)
    {
        return @"";
    }
    strInfo = [DecodeJson replaceEmojiNewString:strInfo];
    char inner_charStr[12];
    for( int i=0; i<10; i++ )
    {
        inner_charStr[i] = 1;
    }
    inner_charStr[10] = 0;
    inner_charStr[11] = 0;
    
    NSString *strImg = [NSString stringWithFormat:@"%s",inner_charStr];
    
    NSRange range = [strInfo rangeOfString:strImg];
    if(range.location != NSNotFound)
    {
        DLog(@"找到图片");
    }
    return @"";
}

+ (BOOL)getSrcMobile:(NSString *)mobileInfo
{
    // | 47\\d{8}
    NSString *strMobile = @"(1[3578]\\d{9}|14[57]\\d{8})";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strMobile];
    if([regextestmobile evaluateWithObject:mobileInfo]==YES)
    {
        return YES;
    }
    return NO;
}


+ (int)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return 1;
    }
    else if ([dateString isEqualToString:yesterdayString])
    {
        return 0;
    }
    else
    {
        return -1;
    }
}

/**
 *  局部拉伸图片
 *
 *  @param image        原image
 *  @param capInsets    区域
 *  @param resizingMode 方式
 *
 *  @return <#return value description#>
 */
+ (UIImage *)stretchImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode{
    UIImage *resultImage = nil;
    resultImage = [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    return resultImage;
}



+ (BOOL)postServerRegError:(NSString *)strMsg type:(int)regType serverIP:(NSString *)strIp
{
    NSString *strInfo = [NSString stringWithFormat:@"http://42.81.53.201/AnalyticStatistics/??ReportItem=Register&ClientType=2&RegType=%d&UserId=123&ServerIP=%@&Error=%@",regType,strIp,strMsg];
    [BaseService post:strInfo dictionay:nil timeout:10 success:^(id responseObject) {

    } fail:^(NSError *error) {
        DLog(@"暂不上报,存储上报内容");
    }];
    return YES;
}

+ (void)postPHPServerMsg:(NSString *)strUrl
{
    NSString *strInfo = [NSString stringWithFormat:@"http://42.81.53.201/AnalyticStatistics/?%@",strUrl];
    DLog(@"上报链接:%@",strInfo);
    [BaseService post:strInfo dictionay:nil timeout:10 success:^(id responseObject) {

    } fail:^(NSError *error) {
        DLog(@"暂不上报,存储上报内容");
    }];
}

+ (void)postApplicationInfo
{
    NSString *strNumber = [NSString stringWithFormat:@"ReportItem=UserLocalAppData&ClientType=3&Os=iOS&SerialNumber=%@&Version=1.3.2&AppList='baidu.test.99SVR'",[DeviceUID uid]];
    [DecodeJson postPHPServerMsg:strNumber];
}

+ (void)postPageHall
{
    NSString *strNumber = [NSString stringWithFormat:@"ReportItem=OpenFrontPageHall&ClientType=3&UserId=%d&ServerIP=127.0.0.1&Error=test",[UserInfo sharedUserInfo].nUserId];
    [DecodeJson postPHPServerMsg:strNumber];
}

+ (NSString *)resoleNotice:(NSString *)strInfo index:(int)nIndex
{
    if (strInfo==nil || [strInfo length]==0) {
        return @"";
    }
    NSString *strTilte = @"";
    if([strInfo rangeOfString:@"<h3>"].location != NSNotFound &&
       [strInfo rangeOfString:@"</h3>"].location != NSNotFound){
        NSRange start = [strInfo rangeOfString:@"<h3>"];
        NSRange end = [strInfo rangeOfString:@"</h3>"];
        strTilte = [strInfo substringWithRange:NSMakeRange(start.location,end.location-start.location+5)];
        strInfo = [strInfo stringByReplacingCharactersInRange:NSMakeRange(start.location,end.location-start.location+5) withString:@""];
    }
    NSString *msg ;
    if(nIndex==1)
    {
        msg = @"<p>房间公告</p>";
    }
    else if(nIndex==2)
    {
        msg = @"<p>房间广播</p>";
    }
    else if(nIndex == 3)
    {
        msg = @"<p>悄悄话</p>";
    }
    NSString *strMsg = [NSString stringWithFormat:@"%@%@%@",strTilte,msg,strInfo];
    
    return strMsg;
}

+ (void)setGiftInfo:(NSDictionary *)dict
{
    if (dict && [dict objectForKey:@"gift"]) {
        [UserInfo sharedUserInfo].giftVer = [[dict objectForKey:@"ver"] intValue];
        NSArray *array = [dict objectForKey:@"gift"];
        NSMutableArray *aryIndex = [NSMutableArray array];
        for (NSDictionary *dictionary in array) {
            [aryIndex addObject:[GiftModel resultWithDict:dictionary]];
        }
        [UserInfo sharedUserInfo].aryGift = aryIndex;
    }
}

+ (NSString *)getArrayAddr:(NSString *)strInfo{
    NSString *strMatch = @"[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}:[0-9]{1,5}";
    NSRange range = [strInfo rangeOfString:strMatch options:NSRegularExpressionSearch];
    NSMutableString *strNew = [[NSMutableString alloc] init];
    while (range.location != NSNotFound){
        if (strNew.length>10) {
            [strNew appendString:@";"];
        }
        [strNew appendString:[strInfo substringWithRange:range]];
        NSLog(@"%@", [strInfo substringWithRange:range]);
        strInfo = [strInfo stringByReplacingCharactersInRange:range withString:@""];
        range = [strInfo rangeOfString:strMatch options:NSRegularExpressionSearch];
    }
    return strNew;
}

+ (void)cancelPerfor:(id)object{
    @WeakObj(object)
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:objectWeak];
    });
}

+ (BOOL)isEmpty:(NSString*)strMsg
{
    if (!strMsg)
    {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [strMsg stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
@end







