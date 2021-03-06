//
//  UIImageFactory.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "UIImageFactory.h"

@implementation UIImageFactory

+ (void)loadImageView:(NSString *)strName view:(UIImageView *)imgView{
    @WeakObj(strName)
    @WeakObj(imgView)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/%s.png",path,[strNameWeak UTF8String]);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgViewWeak setImage:image];
            });
        }
    });
}

+ (void)createBtnImage:(NSString *)strName btn:(UIButton *)sender state:(UIControlState)state
{
    @WeakObj(strName)
    @WeakObj(sender)
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
       char cString[255];
       const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
       sprintf(cString, "%s/%s.png",path,[strNameWeak UTF8String]);
       NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
       UIImage *image = [UIImage imageWithContentsOfFile:objCString];
       if (image)
       {
           dispatch_async(dispatch_get_main_queue(), ^{
               [senderWeak setImage:image forState:state];
           });
       }
    });
}
@end
