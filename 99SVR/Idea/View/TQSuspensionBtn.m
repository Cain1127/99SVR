//
//  TQSuspensionBtn.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQSuspensionBtn.h"
#import "UIView+TQFram.h"
@implementation TQSuspensionBtn


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.TQ_x = (self.width - self.imageView.TQ_width) * 0.5;
    self.imageView.TQ_y = 0;
    
    // 调整文字
    // 计算文字尺寸,设置文字宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.TQ_x =(self.TQ_width - self.titleLabel.TQ_width) * 0.5;
    self.titleLabel.TQ_y = self.TQ_height - self.titleLabel.TQ_height;
    
}






@end
