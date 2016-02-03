//
//  NewPlayViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 1/21/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewPlayViewController : UIViewController

@property (nonatomic,strong) UIImageView *imgView;

- (void)startPlayWithURLString:(NSString *)playURLString;
//播放控制
- (void)stop;

- (void)setDefaultImg;

- (void)setNullMic;

@end
