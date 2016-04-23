//
//  TQAllReplyCell.h
//  99SVR
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
//@class TQAnswerModel;
@interface TQAllReplyCell : UITableViewCell
/** 模型 */
//@property (nonatomic ,weak)TQAnswerModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *ansNamelb;
@property (weak, nonatomic) IBOutlet UILabel *ansTimelb;
@property (weak, nonatomic) IBOutlet UILabel *ansContentV;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UILabel *askNamelb;
@property (weak, nonatomic) IBOutlet UILabel *askContentV;

@property (weak, nonatomic) IBOutlet UIView *askView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *askViewTopConstraint;
@end
