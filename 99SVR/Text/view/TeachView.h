//
//  TeachView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/2/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherModel;
@interface TeachView : UIView

@property (nonatomic,strong) UILabel *lblFans;
@property (nonatomic,strong) UILabel *lblThum;
@property (nonatomic,strong) UILabel *lblCount;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UILabel *lblLabel;
@property (nonatomic,strong) UIImageView *imgHead;
@property (nonatomic,strong) UILabel *lblHistory;
@property (nonatomic,strong) UILabel *lblHistoryCount;
@property (nonatomic,strong) UILabel *lblLine;

- (void)setTeachModel:(TeacherModel *)model;

@end
