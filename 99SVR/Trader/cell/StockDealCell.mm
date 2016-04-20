


#import "StockDealCell.h"

@implementation StockDealCell


-(void)initUI{

    self.lineView.hidden = YES;
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    
    //股票走势图
    self.chartView = [[StockChartView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,ScreenWidth*0.75}];
    self.chartView.topTitItems = @[@"全部",@"三个月",@"一个月"];
    self.chartView.leftTitArrays = @[@"200%",@"100%",@"200%"];
    self.chartView.lowTitArrays = @[@"2016-1-3",@"2016-1-3",@"2016-1-3"];
    [self.bakImageView addSubview:self.chartView];
    
    //交易动态的
    self.tradeLabeView = [[StockDealCellLabelView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,50}];
    [self.bakImageView addSubview:self.tradeLabeView];
    
    //仓库
    self.wareHouseViw = [[StockDealCellView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,150}];
    [self.bakImageView addSubview:self.wareHouseViw];


}


-(void)setCellDataWithModel:(StockDealModel *)model withIsVip:(BOOL)value withCellId:(NSString *)cellId{
    
    if ([cellId isEqualToString:@"section0"]) {
        
        self.tradeLabeView.hidden = YES;
        self.wareHouseViw.hidden = YES;
        self.chartView.hidden = NO;

        
    }else if ([cellId isEqualToString:@"section1"]){
        
        self.chartView.hidden =YES;
        self.wareHouseViw.hidden = YES;
        self.tradeLabeView.hidden = NO;
        
        self.tradeLabeView.leftLab.text = [NSString stringWithFormat:@"买入 %@ %@ 股",model.stockname,model.count];
        self.tradeLabeView.rightLab.text = [NSString stringWithFormat:@"时间：%@",model.time];
        
    }else{
    
        self.chartView.hidden =YES;
        self.tradeLabeView.hidden = YES;
        self.wareHouseViw.hidden = NO;

        

        self.wareHouseViw.titleLabV.leftLab.text = @"平安银行";
        self.wareHouseViw.costRmbLabV.leftLab.text = @"成本 23.64";
        self.wareHouseViw.nowRmbLabV.leftLab.text = @"现价 25.23";
        
        
    }
}



@end
