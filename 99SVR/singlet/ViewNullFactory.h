//
//  ViewNullInfo.h
//  99SVR
//
//  Created by xia zhonglin  on 4/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewNullFactory : NSObject

+ (UIView*)createViewBg:(CGRect)frame imgView:(UIImage*)image msg:(NSString *)strMsg;

@end
