//
//  DetaileHeaderView.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "DetaileHeaderView.h"
@interface DetaileHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *contenLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *DateLabel;

@end

@implementation DetaileHeaderView

+ (instancetype)DetaileHeaderViewForXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, 0, 2000);
//}
@end
