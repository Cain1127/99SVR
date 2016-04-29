// 修改项：
//1. 位域
//2. 城主信息 预编译去掉的字段
//3. typedef struct 空
//4. unsigned char/ long long
//5. 枚举类型
//6. int数组 openresult_1 members

#ifndef __CMD_LOGIN_VCHAT_H__
#define __CMD_LOGIN_VCHAT_H__

#include "yc_datatypes.h"

#define MAXSTARSIZE		  16  //周星等最大数目限制
//#define __SWITCH_SERVER2__ 
//-----------------------------------------------------------
#pragma pack(1)

namespace protocol
{
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

	//Logon from other platform
	typedef struct tag_CMDUserLogonReq5
	{
		uint32 nmessageid;          //message id
		uint32 userid;              //local user id,as before
		char   openid[48];          //open platform id
		char   opentoken[64];       //open platform token
		uint32 platformType;        //platform type,for example:1-QQ,2-weibo
		uint32 nversion;            //本地版本号?
		uint32 nmask;               //标示,用于客户端验证是不是自己发出的resp
		char   cSerial[64];         //uuid
		char   cMacAddr[IPADDRLEN]; //mac地址
		char   cIpAddr[IPADDRLEN];  //ip地址
		byte   nimstate;            //IM状态:如隐身登录
		byte   nmobile;             //0-PC,1-Android,2-IOS,3-web
	}CMDUserLogonReq5_t;

	//登录错误消息
	//4 bytes
	typedef struct tag_CMDUserLogonErr
	{
		uint32 errid;       //根据id,客户端本地判断错误,包括版本错误(需要升级),封杀
		uint32 data1;       //参数1
		uint32 data2;       //参数2
	}CMDUserLogonErr_t;

	//登录错误消息
	typedef struct tag_CMDUserLogonErr2
	{
		uint32 nmessageid;  //message id
		uint32 errid;       //根据id,客户端本地判断错误,包括版本错误(需要升级),封杀
		uint32 data1;       //参数1
		uint32 data2;       //参数2
	}CMDUserLogonErr2_t;

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

	typedef struct tag_CMDUserLogonSuccess2
	{
		uint32 nmessageid;            //message id
		int64 nk;                     //金币
		int64 nb;                     //礼物积分,可以换金币或兑换RMB
		int64 nd;                     //游戏豆
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
		byte   lastmonthcostlevel;    //上月消费排行
		byte   thismonthcostlevel;    //本月消费排行
		byte   thismonthcostgrade;    //本月累计消费等级
		byte   ngender;               //性别
		byte   blangidexp;            //靓号是否过期
		byte   bxiaoshou;             //是不是销售标志
		char   cuseralias[NAMELEN];   //呢称
		byte   nloginflag;            //login flag
		byte   bloginSource;          //local 99 login or other platform login:0-local;1-other platform
		byte   bBoundTel;             //bound telephone number:0-not;1-yes.
		char   csid[48];              //sid for visit web
	}CMDUserLogonSuccess2_t;

	//设置用户资料
	typedef struct tag_CMDSetUserProfileReq
	{
		uint32 userid;                 //用户ID
		uint32 headid;                 //用户头像ID
		byte   ngender;                //性别
		char   cbirthday[BIRTHLEN];    //生日
		char   cuseralias[NAMELEN];    //用户昵称
		char   province[16];           //省份
		char   city[16];               //城市
		int16  introducelen;           //个人签名长度
		char   introduce[0];             //消息内容，格式：个人签名
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
		char   pwdtype;
		char   cnewpwd[PWDLEN];     //设置成功的新密码
	}CMDSetUserPwdResp_t;

	//请求房间组列表消息
	//12...-bytes
	typedef struct tag_CMDRoomGroupListReq
	{
		uint32 userid;               //请求者的id
	}CMDRooGroupListReq_t;

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
		char   content[0];          //vcb_id列表
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

	typedef struct tag_CMDQuanxianId2Item
	{
		int16 levelid;  //可(-)
		int16 quanxianid;  //可(-)
		uint8 quanxianprio;
		uint16 sortid;
		uint8 sortprio;
	}CMDQuanxianId2Item_t;

	typedef struct tag_CMDQuanxianAction2Item
	{
		uint16 actionid;
		int8 actiontype;
		int16 srcid;
		int16 toid;
	}CMDQuanxianAction2Item_t;

	//用户退出程序给出的提示
	typedef struct tag_CMDExitAlertReq
	{
		int32 userid;                      //用户ID
	}CMDExitAlertReq_t;

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

	////////////////////////////////////////
	//信箱小红点提醒（服务器主动推送）
	typedef struct tag_CMDMessageNoty
	{
		int32 userid;					//用户ID
	}CMDMessageNoty_t;

	//信箱未读记录数返回
	typedef struct tag_CMDMessageUnreadResp
	{
		int32 userid;				      //用户ID
		int8  teacherflag;                //是否讲师（0-不是，1-是）
		int32 chatcount;                  //互动回复未读记录数
		int32 viewcount;                  //观点回复未读记录数
		int32 answercount;                //问答提醒未读记录数
		int32 syscount;                   //系统信息未读记录数
	}CMDMessageUnreadResp_t;

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
	typedef struct tag_CMDInteractResp
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
	}CMDInteractResp_t;

	//问答回复-个人信箱
	typedef struct tag_CMDAnswerResp
	{
		int16   type;                   //分类：互动回复（11.收到的互动（用户）；12.发出的互动（讲师）；）； 问答提醒（31. 未回答提问；32.已回答提问；）；
		uint32  userid;                 //发送该请求的用户ID
		uint32  touserid;               //对端用户ID
		char    touseralias[NAMELEN];   //互动用户昵称
		uint32  touserheadid;           //互动用户头像
		int64   messageid;              //消息ID（用于回复时找到对应的记录）
		int16   answerlen;             //回复内容长度
		int16   stokeidlen;             //股票ID长度
		int16   questionlen;           //问题长度
		uint64  messagetime;           //回复时间(yyyymmddhhmmss)
		int8    commentstype;           //客户端类型 0:PC端 1:安卓 2:IOS  3:WEB
		char    content[0];             //消息内容，格式：回答+股票ID+问题
	}CMDAnswerResp_t;

	//查看观点回复
	typedef struct tag_CMDViewShowResp
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
	}CMDViewShowResp_t;

	//查看我的粉丝
	typedef struct tag_CMDTeacherFansResp
	{
		uint32 teacherid;              //讲师ID
		uint32 userid;                 //用户ID
		char   useralias[NAMELEN];     //用户昵称
		uint32 userheadid;             //用户头像
	}CMDTeacherFansResp_t;

	//查看我的关注（已关注讲师）
	typedef struct tag_CMDInterestResp
	{
		uint32 userid;                 //用户ID
		uint32 teacherid;              //讲师ID
		char   teacheralias[NAMELEN];  //讲师昵称
		uint32 teacherheadid;          //讲师头像
		int16  levellen;               //讲师等级长度
		int16  labellen;               //讲师标签长度
		int16  introducelen;           //讲师简介长度
		char   content[0];             //消息内容，格式：讲师等级+讲师标签+讲师简介
	}CMDInterestResp_t;

	//查看我的关注（无关注讲师）
	typedef struct tag_CMDUnInterestResp
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
	}CMDUnInterestResp_t;

	//查看明日预测（已关注的讲师）
	typedef struct tag_CMDTextLivePointListResp
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
	}CMDTextLivePointListResp_t;

	//个人秘籍大厅列表
	typedef struct tag_CMDHallSecretsListResp
	{
		int32  secretsid;              //秘籍ID
		char	 srcalias[NAMELEN];      //讲师昵称
		int16  coverlittlelen;         //封面小图名称长度
		int16  titlelen;               //秘籍标题长度
		int16  textlen;                //秘籍简介长度
		uint64 messagetime;            //发送时间(yyyymmdd)
		char  content[0];              //消息内容，格式：封面小图名称+秘籍标题+秘籍简介
	}CMDHallSecretsListResp_t;

	//系统消息大厅邮箱列表
	typedef struct tag_CMDHallSystemInfoListResp
	{
		int32  systeminfosid;          //系统消息ID
		int16  titlelen;               //标题长度
		int16  linklen;         			 //链接长度
		int16  textlen;                //内容长度
		uint64 messagetime;            //发送时间(yyyymmdd)
		char  content[0];              //消息内容，格式：标题+链接+内容
	}CMDHallSystemInfoListResp_t;
	/*---------------------------------------------------------------------------------*/


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
	typedef struct tag_CMDViewAnswerResp
	{
		int32 userid;				    //用户ID
		int16 type;                     //分类：1.互动回复；2.观点回复；3.问答提醒；
		int64 messageid;                //创建成功的对应消息ID
		int16 result;                   //回复是否成功：0失败，1成功；
	}CMDViewAnswerResp_t;

	//关注（无关注讲师时返回所有讲师列表，点击关注）
	typedef struct tag_CMDInterestForReq
	{
		uint32 userid;                 //用户ID
		uint32 teacherid;              //讲师ID
		int16  optype;                 //操作类型：1是关注，2是取消关注
	}CMDInterestForReq_t;

	//关注响应
	typedef struct tag_CMDInterestForResp
	{
		int32 userid;				  //用户ID
		int16 result;                 //回复是否成功：0失败，1成功；
	}CMDInterestForResp_t;

	//返回讲师的粉丝总数
	typedef struct tag_CMDFansCountReq
	{
		uint32 teacherid;              //讲师ID
	}CMDFansCountReq_t;

	typedef struct tag_CMDFansCountResp
	{
		uint32 teacherid;              //讲师ID
		uint64 fansCount;              //粉丝总数
	}CMDFansCountResp_t;

	typedef struct tag_CMDSessionTokenReq
	{
		uint32  userid;
	}CMDSessionTokenReq_t;

	typedef struct tag_CMDSessionTokenResp
	{
		uint32  userid;
		char    sessiontoken[33];
		char    validtime[32];
	}CMDSessionTokenResp_t;

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


	typedef struct tag_CMDConfigSvrNoty
	{
		byte type;         //1：静态配置数据，2：礼物列表数据
		uint32 data_ver;    //数据的版本号
	}CMDConfigSvrNoty_t;

	typedef struct tag_CMDPushGateMask
	{
		uint32 userid;      //用户ID，广播用户填0
		byte termtype;     //登陆类型（0：PC，1：Android，2：IOS，3：Web，4：所有类型）
		byte type;         //业务类型：1. 配置服务器推送;2. 通知客户端打印日志;3. 客户端升级推送;4. 砸金蛋;5. 飘窗提示;9.信箱消息推送
		byte needresp;      //是否需要确认
		uint16 validtime;    //有效时长
		byte versionflag;    //0：所有，1：等于，2：大于等于，3：小于等于
		uint32 version;     //版本号，0代表没有版本限制
		uint16 length;      //推送业务内容长度，比如砸金蛋结构体长度
		char content[0];    //推送业务内容，比如砸金蛋结构体内容
	}CMDPushGateMask_t;

	typedef struct tag_CMDBayWindow
	{
		uint32  ntime;         //飘窗时间
		char   title[64];     //飘窗标题
		uint16 contlen;       //飘窗内容长度
		uint8  urllen;        //链接长度
		char   content[0];    //飘窗内容+链接信息
	}CMDBayWindow_t;

	typedef struct tag_CMDGetUserMoreInfReq
	{
		uint32 userid;
	}CMDGetUserMoreInfReq_t;

	typedef struct tag_CMDGetUserMoreInfResp
	{
		char   tel[32];                   //手机号码
		char   birth[16];                 //生日
		char   email[40];                 //email
		int16  autographlen;              //个性签名长度
		char   autograph[0];              //个性签名内容
	}CMDGetUserMoreInfResp_t;

	typedef struct tag_CMDRoomTeacherOnMicResp
	{
		uint32  teacherid;      //讲师ID
		uint32  vcbid;          //房间ID
		char    alias[NAMELEN]; //讲师昵称
	}CMDRoomTeacherOnMicResp_t;

	//砸完金蛋通知客户端
	typedef struct tag_CMDHitGoldEggClientNoty
	{
		uint32 vcbid;
		uint32 userid;
		uint64 money;
	}CMDHitGoldEggClientNoty_t;

	//私人订制购买请求
	typedef struct tag_CMDBuyPrivateVipReq
	{
		uint32 userid;          //用户ID
		uint32 teacherid;     	//讲师ID
		uint32 viptype;     	//vip等级ID
	}CMDBuyPrivateVipReq_t;

	//私人订制购买响应
	typedef struct tag_CMDBuyPrivateVipResp
	{
		uint32 userid;          //用户ID
		uint32 teacherid;     	//讲师ID
		uint32 viptype;     		//vip等级ID
		uint64 nk;        	    //账户余额
	}CMDBuyPrivateVipResp_t;

	//邮箱新消息提示
	typedef struct tag_CMDEmailNewMsgNoty
	{
	  byte bEmailType;        //1 私人定制 2系统消息 3评论回复 4提问回复
	  uint32 messageid;       //消息ID
	}CMDEmailNewMsgNoty_t;
	
	typedef struct tag_CMDErrCodeResp_t
	{
		 uint16 errmaincmd;
		 uint16 errsubcmd;
		 uint16 errcode;
	}CMDErrCodeResp_t;

};

#pragma pack()


#endif //__CMD_VCHAT_HH_20110409__

