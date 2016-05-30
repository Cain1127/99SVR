//
//  AttrTextPartModel.h
//  99SVR
//
//  Created by jiangys on 16/5/30.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//  图文混排文字AttributText属性

#import <Foundation/Foundation.h>

@interface AttrTextPartModel : NSObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
