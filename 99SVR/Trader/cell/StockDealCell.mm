


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
    
    //空数据的提示label
    self.nullLabe = [[UILabel alloc]init];
    self.nullLabe.font = Font_15;
    self.nullLabe.textColor = COLOR_Text_Gay;
    self.nullLabe.textAlignment = NSTextAlignmentCenter;
    [self.bakImageView addSubview:self.nullLabe];
    [self.nullLabe mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
}


-(void)setCellDataWithModel:(id)modelObject withIsVip:(BOOL)vipBool withCellId:(NSString *)cellId withStockHeaderModel:(StockDealModel *)headerModel{
    
    if ([cellId isEqualToString:@"section0"]) {
        self.nullLabe.hidden = YES;
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
        self.nullLabe.hidden = YES;
        self.wareHouseViw.hidden = YES;
        self.lineView.hidden = YES;
        
        if ([model.teamname isEqualToString:@"空的数据"]) {
            self.nullLabe.hidden = NO;
            self.notVipView.hidden = YES;
            self.nullLabe.text = @"暂无交易动态";
            
        }else{
            self.nullLabe.hidden = YES;
            if (vipBool) {
                self.tradeLabeView.hidden = NO;
                self.notVipView.hidden = YES;
                NSString *leftAttText = [NSString stringWithFormat:@"%@ %@ %@ 股",model.buytype,model.stockname,model.count];
                NSString *leftText = model.count;
                NSString *rightAttText = [NSString stringWithFormat:@"%@",model.time];
                NSString *rightText = @"";
                [self.tradeLabeView setLeftLabAttText:leftAttText withLeftAttTextColor:COLOR_Text_Black withLeftText:leftText withLeftTextColor:COLOR_Text_BigBlack rightLabAttText:rightAttText withRightAttTextColor:COLOR_Text_Black withRightText:rightText withRightTextColor:COLOR_Text_BigBlack];
                
            }else{
                self.tradeLabeView.hidden = YES;
                self.notVipView.hidden = NO;
                [self.notVipView setViewType:StockNotVipViewType_Business withVipLevel:headerModel.minVipLevel];
            }
            
        }
        
        
        
        
    }else{
    
        StockDealModel *model = modelObject;
        self.chartView.hidden =YES;
        self.tradeLabeView.hidden = YES;
        
        
        if ([model.teamname isEqualToString:@"空的数据"]) {
            self.nullLabe.hidden = NO;
            self.notVipView.hidden = YES;
            self.nullLabe.text = @"暂无持仓";
            
        }else{
            self.nullLabe.hidden = YES;
            if (vipBool) {
                self.wareHouseViw.hidden = NO;
                self.lineView.hidden = NO;
                self.notVipView.hidden = YES;
                
                //标题
                [self.wareHouseViw.titleLabV setLeftLabAttText:model.stockname withLeftAttTextColor:COLOR_Text_Black withLeftText:model.stockname withLeftTextColor:COLOR_Text_Black rightLabAttText:@"" withRightAttTextColor:COLOR_Text_Black withRightText:@"" withRightTextColor:COLOR_Text_Black];
                //成本
                NSString *costRmbLeftAttText = [NSString stringWithFormat:@"成本 %@",model.cost];
                NSString *costRmbRightAttText = [NSString stringWithFormat:@"持有数 %@",model.count];
                [self.wareHouseViw.costRmbLabV setLeftLabAttText:costRmbLeftAttText withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"成本" withLeftTextColor:COLOR_Text_Gay rightLabAttText:costRmbRightAttText withRightAttTextColor:COLOR_Text_BigBlack withRightText:@"持有数" withRightTextColor:COLOR_Text_Gay];
                
                
                //现价
                NSString *nowRmbLeftAttText = [NSString stringWithFormat:@"现价 %@",model.currprice];
                NSString *nowRmbRightAttText = [NSString stringWithFormat:@"盈亏 %@/%@",model.profitmoney,model.profitrate];
                [self.wareHouseViw.nowRmbLabV setLeftLabAttText:nowRmbLeftAttText withLeftAttTextColor:COLOR_Text_BigBlack withLeftText:@"现价" withLeftTextColor:COLOR_Text_Gay rightLabAttText:nowRmbRightAttText withRightAttTextColor:COLOR_Auxiliary_Red withRightText:@"盈亏" withRightTextColor:COLOR_Text_Gay];
                
            }else{
                
                self.wareHouseViw.hidden = YES;
                self.lineView.hidden = YES;
                self.notVipView.hidden = NO;
                [self.notVipView setViewType:StockNotVipViewType_Storehouse withVipLevel:headerModel.minVipLevel];

            }

            
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
