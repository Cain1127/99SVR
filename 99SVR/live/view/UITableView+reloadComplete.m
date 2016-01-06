//
//  UITableView(reloadComplete).m
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "UITableView+reloadComplete.h"

@implementation UITableView(reloadComplete)

- (void)reloadDataWithCompletion:(void (^)(void))completionBlock
{
    [self reloadData];
    if(completionBlock) {
        completionBlock();
    }
}

@end
