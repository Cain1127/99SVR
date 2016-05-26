//
//  LoginTextField.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/21.
//  Copyright (c) 2015年 xia zhonglin . All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

// 改变文字位置
-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super textRectForBounds:bounds];
    iconRect.origin.x+=10;
    return iconRect;
}
// 改变编辑时文字位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super editingRectForBounds:bounds];
    iconRect.origin.x+=10;
    return iconRect;
}

@end
