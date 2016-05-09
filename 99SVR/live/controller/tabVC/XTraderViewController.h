
/**房间内高手操盘*/

#import "CustomViewController.h"

@class RoomHttp;

typedef void(^TouchHanleBlock)(void);

@interface XTraderViewController :UIView

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room control:(UIViewController *)control;

- (void)reloadModel:(RoomHttp *)room;

- (void)addNotify;

- (void)removeNotify;


@end
