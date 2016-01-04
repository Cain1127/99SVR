//
//  VedioCellView.h
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RoomHttp;

@interface VideoCellView : UIView

@property (nonatomic,strong) RoomHttp *room;

- (void)addGesture:(void (^)(id sender))handler;

@end
