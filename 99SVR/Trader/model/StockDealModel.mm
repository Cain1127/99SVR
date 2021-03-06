//
//  StockDealModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockDealModel.h"
#import "StockMacro.h"
#import "HttpMessage.pb.h"

@implementation StockDealModel

- (instancetype)initWithStockDealHeaderData:(void *)pData
{
    self = [super init];
    OperateStockProfit *profit = (OperateStockProfit *)pData;
    if (self) {
        _teamicon = StrTransformCToUTF8(profit->teamicon().c_str());
        _focus = StrTransformCToUTF8(profit->focus().c_str());
        _teamname = StrTransformCToUTF8(profit->teamname().c_str());
        _operateid = IntTransformIntToStr(profit->operateid());
        _goalprofit = FloatTransformFloatToStr(profit->goalprofit());
        _totalprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->totalprofit()))];
        //日利率
        _dayprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->dayprofit()))];
        //月收益
        _monthprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->monthprofit()))];
        //超赢
        _winrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->winrate()))];
        
        _teamid = IntTransformIntToStr(profit->teamid());
        _selectBtnTag = 1;

    }
    return self;
}


#pragma mark 股票详情--交易动态记录
- (instancetype)initWithStockDealBusinessRecoreData:(void *)pData{

    self = [super init];
    if (self) {
        OperateStockTransaction *trans = (OperateStockTransaction *)pData;
        _operateid = IntTransformIntToStr(trans->operateid());
        _buytype = StrTransformCToUTF8(trans->buytype().c_str());
        _stockid = StrTransformCToUTF8(trans->stockid().c_str());
        _stockname = StrTransformCToUTF8(trans->stockname().c_str());
        _price = FloatTransformFloatToStr(trans->price());
        _count = IntTransformIntToStr(trans->count());
        _money = FloatTransformFloatToStr(trans->money());
        _time = StrTransformCToUTF8(trans->time().c_str());
        _selectBtnTag = 1;
        _buytypeflag = IntTransformIntToStr(trans->buytypeflag());
    }
    return self;

}
#pragma mark 股票详情--持仓记录
- (instancetype)initWithStockDealWareHouseRecoreData:(void *)pData{

    self = [super init];
    if (self) {
        OperateStocks *stocks = (OperateStocks *)pData;
        _operateid = IntTransformIntToStr(stocks->operateid());
        _stockid = StrTransformCToUTF8(stocks->stockid().c_str());
        _stockname = StrTransformCToUTF8(stocks->stockname().c_str());
        _count = IntTransformIntToStr(stocks->count());
        _cost = FloatTransformFloatToStr(stocks->cost());
        _currprice = FloatTransformFloatToStr(stocks->currprice());
        _profitrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((stocks->profitrate()))];
        _profitmoney = FloatTransformFloatToStr(stocks->profitmoney());
        _selectBtnTag = 1;
    }
    return self;
    
}
#pragma mark 初始化交易记录详情--交易记录的模型
- (instancetype)initWithStockRecordBusinessData:(void *)pData
{
    self = [super init];
    if (self) {
        OperateStockTransaction *data = (OperateStockTransaction *)pData;
        _operateid = IntTransformIntToStr(data->operateid());
        _buytype = StrTransformCToUTF8(data->buytype().c_str());
        _stockid = StrTransformCToUTF8(data->stockid().c_str());
        _stockname = StrTransformCToUTF8(data->stockname().c_str());
        _count = IntTransformIntToStr(data->count());
        _price = FloatTransformFloatToStr(data->price());
        _money = FloatTransformFloatToStr(data->money());
        _time = StrTransformCToUTF8(data->time().c_str());
        _transId = IntTransformIntToStr(data->transid());
        _buytypeflag = IntTransformIntToStr(data->buytypeflag());

    }
    return self;
}

#pragma mark 初始化持仓情况的模型
- (instancetype)initWithStockRecordWareHouseData:(void *)pData
{
    self = [super init];
    if (self) {
        OperateStocks *data = (OperateStocks*)pData;
        _operateid = IntTransformIntToStr(data->operateid());
        _stockid = StrTransformCToUTF8(data->stockid().c_str());
        _stockname = StrTransformCToUTF8(data->stockname().c_str());
        _count = IntTransformIntToStr(data->count());
        _cost = FloatTransformFloatToStr(data->cost());
        _currprice = FloatTransformFloatToStr(data->currprice());
        _profitmoney = FloatTransformFloatToStr(data->profitmoney());
        _profitrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((data->profitrate()))];
    }
    return self;
}
#pragma mark 股票首页
- (instancetype)initWithHomeRecordData:(void *)pData{
    
    
    self = [super init];
    
    if (self) {
        OperateStockProfit *profit = (OperateStockProfit *)pData;
        _teamicon = StrTransformCToUTF8(profit->teamicon().c_str());
        
        _focus = StrTransformCToUTF8(profit->focus().c_str());
        _teamname = StrTransformCToUTF8(profit->teamname().c_str());
        _operateid = IntTransformIntToStr(profit->operateid());
        /**目标收益*/
        _goalprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->goalprofit()))];
        /**总收益*/
        _totalprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->totalprofit()))];
        //日利率
        _dayprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->dayprofit()))];
        //月收益
        _monthprofit = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->monthprofit()))];
        //超赢
        _winrate = [NSString stringWithFormat:@"%@%%",FloatTransformFloatToStr((profit->winrate()))];
        _teamid = IntTransformIntToStr(profit->teamid());
    }
    
    return self;
}


@end
