//
//  HttpProtocolManager.h
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  单例类  http  所有请求协议
 */
@interface HttpProtocolManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(HttpProtocolManager)

/**
 *  请求闪屏
 */
- (void)requestSplashImage;

/**
 *  请求观点列表
 */
- (void)RequestViewpointSummary:(int)authorId start:(int)startId count:(int)requestCount;

/**
 *  请求观点详情
 */
- (void)RequestViewpointDetail:(int)viewpointId;

/**
 *  请求观点回复
 */
- (void)RequestReply:(int)viewpointId start:(int)startId count:(int)requestCount;

/**
 *  回复观点
 */
- (void)PostReply:(int)viewpointId replyId:(int)parentReplyId author:(int)authorId content:(char*)content;

/**
 * 请求操盘列表
 */
- (void)RequestOperateStockProfit:(int)teamId;

/**
 *  请求操盘详情
 */
- (void)RequestOperateStockAllDetail:(int)operateId;

/**
 * 请求操盘详情--交易记录
 */
- (void)RequestOperateStockTransaction:(int)operateId;

/**
 *  请求操盘详情--持仓情况
 */
- (void)RequestOperateStocks:(int)operateId;

// 什么是我的私人定制
- (void) RequestWhatIsPrivateService;

// 请求我已经购买的私人定制
- (void) RequestMyPrivateService:(int)userId;

// 显示购买私人定制页
- (void) RequestBuyPrivateServicePage:(int)userId;//, BuyPrivateServiceListener* listener);

// 请求战队的私人定制缩略信息
- (void) RequestTeamPriviteServiceSummaryPack:(int)teamId;// TeamPriviteServiceSummaryPackListener* listener);

// 请求私人定制详情
- (void) RequestPrivateServiceDetail:(int)nId;// PrivateServiceDetailListener* listener);

// 请求充值规则列表
- (void) RequestChargeRuleList;//(ChargeRuleListener* listener);

// 请求战队（财经直播）列表
- (void) RequestTeamList;

// 请求战队简介
- (void) RequestTeamIntroduce:(int)teamId;

// 请求贡献榜
- (void) RequestConsumeRank:(int)teamId;

// 提问
- (void) PostAskQuestion:(int)teamId stock:(const char*)stock question:(const char *)question;



@end
