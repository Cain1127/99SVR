//
//  TQMessageCell.h
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQMessageModel;
@interface TQMessageCell : UITableViewCell
/** <#desc#> */
@property (nonatomic ,weak)TQMessageModel *messageModel;
@end
