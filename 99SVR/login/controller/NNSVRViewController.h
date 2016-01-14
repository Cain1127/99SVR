//
//  NNSVRViewController.h
//  99SVR
//  99财经协议
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@interface NNSVRViewController : CustomViewController

@property (nonatomic,strong) NSString *strPath;
@property (nonatomic,strong) NSString *strTitle;

- (id)initWithPath:(NSString *)strPath title:(NSString *)strTitle;

@end
