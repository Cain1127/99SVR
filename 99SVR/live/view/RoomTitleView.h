//
//  RoomTitleView.h
//  99SVR
//
//  Created by xia zhonglin  on 12/14/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleViewDelegate <NSObject>

- (void)roomTitleView:(UIButton *)sender;

@end

@interface RoomTitleView : UIView

@property (nonatomic,assign) id<TitleViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName;

- (void)setBtnSelect:(NSInteger)tag;
@end
