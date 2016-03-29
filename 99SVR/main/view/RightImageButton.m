//
//  RightImageButton.m
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "RightImageButton.h"

@interface RightImageButton()

@property (nonatomic, copy) void(^tapActionBlock)(UIButton *button);    ///按钮单击时的回调block
@property (nonatomic, assign) CGFloat rightImageWidth;                  ///右侧图片的宽度

@end

@implementation RightImageButton

#pragma mark -
#pragma mark - 自定义右侧图片的回调block按钮
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
- (instancetype)initWithFrame:(CGRect)frame rightImageWidth:(CGFloat)width tapActionBlock:(void(^)(UIButton *button))block
{

    if (self = [super initWithFrame:frame])
    {
        
        ///save custom info
        if (width > 1.0f && width < 1000.0f)
        {
            
            self.rightImageWidth = width;
            
        }
        
        if (block)
        {
            
            self.tapActionBlock = block;
            
        }
        
        ///add tap action
        [self addTarget:self action:@selector(rightImageButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;

}

#pragma mark -
#pragma mark - 自定义右侧图片展现按钮的单击事件
- (void)rightImageButtonTapAction:(UIButton *)button
{

    if (self.tapActionBlock)
    {
        
        self.tapActionBlock(button);
        
    }

}

#pragma mark -
#pragma mark - 重载图片的显示位置，将图片定位显示在右侧
/**
 *  @author             yangshengmeng, 16-03-29 14:03:10
 *
 *  @brief              重载父类UIButton的图片位置消息，将图片定位在右侧
 *
 *  @param contentRect  当前按钮的可展现区域
 *
 *  @return             返回图片的坐标和大小
 *
 *  @since              v1.0.0
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    return Rect(CGRectGetWidth(contentRect) - self.rightImageWidth, 0.0f, self.rightImageWidth, CGRectGetHeight(contentRect));

}

@end
