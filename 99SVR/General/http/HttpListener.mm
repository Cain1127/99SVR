//
//  HttpListener.cpp
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#include <stdio.h>
#include "HttpListener.h"
#import "BannerModel.h"
#import "RoomHttp.h"
#import  "XPrivateService.h"
#import "ZLReply.h"
#import "ZLOperateStock.h"
#import "ZLViewPoint.h"
#include "StockDealModel.h"
#import "DecodeJson.h"
#import "TQIdeaModel.h"
#import "TQIdeaDetailModel.h"
#import "TQMessageModel.h"
#import "TQAnswerModel.h"
#import "StockMacro.h"
#import "XConsumeRankModel.h"
#import "TQPersonalModel.h"
#import "TQMeCustomizedModel.h"
#import "TQNoPurchaseModel.h"
#import "TQIntroductModel.h"
#import "MJExtension.h"
#import "XPrivateDetail.h"
#import "XVideoTeamInfo.h"
#import "SplashModel.h"
#import "RoomHttp.h"
#import "TQPurchaseModel.h"
#import "RoomHttp.h"

/**
 *  闪屏响应
 */
void SplashImageListener::onResponse(Splash& info){
    SplashModel *model = [[SplashModel alloc] initWithSplash:&info];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_SPLASH_VC object:model];
}

void SplashImageListener::OnError(int errCode)
{
    
}

void ViewpointSummaryListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:dict];
}
/**
 *  请求观点列表
 */
void ViewpointSummaryListener::onResponse(vector<ViewpointSummary>& infos){
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<infos.size(); i++) {
        ViewpointSummary summary = infos[i];
        TQIdeaModel *model = [[TQIdeaModel alloc] initWithViewpointSummary:&summary];
        [ary addObject:model];
    }
    NSDictionary *dict = @{@"code":@(1),@"model":ary};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:dict];
}

/**
 *  请求观点详情
 */
void ViewpointDetailListener::onResponse(ViewpointDetail& info, vector<ImageInfo>& images){
    DLog(@"images:%ld",images.size());
    TQIdeaDetailModel *model = [[TQIdeaDetailModel alloc] initWithViewpointDetail:&info];
    NSDictionary *dict = @{@"code":@(1),@"model":model};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTDETAIL_VC object:dict];
}

void ViewpointDetailListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_VIEWPOINTDETAIL_VC object:dict];
}

/**
 *  评论回复响应
 */
void ReplyListener::onResponse(vector<Reply>& infos){
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<infos.size(); i++) {
        ZLReply *reply = [[ZLReply alloc] init];
        Reply info = infos[i];
        reply.replytid = info.replytid();
        reply.viewpointid = info.viewpointid();
        reply.parentreplyid = info.parentreplyid();
        reply.authorid = NSStringFromInt(info.authorid());
        reply.authorname = [NSString stringWithUTF8String:info.authorname().c_str()];
        reply.authoricon = [NSString stringWithUTF8String:info.authoricon().c_str()];
        reply.fromauthorid = NSStringFromInt(info.fromauthorid());
        reply.fromauthorname = [NSString stringWithUTF8String:info.fromauthorname().c_str()];
        reply.fromauthoricon = [NSString stringWithUTF8String:info.fromauthoricon().c_str()];
        reply.publishtime = [NSString stringWithUTF8String:info.publishtime().c_str()];
        reply.content = [NSString stringWithUTF8String:info.content().c_str()];
        [ary addObject:reply];
    }
    NSDictionary *dict = @{@"code":@(1),@"model":ary};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_REQUEST_REPLY_VC object:dict];
}

void ReplyListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_REQUEST_REPLY_VC object:dict];
}
/**
 *  回复观点
 */
void PostReplyListener::onResponse(int errorCode, Reply& info){
    DLog(@"回复成功!");
    ZLReply *reply = [[ZLReply alloc] init];
    reply.replytid = info.replytid();
    reply.viewpointid = info.viewpointid();
    reply.parentreplyid = info.parentreplyid();
//    reply.authorid = [NSString stringWithUTF8String:info.authorid().c_str()];
    reply.authorname = [NSString stringWithUTF8String:info.authorname().c_str()];
    reply.authoricon = [NSString stringWithUTF8String:info.authoricon().c_str()];
//    reply.fromauthorid = [NSString stringWithUTF8String:info.fromauthorid().c_str()];
    reply.fromauthorname = [NSString stringWithUTF8String:info.fromauthorname().c_str()];
    reply.fromauthoricon = [NSString stringWithUTF8String:info.fromauthoricon().c_str()];
    reply.publishtime = [NSString stringWithUTF8String:info.publishtime().c_str()];
    reply.content = [NSString stringWithUTF8String:info.content().c_str()];
    
    NSDictionary *dict = @{@"code":@(1),@"model":reply};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_IDEA_REPLY_RESPONSE_VC object:dict];
    
}
void PostReplyListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_IDEA_REPLY_RESPONSE_VC object:dict];
}

/**
 *  请求操盘列表日
 */
void OperateStockProfitListenerDay::onResponse(vector<OperateStockProfit>& day){
    
    NSMutableArray *muArray = [NSMutableArray array];
    for (size_t i=0; i!=day.size(); i++) {
        
        OperateStockProfit *profit = &day[i];
        StockDealModel *allModel = [[StockDealModel alloc]initWithHomeRecordData:profit];
        [muArray addObject:allModel];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_DAY__VC object:@{@"data":muArray,@"code":@"1"}];
}

void OperateStockProfitListenerDay::OnError(int errCode)
{
    
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_DAY__VC object:@{@"code":code}];
}
/**
 *  请求操盘列表月
 */

void OperateStockProfitListenerMonth::onResponse(vector<OperateStockProfit>& mon){
    
    NSMutableArray *muArray = [NSMutableArray array];
    
    for (size_t i=0; i!=mon.size(); i++) {
        
        OperateStockProfit *profit = &mon[i];
        StockDealModel *allModel = [[StockDealModel alloc]initWithHomeRecordData:profit];
        [muArray addObject:allModel];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_MON__VC object:@{@"data":muArray,@"code":@"1"}];
}

void OperateStockProfitListenerMonth::OnError(int errCode)
{
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_MON__VC object:@{@"code":code}];
}



/**
 *  请求操盘列表总的
 */
void OperateStockProfitListenerAll::onResponse(vector<OperateStockProfit>& total){
    
    NSMutableArray *muArray = [NSMutableArray array];
    
    for (size_t i=0; i!=total.size(); i++) {
        
        OperateStockProfit *profit = &total[i];
        StockDealModel *allModel = [[StockDealModel alloc]initWithHomeRecordData:profit];
        [muArray addObject:allModel];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_TOTAL__VC object:@{@"data":muArray,@"code":@(1)}];
}

void OperateStockProfitListenerAll::OnError(int errCode)
{
    
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_TOTAL__VC object:@{@"code":code}];
}

/**
 *  请求操盘详情 错误
 */

void OperateStockAllDetailListener::OnError(int errCode)
{
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_DEAL_VC object:@{@"code":code}];
}
/**
 *  请求操盘详情
 */
void OperateStockAllDetailListener::onResponse(OperateStockProfit& profit, vector<OperateDataByTime>& totals, vector<OperateDataByTime>& month3s, vector<OperateDataByTime>& months, vector<OperateDataByTime>& weeks, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks, uint32 currLevelId, uint32 minVipLevel){
    
    //判断是否显示记录 
    BOOL isShowRecal = currLevelId >= minVipLevel ? YES : NO;
    DLog(@"---------------------------------------------------");
    DLog(@"currLevelId=%d   minVipLevel=%d ",currLevelId,minVipLevel);
    DLog(@"---------------------------------------------------");

//    BOOL isShowRecal = NO;

    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    
    //股票头部数据
    StockDealModel *headerModel = [[StockDealModel alloc] initWithStockDealHeaderData:&profit];
    headerModel.minVipLevel = IntTransformIntToStr(minVipLevel);
    headerModel.currLevelId = IntTransformIntToStr(currLevelId);
    //头部数据
    muDic[@"headerModel"] = headerModel;
    
    
    //股票数据
    StockDealModel *stockDataModel = [[StockDealModel alloc] initWithStockDealStockData:&stocks];
    muDic[@"stockModel"] = stockDataModel;
    
    
    //交易详情
    NSMutableArray *transArray = [NSMutableArray array];
    if (isShowRecal) {
        for (size_t i =0; i < trans.size(); i ++) {
            OperateStockTransaction *transaction = &trans[i];
            StockDealModel *transactionModel = [[StockDealModel alloc]initWithStockDealBusinessRecoreData:transaction];
            [transArray addObject:transactionModel];
        }
    }else{
        
        StockDealModel *model = [[StockDealModel alloc]init];
        model.selectBtnTag = 1;
        [transArray addObject:model];
    }
    muDic[@"trans"] = transArray;
    
    //持仓详情
    NSMutableArray *stocksArray = [NSMutableArray array];
    if (isShowRecal) {
        for (size_t i =0; i < stocks.size(); i ++) {
            OperateStocks *operateStocks = &stocks[i];
            StockDealModel *operateStocksModel = [[StockDealModel alloc]initWithStockDealWareHouseRecoreData:operateStocks];
            [stocksArray addObject:operateStocksModel];
        }
        
    }else{
        StockDealModel *model = [[StockDealModel alloc]init];
        model.selectBtnTag = 1;
        [stocksArray addObject:model];
    }
    
    muDic[@"currLevelId"] = [NSString stringWithFormat:@"%d",currLevelId];
    muDic[@"minVipLevel"] = [NSString stringWithFormat:@"%d",minVipLevel];
    muDic[@"stocks"] = stocksArray;
    
    
    muDic[@"recalState"] = isShowRecal ? @"show" : @"hide";
    muDic[@"operateId"] = [NSString stringWithFormat:@"%d",profit.operateid()];
    //ID
    muDic[@"code"] = @"1";
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_DEAL_VC object:muDic];
}

/**
 *  请求操盘详情--交易记录
 */
void OperateStockTransactionListener::onResponse(vector<OperateStockTransaction>& trans){
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    
    NSMutableArray *muArray = [NSMutableArray array];
    for (size_t i=0; i!=trans.size(); i++) {
        OperateStockTransaction *operateStockTransaction = &trans[i];
        StockDealModel *model = [[StockDealModel alloc]initWithStockRecordBusinessData:operateStockTransaction];
        [muArray addObject:model];
    }
    mudic[@"code"] = @"1";
    mudic[@"data"] = muArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_RECORD_BUSINESS_VC object:mudic];
}

void OperateStockTransactionListener::OnError(int errCode)
{
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_RECORD_BUSINESS_VC object:@{@"code":code,@"data":@[]}];

}

/**
 *  请求操盘详情--持仓情况
 */
void OperateStocksListener::onResponse(vector<OperateStocks>& stocks){
    
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    NSMutableArray *muArray = [NSMutableArray array];
    for (size_t i=0; i!=stocks.size(); i++) {
        
        OperateStocks *stocksModel = &stocks[i];
        StockDealModel *model = [[StockDealModel alloc]initWithStockRecordWareHouseData:stocksModel];
        [muArray addObject:model];
    }
    mudic[@"code"] = @"1";
    mudic[@"data"] = muArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_WAREHOUSE__VC object:mudic];
}

void OperateStocksListener::OnError(int errCode)
{
 
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_WAREHOUSE__VC object:@{@"code":code,@"data":@[]}];

}
/**
 *  请求信息--已购买的私人定制(购买或者未购买)
 */
void MyPrivateServiceListener::onResponse(vector<MyPrivateService>& infos, Team recommendTeam, std::vector<TeamPrivateServiceSummaryPack>& teamSummaryPackList){
    if (infos.size() == 0) {
        RoomHttp *room = [[RoomHttp alloc] initWithData:&recommendTeam];
        NSMutableArray *aryDict = [NSMutableArray array];
        for(int i=0;i<teamSummaryPackList.size();i++)
        {
            TeamPrivateServiceSummaryPack pack = teamSummaryPackList[i];
            XPrivateService *service = [[XPrivateService alloc] init];
            service.vipLevelId = pack.vipLevelId();
            service.vipLevelName = [NSString stringWithUTF8String:pack.vipLevelName().c_str()];
            service.isOpen = pack.isOpen();
            NSMutableArray *array = [NSMutableArray array];
            for (int j = 0 ; j < pack.summaryList().size(); j++) {
                PrivateServiceSummary sumary = pack.summaryList()[j];
                XPrivateSummary *priSummary = [[XPrivateSummary alloc] init];
                priSummary.nId = sumary.id();
                priSummary.title = [NSString stringWithUTF8String:sumary.title().c_str()];
                priSummary.summary = [NSString stringWithUTF8String:sumary.summary().c_str()];
                priSummary.publishtime = [NSString stringWithUTF8String:sumary.publishtime().c_str()];
                priSummary.teamname = [NSString stringWithUTF8String:sumary.teamname().c_str()];
                [array addObject:priSummary];
            }
            service.summaryList = array;
            [aryDict addObject:service];
        }
        //获取直播未购买页数据
        NSDictionary *dict = @{@"code":@(1),@"array":aryDict,@"model":room};
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_NOPURCHASE_VC object:dict];
        
    }else {
        
        for (int i=0; i<infos.size(); i++) {
            //获取已经购买数据
            NSMutableArray *ary = [NSMutableArray array];
            for (int i=0; i<infos.size(); i++) {
                MyPrivateService service = infos[i];
                NSString *teamid = NSStringFromInt(service.teamid());
                NSString *teamname = [NSString stringWithUTF8String:service.teamname().c_str()];
                NSString *teamicon = [NSString stringWithUTF8String:service.teamicon().c_str()];
                NSString *levelname = [NSString stringWithUTF8String:service.levelname().c_str()];
                NSString *expirationdate = [NSString stringWithUTF8String:service.expirationdate().c_str()];
                int levelid = service.levelid();
                NSDictionary *dict = @{@"teamid":teamid,@"teamname":teamname,@"teamicon":teamicon,@"levelname":levelname,
                                       @"expirationdate":expirationdate,@"levelid":@(levelid)};
                TQMeCustomizedModel *model = [TQMeCustomizedModel mj_objectWithKeyValues:dict];
                [ary addObject:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_MYPRIVATESERVICE_VC object:ary];
        }
    }
}

void MyPrivateServiceListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_NOPURCHASE_VC object:@{@"code":@(errCode)}];
}

void WhatIsPrivateServiceListener::onResponse(WhatIsPrivateService& infos){
    NSString *strInfo = [NSString stringWithUTF8String:infos.content().c_str()];
    NSDictionary *dict = @{@"code":@(1),@"data":strInfo};
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_WHAT_IS_PRIVATE_VC object:dict];
}

void WhatIsPrivateServiceListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_WHAT_IS_PRIVATE_VC object:@{@"code":@(errCode)}];
    
}

/**
 *  请求信息--购买 私人订制的详情列表。
 */

void BuyPrivateServiceListener::onResponse(vector<PrivateServiceLevelDescription>& infos){
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    NSMutableArray *muArray = [NSMutableArray array];
    for (size_t i=0; i!=infos.size(); i++) {
        PrivateServiceLevelDescription *profit = &infos[i];
        TQPurchaseModel *headerModel =[[TQPurchaseModel alloc] initWithPrivateServiceLevelData:profit];
        
        DLog(@"vip等级%zi === 是否开通%@",i,headerModel.isopen);
        [muArray addObject:headerModel];
    }
    
    NSString *vipValue = @"0";
    /**
     *  判断是不是vip 只要有购买过vip 就是vip。根据 model里面的isopen来判断
     */
    for (TQPurchaseModel *model in muArray) {
        if ([model.isopen isEqualToString:@"1"]) {
            vipValue = @"1";
            break;
        }
    }
    for (TQPurchaseModel *model in muArray) {
        model.vipValue = vipValue;
    }
    
    if (infos.size()>=1) {
        muDic[@"headerModel"] = muArray[0];
    }
    
    muDic[@"data"] = muArray;
    muDic[@"code"] = @"1";
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TQPURCHASE_VC object:muDic];
}

void BuyPrivateServiceListener::OnError(int errCode)
{
    
    NSString *code = [NSString stringWithFormat:@"%d",errCode];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TQPURCHASE_VC object:@{@"code":code}];
}

void TeamPrivateServiceSummaryPackListener::onResponse(vector<TeamPrivateServiceSummaryPack>& infos){
    NSMutableArray *aryDict = [NSMutableArray array];
    for(int i=0;i<infos.size();i++)
    {
        TeamPrivateServiceSummaryPack pack = infos[i];
        XPrivateService *service = [[XPrivateService alloc] init];
        service.vipLevelId = pack.vipLevelId();
        service.vipLevelName = [NSString stringWithUTF8String:pack.vipLevelName().c_str()];
        service.isOpen = pack.isOpen();
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0 ; j < pack.summaryList().size(); j++) {
            PrivateServiceSummary sumary = pack.summaryList()[j];
            XPrivateSummary *priSummary = [[XPrivateSummary alloc] init];
            
            priSummary.nId = sumary.id();
            priSummary.title = [NSString stringWithUTF8String:sumary.title().c_str()];
            priSummary.summary = [NSString stringWithUTF8String:sumary.summary().c_str()];
            priSummary.publishtime = [NSString stringWithUTF8String:sumary.publishtime().c_str()];
            priSummary.teamname = [NSString stringWithUTF8String:sumary.teamname().c_str()];
            [array addObject:priSummary];
        }
        service.summaryList = array;
        [aryDict addObject:service];
    }
    NSDictionary *dict = @{@"code":@(1),@"model":aryDict};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_PRIVATE_TEAM_SERVICE_VC object:dict];
}

void TeamPrivateServiceSummaryPackListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_PRIVATE_TEAM_SERVICE_VC object:dict];
}

void PrivateServiceDetailListener::onResponse(PrivateServiceDetail& info){
    
    NSString *title = [NSString stringWithUTF8String:info.title().c_str()];
    NSString *content = [NSString stringWithUTF8String:info.content().c_str()];
    NSString *publishtime = [NSString stringWithUTF8String:info.publishtime().c_str()];
    NSString *videourl = [NSString stringWithUTF8String:info.videourl().c_str()];
    NSString *videoname = [NSString stringWithUTF8String:info.videoname().c_str()];
    NSString *attachmenturl = [NSString stringWithUTF8String:info.attachmenturl().c_str()];
    NSString *attachmentname = [NSString stringWithUTF8String:info.attachmentname().c_str()];
    int operatestockid = info.operatestockid();
    NSString *html5url = [NSString stringWithUTF8String:info.html5url().c_str()];
    NSDictionary *dict = @{@"title":title,@"content":content,@"publishtime":publishtime,@"videourl":videourl,
                           @"videoname":videoname,@"attachmenturl":attachmenturl,@"attachmentname":attachmentname,@"html5url":html5url,
                           @"operatestockid":@(operatestockid)};
    XPrivateDetail *detail = [XPrivateDetail mj_objectWithKeyValues:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_PRIVATE_DETAIL_VC object:detail];
}

void PrivateServiceDetailListener::OnError(int errCode)
{
    
}

void ChargeRuleListener::onResponse(vector<ChargeRule>& infos){
    
}

void ChargeRuleListener::OnError(int errCode)
{
    
}

void TeamListListener::onResponse(vector<Team>& team_infos, vector<Team>& hiden_infos, vector<Team>& custom_service_infos){
    NSMutableArray *array = [NSMutableArray array];
    int i=0;
    NSMutableArray *aryHiden = [NSMutableArray array];
    NSMutableArray *aryHelp = [NSMutableArray array];
    for (; i<team_infos.size(); i++)
    {
        Team _team = team_infos[i];
        RoomHttp *room = [[RoomHttp alloc] initWithData:&_team];
        [array addObject:room];
    }
    
    for (i=0;i<hiden_infos.size(); i++)
    {
        Team _team = hiden_infos[i];
        RoomHttp *room = [[RoomHttp alloc] initWithData:&_team];
        [aryHiden addObject:room];
    }
    
    for(i=0; i<custom_service_infos.size(); i++)
    {
        Team _team = custom_service_infos[i];
        RoomHttp *room = [[RoomHttp alloc] initWithData:&_team];
        [aryHelp addObject:room];
    }
    
    NSDictionary *result = @{@"code":@(1),@"show":array,@"hidden":aryHiden,@"help":aryHelp};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HOME_VIDEO_LIST_VC object:result];
}

void TeamListListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HOME_VIDEO_LIST_VC object:@{@"code":@(errCode)}];
}

void TeamIntroduceListener::onResponse(Team& info)
{
    NSString *teamName = [NSString stringWithUTF8String:info.teamname().c_str()];
    NSString *teamIcon = [NSString stringWithUTF8String:info.teamicon().c_str()];
    NSString *introduce = [NSString stringWithUTF8String:info.introduce().c_str()];
    NSDictionary *dict = @{@"teamName":teamName,@"teamIcon":teamIcon,@"introduce":introduce};
    XVideoTeamInfo *xVideo = [XVideoTeamInfo mj_objectWithKeyValues:dict];
    NSDictionary *result = @{@"code":@(1),@"data":xVideo};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEAM_INTRODUCE_VC object:result];
}

void TeamIntroduceListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEAM_INTRODUCE_VC object:@{@"dict":@(errCode)}];
}

void TeamVideoListener::onResponse(vector<VideoInfo>& infos)
{
    NSMutableArray *aryIndex = [NSMutableArray array];
    for(int i=0;i<infos.size();i++)
    {
        XVideoModel *model = [[XVideoModel alloc] initWithInfo:&infos[i]];
        [aryIndex addObject:model];
    }
    NSDictionary *dict = @{@"code":@(1),@"data":aryIndex};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_VIDEO_LIST_VC object:dict];
}

void TeamVideoListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_VIDEO_LIST_VC object:@{@"code":@(errCode)}];
}

void ConsumeRankListener::OnError(int errCode)
{
    
}

void ConsumeRankListener::onResponse(vector<ConsumeRank>& info){
    NSMutableArray *array = [NSMutableArray array];
    for (int i= 0; i<info.size();i++) {
        ConsumeRank rank = info[i];
        NSString *strUserName = [NSString stringWithUTF8String:rank.username().c_str()];
        int headid = rank.headid();
        float consume = rank.consume();
        NSDictionary *dict = @{@"username":strUserName,@"headid":@(headid),@"consume":@(consume)};
        XConsumeRankModel *model = [XConsumeRankModel mj_objectWithKeyValues:dict];
        [array addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CONSUMERANK_LIST_VC object:array];
}


void AskQuestionListener::onResponse(int retCode){
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_QUESTION_VC object:@{@"code":@(retCode)}];
}

void AskQuestionListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_QUESTION_VC object:@{@"code":@(errCode)}];
}

/**
 *  请求信息--系统消息
 */

void SystemMessageListener::onResponse(vector<SystemMessage>& info)
{
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<info.size(); i++) {
        TQMessageModel *model = [[TQMessageModel alloc] initWithSystemMessage:&info[i]];
        [ary addObject:model];
    }
    NSDictionary *dict = @{@"code":@(1),@"data":ary};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SYSTEMMESSAGE_VC object:dict];
}

void SystemMessageListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SYSTEMMESSAGE_VC object:@{@"code":@(errCode)}];
}

/**
 *  请求信息--提问回复
 */

void QuestionAnswerListener::onResponse(vector<QuestionAnswer>& info)
{
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<info.size(); i++) {
        TQAnswerModel *model = [[TQAnswerModel alloc] initWithAnswer:&info[i]];
        [ary addObject:model];
    }
    NSDictionary *dict = @{@"code":@(1),@"data":ary};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ANSWERREPLY_VC object:dict];
}

void QuestionAnswerListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ANSWERREPLY_VC object:@{@"code":@(errCode)}];
}

/**
 *  请求信息--评论回复
 */

void MailReplyListener::onResponse(vector<MailReply>& info)
{
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<info.size(); i++) {
        TQAnswerModel *model = [[TQAnswerModel alloc] initWithRplay:&info[i]];
        [ary addObject:model];
    }
    NSDictionary *dict = @{@"code":@(1),@"data":ary};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_MAILREPLY_VC object:dict];
}

void MailReplyListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_MAILREPLY_VC object:@{@"code":@(errCode)}];
}

//信息请求私人定制
void PrivateServiceSummaryListener::onResponse(vector<PrivateServiceSummary>& info)
{
    
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0; i<info.size(); i++) {
        TQPersonalModel *model = [[TQPersonalModel alloc] initWithMyPrivateService:&info[i]];
        [ary addObject:model];
    }
    NSDictionary *dict = @{@"code":@(1),@"data":ary};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:dict];
    
}

void PrivateServiceSummaryListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:@{@"code":@(errCode)}];
}

void UnreadListener::onResponse(Unread& info)
{
    NSDictionary *dict = @{@"code":@(1),@"system":@(info.system()),@"answer":@(info.answer()),@"reply":@(info.reply()),@"privateservice":@(info.privateservice())};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_INFO_VC object:dict];
}

void UnreadListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_INFO_VC object:@{@"code":@(1)}];
}

void HomePageListener::onResponse(std::vector<BannerItem>& banner_data, std::vector<Team>& team_data, std::vector<ViewpointSummary>& viewpoint_data, std::vector<OperateStockProfit>& operate_data)
{
    NSMutableArray *banner = [NSMutableArray array];
    int i;
    for (i=0; i<banner_data.size(); i++) {
        BannerItem _banner = banner_data[i];
        BannerModel *model = [[BannerModel alloc] initWithData:&_banner];
        [banner addObject:model];
    }
    
    NSMutableArray *videoRoom = [NSMutableArray array];
    for (i=0; i<team_data.size(); i++) {
        Team _team = team_data[i];
        RoomHttp *room = [[RoomHttp alloc] initWithData:&_team];
        [videoRoom addObject:room];
    }
    NSMutableArray *aryViewPoint = [NSMutableArray array];
    for (i=0; i<viewpoint_data.size(); i++) {
        ViewpointSummary summary = viewpoint_data[i];
        TQIdeaModel *model = [[TQIdeaModel alloc] initWithViewpointSummary:&summary];
        [aryViewPoint addObject:model];
    }
    NSMutableArray *aryOperate = [NSMutableArray array];
    for (i=0; i<operate_data.size(); i++) {
        OperateStockProfit item = operate_data[i];
        ZLOperateStock *operStock = [[ZLOperateStock alloc] init];
        
        operStock.operateid = item.operateid();
        operStock.teamname = [NSString stringWithUTF8String:item.teamname().c_str()];;
        operStock.teamicon = [NSString stringWithUTF8String:item.teamicon().c_str()];;
        operStock.focus = [NSString stringWithUTF8String:item.focus().c_str()];;
        
        operStock.goalprofit = item.goalprofit();
        operStock.totalprofit = item.totalprofit();
        operStock.dayprofit = item.dayprofit();
        operStock.monthprofit = item.monthprofit();
        
        [aryOperate addObject:operStock];
    }
    NSDictionary *dict = @{@"code":@(1),@"video":videoRoom,@"viewpoint":aryViewPoint,@"operate":aryOperate,@"banner":banner};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HOME_BANNER_VC object:dict];
}

void HomePageListener::OnError(int errCode)
{
    NSDictionary *dict = @{@"code":@(errCode)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HOME_BANNER_VC object:dict];
}

void CollectionListener::onResponse(std::vector<Team>& room_data)
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<room_data.size(); i++)
    {
        RoomHttp *room = [[RoomHttp alloc] initWithData:&room_data[i]];
        [array addObject:room];
    }
    NSDictionary *dict = @{@"code":@(1),@"data":array};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:dict];
}

void CollectionListener::OnError(int errCode)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:@{@"code":@(errCode)}];
}











