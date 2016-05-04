//
//  MessageTableViewCell.h
//  99SVR
//
//  Created by Jiangys on 16/5/4.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQMessageModel;
@class MessageTableViewCell;

@protocol MessageTableViewCellDelegate <NSObject>
@optional
-(void)messageTableViewCell:(MessageTableViewCell *)messageTableViewCell allTextClick:(NSUInteger)btnId;
@end

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic,strong) TQMessageModel *messageModel;
@property(nonatomic,weak) id<MessageTableViewCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
