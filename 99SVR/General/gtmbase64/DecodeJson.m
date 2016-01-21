//
//  XCDecodeJson.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/6/10.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "DecodeJson.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
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
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
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
    DLog(@"result%@",result);
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

+ (NSString *)replaceEmojiString:(NSString *)strInfo
{
    const char *cInfo = [strInfo UTF8String];
    char cBuffer[2048],cEnd[2048];
    char cNumber[10];
    
    memset(cBuffer, 0, 2048);
    memset(cEnd, 0, 2048);
    memset(cNumber, 0, 10);
    int nNum = 0;
    
    while ([strInfo rangeOfString:@"[$"].location != NSNotFound && [strInfo rangeOfString:@"$]"].location != NSNotFound)
    {
        memset(cBuffer, 0, 2048);
        memset(cEnd, 0, 2048);
        memset(cNumber, 0, 10);
        sscanf(cInfo,"%[^[][$%d$]%s",cBuffer,&nNum,cEnd);
        
        strInfo = [strInfo stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[$%d$]",nNum] withString:
                   [NSString stringWithFormat:@"<object value=%d width=24 height=24 ></object>",nNum]];
        cInfo = [strInfo UTF8String];
    }
    return strInfo;
}

+ (NSArray *)getSrcPath:(NSString *)urlString
{
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
            DLog(@"result:%@",result);
            [array addObject:result];
        }
    }
    return array;
}

@end
