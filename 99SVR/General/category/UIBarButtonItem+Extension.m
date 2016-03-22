//
//  UIBarButtonItem+Extension.m
//  BiShe
//
//  Created by Apple on 15/12/18.
//
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    UIImage *img = [UIImage imageNamed:image];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    // 设置尺寸
    //btn.size = CGSizeMake(44, 44);//btn.currentBackgroundImage.size;
    // 一定要设置frame，才能显示
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [btn.titleLabel setFont:kFontSize(15)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 一定要设置frame，才能显示
    btn.frame = CGRectMake(0, 0, 60, 44);
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
