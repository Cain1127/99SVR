#ifndef __CMD_VCHAT_HH_20160401_
#define __CMD_VCHAT_HH_20160401_

#include "yc_datatypes.h"

#pragma pack(1)

namespace protocol
{
//加入房间成功后推送讲师信息请求
typedef struct tag_CMDTextRoomTeacherReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
}CMDTextRoomTeacherReq_t;

//加入房间成功后推送讲师信息响应
typedef struct tag_CMDTextRoomTeacherNoty
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	char   teacheralias[NAMELEN];  //讲师昵称
	uint32 headid;                 //讲师头像ID
	int16  levellen;               //讲师等级长度
	int16  labellen;               //讲师标签长度
	int16  goodatlen;              //讲师擅长领域长度
	int16  introducelen;           //讲师简介长度
	int64  historymoods;           //直播人气数
	int64  fans;                   //粉丝数
    int64  zans;                   //点赞数
	int64  todaymoods;             //今日人气数
	int64  historyLives;           //直播历史数
	int16  liveflag;               //是否直播中（0-不在线；1-在线）
	int16  fansflag;               //是否已经关注讲师（0-未关注；1-已关注）
	int16  bstudent;               //是否已经拜师（0-未拜师；1-已拜师）
	int32   rTeacherLiveRoom;			//是否视频直播中 等于0代表没有在直播中
	char   content[0];             //消息内容，格式：讲师等级+讲师标签+讲师擅长领域（多个以分号分隔）+讲师简介
}CMDTextRoomTeacherNoty_t;

//加载直播记录请求
typedef struct tag_CMDTextRoomLiveListReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	int16  type;                   //类型：1-文字直播；2-直播重点；3-明日预测（已关注的用户可查看）；4-观点；5-所有秘籍；6-已购买秘籍；
	int64  messageid;              //上一次请求得到的最小消息ID，第一次为0
    int32  count;                  //获取多少条记录
}CMDTextRoomLiveListReq_t;

//加载直播记录响应
typedef struct tag_CMDTextRoomLiveListNoty
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	uint32 srcuserid;              //互动用户ID
	char   srcuseralias[NAMELEN];  //互动用户昵称
	int64  messageid;              //消息ID
	int16  pointflag;              //是否直播重点:0-否；1-是；
	int16  forecastflag;           //是否明日预测:0-否；1-是；
	int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片；4-互动回复；5-观点动态；6-个人秘籍动态；
	int64  viewid;     			   //观点ID(5-观点动态用)/秘籍ID(6-个人秘籍动态用)
	int16  textlen;                //消息长度
	int16  destextlen;             //互动回复长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int64  zans;                   //点赞数
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //消息内容，格式：消息内容（发送的直播是内容，发送的观点是标题，互动的是源内容）+互动回复内容
}CMDTextRoomLiveListNoty_t;

//加入房间成功后推送直播重点和明日预测记录
typedef struct tag_CMDTextRoomLivePointNoty
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	int64  messageid;              //消息ID
	int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片;
	int16  textlen;                //消息长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int64  zans;                   //点赞数
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //消息内容
}CMDTextRoomLivePointNoty_t;

//讲师发送文字直播请求
typedef struct tag_CMDTextRoomLiveMessageReq
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //讲师ID
	int16  pointflag;              //是否直播重点:0-否；1-是；
	int16  forecastflag;           //是否明日预测:0-否；1-是；
	int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片；
	int16  textlen;                //直播消息长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //直播消息内容
}CMDTextRoomLiveMessageReq_t;

//讲师发送文字直播响应
typedef struct tag_CMDTextRoomLiveMessageResp
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //讲师ID
	int64  messageid;              //消息ID
	int16  pointflag;              //是否直播重点:0-否；1-是；
	int16  forecastflag;           //是否明日预测:0-否；1-是；
	int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片；
	int16  textlen;                //直播消息长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //直播消息内容
}CMDTextRoomLiveMessageResp_t;

//用户点击关注请求
typedef struct tag_CMDTextRoomInterestForReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
    int16  optype;                 //操作类型：1-关注  2-取消关注
}CMDTextRoomInterestForReq_t;

//用户点击关注响应
typedef struct tag_CMDTextRoomInterestForResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int16  result;                 //回复是否成功：0失败；1成功；2已关注；
    uint32 teacherid;              //讲师ID
    int16  optype;                 //操作类型：1是关注，2是取消关注
}CMDTextRoomInterestForResp_t;

//查询用户商品请求
typedef struct tag_CMDTextRoomGetUserGoodStatusReq
{
	uint32 userid;               //用户ID
	uint32 salerid;              //老师ID
	uint32 type;                 //类型
	uint32 goodclassid;          //商品类型ID
}CMDTextRoomGetUserGoodStatusReq_t;

typedef struct tag_CMDTextRoomGetUserGoodStatusResp
{
	uint32 userid;              //用户ID
	uint32 salerid;             //老师ID
	uint32 num;                 //数量
	int16  result;							//0 成功 1 error
}CMDTextRoomGetUserGoodStatusResp_t;

//用户点击提问请求
typedef struct tag_CMDTextRoomQuestionReq
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //老师ID
	uint32 userid;                 //用户ID
	int16  stocklen;               //个股名称长度
	int16  textlen;                //问题描述长度
	int8   commentstype;		   		 //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
	int8	 isfree;								 //免费提问还是付费提问
	char   content[0];             //消息内容，格式：个股名称+问题描述
}CMDTextRoomQuestionReq_t;

//用户提问响应
typedef struct tag_CMDTextRoomQuestionResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //请求用户ID
	int16  result;                 //操作是否成功：0失败，1成功；
	int64  messageid;              //消息ID（通用接口，失败时为0）
	uint64 nk;										 //用户余额/或剩余免费提问次数
}CMDTextRoomQuestionResp_t;

//用户操作响应
typedef struct tag_CMDTextRoomLiveActionResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //请求用户ID
	int16  result;                 //操作是否成功：0失败，1成功；
	int64  messageid;              //消息ID（通用接口，失败时为0）
}CMDTextRoomLiveActionResp_t;

//用户点赞请求
typedef struct tag_CMDTextRoomZanForReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int64  messageid;              //消息ID
}CMDTextRoomZanForReq_t;

//用户点赞响应
typedef struct tag_CMDTextRoomZanForResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int16  result;                 //回复是否成功：0失败，1成功；
	int64  messageid;              //消息ID
	int64  recordzans;             //消息点赞数
	int64  totalzans;              //总点赞数
}CMDTextRoomZanForResp_t;

//聊天请求
typedef struct tag_CMDRoomLiveChatReq
{
	uint32 vcbid;                  //房间ID
	uint32 srcid;                  //讲话人ID
	uint32 toid;                   //用户ID
	byte   msgtype;                //私聊类型也在放这里
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    uint16 textlen;                //聊天内容长度
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //聊天内容
}CMDRoomLiveChatReq_t;

//聊天响应
typedef struct tag_CMDTextRoomLiveChatResp
{
	uint32 vcbid;                  //房间ID
	uint32 srcid;                  //讲话人ID
	char   srcalias[NAMELEN];      //讲话人昵称
	uint32 srcheadid;              //讲话人头像
	uint32 toid;                   //用户ID
	char   toalias[NAMELEN];       //用户昵称
	uint32 toheadid;               //用户头像
	byte   msgtype;                //私聊类型也在放这里
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
	uint16 textlen;                //聊天内容长度
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //聊天内容
}CMDTextRoomLiveChatResp_t;

//聊天回复(互动)请求
typedef struct tag_CMDTextLiveChatReplyReq
{
	uint32 vcbid;                  //房间ID
	uint32 fromid;                 //回复人ID
	uint32 toid;                   //被回复人ID
	uint64 messagetime;            //互动时间(yyyymmddhhmmss)
	uint16 reqtextlen;             //源消息内容长度
	uint16 restextlen;             //回复内容长度
	int8  liveflag;                //是否发布到直播：0-否；1-是；
    	int8   commentstype;	       //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //消息内容，格式：源消息内容 + 回复内容
}CMDTextLiveChatReplyReq_t;

//聊天回复(互动)响应
typedef struct tag_CMDTextLiveChatReplyResp
{
	uint32 vcbid;                  //房间ID
	uint32 fromid;                 //回复人ID
	char   fromalias[NAMELEN];     //回复人昵称
	uint32 fromheadid;             //回复人头像
	uint32 toid;                   //被回复人ID
	char   toalias[NAMELEN];       //被回复人昵称
	uint32 toheadid;               //被回复人头像
	uint64 messagetime;            //互动时间(yyyymmddhhmmss)
	uint16 reqtextlen;             //源消息内容长度
	uint16 restextlen;             //回复内容长度
	int8   liveflag;               //是否发布到直播：0-否；1-是；
        int8   commentstype;	       //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	int64  messageid;              //消息ID
	char   content[0];             //消息内容，格式：源消息内容 + 回复内容
}CMDTextLiveChatReplyResp_t;

//点击查看观点类型请求
typedef struct tag_CMDTextRoomLiveViewGroupReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
}CMDTextRoomLiveViewGroupReq_t;

//观点分类响应
typedef struct tag_CMDTextRoomViewGroupResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
	int32  viewtypeid;             //观点类型ID
	int32  totalcount;             //总观点数
	int16  viewtypelen;            //观点类型名称长度
	char   viewtypename[0];        //观点类型名称
}CMDTextRoomViewGroupResp_t;

//点击观点类型分类请求
typedef struct tag_CMDTextRoomLiveViewListReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	int32  viewtypeid;             //观点类型ID，如果为0，则不分类返回
	int64  messageid;              //消息ID，为请求的观点概述列表的起点
	int32  startIndex;             //起始索引
	uint32 count;                  //观点概述的条数
}CMDTextRoomLiveViewListReq_t;

//点击观点类型分类请求(手机版本)，仅限20个
typedef struct tag_CMDTextRoomViewListReq_mobile
{
    char    uuid[16];               //唯一标识头
    uint32  vcbid;                  //房间ID
    uint32  userid;                 //用户ID
    uint32  teacherid;              //讲师ID
    int32   viewtypeid;             //观点类型ID，如果为0，则不分类返回
    int64   messageid;              //消息ID，为请求的观点概述列表的起点
    int32   startIndex;             //起始索引
    uint32  count;                  //观点概述的条数
}CMDTextRoomViewListReq_mobile_t;

//观点列表响应
typedef struct tag_CMDTextRoomLiveViewResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int32  viewtypeid;             //观点类型ID
	int64  viewid;                 //消息ID
	int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片；
	int16  viewTitlelen;           //观点标题长度
	int16  viewtextlen;            //观点内容长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
	int64  looks;                  //浏览次数
    int64  zans;                   //点赞数
	int64  comments;               //评论数
	int64  flowers;                //送花数
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];             //消息内容，格式：观点标题+观点内容
}CMDTextRoomLiveViewResp_t;

//查看观点详情请求
typedef struct tag_CMDTextRoomLiveViewDetailReq{

	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int64  viewid;                 //观点ID
	int64  messageid;              //评论ID，为请求的观点概述列表的起点,从0起始计数 为零会同时发送观点详情包和评论列表，不为零则只发送评论列表
	int64  startcommentpos;        //起始索引
	uint32 count;                  //加载的评论条数
	int8   type;                   //请求类型，1观点详情，2观点评论，3观点详情+评论
}CMDTextRoomLiveViewDetailReq_t;

//查看评论详细信息
typedef struct tag_CMDTextRoomViewInfoResp
{
	uint32 vcbid;                  	//房间ID
	uint32 userid;                 	//请求用户ID
	int64  viewid;			        //观点ID
	int64  commentid;				//评论ID
	uint32 viewuserid;              //评论用户ID
	char   useralias[NAMELEN];		//评论的用户昵称，不对应上面的用户ID
	int16  textlen;                	//评论长度
	uint64 messagetime;            	//发送时间(yyyymmddhhmmss)
	int64  srcinteractid;			//源评论ID（回复评论内容时需要填写），0则代表没有
	char   srcuseralias[NAMELEN];  	//源评论的用户昵称，没有则为空
    int8   commentstype;			//客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	char   content[0];            	//评论内容
}CMDTextRoomViewInfoResp_t;


//讲师修改观点类型分类请求
typedef struct tag_CMDTextRoomViewTypeReq
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //请求用户ID
	int16  actiontypeid;           //操作类型ID：1-新增；2-修改；3-删除（需要删除分类下所有观点后才可操作）；
	int32  viewtypeid;             //观点类型ID（新增时为0）
	char   viewtypename[NAMELEN];  //观点类型名称
}CMDTextRoomViewTypeReq_t;

//讲师修改和新增观点类型分类响应
typedef struct tag_CMDTextRoomViewTypeResp
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //请求用户ID
	int16  result;                 //操作是否成功：0失败，1成功；
	int32  viewtypeid;             //观点类型ID（通用接口，失败时为0）
}CMDTextRoomViewTypeResp_t;

//讲师发布观点或修改观点请求
typedef struct tag_CMDTextRoomViewMessageReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int64  messageid;              //消息ID（修改时填入，新增时为0）
	int16  viewtype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片；
	int16  titlelen;               //观点标题长度
	int16  textlen;                //观点内容长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
    char   content[0];             //观点格式：观点标题+观点内容
}CMDTextRoomViewMessageReq_t;

//讲师发布观点或修改观点响应
typedef struct tag_CMDTextRoomViewMessageReqResp
{
	uint32 userid;                 //用户ID
	int64  messageid;              //消息ID（修改时填入，新增时为0）
	int16  titlelen;               //观点标题长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
	char   content[0];             //观点格式：观点标题
}CMDTextRoomViewMessageReqResp_t;

//讲师删除观点请求
typedef struct tag_CMDTextRoomViewDeleteReq
{
	uint32 vcbid;                  	//房间ID
	uint32 userid;                 	//用户ID
	int64  viewid;              		//观点类型ID
}CMDTextRoomViewDeleteReq_t;

//讲师删除观点响应
typedef struct tag_CMDTextRoomViewDeleteResp
{
	uint32 vcbid;                  	//房间ID
	uint32 userid;                 	//用户ID
	int64  viewid;              	//消息ID
	int16  result;                  //操作是否成功：0失败，1成功；
}CMDTextRoomViewDeleteResp_t;

//观点评论详细页送花请求
typedef struct tag_CMDTextLiveViewFlowerReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int64  messageid;              //消息ID
	int32  count;                  //送多少朵
}CMDTextLiveViewFlowerReq_t;

//观点评论详细页送花响应
typedef struct tag_CMDTextLiveViewFlowerResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int16  result;                 //回复是否成功：0失败，1成功；
	int64  messageid;              //消息ID
	int64  recordflowers;          //总送花数
}CMDTextLiveViewFlowerResp_t;

//对观点进行评论
typedef struct tag_CMDTextRoomViewCommentReq
{
	uint32 vcbid;                  //房间ID
	uint32 fromid;                 //评论人ID
	uint32 toid;                   //被评论人ID
	int64  messageid;              //消息ID
	int16  textlen;                //评论长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
	int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	int64  srcinteractid;          //如果是对评论产生评论，需要填写这字段
	char   content[0];             //评论内容
}CMDTextRoomViewCommentReq_t;

//点击直播历史（可分页请求展示）请求
typedef struct tag_CMDTextLiveHistoryListReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
    int32  count;                  //获取多少条记录
	int16  fromIndex;              //从第几条开始取
	int16  toIndex;                //到第几条结束
	int32  fromdate;               //从哪一天(年月日)开始
	uint8  bInc;                   //是否升序（0降序,1升序）
}CMDTextLiveHistoryListReq_t;

//点击直播历史（可分页请求展示）响应
typedef struct tag_CMDTextLiveHistoryListResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	uint32 datetime;               //日期(yyyymmdd)
	uint64 beginTime;              //一天内直播第一条记录的时间(yyyymmddhhmmss)
	uint64 endTime;                //一天内最后一条记录的时间(yyyymmddhhmmss)
	uint32 renQi;                  //当天人气
	uint32 cAnswer;                //回答问题的条数
	uint32 totalCount;             //当天直播记录总数
}CMDTextLiveHistoryListResp_t;

//请求某一天的直播记录列表（可分页请求展示）请求
typedef struct tag_CMDTextLiveHistoryDaylyReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	int16  type;                   //类型：1-文字直播；2-直播重点；3-明日预测（已关注的用户可查看）；4-观点；
	int64  messageid;              //请求得到的最大消息ID，第一次为0
    int32  count;                  //获取多少条记录
    int32  startindex;             //起始索引
    uint32 datetime;               //哪一天的记录(yyyymmdd)
}CMDTextLiveHistoryDaylyReq_t;

//讲师进入房间广播消息
typedef struct tag_CMDTeacherComeNotify
{
	int64  recordzans;             //房间总点赞数
}CMDTeacherComeNotify_t;

//列表消息头(手机版本)，仅限20个
typedef struct tag_CMDTextRoomLists_mobile
{
    char    uuid[16];               //唯一标识头
}CMDTextRoomLists_mobile_t;

//讲师通过PHP页面发布观点或修改观点或删除观点请求
typedef struct tag_CMDTextRoomViewPHPReq
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //请求用户ID
	int64  messageid;              //消息ID
    int64  businessid;             //观点ID
	int8   viewtype;               //操作类型：1-新增；2-修改；3-删除；
	int16  titlelen;               //观点标题长度
	int16  textlen;                //观点简介长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
    char   content[0];             //格式：观点标题+观点简介
}CMDTextRoomViewPHPReq_t;

//讲师通过PHP页面发布观点或修改观点或删除观点响应
typedef struct tag_CMDTextRoomViewPHPResp
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //请求用户ID
	int64  messageid;              //消息ID
    int64  businessid;             //观点ID
	int8   viewtype;               //操作类型：1-新增；2-修改；3-删除；
	int16  titlelen;               //观点标题长度
	int16  textlen;                //观点简介长度
	uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
    char   content[0];             //格式：观点标题+观点简介
}CMDTextRoomViewPHPResp_t;

///拜师请求&&返回
typedef struct tag_CMDBeTeacherReq
{
	uint32  userid; //请求该信息的用户ID
	uint32  teacherid; //所拜的讲师
	uint32  vcbid; //房间ID
	uint8   opMode; //0:30天 1:90天
}CMDBeTeacherReq_t;

typedef struct tag_CMDBeTeacherResp
{
	uint32  userid; //请求该信息的用户ID
	uint8   result; //结果
	uint64  nk;
}CMDBeTeacherResp_t;

typedef struct tag_CMDUserPayReq
{
	uint32	srcid;				//消费者ID，一般是用户ID
	uint32	dstid;				//获得收益的ID，一般是讲师 ID
	uint32	vcbid;  			//房间ID
	uint8   isPackage;		//是否是礼包类型（商品组合销售）
	uint32  goodclassid;	//商品类型ID
	uint32  type;					//类型
	uint32	num;					//消费数量（主要针对观点鲜花，礼物设计。其他一律设1）
}CMDUserPayReq_t;


typedef struct tag_CMDUserPayResp
{
	uint32 userid; //用户ID
	uint64 nk;   	 //用户余额
	uint32 errid;	 //错误原因：0. 操作成功 1.商品不存在 2.余额不足 3.DB error
}CMDUserPayResp_t;

typedef struct tag_CMDGetUserAccountBalanceReq
{
	uint32 userid;         //用户ID
}CMDGetUserAccountBalanceReq_t;

typedef struct tag_CMDGetUserAccountBalanceResp
{
	uint32 userid;  //用户ID
	uint64 nk;   //用户余额
	uint32 errid;	//错误原因：0. 操作成功 1.用户不存在 2.DB error
}CMDGetUserAccountBalanceResp_t;

//付费表情列表
typedef struct tag_CMDTextRoomEmoticonListResp
{
	uint32 emoticonID;             //表情ID
	char	 emoticonName[NAMELEN];  //表情名称
	int32  prices;                 //价格
	int8   buyflag;                //是否购买：1-已购买；0-未购买；
}CMDTextRoomEmoticonListResp_t;

//个人秘籍总体信息请求
typedef struct tag_CMDTextRoomSecretsTotalReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
}CMDTextRoomSecretsTotalReq_t;

//个人秘籍总体信息响应
typedef struct tag_CMDTextRoomSecretsTotalResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	int32  secretsnum;             //秘籍总数
	int32  ownsnum;                //已购买秘籍总数
	int8   bStudent;               //是否徒弟（0-否；1-是）
}CMDTextRoomSecretsTotalResp_t;

//个人秘籍列表消息头
typedef struct tag_CMDTextRoomListHead
{
    char    uuid[16];              //唯一标识头
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
}CMDTextRoomListHead_t;

//个人秘籍列表
typedef struct tag_CMDTextRoomSecretsListResp
{
	int32  secretsid;              //秘籍ID
	int16  coverlittlelen;         //封面小图名称长度
	int16  titlelen;               //秘籍标题长度
	int16  textlen;                //秘籍简介长度
	uint64 messagetime;            //时间(yyyymmddhhmmss)
	int32  buynums;                //订阅人数
	int32  prices;                 //单次订阅所需玖玖币
	int8   buyflag;                //是否购买：1-已购买；0-未购买；
	int32  goodsid;                //商品ID
	char  content[0];              //消息内容，格式：封面小图名称+秘籍标题+秘籍简介
}CMDTextRoomSecretsListResp_t;

//个人秘籍购买请求
typedef struct tag_CMDTextRoomBuySecretsReq
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	uint32 teacherid;              //讲师ID
	int32  secretsid;              //秘籍ID
	int32  goodsid;                //商品ID
}CMDTextRoomBuySecretsReq_t;

//个人秘籍购买响应
typedef struct tag_CMDTextRoomBuySecretsResp
{
	uint32 vcbid;                  //房间ID
	uint32 userid;                 //用户ID
	int32  secretsid;              //秘籍ID
	int16 result;                  //回复是否成功：0. 操作成功 1.商品不存在 2.余额不足 3.DB error 4.已购买
	uint64  nk99;                  //用户账户玖玖币余额（成功时需要刷新客户端余额）
}CMDTextRoomBuySecretsResp_t;

//PHP后台录入个人秘籍后主动通知服务端
typedef struct tag_CMDTextRoomSecretsPHPReq
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //请求用户ID
	int64  messageid;              //消息ID
	int32  businessid;             //秘籍ID
	int8   viewtype;               //操作类型：1-新增；2-修改；3-删除；
	int16  coverlittlelen;         //封面小图名称长度
	int16  titlelen;               //秘籍标题长度
	int16  textlen;                //秘籍简介长度
	uint64 messagetime;            //时间(yyyymmddhhmmss)
	int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	int32  prices;                 //单次订阅所需玖玖币
	int32  goodsid;                //商品ID
	char  content[0];              //消息内容，格式：封面小图名称+秘籍标题+秘籍简介
}CMDTextRoomSecretsPHPReq_t;

//PHP后台录入个人秘籍后主动通知服务端广播给客户端
typedef struct tag_CMDTextRoomSecretsPHPResp
{
	uint32 vcbid;                  //房间ID
	uint32 teacherid;              //请求用户ID
	int64  messageid;              //消息ID
	int32  businessid;             //秘籍ID
	int8   viewtype;               //操作类型：1-新增；2-修改；3-删除；
	int16  coverlittlelen;         //封面小图名称长度
	int16  titlelen;               //秘籍标题长度
	int16  textlen;                //秘籍简介长度
	uint64 messagetime;            //时间(yyyymmddhhmmss)
	int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
	int32  prices;                 //单次订阅所需玖玖币
	int32  goodsid;                //商品ID
	char  content[0];              //消息内容，格式：封面小图名称+秘籍标题+秘籍简介
}CMDTextRoomSecretsPHPResp_t;

typedef struct tag_CMDGetPackagePrivilegeReq
{
	uint32 userid;         //用户ID
	uint32 packageNum;          //
}CMDGetPackagePrivilegeReq_t;

typedef struct tag_CMDGetPackagePrivilegeResp
{
	uint32 userid;         //用户ID
	uint32 index;          //下标
	char   privilege[256];       //特权描述
}CMDGetPackagePrivilegeResp_t;

//通知客户端麦状态改变
typedef struct tag_CMDVideoRoomOnMicClientResp
{

	uint32 userid;
	char   useralias[NAMELEN];
	uint32 roomid;	
	char   roomName[NAMELEN];
	uint8  state;
}CMDVideoRoomOnMicClientResp_t;

//拜师信息请求版本二
typedef struct tag_CMDGetBeTeacherInfoReq
{
	uint32  userid; //请求该信息的用户ID
	uint32  vcbid; //房间ID
	uint32  teacherid; //讲师ID
}CMDGetBeTeacherInfoReq_t;

//普通用户拜师信息请求resp版本二
//head
typedef struct tag_CMDNormalUserGetBeTeacherInfoRespHead
{
	int32 userid;   //请求者ID
    int32 price_30;
	int32 price_90;
    uint32  teacherid; //当前想拜讲师ID
	uint32  cStudent; //当前讲师徒弟总数
	uint8   bStudent; //您是否他的徒弟
}CMDNormalUserGetBeTeacherInfoRespHead_t;
//Body
typedef struct tag_CMDNormalUserGetBeTeacherInfoRespItem
{
    int32   nuserid; 
	uint64  starttime; //
	uint64  effecttime; //持续时间
	int32 teacherid;
	char  teacherAlias[NAMELEN];
	int32 cQuery;//剩余免费问股次数
	int32 cViewFlowers;//剩余免费观点献花次数
}CMDNormalUserGetBeTeacherInfoRespItem_t;

//讲师用户拜师信息请求resp版本二
//Head
typedef struct tag_CMDTeacherGetBeTeacherInfoRespHead
{
	int32 userid;   //请求者ID
    int32 price_30;
	int32 price_90;
}CMDTeacherTeacherGetBeTeacherInfoRespHead_t;
//Body
typedef struct tag_CMDTeacherGetBeTeacherInfoRespItem
{
    int32   nuserid; 
	uint64  starttime; //
	uint64  effecttime; //持续时间
	int32 studentid;
	char  studentAlias[NAMELEN];
}CMDTeacherGetBeTeacherInfoRespItem_t;

};

#pragma pack()

#endif //__CMD_VCHAT_HH_20160401_

