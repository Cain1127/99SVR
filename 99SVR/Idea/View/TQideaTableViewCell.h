//
//  TQideaTableViewCell.h
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQIdeaModel;

@interface TQideaTableViewCell : UITableViewCell

/** 模型 */
@property (nonatomic ,weak)TQIdeaModel *ideaModel;


@end
