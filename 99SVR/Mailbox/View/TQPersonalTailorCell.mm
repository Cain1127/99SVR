//
//  TQPersonalTailorCell.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQPersonalTailorCell.h"
#import "TQPersonalModel.h"

@interface TQPersonalTailorCell ()
@property (weak, nonatomic) IBOutlet UILabel *TITLELabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@end
@implementation TQPersonalTailorCell
- (IBAction)openClick:(id)sender {
    
    
}

-(void)setPersonalModel:(TQPersonalModel *)personalModel {
    _personalModel = personalModel;
    DLog("%@", personalModel);
    
    self.TITLELabel.text = personalModel.title;
    self.summaryLabel.text = personalModel.summary;
    self.timeLabel.text = personalModel.publishtime;
    self.nameLabel.text = personalModel.teamname;
}



@end
