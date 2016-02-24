#ifndef __CMD_VCHAT_HH_20110409__
#define __CMD_VCHAT_HH_20110409__

#include "yc_datatypes.h"

#define MAXSTARSIZE		  16  //周星等最大数目限制

//-----------------------------------------------------------

//#define __SWITCH_SERVER2__
#pragma pack(1)
//登录请求消息
//bytes
#if 0 //不再在客户端使用
typedef struct tag_CMDUserLogonReq
{
    uint32 userid;          //0-游客登陆,可能是靓号ID
    uint32 nversion;        //本地版本号?
    uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
    char   cuserpwd[PWDLEN];    //登录密码,游客登录不需要密码,长度与将来的md5兼容
    char   cSerial[64];  //uuid
    char   cMacAddr[IPADDRLEN]; //mac地址
    byte   nimstate;        //IM状态:如隐身登录
    byte   nmobile;         //1-手机登录?
}CMDUserLogonReq_t;
#endif

typedef struct tag_CWavHeader
{
    int rId  ;
    int rLen ;
    int wId  ;
    int fId  ;
    int fLen;
    WORD	wFormatTag ;
    WORD nChannels ;
    int nSamplesPerSec  ;
    int nAvgBytesPerSec ;
    WORD nBlockAlign ;
    WORD wBitsPerSample;
    int dId  ;
    int wSampleLength  ;
}CWavHeader_t ;
typedef struct tag_CMDUserLogonReq2
{
    uint32 userid;          //0-游客登陆,可能是靓号ID
    uint32 nversion;        //本地版本号?
    uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
    char   cuserpwd[PWDLEN];    //登录密码,游客登录不需要密码,长度与将来的md5兼容
    char   cSerial[IPADDRLEN];  //uuid
    char   cMacAddr[IPADDRLEN]; //mac地址
    char   cIpAddr[IPADDRLEN];  //ip地址
    byte   nimstate;        //IM状态:如隐身登录
    byte   nmobile;         //1-手机登录?
}CMDUserLogonReq2_t;
typedef struct tag_CMDUserLogonReq3
{
    uint32 userid;          //0-游客登陆,可能是靓号ID
    uint32 nversion;        //本地版本号?
    uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
    char   cuserpwd[PWDLEN];    //登录密码,游客登录不需要密码,长度与将来的md5兼容
    char   cSerial[64];  //uuid
    char   cMacAddr[IPADDRLEN]; //mac地址
    char   cIpAddr[IPADDRLEN];  //ip地址
    byte   nimstate;        //IM状态:如隐身登录
    byte   nmobile;         //1-手机登录?
}CMDUserLogonReq3_t;

//登录错误消息
//4 bytes
typedef struct tag_CMDUserLogonErr
{
    uint32 errid;       //根据id,客户端本地判断错误,包括版本错误(需要升级),封杀
    uint32 data1;       //参数1
    uint32 data2;       //参数2
}CMDUserLogonErr_t;

//用户权限响应消息(10 bytes)
typedef struct tag_CMDUserQuanxianInfo
{
    uint8 qxid;
    uint8 qxtype;
    uint32 srclevel;
    uint32 tolevel;
}CMDUserQuanxianInfo_t;

//登录成功响应消息
//71 bytess
typedef struct tag_CMDUserLogonSuccess
{
    int64 nk;                    //金币
    int64 nb;                    //礼物积分,可以换金币或兑换RMB
    int64 nd;                    //游戏豆
    uint32 nmask;                 //标志位, 用于客户端验证是不是自己发出的resp,
    uint32 userid;                //本号
    uint32 langid;                //靓号id
    uint32 langidexptime;         //靓号id到期时间
    uint32 servertime;            //服务器时间,显示客户端,用于抢星之类的时间查看
    uint32 version;               //服务器版本号,用在在信令相同的情况下登陆成功发回服务器DB中的版本号
    uint32 headid;                //用户头像id
    byte   viplevel;              //会员等级(可能是临时等级)
    byte   yiyuanlevel;           //艺员等级,如
    byte   shoufulevel;           //守护者等级
    byte   zhonglevel;            //终生等级,叠加数字(1~150)
    byte   caifulevel;            //财富等级
    byte   lastmonthcostlevel;     //上月消费排行
    byte   thismonthcostlevel;     //本月消费排行
    byte   thismonthcostgrade;    //本月累计消费等级
    byte   ngender;               //性别
    byte   blangidexp;            //靓号是否过期
    byte   bxiaoshou;             //是不是销售标志
    char   cuseralias[NAMELEN];   //呢称
}CMDUserLogonSuccess_t;

//设置用户资料
typedef struct tag_CMDSetUserProfileReq
{
    uint32 userid;                 //id
    uint32 headid;
    byte   ngender;                //性别
    char   cbirthday[BIRTHLEN];          //生日
    char   cuseralias[NAMELEN];         //用户昵称
}CMDSetUserProfileReq_t;

typedef struct tag_CMDSetUserProfileResp
{
    uint32 userid;
    int32  errorid;    //错误代码
}CMDSetUserProfileResp_t;

//设置用户密码
typedef struct tag_CMDSetUserPwdReq
{
    uint32 userid;         //用户id
    uint32 vcbid;          //0房间外操作
    char   pwdtype;        //密码类型，1-用户登录密码,2-用户银行密码
    char   oldpwd[PWDLEN];     //旧密码
    char   newpwd[PWDLEN];     //新密码
}CMDSetUserPwdReq_t;

typedef struct tag_CMDSetUserPwdResp
{
    uint32 userid;
    uint32 vcbid;
    int    errorid;        //错误代码, 0-无错误
    char   pwdtype;        //同上
    char   cnewpwd[PWDLEN];     //设置成功的新密码
}CMDSetUserPwdResp_t;

//请求房间组列表消息
//12...-bytes
typedef struct tag_CMDRoomGroupListReq
{
    uint32 userid;               //请求者的id
}CMDRoomGroupListReq_t;

//房间组列表的数据体 (已经排序好的,即parent排序[+子排序] 一共二级排序,见高校导航树php说明)
//29 + n bytes
typedef struct tag_CMDRoomGroupItem
{
    uint32 grouid;                //组id
    uint32 parentid;              //父id,0-没有
    int32  usernum;               //用户数目
    uint32 textcolor;             //文字颜色
    byte   reserve_1;
    byte   showusernum;           //是否显示人数
    byte   urllength;             //内容长度
    byte   bfontbold;             //文字是否是粗体
    char   cgroupname[NAMELEN];   //组名字
    char   clienticonname[NAMELEN];  //图标名称
    char   content[0];            //URL内容
}CMDRoomGroupItem_t;

//房间组状态消息
typedef struct tag_CMDRoomGroupStatus
{
    uint32 grouid;                //组id
    uint32 usernum;               //组人数
}CMDRoomGroupStatus_t;

//请求房间列表消息
//4 bytes
typedef struct tag_CMDRoomListReq
{
    uint32 userid;               //请求者的id
    uint32 ntype;                //-1,指定vcb_id列表,>0,就是房间组id
    uint32 nvcbcount;
    char   content[0];           //vcb_id列表
}CMDRoomListReq_t;

//房间列表的数据体
//112 byte -- 不再使用,依然使用web的方式代替
typedef struct tag_CMDRoomItem
{
    uint32 roomid;            //房间id
    uint32 creatorid;         //房间创建者id
    uint32 groupid;           //房间组id, 这里不适合使用多组有同一个房间的方式,如果是多组有同一个房间,应该单独有个组/房间对应表
    uint32 flag;              //
    char   cname[NAMELEN];         //房间名称
    char   croompic[NAMELEN];      //房间图片
    char   croomaddr[GATEADDRLEN];       //只有一个roomaddr,房间网关地址
}CMDRoomItem_t;

//加入房间请求
//248 bytes
typedef struct tag_CMDJoinRoomReq
{
    uint32 userid;         //用户id,可能是靓号id,可能是游客号码
    uint32 vcbid;          //房间id
    uint32 userstate;      //请求时的状态(如-在线,离线,隐身)
    uint32 time;
    uint32 crc32;
    uint32 coremessagever;     //客户端内核版本
    char   cuserpwd[PWDLEN];   //用户密码,没有就是游客
    char   croompwd[PWDLEN];   //房间密码,可能有
    char   cSerial[64];    //uuid
    char   cMacAddr[IPADDRLEN];   //
    char   cIpAddr[IPADDRLEN];
}CMDJoinRoomReq_t;

//攻城消息内容(88byte)
typedef struct tag_SiegeInfo
{
    uint32	vcbid;
    uint32	srcid;				//发送者id
    uint32	toid;				//接收者id
    uint32	giftid;				//礼物id
    uint32	count;				//礼物数目
    uint32	time;				//发起时间
    char	srcalias[NAMELEN];	    //发送者昵称
    char	toalias[NAMELEN];	    //接收者昵称
}SiegeInfo_t;


//加入房间响应 332 + 88bytes (420byte)
typedef struct tag_CMDJoinRoomResp
{
    uint32 userid;       //用户id
    uint32 vcbid;        //房间id
    byte   roomtype;     //房间类型
    byte   busepwd:1;      //
    byte   bIsCollectRoom:1;  //
    byte   reserve1:6;    //
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
    int32  ncarid;            //座驾id.0-没有
    char   carname[NAMELEN];  //座驾名称,如果有座驾的话
    char   cname[NAMELEN];         //房间名字
    char   cmediaaddr[MEDIAADDRLEN];   //媒体服务器地址
    char   cpwd[PWDLEN];
    SiegeInfo_t	siege_info;	       //城主信息
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

//加入房间的通知(通知其他房间服务器)
typedef struct tag_CMDJoinOtherRoomNoty
{
    uint32 userid;
    uint32 vcbid;
    uint32 curip;     //当前ip,用来判断防止异地,供roomsvr逻辑使用
}CMDJoinOtherRoomNoty_t;

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
    
    byte   isxiaoshou:1;          //是不是销售
    byte   gender:1;              //性别,
    byte   reserve1:6;
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
    
#ifdef __SWITCH_SERVER2__
    int64   nb;                  //积分
    char   cemail[NAMELEN];      //邮箱
    char   cqq[NAMELEN];         //QQ
    char   ctel[NAMELEN];        //手机
#endif
    
}CMDRoomUserInfo_t;

//房间公麦状态
typedef struct tag_CMDRoomPubMicState
{
    int16   micid;         //从0开始(0-第一个公麦),和本地公麦用户的micid对应
    int16   mictimetype;   //
    uint32  userid;        //该麦的用户id,可能为0
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
    byte msgtype;      //私聊类型也在放这里
    uint16 textlen;    //聊天内容长度
    char   srcalias[NAMELEN];
    char   toalias[NAMELEN];
    char   vcbname[NAMELEN];
    char   tocbname[NAMELEN]; //new
    char   content[0];  //聊天内容
}CMDRoomChatMsg_t;
//msgtype定义:
//0-文字聊天消息,1-房间内广播消息,2-欢迎词消息(收到此消息不会再自动回复)，3-小喇叭消息(聊天),4-礼物喇叭消息,5-塞子,
//8-宝箱获取广播喇叭消息,10-获得幸运奖消息(给小喇叭窗口),11-自动回复消息(收到此消息不会再自动回复)
//13-彩色文字(提出区别的目的:该数据只在公麦区显示),14－隔房间小纸条消息(给自己私聊窗口),15-房间内私聊消息 16-礼物感谢,
//20-系统广播消息

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
    byte  casttype;    //是否广播，0-表示不广播，1-表示广播,客户端设是否需要上小喇叭通知 5-单价大于１０万的所有房间广播
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

//鲜花赠送消息
//见消息定义说明,一种特殊的应用 (同平台,同房间内应用),不可用在月票上
typedef struct tag_CMDTradeFlowerRecord
{
    uint32 vcbid;
    uint32 srcid;
    uint32 toid;
    uint32 giftid;    //鲜花礼物id
    uint32 sendnum;   //数目,默认为1
    uint32 allnum;    //总数,收到后更新客户端
    char   srcalias[NAMELEN];
    char   toalias[NAMELEN];
} CMDTradeFlowerRecord_t;

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

//封杀用户信息(req, notify)
typedef struct tag_CMDThrowUserInfo
{
    uint32 vcbid;          //操作所在的房间
    uint32 runnerid;
    uint32 toid;
    byte   viplevel;       //(roomsvr填写)
    byte   nscopeid;       //封杀范围 :1-房间,2-全站
    byte   ntimeid;        //封杀时长
    byte   nreasionid;     //封杀理由
    
    char   szip[IPADDRLEN];       //(roomsvr填写，如果不在房间则是centersvr处理)
    char   szserial[IPADDRLEN];   //(roomsvr填写)
}CMDThrowUserInfo_t;

//解除封杀
typedef struct tag_CMDRelieveUserInfo
{
    byte   nscopeid;       //封杀范围 :1-房间,2-全站
    uint32 vcbid;			//操作所在的房间
    uint32 runnerid;		//操作人
    uint32 toid;			//解封ID
    bool	isRelieve;		//true:解封成功	false:未解封
}CMDRelieveUserInfo_t;

typedef struct tag_CMDThrowUserInfoResp
{
    uint32 vcbid;
    int32 errorid;
}CMDThrowUserInfoResp_t;

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


//用户昵称更新 (req,resp,noty都使用该结构)
typedef struct tag_CMDUserAliasState
{
    uint32 vcbid;
    uint32 userid;
    uint32 headid;
    char   alias[NAMELEN];
}CMDUserAliasState_t;

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

// 音视频请求消息
typedef struct tag_CMDTransMediaInfo
{
    uint32 vcbid;
    uint32 srcid;
    uint32 toid;
    byte   action;  //动作：1表示请求打开对方音视频，3表示请求关闭对方音视频。
    byte   vvflag;  //vv标志
}CMDTransMediaInfo_t;

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

//修改房间媒体URL请求消息
typedef struct tag_CMDRoomMediaInfo
{
    uint32 vcbid;
    uint32 userid;
    char caddr[MEDIAADDRLEN];  //媒体服务器URL
}CMDRoomMediaInfo_t;


//设置公麦状态的请求消息
typedef struct tag_CMDChangePubMicStateReq
{
    uint32 vcbid;
    uint32 runnerid;   //操作人员id
    byte   micid;      //公麦id
    byte   optype;     //操作类型:1-延迟当前用户麦时间,2-设置麦属性
    int16  param1;     //麦时类型 或延迟时间(分)
}CMDChangePubMicStateReq_t;

//设置公麦状态的响应/错误消息
typedef struct tag_CMDChangePubMicStateResp
{
    uint32  vcbid;
    int32   errorid;    //错误代码
}CMDChangePubMicStateResp_t;

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

//把别人抱上了排麦(麦序)(req,resp,err 消息共用数据结构？)
typedef struct tag_CMDUpWaitMic
{
    uint32  vcbid;
    uint32  ruunerid;
    uint32  touser;
    int32   nmicindex;   //-1,默认(插麦到最后一个);1-同时插入到第一个
}CMDUpWaitMic_t;

//设置排序用户index的请求 (含 CMDChangeWaitMicIndexReq 功能)
typedef struct tag_CMDOperateWaitMic
{
    uint32  vcbid;
    uint32  ruunerid;
    uint32  userid;
    int16   micid;      //该用户的第几个麦序
    int     optype;     //操作类型: -3,清除所有麦序?,-2 删除该用户的所有麦序,-1,删除该麦序,1-up,2-down,3-top,4-button
}CMDOperateWaitMic_t;

//设置排序用户index的响应/错误消息
typedef struct tag_CMDChangeWaitMicIndexResp
{
    uint32  vcbid;
    int32   errorid;     //错误代码
}CMDChangeWaitMicIndexResp_t;

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
    uint32 vcbid;             //只读
    uint32 runnerid;
    uint32 creatorid;         //房主
    uint32 op1id;             //副房主
    uint32 op2id;
    uint32 op3id;
    uint32 op4id;
    int    busepwd;         //是否启用密码
    char   cname[NAMELEN];  //房间名
    char   cpwd[PWDLEN];    //密码(可能有)
}CMDSetRoomInfoReq_t;

typedef struct tag_CMDSetRoomInfoReq_v2
{
    uint32 vcbid;             //只读
    uint32 runnerid;
    //进入房间设置
    int8 nallowjoinmode;
    //房间聊天设置
    int8 ncloseroom;//关闭聊天室/屏蔽互动聊天
    int8 nclosepubchat;//关闭公聊/禁止聊天回复
    int8 nclosecolorbar;//屏蔽献花
    int8 nclosefreemic;//自由排麦/禁止点赞
    int8 ncloseinoutmsg;
    int8 ncloseprvchat;//关闭私聊/禁止问股
    char   cname[NAMELEN];  //房间名
    char   cpwd[PWDLEN];    //密码(可能有)
}CMDSetRoomInfoReq_v2_t;

//设置房间信息的应答消息
typedef struct tag_CMDSetRoomInfoResp
{
    uint32 vcbid;
    int32  errorid;    //错误代码
}CMDSetRoomInfoResp_t;

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


//盖章请求和被盖章通知/广播的数据体
typedef struct tag_CMDSendUserSeal
{
    uint32 userid;
    uint32 vcbid;
    uint32 toid;
    uint16 sealid;
    uint16 sealtime;
}CMDSendUserSeal_t;

typedef struct tag_CMDSendUserSealErr
{
    uint32 userid;
    uint32 vcbid;
    int32  errid;
}CMDSendUserSealErr_t;

//禁言请求消息和通知/广播的数据体
typedef struct tag_CMDForbidUserChat
{
    uint32 vcbid;
    uint32 srcid;    //操作人
    uint32 toid;
    uint32 ttime;    //禁言时长
    byte   action;   //动作：1禁言 0解禁
}CMDForbidUserChat_t;

typedef struct tag_CMDMgrRefreshList
{
    uint32 vcbid;		//房间ID
    uint32 userid;		//用户ID
    char	name[20];	//用户名字
    uint32 srcid;		//操作人
    int    actionid;  //1:禁言 2:黑名单 3:其他
}CMDMgrRefreshList_t;

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

//中奖礼物通知消息
//该消息只限制同房间内广播,因此不需要srcalias,由于最多可能20次中奖,因此有重复的中奖率(如10倍中了2次),
//因此使用下面的内容结构,最后是变长的中奖数据。
typedef struct tag_CMDLotteryGiftNotice
{
    uint32 vcbid;   //房间id
    uint32 srcid;   //userid
    uint16 giftid;  //礼物id
    uint16 noddsnum;   //后续的中奖记录数目
    char content[0];   //中奖内容:[int16|int16]... 奖率|次数
}CMDLotteryGiftNotice_t;

//中奖爆炸礼物通知消息
typedef struct tag_CMDBoomGiftNotice
{
    uint32 vcbid;
    uint32 srcid;
    uint32 giftid; //礼物id
    int    beishu; //倍数
    uint64 winmoney;  //爆炸中奖总额
}CMDBoomGiftNotice_t;

//幸运奖池通知消息
typedef struct tag_CMDLotteryPoolInfo
{
    uint64 nlotterypool;
}CMDLotteryPoolInfo_t;

//捡烟花加钱请求消息
typedef struct tag_CMDTradeFireworksReq
{
    uint32 vcbid;
    uint32 userid;   //送烟花的用户id
    uint16 giftid;   //centersvr自己根据giftid获得礼物价格
    uint16 giftnum;
    uint16 usernum;   //分钱的用户个数
    char   alias[NAMELEN];  //昵称
    char   content[0];      //得到烟花礼物的用户id列表(uint32|uint32)
}CMDTradeFireworksReq_t;

//捡烟花加钱的通知消息 (每个得到钱的用户都下发一个给自己)
typedef struct tag_CMDTradeFireworksNotify
{
    uint32 vcbid;
    uint32 userid;
    int64 getmoney;  //该用户本次捡到的钱
    int64 nk;        //自己新的余额
    int64 nb;
    uint32 srcid;     //送烟花的用户id
    uint16 giftid;    //烟花礼物的id,可能有不同的烟花种类
}CMDTradeFireworksNotify_t;

//gch++
typedef struct tag_CMDTradeFireworksErr
{
    uint32 vcbid;
    uint32 userid;
    uint32 giftid;
    int32  errid;
}CMDTradeFireworksErr_t;

typedef struct tag_CMDTradeFireworksResp
{
    uint32 vcbid;
    uint32 userid;
    uint32 playtime;
    uint16 giftid;
    uint16 giftnum;
}CMDTradeFireworksResp_t;
//~~~

//房间播放烟花的通知消息(用来做动画触发指令)
typedef struct tag_CMDPlayFireworksNotify
{
    uint32 vcbid;
    uint32 srcid;
    uint16 giftid;   //烟花礼物id
}CMDPlayFireworksNotify_t;

//银行存取款
typedef struct tag_CMDMoneyAndPointOp
{
    uint32 vcbid;
    uint32 srcid;
    uint32 touserid;
    int64 data;       //金额/积分数目
    uint8 optype;     //1 银行存款 2 银行取款   3 转账  4 积分兑换金币
}CMDMoneyAndPointOp_t;

typedef struct tag_CMDSetRoomWaitMicMaxNumLimit
{
    uint32 vcbid;
    uint32 runnerid;
    uint32 maxwaitmicuser; //最大排麦人数
    uint32 maxuserwaitmic; //每人最多排麦次数
}CMDSetRoomWaitMicMaxNumLimit_t;

typedef struct tag_CMDSetForbidInviteUpMic
{
    uint32 vcbid;
    uint32 userid;
    int32  reserve;
}CMDSetForbidInviteUpMic_t;

typedef struct tag_PropsFlashPlayTaskItem
{
    short nTaskType;
    short nArg;
}PropsFlashPlayTaskItem_t;//, *PPropsFlashPlayTaskItem_t;

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

typedef struct tag_CMDOpenChestResp
{
    int32 errorid;   //错误 !=0
    uint32 vcbid;
    uint32 userid;
    int32 usedchestnum;   //使用掉的宝箱
    int32 remainchestnum;  //剩余的宝箱
    int32 openresult_type;   //开奖类型 - 对应请求中数据
    int32 openresult_0;      //单次奖项的数目
    int32 openresult_1[7];   //7个奖项的次数,注意,特等奖只会产生一次
    int64 poolvalue;         //剩余奖池数目
    int64 tedengvalue;       //特等奖结果
}CMDOpenChestResp_t;

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

//gch++ 用户详细信息
typedef struct tag_CMDUserMoreInfo
{
    int userid;
    byte  birthday_day;
    byte  birthday_month;
    byte  gender;
    byte  bloodgroup;
    int16 birthday_year;
    char  country[NAMELEN];
    char  province[NAMELEN];
    char  city[NAMELEN];
    byte  moodlength;
    byte  explainlength;
    char content[0];
}CMDUserMoreInfo_t;

typedef struct tag_CMDSetUserMoreInfoResp
{
    uint32 userid;
    int32  errorid;    //错误代码
}CMDSetUserMoreInfoResp_t;

typedef struct tag_CMDQueryUserMoreInfo
{
    uint32 srcid;
    uint32 vcbid;
    uint32 toid;
    int32  errorid;    //错误代码
}CMDQueryUserMoreInfo_t;

typedef struct tag_CMDQuanxianId2Item
{
    int16 levelid; //
    int16 quanxianid; //
    uint8 quanxianprio;
    uint16 sortid;
    uint8 sortprio;
}CMDQuanxianId2Item_t;

// 关键字屏蔽
typedef struct tag_AdKeywordInfo
{
    int		naction;				//0-刷新 1-增加 2-删除
    int		ntype;					//广告类型
    int		nrunerid;				//操作人Id
    char	createtime[32];			//创建时间
    char	keyword[64];			//关键词
}CMDAdKeywordInfo_t;


// 关键字操作请求
typedef struct tag_CMDAdKeywordsReq{
    int num;
    char keywod[0];
}CMDAdKeywordsReq_t;

//关键字操作回应
typedef struct tag_CMDAdKeywordsResp{
    int errid;				// 0 代表成功，否则失败
    uint32 userid;
}CMDAdKeywordsResp_t;

//关键字操作广播(也作为用户加入房间后，客户端第一次获取关键字列表的请求）
typedef struct tag_CMDAdKeywordsNotify{
    int num;
    char keywod[0];
}CMDAdKeywordsNotify_t;

typedef struct tag_CMDQuanxianAction2Item
{
    uint16 actionid;
    int8 actiontype;
    int16 srcid;
    int16 toid;
}CMDQuanxianAction2Item_t;

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

typedef struct tag_CMDClientPingResp
{
    uint32 userid;        //用户id
    uint32 roomid;        //房间id
}CMDClientPingResp_t;

typedef struct tag_CMDQueryRoomGateAddrReq
{
    uint32 userid;
    uint32 roomid;
    uint32 flags;    //自定义传输参数，返回带入
}CMDQueryRoomGateAddrReq_t;

typedef struct tag_CMDQueryRoomGateAddrResp
{
    uint32 errorid;   //错误id
    uint32 userid;
    uint32 roomid;
    uint32 flags;    //自定义传输参数
    int16 textlen;   //地址长度变长
    char content[0];
}CMDQueryRoomGateAddrResp_t;

typedef struct tag_CMDSetUserHideStateReq
{
    uint32 userid;
    uint32 vcbid;
    int32  hidestate;    //1-toHide, 2-tounHide
}CMDSetUserHideStateReq_t;

typedef struct tag_CMDSetUserHideStateResp
{
    uint32 errorid;   //错误id
}CMDSetUserHideStateResp_t;

typedef struct tag_CMDSetUserHideStateNoty
{
    uint32 userid;
    uint32 vcbid;
    uint32 inroomstate;  //最终状态
}CMDSetUserHideStateNoty_t;

typedef struct tag_CMDUserAddChestNumNoty
{
    uint32 userid;
    uint32 vcbid;
    uint32 addchestnum; //新增宝箱数目
    uint32 totalchestnum; //共有宝箱
}CMDUserAddChestNumNoty_t;

//增加密友通知
typedef struct tag_CMDAddClosedFriendNotify
{
    uint32 userid;
    uint32 vcbid;
}CMDAddClosedFriendNotify_t;

//资讯弹出
//512 bytes
typedef struct tag_CMDBroadcastInfomation
{
    char   info[256];   //摘要
    char   link[256];   //链接
}CMDBroadcastInfomation_t;

//报告媒体服务器
typedef struct tag_CMDReportMediaGateReq
{
    uint32 vcbid;
    uint32 userid;
    uint16 textlen;          //下面内容的长度
    char  content[0];       //ip:port的形式，分号作为分隔符，用“|”竖号分隔媒体服务器地址和网关服务器地址
}CMDReportMediaGateReq_t;
//报告媒体服务器回应
typedef struct tag_CMDReportMediaGateResp
{
    uint32 vcbid;
    uint32 userid;
    int errid;
}CMDReportMediaGateResp_t;

//讲师请求打分
typedef struct tag_CMDTeacherScore
{
    uint32 teacherid;             //讲师ID
    char   teacheralias[NAMELEN]; //讲师昵称
    uint32  vcbid;                //所在房间id
    int64 data1;                  //备用字段1
    char   data2[NAMELEN];        //备用字段2
}CMDTeacherScore_t;

//讲师请求打分结果
typedef struct tag_CMDTeacherScoreResp
{
    int    type;                  //操作是否成功
    uint32 teacherid;             //讲师ID
    char   teacheralias[NAMELEN]; //讲师昵称
    int   vcbid;        //讲师所在房间id列表，包括主房间和所有子房间
}CMDTeacherScoreResp_t;

//用户打分记录请求
typedef struct tag_CMDTeacherScoreRecord
{
    uint32 teacherid;             //讲师ID
    char   teacheralias[NAMELEN]; //讲师昵称
    uint32 userid;                //打分人ID
    char   alias[NAMELEN];        //打分人呢称
    byte   usertype;              //打分人类型: 0-普通 1-机器人
    uint32 score;                 //分数
    char   logtime[NAMELEN];      //打分时间
    uint32  vcbid;                //所在房间id
    int64 data1;                  //备用字段1
    int64 data2;                  //备用字段2
    int64 data3;                  //备用字段3
    char   data4[NAMELEN];        //备用字段4
    char   data5[NAMELEN];        //备用字段5
}CMDTeacherScoreRecord_t;
//用户打分记录响应
typedef struct tag_CMDTeacherScoreRes
{
    uint32 teacherid;             //讲师ID
    char   teacheralias[NAMELEN]; //讲师昵称
    int    type;                  //操作是否成功
}CMDTeacherScoreRes_t;

//机器人对应讲师ID通知
typedef struct tag_CMDRoborTeacherIdNoty
{
    uint32 vcbid;	//房间id
    uint32 roborid;//机器人id
    uint32 teacherid;             //讲师ID
}CMDRoborTeacherIdNoty_t;
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
    char   useralias[NAMELEN];	    //用户昵称
    uint64 t_num;					//忠实度值
}CMDTeacherGiftListResp_t;

//砸玩金蛋的通知客户端
typedef struct tag_CMDHitGoldEggClientNoty
{
    uint32 vcbid;
    uint32 userid;
    uint64 money;
}CMDHitGoldEggClientNoty_t;

//用户对讲师的评分响应
typedef struct tag_CMDUserScoreNoty
{
    uint32 vcbid;					//房间号
    uint32 teacherid;				//讲师ID
    int32  score;					//用户对讲师的评分
    int32 userid;					//用户ID
}CMDUserScoreNoty_t;
//讲师评分平均分
typedef struct tag_CMDTeacherAvarageScoreNoty
{
    uint32 teacherid;
    uint32 roomid;
    float avarage_score;
    char data1[NAMELEN]; //备用字段1
    uint32 data2; //备用字段2
}CMDTeacherAvarageScoreNoty_t;


////////////////////////////////////////
//信箱小红点提醒（服务器主动推送）
typedef struct tag_CMDMessageNoty
{
    int32 userid;					//用户ID
}CMDMessageNoty_t;

//信箱未读记录数提醒
typedef struct tag_CMDMessageUnreadRes
{
    int32 userid;				      //用户ID
    int8  teacherflag;                //是否讲师（0-不是，1-是）
    int32 chatcount;                  //互动回复未读记录数
    int32 viewcount;                  //观点回复未读记录数
    int32 answercount;                //问答提醒未读记录数
    int32 syscount;                   //系统信息未读记录数
}CMDMessageUnreadRes_t;

//查看邮箱（不同分类请求用同一个消息类型及结构）
typedef struct tag_CMDHallMessageReq
{
    uint32 userid;                 //用户ID
    int8   teacherflag;            //是否讲师（0-不是，1-是）
    int16  type;                   //分类：1.互动回复（11.收到的互动（用户）；12.发出的互动（讲师）；）；
    //2.观点回复（21.收到的观点回复；22.发出的观点评论；）；
    //3.问答提醒（31. 未回答提问；32.已回答提问；）；
    //4.我的关注（41.我的粉丝；42.我的关注；43.明日预测）；
    //5.系统信息；
    int64  messageid;              //请求得到的最大消息ID，第一次为0
    int32  startIndex;             //起始索引
    int16  count;                  //请求记录数
}CMDHallMessageReq_t;

//查看互动回复，查看问答提醒
typedef struct tag_CMDInteractRes
{
    int16  type;                   //分类：互动回复（11.收到的互动（用户）；12.发出的互动（讲师）；）； 问答提醒（31. 未回答提问；32.已回答提问；）；
    uint32 userid;                 //请求用户ID
    uint32 touserid;               //互动用户ID
    char   touseralias[NAMELEN];   //互动用户昵称
    uint32 touserheadid;           //互动用户头像
    int64  messageid;              //消息ID（用于回复时找到对应的记录）
    int16  sortextlen;             //源内容长度
    int16  destextlen;             //回复内容长度，type=3时值为0表示未回答的提问，否则表示已回答的提问；
    uint64 messagetime;            //回复时间(yyyymmddhhmmss)
    int8   commentstype;           //客户端类型 0:PC端 1:安卓 2:IOS  3:WEB
    char   content[0];             //消息内容，格式：源内容+回复内容
}CMDInteractRes_t;

//查看观点回复
typedef struct tag_CMDViewShowRes
{
    int16  type;                   //分类： 观点回复（21.收到的观点回复；22.发出的观点评论；）；
    uint32 userid;                 //请求用户ID
    uint32 touserid;               //互动用户ID
    char   useralias[NAMELEN];     //互动用户昵称
    uint32 userheadid;             //互动用户头像
    int64  commentid;              //评论ID（用于回复时找到对应的记录）
    int16  viewTitlelen;           //观点标题长度
    int16  viewtextlen;            //观点内容长度
    int16  srctextlen;             //评论内容长度
    int16  replytextlen;           //回复内容长度，对于用户值为0表示发出的观点评论，否则表示收到的观点回复；
    //对于讲师值为0表示收到的观点评论，否则表示发出的观点回复;
    uint64 restime;                //回复时间
    int8   commentstype;           //客户端类型 0:PC端 1:安卓 2:IOS  3:WEB
    char   content[0];             //消息内容，格式：观点标题+观点内容+评论内容+回复内容
}CMDViewShowRes_t;

//查看我的粉丝
typedef struct tag_CMDTeacherFansRes
{
    uint32 teacherid;              //讲师ID
    uint32 userid;                 //用户ID
    char   useralias[NAMELEN];     //用户昵称
    uint32 userheadid;             //用户头像
}CMDTeacherFansRes_t;

//查看我的关注（已关注讲师）
typedef struct tag_CMDInterestRes
{
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    char   teacheralias[NAMELEN];  //讲师昵称
    uint32 teacherheadid;          //讲师头像
    int16  levellen;               //讲师等级长度
    int16  labellen;               //讲师标签长度
    int16  introducelen;           //讲师简介长度
    char   content[0];             //消息内容，格式：讲师等级+讲师标签+讲师简介
}CMDInterestRes_t;

//查看我的关注（无关注讲师）
typedef struct tag_CMDUnInterestRes
{
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    char   teacheralias[NAMELEN];  //讲师昵称
    uint32 teacherheadid;          //讲师头像
    int16  levellen;               //讲师等级长度
    int16  labellen;               //讲师标签长度
    int16  goodatlen;              //讲师擅长领域长度
    int64  answers;                //已回答问题的数目
    char   content[0];             //消息内容，格式：讲师等级+讲师标签+讲师擅长领域
}CMDUnInterestRes_t;

//查看明日预测（已关注的讲师）
typedef struct tag_CMDTextLivePointListRes
{
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    char   teacheralias[NAMELEN];  //讲师昵称
    uint32 teacherheadid;          //讲师头像
    int64  messageid;              //消息ID
    int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片;
    int16  textlen;                //消息长度
    int8   commentstype;           //客户端类型 0:PC端 1:安卓 2:IOS  3:WEB
    uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    char   content[0];             //消息内容
}CMDTextLivePointListRes_t;

//讲师回复（包含观点回复和回答提问）
typedef struct tag_CMDViewAnswerReq
{
    uint32 fromid;              //发出人
    uint32 toid;                //接收人
    int16  type;                //分类：1.互动回复；2.观点回复；3.问答提醒；（互动无回复）
    int64  messageid;           //消息ID
    int16  textlen;             //观点回复长度
    int8   commentstype;        //客户端类型 0:PC端 1:安卓 2:IOS  3:WEB
    char   content[0];          //观点回复内容
}CMDViewAnswerReq_t;

//讲师回复响应
typedef struct tag_CMDViewAnswerRes
{
    int32 userid;				    //用户ID
    int16 type;                     //分类：1.互动回复；2.观点回复；3.问答提醒；
    int64 messageid;                //创建成功的对应消息ID
    int16 result;                   //回复是否成功：0失败，1成功；
}CMDViewAnswerRes_t;

//关注（无关注讲师时返回所有讲师列表，点击关注）
typedef struct tag_CMDInterestForReq
{
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    int16  optype;                 //操作类型：1是关注，2是取消关注
}CMDInterestForReq_t;

//关注响应
typedef struct tag_CMDInterestForRes
{
    int32 userid;				  //用户ID
    int16 result;                 //回复是否成功：0失败，1成功；
}CMDInterestForRes_t;

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
    char   content[0];             //消息内容，格式：讲师等级+讲师标签+讲师擅长领域（多个以分号分隔）+讲师简介
}CMDTextRoomTeacherNoty_t;

//加载直播记录请求
typedef struct tag_CMDTextRoomLiveListReq
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    int16  type;                   //类型：1-文字直播；2-直播重点；3-明日预测（已关注的用户可查看）；4-观点；
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
    int16  livetype;               //文字直播类型：1-纯文字；2-文字+链接；3-文字+图片；4-互动回复；5-观点动态；
    int64  viewid;     			   //观点ID(5-观点动态用)
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
typedef struct tag_CMDTextRoomLiveMessageRes
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
}CMDTextRoomLiveMessageRes_t;

//用户点击关注请求
typedef struct tag_CMDTextRoomInterestForReq
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    int16  optype;                 //操作类型：1-关注  2-取消关注
}CMDTextRoomInterestForReq_t;

//用户点击关注响应
typedef struct tag_CMDTextRoomInterestForRes
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    int16  result;                 //回复是否成功：0失败；1成功；2已关注；
    uint32 teacherid;              //讲师ID
    int16  optype;                 //操作类型：1是关注，2是取消关注
}CMDTextRoomInterestForRes_t;

//用户点击提问请求
typedef struct tag_CMDTextRoomQuestionReq
{
    uint32 vcbid;                  //房间ID
    uint32 teacherid;              //老师ID
    uint32 userid;                 //用户ID
    int16  stocklen;               //个股名称长度
    int16  textlen;                //问题描述长度
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
    uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    char   content[0];             //消息内容，格式：个股名称+问题描述
}CMDTextRoomQuestionReq_t;

//用户操作响应
typedef struct tag_CMDTextRoomLiveActionRes
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //请求用户ID
    int16  result;                 //操作是否成功：0失败，1成功；
    int64  messageid;              //消息ID（通用接口，失败时为0）
}CMDTextRoomLiveActionRes_t;

//用户点赞请求
typedef struct tag_CMDTextRoomZanForReq
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    int64  messageid;              //消息ID
}CMDTextRoomZanForReq_t;

//用户点赞响应
typedef struct tag_CMDTextRoomZanForRes
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    int16  result;                 //回复是否成功：0失败，1成功；
    int64  messageid;              //消息ID
    int64  recordzans;             //消息点赞数
    int64  totalzans;              //总点赞数
}CMDTextRoomZanForRes_t;

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
typedef struct tag_CMDTextRoomLiveChatRes
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
}CMDTextRoomLiveChatRes_t;

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
typedef struct tag_CMDTextLiveChatReplyRes
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
}CMDTextLiveChatReplyRes_t;

//点击查看观点类型请求
typedef struct tag_CMDTextRoomLiveViewGroupReq
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
}CMDTextRoomLiveViewGroupReq_t;

//观点分类响应
typedef struct tag_CMDTextRoomViewGroupRes
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    uint32 teacherid;              //讲师ID
    int32  viewtypeid;             //观点类型ID
    int32  totalcount;             //总观点数
    int16  viewtypelen;            //观点类型名称长度
    char   viewtypename[0];        //观点类型名称
}CMDTextRoomViewGroupRes_t;

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

//观点列表响应
typedef struct tag_CMDTextRoomLiveViewRes
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
}CMDTextRoomLiveViewRes_t;

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
typedef struct tag_CMDTextRoomViewInfoRes
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
}CMDTextRoomViewInfoRes_t;


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
typedef struct tag_CMDTextRoomViewTypeRes
{
    uint32 vcbid;                  //房间ID
    uint32 teacherid;              //请求用户ID
    int16  result;                 //操作是否成功：0失败，1成功；
    int32  viewtypeid;             //观点类型ID（通用接口，失败时为0）
}CMDTextRoomViewTypeRes_t;

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
typedef struct tag_CMDTextRoomViewMessageReqRes
{
    uint32 userid;                 //用户ID
    int64  messageid;              //消息ID（修改时填入，新增时为0）
    int16  titlelen;               //观点标题长度
    uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    char   content[0];             //观点格式：观点标题
}CMDTextRoomViewMessageReqRes_t;

//讲师删除观点请求
typedef struct tag_CMDTextRoomViewDeleteReq
{
    uint32 vcbid;                  	//房间ID
    uint32 userid;                 	//用户ID
    int64  viewid;              		//观点类型ID
}CMDTextRoomViewDeleteReq_t;

//讲师删除观点响应
typedef struct tag_CMDTextRoomViewDeleteRes
{
    uint32 vcbid;                  	//房间ID
    uint32 userid;                 	//用户ID
    int64  viewid;              	//消息ID
    int16  result;                  //操作是否成功：0失败，1成功；
}CMDTextRoomViewDeleteRes_t;

//观点评论详细页送花请求
typedef struct tag_CMDTextLiveViewFlowerReq
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    int64  messageid;              //消息ID
    int32  count;                  //送多少朵
}CMDTextLiveViewFlowerReq_t;

//观点评论详细页送花响应
typedef struct tag_CMDTextLiveViewFlowerRes
{
    uint32 vcbid;                  //房间ID
    uint32 userid;                 //用户ID
    int16  result;                 //回复是否成功：0失败，1成功；
    int64  messageid;              //消息ID
    int64  recordflowers;          //总送花数
}CMDTextLiveViewFlowerRes_t;

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
typedef struct tag_CMDTextLiveHistoryListRes
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
}CMDTextLiveHistoryListRes_t;

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
typedef struct tag_CMDTextRoomList_mobile
{
    char    uuid[16];               //唯一标识头
}CMDTextRoomList_mobile;

//讲师通过PHP页面发布观点或修改观点或删除观点请求（由于PHP不支持64位数据传输故将其合并到字符串中）
typedef struct tag_CMDTextRoomViewPHPReq
{
    uint32 vcbid;                  //房间ID
    uint32 teacherid;              //请求用户ID
    //int64  messageid;              //消息ID
    int8   viewtype;               //操作类型：1-新增；2-修改；3-删除；
    int16  titlelen;               //观点标题长度
    //uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
    char   content[0];             //格式：消息ID|观点ID|发送时间(yyyymmddhhmmss)|观点标题
}CMDTextRoomViewPHPReq_t;

//讲师通过PHP页面发布观点或修改观点或删除观点响应
typedef struct tag_CMDTextRoomViewPHPRes
{
    //int64  messageid;              //消息ID
    int8   viewtype;               //操作类型：1-新增；2-修改；3-删除；
    int16  titlelen;               //观点标题长度
    //uint64 messagetime;            //发送时间(yyyymmddhhmmss)
    int8   commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
    char   content[0];             //格式：消息ID|观点ID|发送时间(yyyymmddhhmmss)|观点标题
}CMDTextRoomViewPHPRes_t;

//房间推送系统公告
typedef struct tag_CMDSyscast
{
    unsigned char newType;  //0 一次性新闻 1
    long long   nid;        //记录ID
    char   title[32];
    char   content[512];
}CMDSyscast;

#pragma pack()

//////////////////////////////////////////////////////////////////////////
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
}e_userinroomstate;

typedef enum
{
    FT_ROOMOPSTATUS_CLOSE_PUBCHAT     = 0x00000001,   //关闭私聊
    FT_ROOMOPSTATUS_CLOSE_PRIVATECHAT = 0x00000002,   //关闭公聊
    FT_ROOMOPSTATUS_CLOSE_SAIZI       = 0x00000004,   //关闭塞子
    FT_ROOMOPSTATUS_CLOSE_PUBMIC      = 0x00000010,   //关闭公麦 (不允许上)
    FT_ROOMOPSTATUS_CLOSE_PRIVATEMIC  = 0x00000020,   //关闭私麦 (不允许上)
    FT_ROOMOPSTATUS_OPEN_AUTOPUBMIC   = 0x00000040,   //打开排麦自动上公麦
    FT_ROOMOPSTATUS_OPEN_WAITMIC      = 0x00000080,   //打开排麦功能
    FT_ROOMOPSTATUS_CLOSE_COLORBAR    = 0x00000100,   //屏蔽彩条
    FT_ROOMOPSTATUS_CLOSE_FREEMIC      = 0x00000200,   //自由排麦
    FT_ROOMOPSTATUS_CLOSE_INOUTMSG    = 0x00000400,   //屏蔽用户进出信息
    FT_ROOMOPSTATUS_CLOSE_ROOM        = 0x00000800,   //关闭聊天室
}e_roomopstate;

typedef enum
{
    FT_SCOPE_ALL           = 0,     //gcz++ 不限
    FT_SCOPE_ROOM          = 1,     //房间 
    FT_SCOPE_GLOBAL        = 2,     //gcz++ 全局
}e_violatioscope;

//用户安全信息查询请求
typedef struct tag_CMDSecureInfoReq
{
    int32 userid;                      //用户ID
}CMDSecureInfoReq_t;

//用户安全信息查询响应
typedef struct tag_CMDSecureInfoResp
{
    char email[32];                 //邮箱
    char qq[32];                    //qq号码
    char tel[32];                   //手机号码
    int32 remindtime;                 //已提醒次数
    int32 data1;
    int32 data2;
    int32 data3;
    char data4[32];
    char data5[32];
    char data6[32];
}CMDSecureInfoResp_t;

typedef struct tag_CMDExitAlertResp
{
    int32 userid;
    char email[32];                 //邮箱
    char qq[32];                    //qq号码
    char tel[32];                   //手机号码
    int32 hit_gold_egg_time;        //当天内砸蛋的次数
    int32 data1;
    int32 data2;
    int32 data3;
    char data4[32];
    char data5[32];
}CMDExitAlertResp_t;


//资讯消息
typedef struct tag_CMDSysBroadCastInfo
{
    int		ntype;
    char	ctitle[64];
    char	cabstract[256];	//摘要
    char	clink[256];		//链接
}CMDSysBroadCastInfo_t;


typedef struct tag_CMDUserLogonSuccess2
{
    uint32 nmessageid;           //message id
    int64 nk;                    //金币
    int64 nb;                    //礼物积分,可以换金币或兑换RMB
    int64 nd;                    //游戏豆
    uint32 nmask;                 //标志位, 用于客户端验证是不是自己发出的resp,
    uint32 userid;                //本号
    uint32 langid;                //靓号id
    uint32 langidexptime;         //靓号id到期时间
    uint32 servertime;            //服务器时间,显示客户端,用于抢星之类的时间查看
    uint32 version;               //服务器版本号,用在在信令相同的情况下登陆成功发回服务器DB中的版本号
    uint32 headid;                //用户头像id
    byte   viplevel;              //会员等级(可能是临时等级)
    byte   yiyuanlevel;           //艺员等级,如
    byte   shoufulevel;           //守护者等级
    byte   zhonglevel;            //终生等级,叠加数字(1~150)
    byte   caifulevel;            //财富等级
    byte   lastmonthcostlevel;     //上月消费排行
    byte   thismonthcostlevel;     //本月消费排行
    byte   thismonthcostgrade;    //本月累计消费等级
    byte   ngender;               //性别
    byte   blangidexp;            //靓号是否过期
    byte   bxiaoshou;             //是不是销售标志
    char   cuseralias[NAMELEN];   //呢称
    byte   nloginflag;            //login flag
    byte   bloginSource;          //local 99 login or other platform login:0-local;1-other platform
    byte   bBoundTel;             //bound telephone number:0-not;1-yes.
    char   sid[32];               //sid for visit web
}CMDUserLogonSuccess2_t;

typedef struct tag_CMDUserLogonErr2
{
    uint32 nmessageid;  //message id
    uint32 errid;       //根据id,客户端本地判断错误,包括版本错误(需要升级),封杀
    uint32 data1;       //参数1
    uint32 data2;       //参数2
}CMDUserLogonErr2_t;

typedef struct tag_CMDUserLogonReq4
{
    uint32 nmessageid;      //message id
    char   cloginid[32];    //[0]-游客登陆
    uint32 nversion;        //本地版本号?
    uint32 nmask;           //标示,用于客户端验证是不是自己发出的resp,
    char   cuserpwd[PWDLEN];    //登录密码,游客登录不需要密码,长度与将来的md5兼容
    char   cSerial[64];  //uuid
    char   cMacAddr[IPADDRLEN]; //mac地址
    char   cIpAddr[IPADDRLEN];  //ip地址
    byte   nimstate;        //IM状态:如隐身登录
    byte   nmobile;         //0-PC,1-Android,2-IOS,3-web
}CMDUserLogonReq4_t;

#endif //__CMD_VCHAT_HH_20110409__

