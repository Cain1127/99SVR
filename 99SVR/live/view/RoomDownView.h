//
//  RoomDownView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoomDownDelegate <NSObject>

- (void)clickRoom:(UIButton *)button index:(NSInteger)nIndex;

@end

@interface RoomDownView : UIView

@property (nonatomic,strong) UIButton *btnChat;
@property (nonatomic,strong) UIButton *btnUser;
@property (nonatomic,strong) UIButton *btnGift;
@property (nonatomic,strong) UIButton *btnRose;
@property (nonatomic,assign) id<RoomDownDelegate> delegate;

@end
