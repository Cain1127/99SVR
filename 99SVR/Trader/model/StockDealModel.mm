//
//  StockDealModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockDealModel.h"
#import "StockMacro.h"

@implementation StockDealModel

- (instancetype)initWithStockDealHeaderData:(OperateStockProfit &)profit
{
    self = [super init];
    if (self) {
        
        _teamid = StrTransformCToUTF8(profit.teamid().c_str());
        _teamicon = StrTransformCToUTF8(profit.teamicon().c_str());
        _focus = StrTransformCToUTF8(profit.focus().c_str());
        _teamname = StrTransformCToUTF8(profit.teamname().c_str());
        _operateid = IntTransformIntToStr(profit.operateid());
        _goalprofit = FloatTransformFloatToStr(profit.goalprofit());
        _transId = IntTransformIntToStr(profit.transid());
        _totalprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit.totalprofit()*100))];
        //日利率
        _dayprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit.dayprofit()*100))];
        //月收益
        _monthprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit.monthprofit()*100))];
        //超赢
        _winrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit.winrate()*100))];
    }
    return self;
}



- (instancetype)initWithStockDealStockData:(OperateStockData &)stockData{
    
    self = [super init];
    if (self) {
        _operateid = IntTransformIntToStr(stockData.operateid());
    }
    return self;
}

- (instancetype)initWithStockDealBusinessRecoreData:(OperateStockTransaction *)trans{

    self = [super init];
    if (self) {
        
        _operateid = IntTransformIntToStr(trans->operateid());
        _buytype = StrTransformCToUTF8(trans->buytype().c_str());
        _stockid = StrTransformCToUTF8(trans->stockid().c_str());
        _stockname = StrTransformCToUTF8(trans->stockname().c_str());
        _price = FloatTransformFloatToStr(trans->price());
        _count = IntTransformIntToStr(trans->count());
        _money = FloatTransformFloatToStr(trans->money());
        _time = StrTransformCToUTF8(trans->time().c_str());
        
    }
    return self;

}

- (instancetype)initWithStockDealWareHouseRecoreData:(OperateStocks *)stocks{

    self = [super init];
    if (self) {        
        _operateid = IntTransformIntToStr(stocks->operateid());
        _stockid = StrTransformCToUTF8(stocks->stockid().c_str());
        _stockname = StrTransformCToUTF8(stocks->stockname().c_str());
        _count = IntTransformIntToStr(stocks->count());
        _cost = FloatTransformFloatToStr(stocks->cost());
        _currprice = FloatTransformFloatToStr(stocks->currprice());
        _profitrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((stocks->profitrate()*100))];
        _profitmoney = FloatTransformFloatToStr(stocks->profitmoney());
    }
    return self;
    
}
#pragma mark 初始化交易记录详情--交易记录的模型
- (instancetype)initWithStockRecordBusinessData:(OperateStockTransaction *)data
{
    self = [super init];
    if (self) {
        
        _operateid = IntTransformIntToStr(data->operateid());
        _buytype = StrTransformCToUTF8(data->buytype().c_str());
        _stockid = StrTransformCToUTF8(data->stockid().c_str());
        _stockname = StrTransformCToUTF8(data->stockname().c_str());
        _count = IntTransformIntToStr(data->count());
        _price = FloatTransformFloatToStr(data->price());
        _money = FloatTransformFloatToStr(data->money());
        _time = StrTransformCToUTF8(data->time().c_str());
        
        
    }
    return self;
}

#pragma mark 初始化持仓情况的模型
- (instancetype)initWithStockRecordWareHouseData:(OperateStocks *)data
{
    self = [super init];
    if (self) {
        _operateid = IntTransformIntToStr(data->operateid());
        _stockid = StrTransformCToUTF8(data->stockid().c_str());
        _stockname = StrTransformCToUTF8(data->stockname().c_str());
        _count = IntTransformIntToStr(data->count());
        _cost = FloatTransformFloatToStr(data->cost());
        _currprice = FloatTransformFloatToStr(data->currprice());
        _profitmoney = FloatTransformFloatToStr(data->profitmoney());
        _profitrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((data->profitrate()*100))];
    }
    return self;
}
#pragma mark 股票首页
- (instancetype)initWithHomeRecordData:(OperateStockProfit *)profit{
    
    
    self = [super init];
    
    if (self) {

        _teamid = StrTransformCToUTF8(profit->teamid().c_str());
        _teamicon = StrTransformCToUTF8(profit->teamicon().c_str());
        _focus = StrTransformCToUTF8(profit->focus().c_str());
        _teamname = StrTransformCToUTF8(profit->teamname().c_str());
        _operateid = IntTransformIntToStr(profit->operateid());
        _goalprofit = FloatTransformFloatToStr(profit->goalprofit());
        _totalprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->totalprofit()*100))];
        //日利率
        _dayprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->dayprofit()*100))];
        //月收益
        _monthprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->monthprofit()*100))];
        //超赢
        _winrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->winrate()*100))];
        _transId = IntTransformIntToStr(profit->transid());
        
    }
    
    return self;
}


@end
