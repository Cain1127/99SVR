//
//  TQAllReplyCell.m
//  99SVR
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQAllReplyCell.h"
#import "UIImageView+Header.h"
#import "TQAnswerModel.h"

@interface TQAllReplyCell()
//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//@property (weak, nonatomic) IBOutlet UILabel *ansNamelb;
//@property (weak, nonatomic) IBOutlet UILabel *ansTimelb;
//@property (weak, nonatomic) IBOutlet UILabel *ansContentV;
//@property (weak, nonatomic) IBOutlet UIButton *openBtn;
//@property (weak, nonatomic) IBOutlet UILabel *askNamelb;
//@property (weak, nonatomic) IBOutlet UILabel *askContentV;
//
//@property (weak, nonatomic) IBOutlet UIView *askView;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *askViewTopConstraint;

@end
@implementation TQAllReplyCell
- (IBAction)openContent:(id)sender {
    
    self.askView.hidden = !self.askView.hidden;
}
#if 0
-(void)setModel:(TQAnswerModel *)model {
    [self.iconImageView xmg_setHeader:model.answerauthorhead];
//    self.iconImageView.image = [UIImage imageNamed:model.answerauthorhead];
    self.ansNamelb.text = model.answerauthorname;
    self.ansTimelb.text = model.answertime;
    self.ansContentV.text = model.answercontent;
    self.askNamelb.text = model.askauthorname;
    self.askContentV.text = model.askcontent;
    
    
    
}
#endif
@end
