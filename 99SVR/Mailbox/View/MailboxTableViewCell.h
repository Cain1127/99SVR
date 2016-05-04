//
//  MailboxTableViewCell.h
//  99SVR
//
//  Created by Jiangys on 16/5/3.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class MailboxModel;

@interface MailboxTableViewCell : UITableViewCell

@property(nonatomic, strong) MailboxModel *mailboxModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
