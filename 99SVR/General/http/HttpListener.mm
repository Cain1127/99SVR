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
#import "TQIdeaModel.h"
#import "TQIdeaDetailModel.h"
#import "TQMessageModel.h"
#import "TQAnswerModel.h"

/**
 *  闪屏响应
 */
void SplashImageListener::onResponse(Splash& info){
    
}

/**
*  请求观点列表
*/
void ViewpointSummaryListener::onResponse(vector<ViewpointSummary>& infos){
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<infos.size(); i++) {
        TQIdeaModel *model = [[TQIdeaModel alloc] initWithViewpointSummary:&infos[i]];
        [ary addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:ary];
}

/**
 *  请求观点详情
 */
void ViewpointDetailListener::onResponse(ViewpointDetail& infos){
    TQIdeaDetailModel *model = [[TQIdeaDetailModel alloc] initWithViewpointDetail:&infos];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTDETAIL_VC object:model];
}

/**
 *  请求观点列表
 */
void ReplyListener::onResponse(vector<Reply>& infos){
//    for (int i=0; i<infos.size(); i++) {
//        NSMutableArray *ary = [NSMutableArray array];
//        for (int i=0; i<infos.size(); i++) {
//            TQIdeaModel *model = [[TQIdeaModel alloc] initWithViewpointSummary:&infos[i]];
//            [ary addObject:model];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:ary];
//    }
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
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    
    
    
}
/**
 *  请求操盘详情
 */
void OperateStockAllDetailListener::onResponse(OperateStockProfit& profit, OperateStockData& data, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks,uint32 currLevelId){
    
    int vipLevel = 3;
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    //股票头部数据
    StockDealModel *headerModel = [[StockDealModel alloc]initWithStockDealHeaderData:profit];
    //头部数据
    muDic[@"headerModel"] = headerModel;
    //股票数据
    StockDealModel *stockDataModel = [[StockDealModel alloc]initWithStockDealStockData:data];
    muDic[@"stockModel"] = stockDataModel;
    //交易详情
    NSMutableArray *transArray = [NSMutableArray array];
    if (vipLevel!=0) {

        for (size_t i =0; i < trans.size(); i ++) {
            
            OperateStockTransaction *transaction = &trans[i];
            StockDealModel *transactionModel = [[StockDealModel alloc]initWithStockDealBusinessRecoreData:transaction];
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
            StockDealModel *operateStocksModel = [[StockDealModel alloc]initWithStockDealWareHouseRecoreData:operateStocks];
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
    
    NSMutableArray *muArray = [NSMutableArray array];
    for (size_t i=0; i!=trans.size(); i++) {
        
        OperateStockTransaction *operateStockTransaction = &trans[i];
        StockDealModel *model = [[StockDealModel alloc]initWithStockRecordBusinessData:operateStockTransaction];
        [muArray addObject:model];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_RECORD_BUSINESS_VC object:muArray];
}
/**
 *  请求操盘详情--持仓情况
 */
void OperateStocksListener::onResponse(vector<OperateStocks>& stocks){
    
    
    NSMutableArray *muArray = [NSMutableArray array];
    for (size_t i=0; i!=stocks.size(); i++) {
        
        OperateStocks *stocksModel = &stocks[i];
        StockDealModel *model = [[StockDealModel alloc]initWithStockRecordWareHouseData:stocksModel];
        [muArray addObject:model];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_WAREHOUSE__VC object:muArray];
    
}

void MyPrivateServiceListener::onResponse(vector<MyPrivateService>& infos, Team recommendTeam, TeamPrivateServiceSummaryPack& teamSummaryPack){
    
}

void WhatIsPrivateServiceListener::onResponse(WhatIsPrivateService& infos){
    
}

void BuyPrivateServiceListener::onResponse(vector<PrivateServiceLevelDescription>& infos, string expirationDate, uint32 currLevelId){
    
}

void TeamPrivateServiceSummaryPackListener::onResponse(vector<TeamPrivateServiceSummaryPack>& infos, uint32 currLevelId){
    
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
/**
 *  请求信息--系统消息
 */

void SystemMessageListener::onResponse(vector<SystemMessage>& info)
{
        for (int i=0; i<info.size(); i++) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i=0; i<info.size(); i++) {
            TQMessageModel *model = [[TQMessageModel alloc] initWithSystemMessage:&info[i]];
            [ary addObject:model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SYSTEMMESSAGE_VC object:ary];
    }
    
}

void QuestionAnswerListener::onResponse(vector<QuestionAnswer>& info)
{
    for (int i=0; i<info.size(); i++) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i=0; i<info.size(); i++) {
            TQAnswerModel *model = [[TQAnswerModel alloc] initWithAnswer:&info[i]];
            [ary addObject:model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ANSWERREPLY_VC object:ary];
    }

    
}

void MailReplyListener::onResponse(vector<MailReply>& info)
{
    for (int i=0; i<info.size(); i++) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i=0; i<info.size(); i++) {
//            TQAnswerModel *model = [[TQAnswerModel alloc] initWithAnswer:&info[i]];
//            [ary addObject:model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_MAILREPLY_VC object:ary];
    }

}

void PrivateServiceSummaryListener::onResponse(vector<PrivateServiceSummary>& info)
{
    
}

void UnreadListener::onResponse(Unread& info)
{
    
}

void HomePageListener::onResponse(std::vector<HomePageVideoroomItem> vedioroom_data, std::vector<HomePageTextroomItem> textroom_data, std::vector<HomePageViewpointItem> viewpoint_data)
{
    
}


void FollowTeacherListener::onResponse(std::vector<FollowTeacherRoomItem> room_data)
{
    
}

void FootPrintListener::onResponse(std::vector<FootPrintItem> room_data)
{
    
}

void CollectionListener::onResponse(std::vector<CollectItem> room_data)
{
    
}

void BannerListener::onResponse(std::vector<BannerItem> room_data)
{
    
}












