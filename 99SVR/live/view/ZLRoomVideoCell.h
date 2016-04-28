//
//  ZLRoomVideoCell.h
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class XVideoModel;
@interface ZLRoomVideoCell : UITableViewCell

@property(nonatomic, copy) void (^itemOnClick)(XVideoModel *model); // 点击事件
- (void)setRowDatas:(NSArray *)datas;


@end
