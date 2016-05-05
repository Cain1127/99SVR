//
//  XLiveQuestionView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLiveQuestionDelegate <NSObject>

- (void)requestQuestion:(NSString *)strName content:(NSString *)strContent;

@end

@interface XLiveQuestionView : UIView

@property (nonatomic,assign) id<XLiveQuestionDelegate> delegate;
@property (nonatomic,strong) UIButton *btnTitle;
@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UIButton *btnSubmit;

@property (nonatomic,strong) UILabel *lblTimes;

@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextView *txtContent;
@property (nonatomic,strong) UILabel *lbltimes;
@property (nonatomic,strong) UIView *hiddenView;

@end
