//
//  TQMessageCell.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMessageCell.h"
#import "TQMessageModel.h"

@interface TQMessageCell()
@property (weak, nonatomic) IBOutlet UILabel *conTentLabel;

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TITILELabel;

@end
@implementation TQMessageCell


-(void)setMessageModel:(TQMessageModel *)messageModel
{
    _messageModel = messageModel;
    self.conTentLabel.text = messageModel.content;
    self.TimeLabel.text = messageModel.publishtime;
    self.TITILELabel.text = messageModel.titile;
}



@end
