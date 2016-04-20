//
//  StockDealCellView.m
//  99SVR
//
//  Created by 刘海东 on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockDealCellView.h"

@implementation StockDealCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftLab = [[UILabel alloc]initWithFrame:(CGRect){10,0,self.width/2.0-10,self.height}];
        self.leftLab.font = [UIFont systemFontOfSize:15];
        self.leftLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftLab];
        
        
        self.rightLab = [[UILabel alloc]initWithFrame:(CGRect){self.width/2.0,0,self.width/2.0-10,self.height}];
        self.rightLab.font = [UIFont systemFontOfSize:15];
        self.rightLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightLab];
        
    }
    return self;
}
@end
