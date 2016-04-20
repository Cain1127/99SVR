//
//  TableViewFactory.h
//  99SVR
//
//  Created by xia zhonglin  on 4/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewFactory : NSObject

+ (UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style;

@end
