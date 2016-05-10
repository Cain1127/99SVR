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
        
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",model.buytype,model.stockname]];
        
        if ([model.buytype isEqualToString:@"买入"]) {
            [attriStr addAttribute:NSForegroundColorAttributeName
                             value:COLOR_Auxiliary_Red
                             range:NSMakeRange(0, 2)];
        }else{
            
            [attriStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor greenColor]
                             range:NSMakeRange(0, 2)];
        }
        
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:COLOR_Text_Black
                         range:NSMakeRange(2, ([attriStr length]-2))];

        
        [self.dealView.titleLabV setLeftLabText:[NSString stringWithFormat:@"%@ %@ %@",model.buytype,model.stockname,model.count] rightLabText:@" "];
        [self.dealView.costRmbLabV setLeftLabText:[NSString stringWithFormat:@"成交价 %@",model.price] rightLabText: [NSString stringWithFormat:@"成交数 %@",model.count]];
        [self.dealView.nowRmbLabV setLeftLabText:[NSString stringWithFormat:@"成交额 %@",model.money] rightLabText:[NSString stringWithFormat:@"%@",model.time]];
        self.dealView.titleLabV.leftLab.attributedText = attriStr;
        self.dealView.nowRmbLabV.rightLab.textColor = COLOR_Text_Gay;
        self.dealView.nowRmbLabV.leftLab.textColor = COLOR_Text_Gay;
        self.dealView.costRmbLabV.leftLab.textColor = COLOR_Text_Gay;
        self.dealView.costRmbLabV.rightLab.textColor = COLOR_Text_Gay;

    }else{//仓库详情
    

        [self.dealView.titleLabV setLeftLabText:[NSString stringWithFormat:@"%@ %@",model.stockname,model.stockid] rightLabText:@" "];
        [self.dealView.costRmbLabV setLeftLabText:[NSString stringWithFormat:@"成本 %@",model.cost] rightLabText: [NSString stringWithFormat:@"持有数量 %@",model.count]];
        [self.dealView.nowRmbLabV setLeftLabText:[NSString stringWithFormat:@"现价 %@",model.currprice] rightLabText:[NSString stringWithFormat:@"盈亏 %@/%@",model.profitmoney,model.profitrate]];
        
        self.dealView.nowRmbLabV.rightLab.textColor = COLOR_Auxiliary_Red;

    }
}



@end
