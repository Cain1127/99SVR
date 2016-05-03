


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


-(void)setCellDataWithModel:(StockDealModel *)model withIsVip:(BOOL)vipBool withCellId:(NSString *)cellId{
    
    WeakSelf(self);

    if ([cellId isEqualToString:@"section0"]) {
        
        self.tradeLabeView.hidden = YES;
        self.wareHouseViw.hidden = YES;
        self.chartView.hidden = NO;
        self.lineView.hidden = YES;
        self.notVipView.hidden = YES;
        
        self.chartView.topTitItems = @[@"全部",@"三个月",@"一个月"];
        self.chartView.leftTitArrays = @[@"200%",@"100%",@"200%"];
        self.chartView.lowTitArrays = @[@"2016-1-3",@"2016-1-3",@"2016-1-3"];

        
        self.chartView.lineChartView.drawLine_X = YES;
        self.chartView.lineChartView.drawLine_Y = NO;
        self.chartView.lineChartView.lineColors = @[COLOR_Auxiliary_Orange,COLOR_Auxiliary_Blue];
        self.chartView.lineChartView.timeValue = 0.5;
        self.chartView.lineChartView.raneValue_Y = CGRangeMake(-2000, 2000);
        self.chartView.lineChartView.level_Y = 2;
        self.chartView.lineChartView.level_X = 2;
        
        NSMutableArray *arrayy =[NSMutableArray array];
        NSMutableArray *arrayy1 =[NSMutableArray array];
        
        for (int i=0; i!=10; i++) {
            [arrayy addObject:[NSString stringWithFormat:@"%d",(int)arc4random()%500]];
        }
        
        for (int i=0; i!=10; i++) {
            [arrayy1 addObject:[NSString stringWithFormat:@"%d",(int)arc4random()%500]];
        }
        [weakSelf.chartView.lineChartView clearLine];
        weakSelf.chartView.lineChartView.valuePoints_Y = @[arrayy,arrayy1];
        [weakSelf.chartView.lineChartView drawLine];

        
        self.chartView.didSelcetIndex = ^(NSInteger index){
          
            DLog(@"点击的模块%ld",index);
            
            NSMutableArray *array_y =[NSMutableArray array];
            NSMutableArray *array_y1 =[NSMutableArray array];
            
            for (int i=0; i!=10; i++) {
                [array_y addObject:[NSString stringWithFormat:@"%zi",(int)arc4random()%500-500*(index)]];
            }
            
            for (int i=0; i!=10; i++) {
                [array_y1 addObject:[NSString stringWithFormat:@"%zi",(int)arc4random()%500-500*(index)]];
            }
            [weakSelf.chartView.lineChartView clearLine];
            weakSelf.chartView.lineChartView.valuePoints_Y = @[array_y,array_y1];
            [weakSelf.chartView.lineChartView drawLine];
        };

        
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
