//
//  NSString+Size.h
//  Weibo
//
//  Created by jiangys on 15/10/24.
//  Copyright © 2015年 Jiangys. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  获取文字所占的尺寸大小
 */
@interface NSString (Size)

/**
 *  计算文字的宽高
 *  使用方法 [strText sizeMakeWithFont:[UIFont systemFontOfSize:12] maxW:100];
 *
 *  @param font 字体大小
 *  @param maxW 字体所在的范围的宽度
 *
 *  @return 返回字体所在的范围宽度下的高度。即知道宽，计算高
 */
- (CGSize)sizeMakeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  计算文字的宽高
 *  使用方法 [strText sizeMakeWithFont:[UIFont systemFontOfSize:12]];
 *
 *  @param fontSize 字体大小
 *
 *  @return 返回文字的宽高
 */
- (CGSize)sizeMakeWithFont:(UIFont *)font;
@end
