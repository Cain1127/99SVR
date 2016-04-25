//
//  SexViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@interface SexViewController : CustomViewController

@property (nonatomic, copy) void (^ sexBlock)(NSString * sex);

@end
