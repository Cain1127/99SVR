


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
    self.chartView.lineChartView.drawLine_X = YES;
    self.chartView.lineChartView.drawLine_Y = NO;
    self.chartView.lineChartView.lineColors = @[COLOR_Auxiliary_Orange,COLOR_Auxiliary_Blue];
    self.chartView.lineChartView.timeValue = 0;
    self.chartView.lineChartView.level_Y = 2;
    self.chartView.lineChartView.level_X = 2;
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
        StockDealModel *model = stockLineArray[headerModel.selectBtnTag];
        
        [self setChartLineViewModel:model andHeaderModel:headerModel];
        
    }else if ([cellId isEqualToString:@"section1"]){
        
        
        StockDealModel *model = modelObject;
        self.chartView.hidden =YES;
        self.wareHouseViw.hidden = YES;
        self.lineView.hidden = YES;
        
        if (vipBool) {
            self.tradeLabeView.hidden = NO;
            self.notVipView.hidden = YES;
            
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@ %@ 股",model.buytype,model.stockname,model.count]];
            if ([model.buytype isEqualToString:@"买入"]) {
                [attriStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:NSMakeRange(0, 2)];
            }else{
                
                [attriStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor greenColor]
                                 range:NSMakeRange(0, 2)];
            }
            
            [attriStr addAttribute:NSForegroundColorAttributeName
                             value:COLOR_Text_Black
                             range:NSMakeRange(2, ([attriStr length]-2))];
            
            self.tradeLabeView.leftLab.attributedText = attriStr;
            self.tradeLabeView.rightLab.text = [NSString stringWithFormat:@"%@",model.time];
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

-(void)setChartLineViewModel:(StockDealModel *)model andHeaderModel:(StockDealModel *)headerModel{
    
    
    WeakSelf(self);
    
    if (weakSelf.chartView) {
        
        [weakSelf.chartView removeFromSuperview];
        //股票走势图
        weakSelf.chartView = [[StockChartView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,static_cast<CGFloat>(ScreenWidth*0.75)}];
        weakSelf.chartView.lineChartView.drawLine_X = YES;
        weakSelf.chartView.lineChartView.drawLine_Y = NO;
        weakSelf.chartView.lineChartView.lineColors = @[COLOR_Auxiliary_Orange,COLOR_Auxiliary_Blue];
        weakSelf.chartView.lineChartView.timeValue = 0;
        weakSelf.chartView.lineChartView.level_Y = 2;
        weakSelf.chartView.lineChartView.level_X = 2;
        [weakSelf.bakImageView addSubview:weakSelf.chartView];
        
    }
    
    weakSelf.chartView.topTitItems = @[@"全部",@"三个月",@"一个月"];
    weakSelf.chartView.leftTitArrays = @[[NSString stringWithFormat:@"%@",model.maxY],@"100%",[NSString stringWithFormat:@"%@",model.minY]];
    weakSelf.chartView.lowTitArrays = @[[model.dates firstObject],@"2016-1-3",[model.dates lastObject]];
    weakSelf.chartView.lineChartView.raneValue_Y = CGRangeMake([model.minY floatValue], [model.maxY floatValue]);
    
    [weakSelf.chartView.lineChartView clearLine];
    weakSelf.chartView.lineChartView.valuePoints_Y = @[model.rateYs,model.trendYs];
    [weakSelf.chartView.lineChartView drawLine];
    
    
    
    __weak typeof(model) weakModel = model;
    __weak typeof(headerModel) weakHeaderModel = headerModel;
    
    self.chartView.didSelcetIndex = ^(NSInteger index){
        weakHeaderModel.selectBtnTag = (index-1);
        [weakSelf setChartLineViewModel:weakModel andHeaderModel:weakHeaderModel];
    };

    
}


@end
