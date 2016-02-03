//
//  HotTextView.h
//  99SVR
//
//  Created by xia zhonglin  on 1/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherModel;

@protocol HotTeachDelegate <NSObject>

- (void)clickTeach:(TeacherModel *)teach;

@end

@interface HotTextView : UIView

@property (nonatomic,strong) TeacherModel *teach;
@property (nonatomic,assign) id<HotTeachDelegate> delegate;

- (void)setHotText:(TeacherModel *)teach;

@end
