//
//  NSString+Regex.h
//  YSUtils
//
//  Created by jiangys on 15/9/26.
//  Copyright (c) 2015年 Jiangys. All rights reserved.
//
//  正则表达式

#import <Foundation/Foundation.h>

@interface NSString (Regex)


/**
 *  验证邮箱
 *
 *  @return 返回验证结果
 */
- (BOOL)isValidEmail;

/**
 *  验证URL
 *
 *  @return 返回验证结果
 */
- (BOOL)isValidUrl;

/**
 *  验证数字
 *
 *  @return 返回验证结果
 */
- (BOOL)isNumeric;

/**
 *  验证是否为浮点型
 *
 *  @return 返回验证结果
 */
- (BOOL)isValidFloat;

/**
 *  验证是否是空字符
 *
 *  @return 返回验证结果
 */
- (BOOL)isBackSpace;

/**
 *  验证是否包含某个字符串
 *
 *  @param substring 需要验证的字符串
 *
 *  @return 返回验证结果
 */
- (BOOL)containsString:(NSString *)substring;

/**
 *  验证是否是正确的手机号
 *
 *  @return 返回验证结果，true为是
 */
- (BOOL)isValidateMobile;

/**
 *  昵称验证
 *
 *  @return 验证结果
 */
- (BOOL)isValidNickName;

/**
 *  判断字符串是否纯数字
 *
 *  @return 判定结果
 */
- (BOOL)isPureNumandCharacters;

/**
 *  验证身份证号
 *
 *  @return 返回验证结果，true为是
 */
- (BOOL)isValidateCardID;

/**
 *  判断字符串是否电话
 *
 *  @return 返回验证结果，true为是
 */
- (BOOL)isValidateTel;

/**
 *  判断密码 6-18位 大小写字
 *
 *  @return 返回验证结果，true为是
 */
- (BOOL)isPassword;

@end
