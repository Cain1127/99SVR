//
//  HttpListener.cpp
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#include <stdio.h>
#include "HttpListener.h"
#include "StockDealModel.h"
/**
 *  闪屏响应
 */
void SplashImageListener::onResponse(Splash& info){
    
}
/**
 *  请求观点列表
 */
void ViewpointSummaryListener::onResponse(vector<ViewpointSummary>& infos){
    for (int i=0; i<infos.size(); i++) {
        DLog(@"flowerCount:%d",infos[i].flowercount());
    }
}
/**
 *  请求观点详情
 */
void ViewpointDetailListener::onResponse(ViewpointDetail& infos){
    
}
/**
 *  请求观点回复
 */
void ReplyListener::onResponse(vector<Reply>& infos){
    
}
/**
 *  回复观点
 */
void PostReplyListener::onResponse(int errorCode, Reply& info){
    
}
/**
 *  请求操盘列表
 */
void OperateStockProfitListener::onResponse(vector<OperateStockProfit>& day, vector<OperateStockProfit>& month, vector<OperateStockProfit>& total){
    
}
/**
 *  请求操盘详情
 */
void OperateStockAllDetailListener::onResponse(OperateStockProfit& profit, OperateStockData& data, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks){
    
    int vipLevel = 0;
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    //股票头部数据
    StockDealModel *headerModel = [[StockDealModel alloc]initWithProfit:profit];
    //头部数据
    muDic[@"headerModel"] = headerModel;
    
    //股票数据
    StockDealModel *stockDataModel = [[StockDealModel alloc]initWithStockData:data];
    muDic[@"stockModel"] = stockDataModel;
    
    //交易详情
    NSMutableArray *transArray = [NSMutableArray array];
    if (vipLevel!=0) {

        for (size_t i =0; i < trans.size(); i ++) {
            
            OperateStockTransaction *transaction = &trans[i];
            StockDealModel *transactionModel = [[StockDealModel alloc]initWithOperateStockTransaction:transaction];
            transactionModel.vipLevel = [NSString stringWithFormat:@"%d",vipLevel];
            [transArray addObject:transactionModel];
        }
        
    }else{
     
        StockDealModel *model = [[StockDealModel alloc]init];
        model.vipLevel = [NSString stringWithFormat:@"%d",vipLevel];
        [transArray addObject:model];
    }
    muDic[@"trans"] = transArray;
    
    //持仓详情
    NSMutableArray *stocksArray = [NSMutableArray array];
    if (vipLevel!=0) {
        for (size_t i =0; i < stocks.size(); i ++) {
            
            OperateStocks *operateStocks = &stocks[i];
            StockDealModel *operateStocksModel = [[StockDealModel alloc]initWithOperateStocks:operateStocks];
            operateStocksModel.vipLevel = [NSString stringWithFormat:@"%d",vipLevel];
            [stocksArray addObject:operateStocksModel];
        }
    }else{
        StockDealModel *model = [[StockDealModel alloc]init];
        model.vipLevel = [NSString stringWithFormat:@"%d",vipLevel];
        [stocksArray addObject:model];
    }
    muDic[@"stocks"] = stocksArray;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_DEAL_VC object:muDic];
}
/**
 *  请求操盘详情--交易记录
 */
void OperateStockTransactionListener::onResponse(vector<OperateStockTransaction>& trans){
    
}
/**
 *  请求操盘详情--持仓情况
 */
void OperateStocksListener::onResponse(vector<OperateStocks>& stocks){
    
}

void MyPrivateServiceListener::onResponse(vector<MyPrivateService>& infos, Team recommendTeam, TeamPriviteServiceSummaryPack& teamSummaryPack){
    
}

void WhatIsPrivateServiceListener::onResponse(WhatIsPrivateService& infos){
    
}

void BuyPrivateServiceListener::onResponse(vector<PrivateServiceLevelDescription>& infos, string expirationDate, uint32 currLevelId){
    
}

void TeamPriviteServiceSummaryPackListener::onResponse(vector<TeamPriviteServiceSummaryPack>& infos){
    
}

void PrivateServiceDetailListener::onResponse(PrivateServiceDetail& info){
    
}

void ChargeRuleListener::onResponse(vector<ChargeRule>& infos){
    
}

void TeamListListener::onResponse(vector<Team>& infos){
    
}

void TeamIntroduceListener::onResponse(TeamIntroduce& info){
    
}

void ConsumeRankListener::onResponse(vector<ConsumeRank>& info){
    
}

void AskQuestionListener::onResponse(int errCode, string errMsg){
    
}





