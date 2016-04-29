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
    self.TITILELabel.text = messageModel.title;
    [self requiredRowHeightInTableView];
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
        _conTentLabel.numberOfLines = 0;
    }
    else
    {
        fHeight = kMax_Cell_Height;
        _conTentLabel.numberOfLines = 2;
    }
    CGRect rect = [_conTentLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth-20,fHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(14)}
                                                   context:nil];
    
    self.conTentLabel.frame = Rect(10,49,kScreenWidth-20,rect.size.height);
    
    if (rect.size.height<30) {
        self.btnShow.hidden = YES;
        return rect.size.height+59;
    }else{
        self.btnShow.hidden = NO;
        self.btnShow.frame = Rect(kScreenWidth-40,_conTentLabel.y+_conTentLabel.height+5, 30, 30);
    }
    return rect.size.height+49+40;
}

- (IBAction)showInfo:(id)sender
{
    _bShow = !_bShow;
    if (_delegate && [_delegate respondsToSelector:@selector(clickCell:show:)]) {
        [_delegate clickCell:self show:YES];
    }
//    [self requiredRowHeightInTableView];
}

@end
