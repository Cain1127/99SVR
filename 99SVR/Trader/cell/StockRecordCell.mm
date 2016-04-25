//
//  StockRecordCell.m
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockRecordCell.h"
#import "StockMacro.h"
#import "StockDealModel.h"

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
    self.dealView.titleLabV.leftLab.font = [UIFont systemFontOfSize:17];
    self.dealView.titleLabV.leftLab.textColor = UIColorFromRGB(0x343434);
    [self.bakImageView addSubview:self.dealView];
}

-(void)setCellDataWithModel:(StockDealModel *)model withTag:(NSInteger)tag{
    
    
    if (tag==1) {//交易记录
        
        self.dealView.titleLabV.leftLab.text = [NSString stringWithFormat:@"%@ %@",model.buytype,model.stockname];
        self.dealView.costRmbLabV.leftLab.text = [NSString stringWithFormat:@"成交价 %@",model.price];
        self.dealView.costRmbLabV.rightLab.text = [NSString stringWithFormat:@"成交数量 %@",model.count];
        self.dealView.nowRmbLabV.leftLab.text = [NSString stringWithFormat:@"成交额 %@",model.money];
        self.dealView.nowRmbLabV.rightLab.text = [NSString stringWithFormat:@"成交时间 %@",model.time];
        self.dealView.nowRmbLabV.rightLab.textColor = COLOR_STOCK_Text_Black;

    }else{//仓库详情
    
        self.dealView.titleLabV.leftLab.text = [NSString stringWithFormat:@"%@ %@",model.stockname,model.stockid];
        self.dealView.costRmbLabV.leftLab.text = [NSString stringWithFormat:@"成本 %@",model.cost];
        self.dealView.costRmbLabV.rightLab.text = [NSString stringWithFormat:@"持有数量 %@",model.count];
        self.dealView.nowRmbLabV.leftLab.text = [NSString stringWithFormat:@"现价 %@",model.currprice];
        self.dealView.nowRmbLabV.rightLab.text = [NSString stringWithFormat:@"盈亏 %@/%@",model.profitmoney,model.profitrate];
        self.dealView.nowRmbLabV.rightLab.textColor = COLOR_STOCK_YingKui;

    }
}



@end
