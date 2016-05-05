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

/**
 *  时期计算，今天，昨天
 *
 *  @param date 比较日期
 *
 *  @return 1 今天 0 昨天 
 */
+ (int)compareDate:(NSDate *)date;
/**
 *  新解析表情方式
 *
 */
+ (NSString *)replaceEmojiNewString:(NSString *)strInfo;


/**
 *  局部拉伸图片
 *
 *  @param image        原image
 *  @param capInsets    拉伸区域
 *  @param resizingMode 拉伸方式
 *
 *  @return 返回修改的图片
 */
+ (UIImage *)stretchImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

/**
 *  PHP注册出现错误上报
 */
+ (BOOL)postServerRegError:(NSString *)strMsg type:(int)regType serverIP:(NSString *)strIp;
/**
 *  发送所有请求，质量报警信息
 */
+ (void)postPHPServerMsg:(NSString *)strUrl;
/**
 *  推送app信息
 */
+ (void)postApplicationInfo;

/**
 *  推送获取不到大厅
 */
+ (void)postPageHall;
/**
 *  解析公告
 */
+ (NSString *)resoleNotice:(NSString *)strInfo index:(int)nIndex;
+ (void)setGiftInfo:(NSDictionary *)dict;



/**
 *  解析字符串中的ip与端口
 */
+ (NSString *)getArrayAddr:(NSString *)strInfo;

+ (void)cancelPerfor:(id)object;

+ (BOOL)isEmpty:(NSString*)strMsg;

@end
