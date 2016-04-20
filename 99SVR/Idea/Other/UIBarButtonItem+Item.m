//
//  UIBarButtonItem+Item.m
//  01-BuDeJie
//
//  Created by 1 on 16/1/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image  forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    // 把按钮包装成view,处理点击区域太大
    UIView *barButtonView = [[UIView alloc] initWithFrame:button.bounds];
    [barButtonView addSubview:button];
    
    // 把按钮包装成UIBarButtonItem就会由问题
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    
    return item;
}


+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image  forState:UIControlStateNormal];
    [button setImage:selImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    // 把按钮包装成view,处理点击区域太大
    UIView *barButtonView = [[UIView alloc] initWithFrame:button.bounds];
    [barButtonView addSubview:button];
    
    // 把按钮包装成UIBarButtonItem就会由问题
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    
    return item;
}

+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title
{
    // 设置返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    // 设置内容内边距
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    UIView *contentView = [[UIView alloc] initWithFrame:backButton.bounds];
    [contentView addSubview:backButton];
    return  [[UIBarButtonItem alloc] initWithCustomView:contentView];

}
@end
