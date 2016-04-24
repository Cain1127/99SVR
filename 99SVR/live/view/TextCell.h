//
//  TextCell.h
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextRoomModel.h"

@interface TextCell : UITableViewCell

@property(nonatomic, copy) void (^itemOnClick)(TextRoomModel *model); // 点击事件

- (void)setRowDatas:(NSArray *)datas; // 设置每一行数据

@end
