


#import "StockDealCell.h"
#import "StockMacro.h"
#import "ShareFunction.h"
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
    self.chartView.lineChartView.drawLine_X = YES;
    self.chartView.lineChartView.drawLine_Y = NO;
    self.chartView.lineChartView.lineColors = @[COLOR_Auxiliary_Orange,COLOR_Auxiliary_Blue];
    self.chartView.lineChartView.timeValue = 0;
    self.chartView.lineChartView.level_Y = 4;
    self.chartView.lineChartView.level_X = 2;
    self.chartView.topTitItems = @[@"全部",@"三个月",@"一个月"];
    [self.bakImageView addSubview:self.chartView];
    
    //交易动态的 VIP
    self.tradeLabeView = [[StockDealCellLabelView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_Deal_BusinessRecordCell_VIP_H}];
    [self.bakImageView addSubview:self.tradeLabeView];
    
    //仓库 VIP
    self.wareHouseViw = [[StockDealCellView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_Deal_WareHouseRecordCell_VIP_H}];
    self.wareHouseViw.nowRmbLabV.rightLab.textColor = COLOR_Auxiliary_Red;
    [self.bakImageView addSubview:self.wareHouseViw];
    
    //不是vip的view
    self.notVipView = [[StockNotVipView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,100}];
    [self.bakImageView addSubview:self.notVipView];


}


-(void)setCellDataWithModel:(id)modelObject withIsVip:(BOOL)vipBool withCellId:(NSString *)cellId withStockHeaderModel:(StockDealModel *)headerModel{
    
    if ([cellId isEqualToString:@"section0"]) {
        
        self.tradeLabeView.hidden = YES;
        self.wareHouseViw.hidden = YES;
        self.chartView.hidden = NO;
        self.lineView.hidden = YES;
        self.notVipView.hidden = YES;

        NSArray *stockLineArray = modelObject;
        [self setChartLineViewModelArray:stockLineArray andHeaderModel:headerModel];
        
    }else if ([cellId isEqualToString:@"section1"]){
        
        
        StockDealModel *model = modelObject;
        self.chartView.hidden =YES;

        self.wareHouseViw.hidden = YES;
        self.lineView.hidden = YES;
        
        if (vipBool) {
            self.tradeLabeView.hidden = NO;
            self.notVipView.hidden = YES;
        
                        
            [self.tradeLabeView setLeftLabText:[NSString stringWithFormat:@"%@ %@ %@ 股",model.buytype,model.stockname,model.count] rightLabText:[NSString stringWithFormat:@"%@",model.time]];
            self.tradeLabeView.leftLab.text = [NSString stringWithFormat:@"%@ %@ %@ 股",model.buytype,model.stockname,model.count];
            
            
        }else{
            self.tradeLabeView.hidden = YES;
            self.notVipView.hidden = NO;
            self.notVipView.type = StockNotVipViewType_Business;
        }
        
        
    }else{
    
        StockDealModel *model = modelObject;
        self.chartView.hidden =YES;
        self.tradeLabeView.hidden = YES;
        
        if (vipBool) {
            self.wareHouseViw.hidden = NO;
            self.lineView.hidden = NO;
            self.notVipView.hidden = YES;

            [self.wareHouseViw.titleLabV setLeftLabText:model.stockname rightLabText:@""];
            [self.wareHouseViw.nowRmbLabV setLeftLabText:[NSString stringWithFormat:@"现价 %@",model.currprice] rightLabText:[NSString stringWithFormat:@"盈亏 %@/%@",model.profitmoney,model.profitrate]];
            [self.wareHouseViw.costRmbLabV setLeftLabText:[NSString stringWithFormat:@"成本 %@",model.cost] rightLabText:[NSString stringWithFormat:@"持有数 %@",model.count]];
            
            
            
        }else{
        
            self.wareHouseViw.hidden = YES;
            self.lineView.hidden = YES;
            self.notVipView.hidden = NO;
            self.notVipView.type = StockNotVipViewType_Storehouse;
        }
    }
}

-(void)setChartLineViewModelArray:(NSArray *)array andHeaderModel:(StockDealModel *)headerModel{
    
    WeakSelf(self);
    weakSelf.chartView.selectIndex = headerModel.selectBtnTag;
    StockDealModel *model = array[headerModel.selectBtnTag];
    
    CGFloat midLeftStr = 0.0;
    midLeftStr = ABS(((ABS([model.maxY floatValue]) - [model.minY floatValue])/2.0)) + [model.minY floatValue];

    weakSelf.chartView.leftTitArrays = [ShareFunction returnStockDelChartLineViewLeftLabelTextWithDataArray:@[model.minY,model.maxY]];
    
    
    NSString *leftlowStr = @"";
    NSString *rightLowStr = @"";
    
    if(model.dates.count>0) {
        
        leftlowStr = [model.dates firstObject];
        rightLowStr = [model.dates lastObject];
    }
    
    weakSelf.chartView.lowTitArrays = @[leftlowStr,rightLowStr];
    weakSelf.chartView.lineChartView.raneValue_Y = CGRangeMake([model.minY floatValue], [model.maxY floatValue]);
    
    [weakSelf.chartView.lineChartView clearLine];
    weakSelf.chartView.lineChartView.valuePoints_Y = @[model.rateYs,model.trendYs];
    [weakSelf.chartView.lineChartView drawLine];
        
    __weak typeof(array) weakArray = array;
    __weak typeof(headerModel) weakHeaderModel = headerModel;
    
    self.chartView.didSelcetIndex = ^(NSInteger index){
        weakHeaderModel.selectBtnTag = (index-1);
        [weakSelf setChartLineViewModelArray:weakArray andHeaderModel:weakHeaderModel];
    };

    
}


@end
