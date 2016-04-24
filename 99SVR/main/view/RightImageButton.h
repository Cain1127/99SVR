//
//  RightImageButton.h
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightImageButton : UIButton

/**
 *  @author         yangshengmeng, 16-03-29 14:03:27
 *
 *  @brief          根据给定的右侧图片宽度，创建一个标题在左，图片在右的block回调按钮按钮
 *
 *  @param frame    给定的大小和位置
 *  @param width    右侧图片的宽度
 *  @param block    单击按扭时的事件回调
 *
 *  @return         返回一个右侧图片的block回调按钮
 *
 *  @since          v1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame rightImageWidth:(CGFloat)width tapActionBlock:(void(^)(UIButton *button))block;

@end
