//
//  TQNoCustomHeader.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQNoCustomHeader.h"

@implementation TQNoCustomHeader

- (IBAction)questionClick:(id)sender {
    UIViewController *vc = [self viewController];
    
}


- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
