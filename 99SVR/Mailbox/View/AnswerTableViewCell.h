//
//  AnswerTableViewCell.h
//  99SVR_UI
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQAnswerModel;
@class AnswerTableViewCell;

// 定义一个协议，控件类名 + Delegate
@protocol AnswerTableViewCellDelegate <NSObject>
// 代理方法一般都定义为@optional
@optional
// 代理方法名都以控件名开头,代理方法至少有1个参数,将控件本身传递出去
-(void)answerTableViewCell:(AnswerTableViewCell *)answerTableViewCell allTextClick:(NSUInteger)btnId;

@end

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, strong) TQAnswerModel *answerModel;
@property(nonatomic,weak) id<AnswerTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
