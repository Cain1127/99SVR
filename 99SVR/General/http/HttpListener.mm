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
#import "DecodeJson.h"
#import "TQIdeaModel.h"
#import "TQIdeaDetailModel.h"
#import "TQMessageModel.h"
#import "TQAnswerModel.h"
#import "XConsumeRankModel.h"
#import "TQPersonalModel.h"
#import "TQMeCustomizedModel.h"
#import "TQNoPurchaseModel.h"
#import "TQIntroductModel.h"
#import "MJExtension.h"
#import "XPrivateDetail.h"
#import "XVideoTeamInfo.h"

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
        model.content = [NSString stringWithFormat:@"附近的可拉伸机发了多少啊叫付款了的撒安居客福利的撒健康路放电视剧阿卡丽发十大健康了缴费的斯科拉交罚款了撒娇快乐飞机的撒垃圾快速打开了纪检委付款了为尽快了解分手快乐大脚付款了文件分开来叫我快乐飞机速度快辣椒粉看来我姐夫看来今晚看路附近付款了的撒家里开发的叫撒考虑福建师大路口就开了及刻录机离开极乐空间看林俊杰及刻录机考虑及刻录机离开就开了"];
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
 *  请求操盘列表日
 */
void OperateStockProfitListenerDay::onResponse(vector<OperateStockProfit>& day){
    
    NSMutableArray *muArray = [NSMutableArray array];
    
    for (size_t i=0; i!=day.size(); i++) {
        
        OperateStockProfit *profit = &day[i];
        StockDealModel *allModel = [[StockDealModel alloc]initWithHomeRecordData:profit];
        [muArray addObject:allModel];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_DAY__VC object:muArray];

    });
    
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_MON__VC object:muArray];

    });
    

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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_HOME_TOTAL__VC object:muArray];
    });
    
}


/**
 *  请求操盘详情
 */
void OperateStockAllDetailListener::onResponse(OperateStockProfit& profit, OperateStockData& data, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks,uint32 currLevelId){
    
    int vipLevel = 1;
    
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
            [transArray addObject:transactionModel];
        }
    }else{
     
        StockDealModel *model = [[StockDealModel alloc]init];
        [transArray addObject:model];
    }
    muDic[@"trans"] = transArray;
    
    //持仓详情
    NSMutableArray *stocksArray = [NSMutableArray array];
    if (vipLevel!=0) {
        for (size_t i =0; i < stocks.size(); i ++) {
            
            OperateStocks *operateStocks = &stocks[i];
            StockDealModel *operateStocksModel = [[StockDealModel alloc]initWithStockDealWareHouseRecoreData:operateStocks];
            [stocksArray addObject:operateStocksModel];
        }
    }else{
        StockDealModel *model = [[StockDealModel alloc]init];
        [stocksArray addObject:model];
    }
    muDic[@"stocks"] = stocksArray;
    muDic[@"vipLevel"] = @(vipLevel);
    muDic[@"operateId"] = @(profit.operateid());
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_RECORD_BUSINESS_VC object:muArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_WAREHOUSE__VC object:muArray];
        
    });

    

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
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_STOCK_WAREHOUSE__VC object:muArray];
    
}
/**
 *  请求信息--已购买的私人定制(购买或者未购买)
 */
void MyPrivateServiceListener::onResponse(vector<MyPrivateService>& infos, Team recommendTeam, std::vector<TeamPrivateServiceSummaryPack>& teamSummaryPackList){
    if (infos.size() == 0) {
        //获取直播未购买页数据
//        NSMutableArray *noPurArray = [NSMutableArray array];
//        TQNoPurchaseModel *noPurModel = [[TQNoPurchaseModel alloc] initWithTeamSummaryPack:&teamSummaryPack];
//        [noPurArray addObject:noPurModel];
//        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_NOPURCHASE_VC object:noPurArray];
    }else {
        
        for (int i=0; i<infos.size(); i++) {
        //获取已经购买数据
            NSMutableArray *ary = [NSMutableArray array];
            for (int i=0; i<infos.size(); i++) {
                MyPrivateService service = infos[i];
                NSString *teamid = [NSString stringWithUTF8String:service.teamid().c_str()];
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

void WhatIsPrivateServiceListener::onResponse(WhatIsPrivateService& infos){
    NSString *strInfo = [NSString stringWithUTF8String:infos.content().c_str()];
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_WHAT_IS_PRIVATE_VC object:strInfo];
}

/**
 *  请求信息--购买
 */

void BuyPrivateServiceListener::onResponse(vector<PrivateServiceLevelDescription>& infos){
    
}

void TeamPrivateServiceSummaryPackListener::onResponse(vector<TeamPrivateServiceSummaryPack>& infos){
    
    
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

void ChargeRuleListener::onResponse(vector<ChargeRule>& infos){
    
}

void TeamListListener::onResponse(vector<Team>& infos){
    
}

void TeamIntroduceListener::onResponse(Team& info)
{
    NSString *teamName = [NSString stringWithUTF8String:info.teamname().c_str()];
    NSString *teamIcon = [NSString stringWithUTF8String:info.teamicon().c_str()];
    NSString *introduce = [NSString stringWithUTF8String:info.introduce().c_str()];
    NSDictionary *dict = @{@"teamName":teamName,@"teamIcon":teamIcon,@"introduce":introduce};
    XVideoTeamInfo *xVideo = [XVideoTeamInfo mj_objectWithKeyValues:dict];
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i=0; i<info.videoList().size(); i++)
//    {
//        VideoInfo video = info.videoList()[i];
//        int nId = video.id();
//        NSString *name = [NSString stringWithUTF8String:video.name().c_str()];
//        NSString *picurl = [NSString stringWithUTF8String:video.picurl().c_str()];
//        NSString *videourl = [NSString stringWithUTF8String:video.videourl().c_str()];
//        NSDictionary *parameter = @{@"name":name,@"picurl":picurl,@"videourl":videourl,@"nId":@(nId)};
//        VideoModel *model = [VideoModel mj_objectWithKeyValues:parameter];
//        [array addObject:model];
//    }
//    xVideo.videoList = array;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEAM_INTRODUCE_VC object:xVideo];
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

void AskQuestionListener::onResponse(int errCode, string errMsg){
    NSDictionary *dict = @{@"errCode":@(errCode),@"errMsg":[NSString stringWithUTF8String:errMsg.c_str()]};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_QUESTION_VC object:dict];
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
/**
 *  请求信息--提问回复
 */

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
/**
 *  请求信息--评论回复
 */

void MailReplyListener::onResponse(vector<MailReply>& info)
{
    for (int i=0; i<info.size(); i++) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i=0; i<info.size(); i++) {
            TQAnswerModel *model = [[TQAnswerModel alloc] initWithRplay:&info[i]];
            [ary addObject:model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_MAILREPLY_VC object:ary];
    }
}
//信息请求私人定制
void PrivateServiceSummaryListener::onResponse(vector<PrivateServiceSummary>& info)
{
    
    for (int i=0; i<info.size(); i++) {
        NSMutableArray *ary = [NSMutableArray array];
        for (int i=0; i<info.size(); i++) {
            TQPersonalModel *model = [[TQPersonalModel alloc] initWithMyPrivateService:&info[i]];
            [ary addObject:model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:ary];
    }

}

void UnreadListener::onResponse(Unread& info)
{
    
}

void HomePageListener::onResponse(std::vector<HomePageVideoroomItem> vedioroom_data, std::vector<HomePageViewpointItem> viewpoint_data, std::vector<OperateStockProfit> operate_data)
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












