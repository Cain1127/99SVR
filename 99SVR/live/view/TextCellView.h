//
//  TextCellView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextRoomModel;

@interface TextCellView : UIView

@property (nonatomic,strong) TextRoomModel *room;

- (void)addGesture:(void (^)(id sender))handler;

@end
