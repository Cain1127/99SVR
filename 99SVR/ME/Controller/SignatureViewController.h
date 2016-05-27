//
//  SignatureViewController.h
//  99SVR
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureViewController:CustomViewController

@property (nonatomic, copy) NSString *signature;
/**
 *  修改签名信息成功后的回调
 */
@property (nonatomic, copy) void (^ signatureBlock)(NSString * signature);

@end
