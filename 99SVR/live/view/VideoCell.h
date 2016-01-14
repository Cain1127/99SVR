//
//  VedioCell.h
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRowHeight 120

@class RoomHttp;
@class Vedio;

@interface VideoCell : UITableViewCell

@property(nonatomic, copy) void (^itemOnClick)(RoomHttp *vedio); // 点击事件

- (void)setRowDatas:(NSArray *)datas; // 设置每一行数据

@end
