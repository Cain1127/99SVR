
/**房间内私人定制*/

#import "CustomViewController.h"
#import "RoomHttp.h"

@protocol WhatIsDelegate  <NSObject>

- (void)showQuestion;

@end

@interface XTeamPrivateController : UIView

@property (nonatomic,assign) id<WhatIsDelegate> delegate;

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room;
- (id)initWithModel:(RoomHttp*)room;

- (void)setModel:(RoomHttp *)room;

- (void)removeNotify;

- (void)addNotify;

@end
