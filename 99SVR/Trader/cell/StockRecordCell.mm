//
//  StockRecordCell.m
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockRecordCell.h"
#import "StockMacro.h"

@implementation StockRecordCell

-(void)initUI{
    
    
    self.lineView.hidden = YES;
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    self.bakImageView.layer.borderWidth = 1.0f;
    self.bakImageView.layer.borderColor = [COLOR_StyleLines colorWithAlphaComponent:0.5].CGColor;
    
    //交易记录或者持仓情况
    self.dealView = [[StockDealCellView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_RecordCell_H}];
    [self.bakImageView addSubview:self.dealView];
}

@end
