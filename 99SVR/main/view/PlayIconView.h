//
//  PlayIconView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayIconDelegate <NSObject>

- (void)exitPlay;
- (void)hidenPlay;
- (void)gotoPlay;

@end

@interface PlayIconView : UIView

@property (nonatomic,assign) id<PlayIconDelegate> delegate;

@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblNumber;
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIButton *btnQuery;
@property (nonatomic,strong) UIButton *btnHidn;
@property (nonatomic,strong) UIButton *btnExit;

@end
