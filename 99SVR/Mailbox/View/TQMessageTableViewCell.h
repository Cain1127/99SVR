//
//  TQMessageTableViewCell.h
//  99SVR
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQMessageModel.h"

@interface TQMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) TQMessageModel *messageModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
