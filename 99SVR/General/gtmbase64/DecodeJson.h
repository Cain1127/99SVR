//
//  XCDecodeJson.h
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/6/10.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecodeJson : NSObject

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
+(NSString*) XCmdMd5String:(NSString *)str;
+(BOOL) validateEmail: (NSString *) candidate;

+ (NSString *) macaddress;
+ (NSString *)getIPAddress;

+ (NSString *)replaceImageString:(NSString *)strInfo;
+ (NSString *)replaceEmojiString:(NSString *)strInfo;

+ (NSArray *)getSrcPath:(NSString *)urlString;

+ (NSString *)replaceImageString:(NSString *)strInfo width:(CGFloat)width height:(CGFloat)height index:(NSInteger)nIndex strTemp:(NSString *)strTemp;

+ (BOOL)getSrcMobile:(NSString *)mobileInfo;

@end
