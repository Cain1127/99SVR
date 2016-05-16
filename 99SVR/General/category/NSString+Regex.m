//
//  NSString+Regex.m
//  YSUtils
//
//  Created by jiangys on 15/9/26.
//  Copyright (c) 2015年 Jiangys. All rights reserved.
//

#import "NSString+Regex.h"
#import <CommonCrypto/CommonDigest.h>

#import <arpa/inet.h>
#import <ifaddrs.h>

@implementation NSString (Regex)

#pragma mark Encryption


/**
 *  邮箱判定
 *
 *  @return 判定结果
 */
- (BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [emailTest evaluateWithObject:self];
}

/**
 *  网址判断
 *
 *  @return 判定结果
 */
- (BOOL)isValidUrl
{
    NSString *regex = @"(http|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
    return ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound);
}

/**
 *   判断非特殊字符
 *
 *  @return 非特殊字符返回yes,
 */
- (BOOL)isNumeric
{
    BOOL isValid = YES;
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"_!@#$%^&*()[]{}'\"<>:;|\\/?+=~`"];
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([myCharSet characterIsMember:c])
            isValid = NO;
    }
    
    return isValid;
}

- (BOOL)isValidFloat
{
    NSString *regex = @"([-+]?[0-9]*\\.?[0-9]*)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  空判定
 *
 *  @return 判定结果
 */
- (BOOL)isBackSpace
{
    return ([self isEqualToString:@""] || self.length == 0) ? YES : NO;
}

/**
 *  字符串中是否包含字符串
 *
 *  @param substring 是否包含的字符
 *
 *  @return 判定结果
 */
- (BOOL)containsString:(NSString *)substring
{
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}


/**
 *  手机号码验证 11位纯数字
 *
 *  @return 判定结果
 */
- (BOOL)isValidateMobile
{
    //11位，只要是1开头，数字字符
    NSString *phoneRegex = @"^1[0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/**
 *  昵称验证
 *
 *  @return 验证结果
 */
- (BOOL)isValidNickName {
    //汉字、数字、字母、下划线
    NSString *phoneRegex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/**
 *  判断字符串是否纯数字
*
 *  @return 判定结果
 */
- (BOOL)isPureNumandCharacters
{
    NSString *strRegex = @"^[0-9]+$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [cardTest evaluateWithObject:self];
    
}

/**
 *  判断身份证号 18位
 *
 *  @return 判定结果
 */
- (BOOL)isValidateCardID
{
    NSString *cardRegex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cardRegex];
    return [cardTest evaluateWithObject:self];
}

// 判断字符串是否电话
- (BOOL)isValidateTel
{
    //匹配国内电话号码：匹配形式如 0511-4405222 或 021-87888822 木有400-1234-1234
    NSString *phoneRegex = @"^(\\(\\d{3,4}\\)|\\d{3,4}-)?\\d{7,8}(-\\d{1,4})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

// 判断密码 6-18位 大小写字母
/**
 *  判断密码是否为数字/字母/下划线
 *
 *  @return 判定结果
 */
- (BOOL)isPassword
{
    NSString *  regex = @"(^{6,16}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

@end
