//
//  TQPersonalTailorCell.h
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQPersonalModel;
@interface TQPersonalTailorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *TITLELabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;

/** 模型 */
//@property (nonatomic ,weak)TQPersonalModel *personalModel;
@end
