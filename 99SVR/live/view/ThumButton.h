//
//  ThumButton.h
//  99SVR
//
//  Created by xia zhonglin  on 2/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumButton : UIButton

@property (nonatomic) CGFloat fWidth;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat sourceWidth;

- (id)initWithFrame:(CGRect)frame size:(CGFloat)width fontSize:(CGFloat)fFont;

@end
