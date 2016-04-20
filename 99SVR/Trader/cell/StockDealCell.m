


#import "StockDealCell.h"

@implementation StockDealCell


-(void)initUI{

    self.lineView.hidden = YES;
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.and.right.and.bottom.equalTo(@0);
    }];
    
    
    //股票走势图
    self.chartView = [[StockChartView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,ScreenWidth*0.75}];
    self.chartView.topTitItems = @[@"全部",@"三个月",@"一个月"];
    self.chartView.leftTitArrays = @[@"200%",@"100%",@"200%"];
    self.chartView.lowTitArrays = @[@"2016-1-3",@"2016-1-3",@"2016-1-3"];
    [self.bakImageView addSubview:self.chartView];
    
    
    

}


@end
