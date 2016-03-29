//
//  SlideBaseViewController.h
//  99SVR
//
//  Created by Jiangys on 16/3/15.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface SlideBaseViewController : CustomViewController

- (void)didPanEvent:(UIPanGestureRecognizer *)recognizer;

-(void)leftItemClick;

@end
