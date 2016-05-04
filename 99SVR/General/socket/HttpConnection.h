#ifndef __HTTP_CONNECTION_H__
#define __HTTP_CONNECTION_H__

#include "platform.h"
#include "Connection.h"
#include "HttpListener.h"
#include "Json.h"
#include "Http.h"
#include "http_common.h"

#include <exception>
#include <string>
#include <cstring>



struct HttpThreadParam
{
	char url[512];
	HttpListener* http_listener;
	ParseJson parser;
	RequestParamter* request;
	int request_method;
};

class HttpConnection
{

private:
	bool needHomePageCache;
	bool needViewPointCache;
	bool needOperateStocksCache[3];
	bool needRoomListCache;

	string GBKToUTF8(const std::string& strGBK);

public:

	HttpConnection()
	{
		needHomePageCache = true;
		needViewPointCache = true;
		needOperateStocksCache[0] = true;
		needOperateStocksCache[1] = true;
		needOperateStocksCache[2] = true;
		needRoomListCache = true;
	}

	~HttpConnection()
	{
	}

	//��������ͼƬ��X���ṩ��
	void RequestSplashImage(SplashImageListener* listener);


	// ��������б�(����������/����������/���������� type:0-ȫ������;1-������;2-������;Ĭ��Ϊ0 )�����ṩ��
	void RequestOperateStockProfit(int type ,int team_id, int page, int size, OperateStockProfitListener* listener);
	
	// ����������飨���ṩ��
	void RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener);

	// �����������--���׼�¼��X���ṩ��
	void RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener);

	// �����������--�ֲ������X���ṩ��
	void RequestOperateStocks(int operateId, OperateStocksListener* listener);


	// ʲô���ҵ�˽�˶��ƣ����ṩ��
	void RequestWhatIsPrivateService(WhatIsPrivateServiceListener* listener);

	// �������Ѿ������˽�˶��ƣ����ṩ��
	void RequestMyPrivateService(MyPrivateServiceListener* listener);

	// ��ʾ����˽�˶���ҳ�����ṩ��
	void RequestBuyPrivateServicePage(int teacher_id, BuyPrivateServiceListener* listener);

	// ����ս�ӵ�˽�˶���������Ϣ�����ṩ��
	void RequestTeamPrivateServiceSummaryPack(int teamId, TeamPrivateServiceSummaryPackListener* listener);

	// ����˽�˶������飨���ṩ��
	void RequestPrivateServiceDetail(int privateServerceId, PrivateServiceDetailListener* listener);


	// ����ս�ӣ��ƾ�ֱ�����б����ṩ��
	void RequestTeamList(TeamListListener* listener);

	// ����ս�Ӽ�飨���ṩ��
	void RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener);

	// ����ս����Ƶ�б����ṩ��
	void RequestTeamVideo(int teamId, TeamVideoListener* listener);

	// �����װ����ṩ��
	void RequestConsumeRankList(int teamId, ConsumeRankListener* listener);

	//��ҳ�б����ݣ����ṩ��
	void RequestHomePage(HomePageListener* listener);

	// �ҵĹ�ע�����ṩ��
	void RequestCollection(CollectionListener* listener);////�ղ�url


	// ����۵��б����ṩ��
	void RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener);

	// ����۵����飨���ṩ��
	void RequestViewpointDetail(int viewpointId, ViewpointDetailListener* listener);

	// ����۵�ظ������ṩ��
	void RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener);

	// �ظ��۵㣨���ṩ��
	void PostReply(int viewpointId, int parentReplyId, int authorId, int fromAuthorId, const char* content, PostReplyListener* listener);

	// ����ÿ�������δ���������ṩ��
	void RequestUnreadCount(UnreadListener* listener);

	// �����ܵ�δ��������δ�ṩ��
	void RequestTotalUnreadCount(TotalUnreadListener* listener);

	// ����ϵͳ��Ϣ�����ṩ��
	void RequestSystemMessage(int startId, int count, SystemMessageListener* listener);

	// ��������ظ�--�ѻش�ģ����ṩ��
	void RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener);

	// �������ۻظ�--�յ������ۣ����ṩ��
	void RequestMailReply(int startId, int count, MailReplyListener* listener);

	// ����˽�˶��ƣ����ṩ��
	void RequestPrivateServiceSummary(int startId, int count, PrivateServiceSummaryListener* listener);

	// ���ֲ��̽��׼�¼PC
	void RequestPrivateTradeRecord(int startId, int count,OperateStockTradeRecordListener* listener);

	// ���ʣ����ṩ��
	void PostAskQuestion(int teamId, const char* stock, const char* question, AskQuestionListener* listener);

	// ��ȡʣ�����ʴ�������Ϣ��δ�ṩ��
	void RequestUserTeamRelatedInfo(int teamId, UserTeamRelatedInfoListener* listener);

	// ��������ظ�--δ�ػش�ģ�PC�˽ӿڣ�
	void RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener);

	// �������ۻظ�--���������ۣ�PC�˽ӿڣ�
	void RequestMailSendReply(int startId, int count, MailReplyListener* listener);

	// ��ʦ�Ŷӻش����ʣ�PC�˽ӿڣ���Xδ�ṩ��
	void PostAnswer(int questionId, int teamId, char* answer, AnswerQuestionListener* listener);

	// PC���˵�
	void RequestPcGroupsPage(GroupsPageListener* listener);

};

#endif
