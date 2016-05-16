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
- (void)PostReply:(int)viewpointId replyId:(int)parentReplyId author:(int)authorId content:(char*)content fromId:(int)fromAuthorId;

/**
 * 请求操盘列表
 */
- (void)RequestOperateStockProfitByDay:(int)teamId start:(int)startId count:(int)count;
- (void)RequestOperateStockProfitByMonth:(int)teamId start:(int)startId count:(int)count;
- (void)RequestOperateStockProfitByAll:(int)teamId start:(int)startId count:(int)count;

/**
 *  请求操盘详情
 */
- (void)RequestOperateStockAllDetail:(int)operateId;

/**
 * 请求操盘详情--交易记录
 */
- (void)RequestOperateStockTransaction:(int)operateId start:(int)startId cout:(int)count;

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
- (void) RequestTeamPrivateServiceSummaryPack:(int)teamId;// TeamPriviteServiceSummaryPackListener* listener);

// 请求私人定制详情
- (void) RequestPrivateServiceDetail:(int)nId;// PrivateServiceDetailListener* listener);

// 请求充值规则列表
- (void) RequestChargeRuleList;//(ChargeRuleListener* listener);

// 请求战队（财经直播）列表
- (void) RequestTeamList;

// 请求战队简介
- (void) RequestTeamIntroduce:(int)teamId;

// 请求贡献榜
- (void)RequestConsumeRank:(int)teamId;

// 提问
- (void) PostAskQuestion:(int)teamId stock:(const char*)stock question:(const char *)question;

//请求系统消息
- (void)RequestSystemMessage:(int)startId count:(int)count;

// 请求问题回复--已回答的
- (void)RequestQuestionAnswer:(int)startId count:(int)count teamer:(BOOL)isTeamer;

// 请求评论回复--收到的评论
- (void)RequestMailReply:(int)startId count:(int)count;

// 请求私人定制
- (void)RequestPrivateServiceSummary:(int)startId count:(int)count;

// 请求未读数
- (void)RequestUnreadCount;

// 请求问题回复--未回回答的（PC端接口）
- (void)RequestQuestionUnAnswer:(int)startId count:(int)count;

// 请求评论回复--发出的评论（PC端接口）
- (void)RequestMailSendReply:(int)startId count:(int)count;

// 讲师团队回答提问（PC端接口）
- (void)PostAnswer:(int)questionId content:(const char *) content;

- (void)RequestHomePage;//首页列表数据

- (void)RequestFollowTeacher;//关注的讲师

- (void)RequestFootPrint;//足迹url

- (void)RequestCollection;////收藏url

- (void)RequestBanner;////获取Banner

- (NSString *)requestGoid;

- (void)RequestUserTeamRelatedInfo:(int)teamId;

- (NSString *)GetPrivateServiceDetailUrl:(int)psid;

- (NSString *)getHttpApi;

@end
