//
//  UITableView(reloadComplete).h
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(reloadComplete)

- (void) reloadDataWithCompletion:( void (^) (void) )completionBlock;

@end
