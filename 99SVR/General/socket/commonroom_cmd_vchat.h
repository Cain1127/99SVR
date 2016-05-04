#ifndef __CMD_TEXT_ROOM_VCHAT_H__
#define __CMD_TEXT_ROOM_VCHAT_H__

#include "yc_datatypes.h"

#pragma pack(1)

namespace protocol
{
	typedef struct tag_CMDClientPingResp
	{
		uint32 userid;        //用户id
		uint32 roomid;        //房间id
	}CMDClientPingResp_t;

	//加入房间预处理请求
	typedef struct tag_CMDPreJoinRoomReq
	{
		uint32 userid;              //用户id,可能是靓号id,可能是游客号码
		uint32 vcbid;               //房间id
	}CMDPreJoinRoomReq_t;

	//加入房间预处理响应
	typedef struct tag_CMDPreJoinRoomResp
	{
		uint32 userid;          //用户id,可能是靓号id,可能是游客号码
		uint32 vcbid;           //房间id
		uint8 result;           //右起1位 1房间存在 0房间不存在，2位 1在黑名单 0不在黑名单，3位 1房间人数是否已满 0房间人数未满，4位 1房间有密码 0房间无密码
	}CMDPreJoinRoomResp_t;

	//加入房间请求
	//281 bytes
	typedef struct tag_CMDJoinRoomReq
	{
		uint32 userid;         //用户id,可能是靓号id,可能是游客号码
		uint32 vcbid;          //房间id
		uint32 devtype;      //0:PC端 1:安卓 2:IOS 3:WEB
		uint32 time;
		uint32 crc32;
		uint32 coremessagever;     //客户端内核版本
		char   cuserpwd[PWDLEN];   //用户密码,没有就是游客
		char   croompwd[PWDLEN];   //房间密码,可能有
		char   cSerial[64];    //uuid
		char   cMacAddr[IPADDRLEN];   //客户端mac地址
		char   cIpAddr[IPADDRLEN];	  //客户端ip地址
		byte   bloginSource;         //local 99 login or other platform login:0-local;1-other platform
		byte   reserve1;
		byte   reserve2;
	}CMDJoinRoomReq_t;

	//加入房间响应 332 + 88bytes (420byte)
	typedef struct tag_CMDJoinRoomResp
	{
		uint32 userid;       //用户id
		uint32 vcbid;        //房间id
		byte   roomtype;     //房间类型
		byte   busepwd;      //是否需要房间密码
		byte   bIsCollectRoom;  //是否被该用户收藏
		byte   devtype;    //设备类型 PC端 1:安卓 2:IOS 3:WEB
		uint16 seats;        //总人数
		uint32 groupid;        //组id, 可以用来做区长判断?
		uint32 runstate;       //房间 管理状态
		uint32 creatorid;      //房主
		uint32 op1id;          //副房主
		uint32 op2id;        
		uint32 op3id;
		uint32 op4id;
		uint32 inroomstate;  //加入房间后在房间状态，目前只有使用到隐身状态解析.
		int64 nk;                //用户余额,nk
		int64 nb;                //用户余额,nb
		int64 nlotterypool;      //幸运奖池彩金
		int32 nchestnum;         //用户现有宝箱个数
		char   cname[NAMELEN];         //房间名字
		char   cmediaaddr[MEDIAADDRLEN];   //媒体服务器地址
		char   cpwd[PWDLEN];     
		uint64 naccess_times;		   //房间访问人气(人次)
		uint32 ncollect_times;		   //房间收藏次数(粉丝数)
	}CMDJoinRoomResp_t;


	//加入房间错误
	typedef struct tag_CMDJoinRoomErr
	{
		uint32 userid;
		uint32 vcbid;
		uint32 errid;
		uint32 data1;
		uint32 data2;
	}CMDJoinRoomErr_t;

	//加入房间成功后请求推送信息
	typedef struct tag_CMDAfterJoinRoomReq
	{
		uint32 userid;
		uint32 vcbid;
	}CMDAfterJoinRoomReq_t;

	//用户退出房间请求和通知的数据体
	typedef struct tag_CMDUserExitRoomInfo
	{
		uint32 userid;
		uint32 vcbid;
	}CMDUserExitRoomInfo_t;

	//踢人请求和通知消息的数据体
	typedef struct tag_CMDUserKickoutRoomInfo
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		int32  resonid; 
		byte   mins;         //提出时间id,自输入(0~255分钟)
	}CMDUserKickoutRoomInfo_t;

	//房间人员列表的数据体 148 bytes
	typedef struct tag_CMDRoomUserInfo
	{
		uint32 userid;                //用户id,可能是靓号id
		uint32 vcbid;                 //房间id

		byte   viplevel;              //会员等级(可能是临时等级)
		byte   yiyuanlevel;           //艺员等级,如
		byte   shoufulevel;           //守护者等级
		byte   zhonglevel;            //终生等级,叠加数字(1~150)

		byte   caifulevel;            //财富等级,即nk,nb的缩略图
		byte   lastmonthcostlevel;     //上月消费排行
		byte   thismonthcostlevel;     //本月消费排行
		byte   thismonthcostgrade;    //本月累计消费等级

		//byte   isxiaoshou:1;          //是不是销售
		//byte   gender:1;              //性别,
		//byte   reserve1:6;            //临时作为设备类型（2016-01-22 by shuisheng)
		byte flags;
		char   pubmicindex;           //公麦位置
		byte   roomlevel;             //房间等级
		byte   usertype;              //用户类型: 普通 机器人

		uint32 sealid;                //是否有章(id最大65535, 0-无章)
		uint32 cometime;
		uint32 headicon;              //头像
		uint32 micgiftid;             //礼物麦礼物id,只对礼物麦状态有效
		uint32 micgiftnum;            //礼物麦礼物数量,

		uint32 sealexpiretime;        //章的过期时间
		uint32 userstate;             //用户状态,组合标志
		uint32 starflag;              //周星标志
		uint32 activityflag;          //活动星标志(可以多个)
		uint32 flowernum;             //自己的彩条总数(本月), 特别礼物数量
		uint32 ticket1num;            //歌星月票本月数目, 特别礼物数量
		uint32 ticket2num;            //舞星月票本月数目, 特别礼物数量
		uint32 ticket3num;            //最佳主持月票本月数目, 特别礼物数量
		int32  bforbidinviteupmic;
		int32  bforbidchat;
		int32  ncarid;               //座驾id.0-没有
		char   useralias[NAMELEN];   //呢称
		char   carname[NAMELEN];     //座驾名称,如果有座驾的话

	}CMDRoomUserInfo_t;

	// 关键字操作请求
	typedef struct tag_CMDAdKeywordsReq{
		int num;
		int		naction;				//0-刷新 1-增加 2-删除
		int		ntype;					//广告类型
		int		nrunerid;				//操作人Id
		char	createtime[32];			//创建时间
		char	keyword[64];			//关键词
	}CMDAdKeywordsReq_t;

	//关键字操作广播(也作为用户加入房间后，客户端第一次获取关键字列表的请求）
	typedef struct tag_CMDAdKeywordsNotify{	
		int num;
		char keywod[0];
	}CMDAdKeywordsNotify_t;

	//关键字操作回应
	typedef struct tag_CMDAdKeywordsResp{
		int errid;				// 0 代表成功，否则失败
		uint32 userid;	
	}CMDAdKeywordsResp_t;

	typedef struct tag_CMDSetRoomInfoReq_v2
	{
		uint32 vcbid;             //只读
		uint32 runnerid;
		//进入房间设置
		int8 nallowjoinmode;
		//房间聊天设置
		int8 ncloseroom;
		int8 nclosepubchat;
		int8 nclosecolorbar;
		int8 nclosefreemic;
		int8 ncloseinoutmsg;
		int8 ncloseprvchat;
		char   cname[NAMELEN];  //房间名
		char   cpwd[PWDLEN];    //密码(可能有)
	}CMDSetRoomInfoReq_v2_t;

	//设置房间信息的应答消息
	typedef struct tag_CMDSetRoomInfoResp
	{
		uint32 vcbid;
		int32  errorid;    //错误代码
	}CMDSetRoomInfoResp_t;

	// 房间信息消息,下发时使用
	typedef struct tag_CMDRoomBaseInfo
	{
		uint32 vcbid;     //只读
		uint32 groupid;   //房间组ID,只读
		byte   level;     //只读
		byte   busepwd;   //
		uint16 seats;     
		uint32 creatorid;
		uint32 op1id;
		uint32 op2id;
		uint32 op3id;
		uint32 op4id;
		uint32 opstate;   //使用bit,一共可以放置32个,第1位:是否允许悄悄话?
		//                         第2位:是否允许仍塞子，上传和广播时均是混合结果数据.
		char   cname[NAMELEN]; //房间名
		char   cpwd[PWDLEN];  //密码(可能有)
	}CMDRoomBaseInfo_t;

	// 单独 修改房间状态消息(notify)
	typedef struct tag_CMDRoomOpState
	{
		uint32 vcbid;
		uint32 opstate;  //使用bit,一共可以放置32个,第1位:是否允许悄悄话?
		//                         第2位:是否允许仍塞子，上传和广播时均是混合结果数据.
	}CMDRoomOpState_t;

	//禁言请求消息和通知/广播的数据体
	typedef struct tag_CMDForbidUserChat
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		uint32 ttime;   //禁言时长
		byte   action;   //动作：1禁言 0解禁
	}CMDForbidUserChat_t;

	typedef struct tag_CMDThrowUserInfoResp
	{
		uint32 vcbid;
		int32 errorid;
	}CMDThrowUserInfoResp_t;

	//封杀用户信息(req, notify)
	typedef struct tag_CMDThrowUserInfo
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 toid;
		byte   viplevel;       //(roomsvr填写)
		byte   nscopeid;       //封杀范围 :1-房间,2-全站
		byte   ntimeid;        //封杀时长
		byte   nreasionid;     //封杀理由
		char   szip[IPADDRLEN];       //(roomsvr填写)
		char   szserial[IPADDRLEN];   //(roomsvr填写)
	}CMDThrowUserInfo_t;

	//用户权限操作 (req, notify)
	//16 Byte
	typedef struct tag_CMDUserPriority
	{
		uint32 vcbid;       //房间id
		uint32 runnerid;    //操作人员id
		uint32 userid;      //被操作人员id
		byte   action;		//动作 （1->加 2->卸）
		byte   priority;	//用户权限（1->管理员，2->临时管理员）
	}CMDUserPriority_t;

	typedef struct tag_CMDSetUserPriorityResp
	{
		uint32 vcbid;
		int32 errorid;
	}CMDSetUserPriorityResp_t;

	//查看用户IP请求
	typedef struct tag_CMDSeeUserIpReq
	{
		uint32 vcbid;
		uint32 runid;
		uint32 toid;
	}CMDSeeUserIpReq_t;

	//查看用户IP应答
	typedef struct tag_CMDSeeUserIpResp
	{
		uint32 vcbid;
		uint32 runid;
		uint32 userid;
		//char  ip[IPADDRLEN];
		uint16 textlen;          //描述信息长度
		uint16 reserve;          //保留
		char  content[0];       //地址内容
	}CMDSeeUserIpResp_t;

	//报告媒体服务器
	typedef struct tag_CMDReportMediaGateReq
	{
		uint32 vcbid;
		uint32 userid;
		uint16 textlen;          //下面内容的长度
		char  content[0];       //ip:port的形式，分号作为分隔符，用“|”竖号分隔网关服务器地址和媒体服务器地址
	}CMDReportMediaGateReq_t;

	//报告媒体服务器回应
	typedef struct tag_CMDReportMediaGateResp
	{
		uint32 vcbid;
		uint32 userid;
		int errid;
	}CMDReportMediaGateResp_t;

	//获取用户（包括讲师和普通用户）个人资料
	typedef struct tag_CMDGetUserInfoReq
	{
		uint32 srcuserid;    //用户ID
		uint32 dstuserid;		 //被查看的用户ID
	}CMDGetUserInfoReq_t;
	
	//讲师个人资料
	typedef struct tag_CMDTeacherInfoResp
	{
		uint32  teacherid;          //讲师ID
		uint32  headid;             //讲师头像ID
		uint32  vcbid;         			//讲师所属文字直播房间ID
		int16   introducelen;       //个人介绍长度
		int16   lablelen;           //个人标签长度
		int16   levellen;						//讲师级别长度（初级分析师...）
		int16   type;								//讲师类别 1-文字直播；2-视频直播；3-文字+视频直播；
		uint64  czans;							//讲师获赞数
		uint64  moods;							//讲师人气数
		uint64  fans;								//讲师粉丝数
		int8  	fansflag;           //是否已经关注讲师（0-未关注；1-已关注）
		int8  	subflag;           //是否已经订阅讲师课程（0-未关注；1-已关注）
		char    content[0];         //消息内容，格式：个人介绍+个人标签+讲师级别
	}CMDTeacherInfoResp_t;

	//普通用户个人资料
	typedef struct tag_CMDRoomUserInfoResp
	{
		uint32  userid;          //用户ID
		uint32  headid;          //用户头像ID
		uint32  birthday;			   //生日
		int16   introducelen;    //个人介绍长度
		int16   provincelen;     //省份长度
		int16   citylen;				 //城市长度
		char    content[0];      //消息内容，格式：个人介绍+省份+城市
	}CMDRoomUserInfoResp_t;

	typedef struct tag_CMDUserInfoErr
	{
		uint32 userid;  //用户ID
		uint32 errid;   //0 成功（成功不发这个包，1.用户不存在 2.DB error 3.teacherflag 错误
	}CMDUserInfoErr_t;

		//把房间加入Favorite
	typedef struct tag_CMDFavoriteRoomReq
	{
		uint32 vcbid;
		uint32 userid;
		int    actionid;  //1:收藏, -1:取消收藏
	}CMDFavoriteRoomReq_t;

	typedef struct tag_CMDFavoriteRoomResp
	{
		int32  errorid;    //错误代码
		uint32 vcbid;
		int  actionid; //动作,同收藏房间
	}CMDFavoriteRoomResp_t;

	//列表消息头(手机版本)，仅限20个
	typedef struct tag_CMDTextRoomList_mobile
	{
		char    uuid[16];               //唯一标识头
	}CMDTextRoomList_mobile_t;

	//赠送礼物请求和通知的数据体
	typedef struct tag_CMDTradeGiftRecord
	{
		uint32 vcbid;     //roomId
		uint32 srcid;
		uint32 toid;
		uint32 tovcbid;    //接受对象所在的房间
		uint32 totype;     //接受对象类型:0-普通用户,1-所有用户,2-所有注册用户,3-所有会员,4-所有管理,5-所有主持
		uint32 giftid;     //礼物id
		uint32 giftnum;    //赠送数目
		byte  action;      //交易动作:action=0-下发跑道礼物列表时使用(null), 2-普通礼物赠送,3-世界道, 5-收费麦礼物, 6-烟花(特别,因为提示格式不一样)
		byte  servertype;  //服务器转发类型。	0-表示普通转发(房间内）。1-表示通过centerSvr转发, 2-表示房间登陆时获取
		byte  banonymous;  //是否匿名。0-表示不匿名，1-表示匿名 10-接受者隐身 11-送受双方都隐身
		byte  casttype;    //是否广播，0-表示不广播，1-表示广播,客户端设是否需要上小喇叭通知 5-所有房间公聊区显示
		uint32 dtime;      //发起时间
		uint32 oldnum;     //下发时填写,上次数目, 下发跑道礼物列表时0(null)
		char   flyid;      //跑道ID,-1没有
		char   srcvcbname[NAMELEN];     //消费者所在的房间名称
		char   tovcbname[NAMELEN];      //接受者所在的房间名称
		char   srcalias[NAMELEN];
		char   toalias[NAMELEN];
		char   sztext[GIFTTEXTLEN];   //定义40,实际使用最多18个汉字或英文（最多占36个长度)
	}CMDTradeGiftRecord_t;

	//赠送礼物的响应
	typedef struct tag_CMDTradeGiftResp
	{
		//TODO:
	}CMDTradeGiftResp_t;

	//赠送礼物的错误响应
	typedef struct tag_CMDTradeGiftErr
	{
		int nerrid;    //错误编号
	}CMDTradeGiftErr_t;

	typedef struct tag_CMDUserKickoutRoomInfo_ext
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		int32  resonid;
		byte   mins;         //提出时间id,自输入(0~255分钟)
		uint16 textlen;     // the length of content
		char   content[0];   //user ip and gate ip
	}CMDUserKickoutRoomInfo_ext_t;

	typedef struct tag_CMDUserExceptExitRoomInfo_ext
	{
		uint32 userid;
		uint32 vcbid;
		uint16 textlen;     // the length of content
		char   content[0];   //user ip and gate ip
	}CMDUserExceptExitRoomInfo_ext_t;

	//订阅
	typedef struct tag_CMDTeacherSubscriptionReq
	{
		uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
		uint32 userid;
		uint32 teacherid;
		uint8  bSub; // 0 :取消订阅  1: 订阅
	}CMDTeacherSubscriptionReq_t;

	typedef struct tag_CMDTeacherSubscriptionResp
	{
		uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
		uint32 userid;
		uint8  errcode;//返回错误码
	}CMDTeacherSubscriptionResp_t;

	//观点赠送礼物请求
	typedef struct tag_CMDViewpointTradeGiftReq
	{
	  uint32 userid;     // 送礼人
	  uint32 roomid;     // 送给哪个roomId
	  uint32 teamid;     // 送给哪个teamid
	  uint32 viewid;     // 观点id
	  uint32 giftid;     // 礼物id
	  uint32 giftnum;    // 赠送数目
	}CMDViewpointTradeGiftReq_t;

	//观点赠送礼物通知
	typedef struct tag_CMDViewpointTradeGiftNoty
	{
	  uint32 userid;     // 送礼人
	  char useralias[NAMELEN];     // 送礼人昵称
	  uint32 roomid;     // 送给哪个roomId
	  uint32 teamid;     // 送给哪个teamid
	  char teamalias[NAMELEN];     // team昵称
	  uint32 viewid;     // 观点id
	  uint32 giftid;     // 礼物id
	  uint32 giftnum;    // 赠送数目
	}CMDViewpointTradeGiftNoty_t;

};

#pragma pack()

#endif
