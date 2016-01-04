//
//  Vedio.h
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//  视频信息

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property(nonatomic, copy) NSString *name; // 视频名称
@property(nonatomic, copy) NSString *descript; // 视频描述
@property(nonatomic, assign) long lookCount; // 观看人数
@property(nonatomic, copy) NSString *iconUrl; // 图片

@end
