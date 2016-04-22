


#import "StockDealCell.h"
#import "StockMacro.h"
@implementation StockDealCell


-(void)initUI{

    self.lineView.hidden = YES;
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(1));
        make.left.equalTo(@(10));
    }];
    self.lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];

        
    //股票走势图
    self.chartView = [[StockChartView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,static_cast<CGFloat>(ScreenWidth*0.75)}];
    self.chartView.topTitItems = @[@"全部",@"三个月",@"一个月"];
    self.chartView.leftTitArrays = @[@"200%",@"100%",@"200%"];
    self.chartView.lowTitArrays = @[@"2016-1-3",@"2016-1-3",@"2016-1-3"];
    [self.bakImageView addSubview:self.chartView];
    
    //交易动态的 VIP
    self.tradeLabeView = [[StockDealCellLabelView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_Deal_BusinessRecordCell_VIP_H}];
    [self.bakImageView addSubview:self.tradeLabeView];
    
    //仓库 VIP
    self.wareHouseViw = [[StockDealCellView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_Deal_WareHouseRecordCell_VIP_H}];
    self.wareHouseViw.nowRmbLabV.rightLab.textColor = COLOR_STOCK_YingKui;
    [self.bakImageView addSubview:self.wareHouseViw];
    
    //不是vip的view
    self.notVipView = [[StockNotVipView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,100}];
    [self.bakImageView addSubview:self.notVipView];


}


-(void)setCellDataWithModel:(StockDealModel *)model withIsVip:(BOOL)vipBool withCellId:(NSString *)cellId{
    
    if ([cellId isEqualToString:@"section0"]) {
        
        self.tradeLabeView.hidden = YES;
        self.wareHouseViw.hidden = YES;
        self.chartView.hidden = NO;
        self.lineView.hidden = YES;
        self.notVipView.hidden = YES;

        
    }else if ([cellId isEqualToString:@"section1"]){
        
        self.chartView.hidden =YES;
        self.wareHouseViw.hidden = YES;
        self.lineView.hidden = YES;
        
        if (vipBool) {
            self.tradeLabeView.hidden = NO;
            self.notVipView.hidden = YES;
            self.tradeLabeView.leftLab.text = [NSString stringWithFormat:@"%@ %@ %@ 股",model.buytype,model.stockname,model.count];
            self.tradeLabeView.rightLab.text = [NSString stringWithFormat:@"时间：%@",model.time];
        }else{
            self.tradeLabeView.hidden = YES;
            self.notVipView.hidden = NO;
            self.notVipView.type = StockNotVipViewType_Business;
        }
        
        
    }else{
    
        self.chartView.hidden =YES;
        self.tradeLabeView.hidden = YES;
        
        
        if (vipBool) {
            self.wareHouseViw.hidden = NO;
            self.lineView.hidden = NO;
            self.notVipView.hidden = YES;

            self.wareHouseViw.titleLabV.leftLab.text = model.stockname;
            self.wareHouseViw.costRmbLabV.leftLab.text = [NSString stringWithFormat:@"成本 %@",model.currprice];
            self.wareHouseViw.nowRmbLabV.leftLab.text = [NSString stringWithFormat:@"现价 %@",model.currprice];
            self.wareHouseViw.costRmbLabV.rightLab.text = [NSString stringWithFormat:@"持有数 %@",model.count];
            self.wareHouseViw.nowRmbLabV.rightLab.text = [NSString stringWithFormat:@"盈亏 %@/%@",model.profitmoney,model.profitrate];
            
        }else{
        
            self.wareHouseViw.hidden = YES;
            self.lineView.hidden = YES;
            self.notVipView.hidden = NO;
            self.notVipView.type = StockNotVipViewType_Storehouse;
        }
    }
}



@end
