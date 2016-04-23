//
//  TQMessageCell.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMessageCell.h"
#import "TQMessageModel.h"

#define kMax_Cell_Height 48
@interface TQMessageCell()


@property (weak, nonatomic) IBOutlet UILabel *conTentLabel;

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TITILELabel;
@property (nonatomic,weak) IBOutlet UIButton *btnShow;
@end
@implementation TQMessageCell


-(void)setMessageModel:(TQMessageModel *)messageModel
{
    _messageModel = messageModel;
    self.conTentLabel.text = messageModel.content;
    self.TimeLabel.text = messageModel.publishtime;
    self.TITILELabel.text = messageModel.titile;
    CGFloat fHeight = 0;
    if (_bShow) {
        fHeight = MAXFLOAT;
    }
    else
    {
        fHeight = kMax_Cell_Height;
    }
    CGRect rect = [_conTentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-20,fHeight) options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:XCFONT(14)}
                                                   context:nil];
    self.conTentLabel.frame = Rect(10,49,kScreenWidth-20,rect.size.height+10);
    self.btnShow.frame = Rect(kScreenWidth-40,_conTentLabel.y+_conTentLabel.height+10, 30, 30);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (CGFloat)requiredRowHeightInTableView
{
    CGFloat fHeight = 0;
    if (_bShow) {
        fHeight = MAXFLOAT;
    }
    else
    {
        fHeight = kMax_Cell_Height;
    }
    CGRect rect = [_conTentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-20,fHeight) options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:XCFONT(14)}
                                                      context:nil];
    return rect.size.height+49+65;
}

@end
