//
//  UIImageFactory.h
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageFactory : NSObject

+ (void)loadImageView:(NSString *)strName view:(UIImageView *)imgView;

+ (void)createBtnImage:(NSString *)strName btn:(UIButton *)sender state:(UIControlState)state;

@end
