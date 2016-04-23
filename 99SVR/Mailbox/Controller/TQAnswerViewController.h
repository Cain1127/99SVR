//
//  TQAnswerViewController.h
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 问题答复 >**********************************/

#import <UIKit/UIKit.h>

@interface TQAnswerViewController : CustomViewController
/** 点击了那一行cell的row判断是问题回复和评论回复 */

@property (nonatomic ,assign)NSInteger indexPathRow;

@end
