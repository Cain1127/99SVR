//
//  UIBarButtonItem+Extension.h
//  BiShe
//
//  Created by Apple on 15/12/18.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title;
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
