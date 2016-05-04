// 修改项：
//1. 位域
//2. 城主信息 预编译去掉的字段
//3. typedef struct 空
//4. unsigned char/ long long
//5. 枚举类型
//6. int数组 openresult_1 members

#ifndef __CMD_VEDIO_ROOM_VCHAT_H__
#define __CMD_VEDIO_ROOM_VCHAT_H__

#include "yc_datatypes.h"

#pragma pack(1)

namespace protocol
{
	//加入房间请求
	//248 bytes
	//typedef struct tag_CMDJoinRoomReq1
	//{
	//	uint32 userid;         //用户id,可能是靓号id,可能是游客号码
	//	uint32 vcbid;          //房间id
	//	uint32 devtype;      //0:PC端 1:安卓 2:IOS 3:WEB
	//	uint32 time;
	//	uint32 crc32;
	//	uint32 coremessagever;     //客户端内核版本
	//	char   cuserpwd[PWDLEN];   //用户密码,没有就是游客
	//	char   croompwd[PWDLEN];   //房间密码,可能有
	//	char   cSerial[32];    //
	//	char   cMacAddr[IPADDRLEN];   //客户端mac地址
	//	char   cIpAddr[IPADDRLEN];	  //客户端ip地址

	//}CMDJoinRoomReq1_t;

	//加入房间请求
	//280 bytes
	//typedef struct tag_CMDJoinRoomReq
	//{
	//	uint32 userid;         //用户id,可能是靓号id,可能是游客号码
	//	uint32 vcbid;          //房间id
	//	uint32 devtype;       //0:PC端 1:安卓 2:IOS 3:WEB
	//	uint32 time;
	//	uint32 crc32;
	//	uint32 coremessagever;     //客户端内核版本
	//	char   cuserpwd[PWDLEN];   //用户密码,没有就是游客
	//	char   croompwd[PWDLEN];   //房间密码,可能有
	//	char   cSerial[64];    //uuid
	//	char   cMacAddr[IPADDRLEN];   //客户端mac地址
	//	char   cIpAddr[IPADDRLEN];	  //客户端ip地址
	//}CMDJoinRoomReq_t;

	//gate自动切换到房间请求
	typedef struct tag_CMDGateJoinRoomReq
	{
		uint32 userid;         //用户id
		uint32 vcbid;          //房间id
	}CMDGateJoinRoomReq_t;

	//房间公麦状态
	typedef struct tag_CMDRoomPubMicState
	{
		int16   micid;         //从0开始(0-第一个公麦),和本地公麦用户的micid对应
		int16   mictimetype;   //
		uint32  userid;        //该麦的用户id,可能为0(机器人id)
		int16   userlefttime;  //麦用户剩余时间,
	}CMDRoomPubMicState_t;

	//房间聊天请求和通知的数据体,目前无跨平台的大喇叭(客户大多数只有一个平台)
	typedef struct tag_CMDRoomChatMsg
	{
		uint32 vcbid;      //roomId
		uint32 tocbid;		//new
		uint32 srcid;
		uint32 toid;
		byte srcviplevel;  //用户的viplevel,对广播消息有用(前缀图标)
		//msgtype定义:
		//0-文字聊天消息,1-房间内广播消息,2-欢迎词消息(收到此消息不会再自动回复)，3-小喇叭消息(聊天),4-礼物喇叭消息,5-塞子,
		//8-宝箱获取广播喇叭消息,10-获得幸运奖消息(给小喇叭窗口),11-自动回复消息(收到此消息不会再自动回复)
		//13-彩色文字(提出区别的目的:该数据只在公麦区显示),14－隔房间小纸条消息(给自己私聊窗口),15-房间内私聊消息 16-礼物感谢
		//20-系统广播消息
		byte msgtype;      //私聊类型也在放这里
		uint16 textlen;    //聊天内容长度
		char   srcalias[NAMELEN];
		char   toalias[NAMELEN];
		char   vcbname[NAMELEN];
		char   tocbname[NAMELEN];//new
		char   content[0];  //聊天内容
	}CMDRoomChatMsg_t;

	//房间公告的数据体
	typedef struct tag_CMDRoomNotice
	{
		uint32 vcbid;     //roomId
		byte   index;     //房间公告索引idx:0~2(0,1,2)
		uint16 textlen;   //房间公告长度
		char   content[0];
	}CMDRoomNotice_t;

	//系统公告的数据体
	//系统公告消息,注意单独使用，如中奖的提示小喇叭,赠送一定数额的礼物提示
	typedef struct tag_CMDSysCastNotice
	{
		byte msgtype;   //公告类型
		byte reserve;
		uint16 textlen;  //文字长度
		char content[0];
	}CMDSysCastNotice_t;
	//msgtype:
	//1-幸运礼物中大奖提示,2-玩游戏大赢钱提示, 3-一次送超过金额的送礼提示, 4-准备播放烟花提示
	//5-其他系统公告消息(系统公告)

	//房间管理人员列表的数据体
	typedef struct tag_CMDRoomManagerInfo
	{
		uint32 vcbid;
		uint16 num;        //管理员(正管)数目
		uint32 members[0];
	}CMDRoomManagerInfo_t;

	typedef struct tag_CMDUserExitRoomInfo_ext
	{
		uint32 userid;
		uint32 vcbid;
		uint16 textlen;     // the length of content
		char   content[0];   //user ip and gate ip
	}CMDUserExitRoomInfo_ext_t;

	//用户退出房间请求和通知的数据体
	typedef struct tag_CMDUserExceptExitRoomInfo
	{
		uint32 userid;
		uint32 vcbid;
	}CMDUserExceptExitRoomInfo_t;

	//用户帐户消息请求(查询)
	typedef struct tag_CMDQueryUserAccountReq
	{
		uint32  vcbid;
		uint32  userid;
	}CMDQueryUserAccountReq_t;

	typedef struct tag_CMDQueryUserAccountResp
	{
		uint32 vcbid;   //用户所在的房间
		uint32 userid;
		int64 nk;       //
		int64 nb;
		int64 nkdeposit;
	}CMDQueryUserAccountResp_t;

	//用户帐户消息(应答,通知)
	typedef struct tag_CMDUserAccountInfo
	{
		uint32 vcbid;   //用户所在的房间
		uint32 userid;
		int64 nk;       //
		int64 nb;
		uint32 dtime;   //时间
	}CMDUserAccountInfo_t;

	//麦克状态结构体
	//用户上、下麦时使用,2013.09.10 使用新的方式,可能是直接抱上麦的,可能是从麦时上报上麦的,那么此次抱麦消耗不消耗麦时(删除排麦id)?
	// 或者,流程统一,如果在排麦模式下(房间打开允许排麦),抱用户就是把用户放到排麦列表中的第一个(等待自动转换?)
	// 或者,设置, 排麦模式下就没有抱麦功能?
	typedef struct tag_CMDUserMicState
	{
		uint32 vcbid;
		uint32 runid;
		uint32 toid;      //上麦用户
		int32  giftid;    //使用礼物id
		int32  giftnum;   //礼物num
		char   micstate;  //麦克状态,注意下面的麦状态标志
		char   micindex;  //麦克序号(notify中有数据),新修改,上麦时可以指定麦序(公麦时0~2), -1:不指定
		char   optype;    //操作类型,注意: 加入了该字段后就表示这个信令不是简单的上麦了
		//gcz++ 要新加参数,是不是从排麦中(第几个micid, 0-表示不是, 1..n 就是第几个麦id) 转成公麦的(如果是newmic=公麦)
		char   reserve11; //空白
	}CMDUserMicState_t;

	//设备状态结构体
	//开启、关闭麦克风
	typedef struct tag_CMDUserDevState
	{
		uint32 vcbid;
		uint32 userid;
		byte   audiostate;  //设备状态 0-不处理, 1-声音输入静音 (用户禁止share),2-声音未静音(正常)
		byte   videostate;  //设备状态,0-不处理, 3-无视频设备 ,2-有视频设备(正常)， 1-视频关了(有视频设备,但发送者禁止发送数据)(用户禁止share)
		uint32 userinroomstate;  //最新合集状态(客户端根据需要采用)
	}CMDUserDevState_t;

	// 音视频请求消息
	typedef struct tag_CMDTransMediaInfo
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		byte   action;  //动作：1表示请求打开对方音视频，3表示请求关闭对方音视频。
		byte   vvflag;  //vv标志
	}CMDTransMediaInfo_t;

	//修改房间媒体URL请求消息
	typedef struct tag_CMDRoomMediaInfo
	{
		uint32 vcbid;
		uint32 userid;
		char caddr[MEDIAADDRLEN];  //媒体服务器URL
	}CMDRoomMediaInfo_t;

	//设置公麦状态的通知消息
	typedef struct tag_CMDChangePubMicStateNoty
	{
		uint32  vcbid;
		uint32  runnerid;      //操作人员id
		byte    micid;
		byte    optype;        //同请求的操作类型
		int16   param1;        //麦时类型 或延迟时间(分)
		uint32  userid;        //该麦的用户id,可能为0
		int16   userlefttime;  //麦用户剩余时间,
	}CMDChangePubMicStateNoty_t;

	//gch++
	typedef struct tag_CMDUpWaitMic
	{
		uint32  vcbid;
		uint32  ruunerid;
		uint32  touser;
		int32   nmicindex;   //-1,默认(插麦到最后一个);1-同时插入到第一个
	}CMDUpWaitMic_t;

	//设置排序用户index的请求
	typedef struct tag_CMDOperateWaitMic
	{
		uint32  vcbid;
		uint32  ruunerid;
		uint32  userid;
		int16   micid;      //该用户的第几个麦序
		int     optype;     //操作类型: -3,清除所有麦序?,-2 删除该用户的所有麦序,-1,删除该麦序,1-up,2-down,3-top,4-button
	}CMDOperateWaitMic_t;

	//设置排序用户index的通知消息
	typedef struct tag_CMDChangeWaitMicIndexNoty
	{
		uint32 vcbid;
		uint32 ruunerid;
		uint32 userid;
		int16  micid;      //该用户的第几个麦序
		int    optype;     //操作类型: -3,清除所有人所有麦序?,-2 删除该用户的所有麦序,-1,删除该麦序,1-up,2-down,3-top,4-button
	}CMDChangeWaitMicIndexNoty_t;

	//夺用户公麦的请求消息
	typedef struct tag_CMDLootUserMicReq
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 userid;
		int16  micid;     //该用户所在的公麦id
	}CMDLootUserMicReq_t;

	//夺用户公麦的响应/错误消息
	typedef struct tag_CMDLootUserMicResp
	{
		uint32 vcbid;
		int32  errorid;    //错误代码
	}CMDLootUserMicResp_t;

	//夺用户公麦的通知消息
	typedef struct tag_CMDLootUserMicNoty
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 userid;
		int16  micid;   
	}CMDLootUserMicNoty_t;

		//设置房间信息的请求消息
	typedef struct tag_CMDSetRoomInfoReq
	{
		uint32 vcbid;   //只读
		uint32 runnerid;
		uint32 creatorid;
		uint32 op1id;
		uint32 op2id;
		uint32 op3id;
		uint32 op4id;
		int    busepwd; //是否启用密码
		char   cname[NAMELEN]; //房间名
		char   cpwd[PWDLEN];  //密码(可能有)
	}CMDSetRoomInfoReq_t;

	//设置房间运行状态/属性的请求消息
	typedef struct tag_CMDSetRoomOPStatusReq
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 opstatus;
	}CMDSetRoomOPStatusReq_t;

	//设置房间运行状态/属性的应答消息
	typedef struct tag_CMDSetRoomOPStatusResp
	{
		uint32 vcbid;
		int32  errorid;    //错误代码
	}CMDSetRoomOPStatusResp_t;

	//设置房间公告的请求消息
	typedef struct tag_CMDSetRoomNoticeReq
	{
		uint32 vcbid;
		uint32 ruunerid;
		byte   index;       //房间公告索引idx:0~2(0,1,2)
		uint16 textlen;     //房间公告长度
		char   content[0];   //文字内容
	}CMDSetRoomNoticeReq_t;

	//设置房间公告的应答消息
	typedef struct tag_CMDSetRoomNoticeResp
	{
		uint32 vcbid;
		int32  errorid;    //错误代码
	}CMDSetRoomNoticeResp_t;

	typedef struct tag_CMDPropsFlashPlayTaskItem
	{
		short nTaskType;
		short nArg;
	}CMDPropsFlashPlayTaskItem_t;//, *PPropsFlashPlayTaskItem_t;

	//查询房间存在消息
	typedef struct tag_CMDQueryVcbExistReq
	{
		uint32 vcbid;
		uint32 userid;
		uint32 queryvcbid;   //要查询的vcbid
	}CMDQueryVcbExistReq_t;

	typedef struct tag_CMDQueryVcbExistResp
	{
		int32 errorid;  //0-没有错误
		uint32 vcbid;
		uint32 userid;
		uint32 queryvcbid;
		char   cqueryvcbname[NAMELEN];
	}CMDQueryVcbExistResp_t;

	//查看用户是否存在消息
	typedef struct tag_CMDQueryUserExistReq
	{
		uint32 vcbid;   
		uint32 userid; 
		uint32 queryuserid;  //要查询的userid
		uint32 specvcbid;   //要在指定的房间查询
	}CMDQueryUserExistReq_t;

	typedef struct tag_CMDQueryUserExistResp
	{
		int32 errorid;  //0-没有错误
		uint32 vcbid;   
		uint32 userid;
		uint32 queryuserid;
		uint32 specvcbid; 
		byte   queryuserviplevel;
		char   cspecvcbname[NAMELEN];  //如果指定房间
		char   cqueryuseralias[NAMELEN];
	}CMDQueryUserExistResp_t;

	typedef struct tag_CMDOpenChestReq
	{
		uint32 vcbid;
		uint32 userid;
		int32  openresult_type;   //开奖类型, 0-单开, 1-全开
	}CMDOpenChestReq_t;

	typedef struct tag_CMDMobZhuboInfo
	{
		uint32 vcbid;
		uint32 userid;
		char   alias[NAMELEN];
		char   headurl[URLLEN];
	}CMDMobZhuboInfo_t;

	//3.3 gch++ 用户财富消费排行等级实时更新
	typedef struct tag_CMDUserCaifuCostLevelInfo
	{
		uint32 userid;
		uint32 vcbid;
		int32  ncaifulevel;
		int32  nlastmonthcostlevel;    //上月消费排行
		int32  nthismonthcostlevel;    //本月消费排行
		int32  nthismonthcostgrade;    //本月累计消费等级
	}CMDUserCaifuCostLevelInfo_t;

	typedef struct tag_CMDCloseGateObjectReq
	{
		uint64 object;
		uint64 objectid;
	}CMDCloseGateObjectReq_t;

	typedef struct tag_CMDCloseRoomNoty
	{
		uint32 vcbid;
		char closereason[URLLEN];
	}CMDCloseRoomNoty_t;

	typedef struct tag_CMDSetUserHideStateReq
	{
		uint32 userid;
		uint32 vcbid;
		int32  hidestate;    //1-toHide, 2-tounHide 
	}CMDSetUserHideStateReq_t;

	// 关键字屏蔽
	typedef struct tag_CMDAdKeywordInfo
	{
		int		naction;				//0-刷新 1-增加 2-删除
		int		ntype;					//广告类型
		int		nrunerid;				//操作人Id
		char	createtime[32];			//创建时间
		char	keyword[64];			//关键词
	}CMDAdKeywordInfo_t;

	//讲师请求打分
	typedef struct tag_CMDTeacherScoreReq
	{
		uint32 teacher_userid;             //讲师ID
		char  teacheralias[NAMELEN]; //讲师呢称
		uint32  vcbid;                //所在房间id
		int64 data1;                  //备用字段1
		char   data2[NAMELEN];        //备用字段2
	}CMDTeacherScoreReq_t;

	//讲师请求打分结果
	typedef struct tag_CMDTeacherScoreResp
	{
		int    type;                  //操作是否成功
		uint32 teacher_userid;             //讲师ID
		char   teacheralias[NAMELEN]; //讲师呢称
		int    vcbid;                 //房间id，主房间或子房间
	}CMDTeacherScoreResp_t;

	//讲师打分记录
	typedef struct tag_CMDTeacherScoreRecordReq
	{
		uint32 teacher_userid;             //讲师ID
		char   teacheralias[NAMELEN]; //讲师呢称
		uint32 userid;                //打分人ID
		char   alias[NAMELEN];        //打分人呢称
		byte   usertype;              //讲师类型: 0-普通 1-机器人
		uint32 score;                 //分数
		char   logtime[NAMELEN];      //打分时间
		uint32  vcbid;                //所在房间id
		int64 data1;                  //备用字段1
		int64 data2;                  //备用字段2
		int64 data3;                  //备用字段3
		char   data4[NAMELEN];        //备用字段4
		char   data5[NAMELEN];        //备用字段5
	}CMDTeacherScoreRecordReq_t;

	//讲师打分结果
	typedef struct tag_CMDTeacherScoreRecordResp
	{
		uint32 teacher_userid;             //讲师ID
		char   teacheralias[NAMELEN]; //讲师呢称
		int    type;                  //操作是否成功
	}CMDTeacherScoreRecordResp_t;

	//机器人对应讲师ID通知
	typedef struct tag_CMDRobotTeacherIdNoty
	{
		uint32 vcbid;	//房间id
		uint32 roborid;//机器人id
		uint32 teacherid;             //讲师ID
		char   teacheralias[NAMELEN];
	}CMDRobotTeacherIdNoty_t;

	//讲师忠实度周版请求
	typedef struct tag_CMDTeacherGiftListReq
	{
		uint32 vcbid;					//房间id
		uint32 teacherid;				//讲师ID
	}CMDTeacherGiftListReq_t;

	//讲师忠实度周版响应
	typedef struct tag_CMDTeacherGiftListResp
	{
		uint32 seqid;                   //把排名也发过去
		uint32 vcbid;					//房间id
		uint32 teacherid;				//讲师ID
		char useralias[NAMELEN];	    //用户昵称
		uint64 t_num;					//忠实度值
	}CMDTeacherGiftListResp_t;

	//用户进入房间或者讲师上麦，传送一个房间和子房间ID
	typedef struct tag_CMDRoomAndSubRoomIdNoty
	{
		uint32 roomid;                 //主房间ID
		uint32 subroomid;              //子房间ID
	}CMDRoomAndSubRoomIdNoty_t;

	typedef struct tag_CMDTeacherAvarageScoreNoty
	{
		uint32 teacherid;
		uint32 roomid;
		float avarage_score;
		char data1[NAMELEN]; //备用字段1
		uint32 data2; //备用字段2
	}CMDTeacherAvarageScoreNoty_t;

	// for roomsvr notification
	typedef enum
	{
		USER_JOIN = 0,
		USER_LEFT,
		USER_UPDATE,
		USER_UPMIC,
		USER_DOWNMIC,
		GATE_DISCONN,
		CODIS_ADDR
	}E_ROOM_ACTION_NOTIFY;

	typedef struct tag_CMDRoomsvrNotify
	{
		uint16 svrid;
		uint16 gateid;
		uint32 vcbid;
		uint32 userid;
		char   codis_ip[32];
		uint16 codis_port;
		byte   action; //the value from ACTION_NOTIFY type
	}CMDRoomsvrNotify_t;

	//web端砸完金蛋的通知消息
	typedef struct tag_CMDHitGoldEggWebNoty
	{
		uint32 vcbid;
		uint32 userid;
	}CMDHitGoldEggWebNoty_t;

	//用户对讲师的评分响应
	typedef struct tag_CMDUserScoreNoty
	{
		uint32 vcbid;					//房间号
		uint32 teacherid;				//讲师ID
		int32 score;					//用户对讲师的评分
		int32 userid;					//用户ID
	}CMDUserScoreNoty_t;

	//重设客户端的连接信息（用于gate与roomsvr断开时）
	typedef struct tag_CMDResetConnInfo
	{
		uint32 vcbid;					//房间号
		int32 userid;					//用户ID
	}CMDResetConnInfo_t;

	typedef struct tag_CMDUserOnlineBaseInfoNoty
	{
		uint32 userid;
		uint32 sessionid;
		uint32 devicetype;
	}CMDUserOnlineBaseInfoNoty_t;

	typedef struct tag_CMDLogonStasticsReq
	{
		uint32 userid;
		uint32 device_type;
		char   cIpAddr[IPADDRLEN];  //ip地址
	}CMDLogonStasticsReq_t;

	//终端登录信息
	typedef struct tag_CMDLogonClientInf
	{
		uint32 m_userid;
		byte   m_bmobile;
		uint32 m_logontime;
	}CMDLogonClientInf_t;

	typedef struct tag_CMDClientExistNoty
	{
		uint32 userid;             //用户ID
		byte m_ntype;                //退出类型0 重复登录
	}CMDClientExistNoty_t;

	//房间推送系统公告
	typedef struct tag_CMDSyscast
	{
		uint8 newType;  //0 一次性新闻 1
		uint64   nid;        //记录ID
		char   title[32];    
		char   content[512]; 
	}CMDSyscast_t;

	//解除封杀
	typedef struct tag_CMDRelieveUserInfo
	{
		uint8   nscopeid;       //封杀范围 :1-房间,2-全站
		uint32 vcbid;			//操作所在的房间
		uint32 runnerid;		//操作人
		uint32 toid;			//解封ID
		uint8	isRelieve;		//true:解封成功	false:未解封
	}CMDRelieveUserInfo_t;

	typedef struct tag_CMDMgrRefreshList
	{
		uint32 vcbid;		//房间ID
		uint32 userid;		//用户ID
		char	name[20];	//用户名字
		uint32 srcid;		//操作人
		int    actionid;  //1:禁言 2:黑名单 3:其他
	}CMDMgrRefreshList_t;

	//查询订阅状态
	typedef struct tag_CMDTeacherSubscriptionStateQueryReq
	{
		uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
		uint32 userid;
		uint32 teacherid;
	}CMDTeacherSubscriptionStateQueryReq_t;

	typedef struct tag_CMDTeacherSubscriptionStateQueryResp
	{
		uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
		uint32 userid;
		uint8  state;//订阅状态 0:未订阅 1:已订阅
	}CMDTeacherSubscriptionStateQueryResp_t;

	//专家观点消息推送（房间内部广播）
	typedef struct tag_CMDExpertNewViewNoty
	{
		uint32 nmessageid;      //观点ID
		uint32 nvcbid;          //房间ID
		uint32 teamid;          //战队ID
		char  sName[48];        //专家名称
		char  sIcon[256];       //头像信息
		char  sPublicTime[32];  //发表时间
		uint32 nCommentCnt;     //评论次数
		uint32 nLikeCnt;        //点赞次数
		uint32 nFlowerCnt;      //鲜花数量
		uint16 contlen;         //内容长度
		char   content[0];      //内容
	}CMDExpertNewViewNoty_t;

	typedef struct tag_CMDTeamTopNReq
	{
	  uint32 userid;         //用户id,
	  uint32 vcbid;          //房间id
	}CMDTeamTopNReq_t;

	typedef struct tag_CMDTeamTopNResp
	{
	  uint32 vcbid;          //房间id
	  char teamname[32];     //战队名称
	  uint64 giftmoney;      //礼物金币
	}CMDTeamTopNResp_t;

	//0:Both,1:Email,2:SMS
	typedef enum
	{
		e_all_notitype   = 0,
		e_email_notitype = 1,  
		e_sms_notity     = 2
	}E_NOTICE_TYPE;

	typedef enum
	{
		e_db_connect      = 0,
		e_configfile      = 1,
		e_msgqueue        = 2,
		e_network_conn    = 3
	}E_ALARM_TYPE;

	typedef enum
	{
		//mask:0xFF(mic state)
		FT_ROOMUSER_STATUS_PUBLIC_MIC     = 0x00000001,   //公麦状态(任何人可以连接)
		FT_ROOMUSER_STATUS_PRIVE_MIC      = 0x00000002,   //私麦状态(任何人可以连接)
		FT_ROOMUSER_STATUS_SECRET_MIC     = 0x00000004,   //密麦状态(连接时只有好友自动通过连接,其他拒绝,这里现在都要要求验证同意)
		FT_ROOMUSER_STATUS_CHARGE_MIC     = 0x00000010,    //收费状态 (上了收费麦)


		//mask:0xF0
		FT_ROOMUSER_STATUS_IS_TEMPOP      = 0x00000020,    //临时管理 标识
		FT_ROOMUSER_STATUS_IS_PIG         = 0x00000040,    //是否是猪头? 标识
		FT_ROOMUSER_STATUS_IS_FORBID      = 0x00000080,    //被禁言(用户被禁言,假死,不能说话,不能发送小喇叭) 标识,可以被解禁

		//mask:0x0F00(device), 增加新的mic状态:收费密麦 (2012.04.05 by guchengzhi)
		FT_ROOMUSER_STATUS_VIDEOON        = 0x00000100,    //视频打开 (有视频设备,可以发出数据)
		FT_ROOMUSER_STATUS_MICOFF         = 0x00000200,    //麦克关闭 (在麦，但不出声音)
		FT_ROOMUSER_STATUS_VIDEOOFF       = 0x00000400,    //视频关闭 (有视频设备，不允许连接)
		FT_ROOMUSER_STATUS_IS_HIDE        = 0x00000800,    //隐身(在登录时使用名字冗余字段进行初次隐身进入房间操作或默认隐身进场)


		//mask: 盟主(0xF000)
		FT_ROOMUSER_STATUS_IS_SIEGE1      = 0x00002000,    //标识
		FT_ROOMUSER_STATUS_IS_SIEGE2      = 0x00004000,

		//mask: 区长(0xF0000)
		FT_ROOMUSER_STATUS_IS_QUZHUANG    = 0x00010000,    //区长

	}E_USER_INROOM_STATE;

	typedef enum
	{
		FT_ROOMOPSTATUS_CLOSE_PUBCHAT     = 0x00000001,   //关闭公聊/禁止聊天回复
		FT_ROOMOPSTATUS_CLOSE_PRIVATECHAT = 0x00000002,   //关闭私聊/禁止问股
		FT_ROOMOPSTATUS_CLOSE_SAIZI       = 0x00000004,   //关闭塞子
		FT_ROOMOPSTATUS_CLOSE_PUBMIC      = 0x00000010,   //关闭公麦 (不允许上)
		FT_ROOMOPSTATUS_CLOSE_PRIVATEMIC  = 0x00000020,   //关闭私麦 (不允许上)
		FT_ROOMOPSTATUS_OPEN_AUTOPUBMIC   = 0x00000040,   //打开排麦自动上公麦
		FT_ROOMOPSTATUS_OPEN_WAITMIC      = 0x00000080,   //打开排麦功能
		FT_ROOMOPSTATUS_CLOSE_COLORBAR    = 0x00000100,   //屏蔽彩条
		FT_ROOMOPSTATUS_CLOSE_FREEMIC     = 0x00000200,   //自由排麦/禁止点赞
		FT_ROOMOPSTATUS_CLOSE_INOUTMSG    = 0x00000400,   //屏蔽用户进出信息
		FT_ROOMOPSTATUS_CLOSE_ROOM        = 0x00000800,   //关闭聊天室/屏蔽互动聊天

	}E_ROOM_OP_STATE;


	typedef enum
	{
		FT_SCOPE_ALL           = 0,     //gcz++ 不限
		FT_SCOPE_ROOM          = 1,     //房间
		FT_SCOPE_GLOBAL        = 2,     //gcz++ 全局
	}E_VIOLATIO_SCOPE;


}
#pragma pack()

#endif
