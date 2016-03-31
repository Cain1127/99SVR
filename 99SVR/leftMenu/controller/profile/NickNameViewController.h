//
//  NickNameViewController.h
//  99SVR
//
//  Created by Jiangys on 16/3/17.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NickNameViewController : CustomViewController
/**
 *  回调
 */
@property (nonatomic, strong) void (^ nickNameBlock)(NSString * nickName);

@end
