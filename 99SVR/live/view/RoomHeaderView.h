//
//  RoomHeaderView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoomHeadViewDelegate <NSObject>

@optional
- (void)selectIndexSegment:(NSInteger)nIndex;
- (void)enterTeamIntroduce;
- (void)exitRoomHeader;

@end

@interface RoomHeaderView : UIView

@property (nonatomic) id<RoomHeadViewDelegate> delegate;

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblCount;
@property (nonatomic,strong) UILabel *lblFans;

@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnRight;

@property (nonatomic,strong) UISegmentedControl *segmented;

@end
