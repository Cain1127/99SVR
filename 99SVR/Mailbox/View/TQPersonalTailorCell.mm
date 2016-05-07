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

@end

@implementation TQPersonalTailorCell

-(void)awakeFromNib{
    [super awakeFromNib];

    self.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    self.layer.borderWidth = 0.5;
    
    _TITLELabel.textColor = COLOR_Text_Black;
    _summaryLabel.textColor = COLOR_Text_Gay;
    _timeLabel.textColor = COLOR_Text_Gay;
    _nameLabel.textColor = COLOR_Text_Gay;
}

- (IBAction)openClick:(id)sender {
    
    DLog(@"openClick");
    if([self.delegate respondsToSelector:@selector(personalTailorCell:seeButtonClickAtPersonalModel:)])
    {
        [self.delegate personalTailorCell:self seeButtonClickAtPersonalModel:_personalModel];
    }
}

@end
