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
    self.bakImageView.layer.borderColor = [COLOR_Line_Big_Gay colorWithAlphaComponent:0.5].CGColor;
    
    //交易记录或者持仓情况
    self.dealView = [[StockDealCellView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_RecordCell_H}];
    self.dealView.titleLabV.leftLab.textColor = UIColorFromRGB(0x343434);
    [self.bakImageView addSubview:self.dealView];
}

-(void)setCellDataWithModel:(StockDealModel *)model withTag:(NSInteger)tag{
    
    
    if (tag==1) {//交易记录
        
        //标题
        NSString *titleLeftText = @"";
        UIColor *titleLeftColor = [UIColor whiteColor];
        if ([model.buytypeflag isEqualToString:@"1"]) {
            titleLeftText  = @"买入";
            titleLeftColor = COLOR_Auxiliary_Red;
        }else{
            titleLeftText = @"卖出";
            titleLeftColor = COLOR_Bg_Green;
        }
        
        [self.dealView.titleLabV setLeftLabAttText:[NSString stringWithFormat:@"%@ %@ %@",model.buytype,model.stockname,model.count] withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:titleLeftText withLeftTextColor:titleLeftColor rightLabAttText:@"" withRightAttTextColor:COLOR_Text_BigBlack withRightText:@"" withRightTextColor:COLOR_Text_BigBlack];

        
        [self.dealView.costRmbLabV setLeftLabAttText:[NSString stringWithFormat:@"成交价 %@",model.price] withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"成交价" withLeftTextColor:COLOR_Text_Gay rightLabAttText:[NSString stringWithFormat:@"成交数 %@",model.count] withRightAttTextColor:COLOR_Text_BigBlack withRightText:@"成交数" withRightTextColor:COLOR_Text_Gay];
        
        [self.dealView.nowRmbLabV setLeftLabAttText:[NSString stringWithFormat:@"成交额 %@",model.money] withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"成交额" withLeftTextColor:COLOR_Text_Gay rightLabAttText:[NSString stringWithFormat:@"%@",model.time] withRightAttTextColor:COLOR_Text_Gay withRightText:@"" withRightTextColor:COLOR_Text_Gay];
        

    }else{//仓库详情
    
    
        
        [self.dealView.titleLabV setLeftLabAttText:[NSString stringWithFormat:@"%@ %@",model.stockname,model.stockid] withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"" withLeftTextColor:COLOR_Text_BigBlack rightLabAttText:@"" withRightAttTextColor:COLOR_Text_BigBlack withRightText:@"" withRightTextColor:COLOR_Text_BigBlack];
        
        
        [self.dealView.costRmbLabV setLeftLabAttText:[NSString stringWithFormat:@"成交 %@",model.cost] withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"成交" withLeftTextColor:COLOR_Text_Gay rightLabAttText:[NSString stringWithFormat:@"持有数 %@",model.count] withRightAttTextColor:COLOR_Text_BigBlack withRightText:@"持有数" withRightTextColor:COLOR_Text_Gay];
        
        [self.dealView.nowRmbLabV setLeftLabAttText:[NSString stringWithFormat:@"现价 %@",model.currprice] withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"现价" withLeftTextColor:COLOR_Text_Gay rightLabAttText:[NSString stringWithFormat:@"盈亏 %@/%@",model.profitmoney,model.profitrate] withRightAttTextColor:COLOR_Auxiliary_Red withRightText:@"盈亏" withRightTextColor:COLOR_Text_Gay];
        
    }
}



@end
