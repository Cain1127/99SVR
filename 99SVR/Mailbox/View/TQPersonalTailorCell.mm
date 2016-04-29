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

- (IBAction)openClick:(id)sender {
    
    DLog(@"openClick");
    if([self.delegate respondsToSelector:@selector(personalTailorCell:seeButtonClickAtPersonalModel:)])
    {
        [self.delegate personalTailorCell:self seeButtonClickAtPersonalModel:_personalModel];
    }
}

@end
