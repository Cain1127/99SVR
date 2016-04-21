//
//  HttpListener.cpp
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#include <stdio.h>
#include "HttpListener.h"

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
        DLog(@"flowerCount:%d",infos[i].giftcount());
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
void OperateStockProfitListener::onResponse(vector<OperateStockProfit>& day){
     
}
/**
 *  请求操盘详情
 */
void OperateStockAllDetailListener::onResponse(OperateStockProfit& profit, OperateStockData& data, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks){
    
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





