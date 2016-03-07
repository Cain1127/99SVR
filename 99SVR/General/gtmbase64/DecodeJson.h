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
/**
 *  MD5加密
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(NSString*) XCmdMd5String:(NSString *)str;

+(BOOL) validateEmail: (NSString *) candidate;

+ (NSString *) macaddress;
+ (NSString *)getIPAddress;

+ (NSString *)replaceImageString:(NSString *)strInfo;
/**
 *  替换表情
 *
 */
+ (NSString *)replaceEmojiString:(NSString *)strInfo;

/**
 *  正则表达式   获取http的图片路径
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)getSrcPath:(NSString *)urlString;

/**
 *  视频直播中，公告的图片替换
 *
 *  @param strInfo 请求替换的字符串
 *  @param width   宽
 *  @param height  高
 *  @param nIndex  个数
 *  @param strTemp 图片的http路径
 *
 *  @return 返回替换后的
 */
+ (NSString *)replaceImageString:(NSString *)strInfo width:(CGFloat)width height:(CGFloat)height index:(NSInteger)nIndex strTemp:(NSString *)strTemp;

/**
 *  手机号格式判断
 *
 *  @param mobileInfo 判断的字符串
 *
 *  @return 成功则为yes
 */
+ (BOOL)getSrcMobile:(NSString *)mobileInfo;


@end
