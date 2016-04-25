//
//  RightView.h
//  99SVR
//
//  Created by xia zhonglin  on 2/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class RightView;

@protocol RightViewDelegate <NSObject>

- (void)rightView:(RightView *)rightView index:(NSInteger)nNumber;

@end

@interface RightView : UIView

@property (nonatomic,assign) id<RightViewDelegate> delegate;

@property (nonatomic,strong) UIButton *btnFirst;
@property (nonatomic,strong) UIButton *btnSecond;
@property (nonatomic,strong) UIButton *btnThird;


@end
