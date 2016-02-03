
#ifndef __MOON_DEFINES_HH__
#define __MOON_DEFINES_HH__

#define MAX_SERVERADDR_SIZE  6

#include "yc_datatypes.h"


#define CRYPT_KEY	"cxzg6b2201234567"
#define CRYPT_KEY2  "##.define.struct"

#define MAX_TRYCONNECT_COUNT        10 

typedef enum
{
	NETTYPE_TEL =0,
	NETTYPE_UNI =1,
}e_NetType;

typedef struct tag_ServerAddr
{
	char szAddr[IPADDRLEN];   //最长31个字符
	uint16 nport;             //端口
}ServerAddr_t;

//用户登录数据
typedef struct tag_LogonUserData
{
   int32  userid;          //用户数字帐号
   char   szpwd[PWDLEN];   //密码
   char   bsavepwd;        //是否保存密码
}LogonUserData_t;

//用户加入房间数据
typedef struct tag_JoinRoomUserData
{
	int32 userid;              //用户帐号
	int32 roomid;              //房间id
	uint32 userstate;          //用户状态: 隐身,正常
	char  szRoomAddr[URLLEN4]; //房间网关地址
	char  szroompwd[PWDLEN];   //房间密码
}JoinRoomUserData_t;

//房间组数据
typedef struct tag_RoomGroupData
{
	int32 groupid;   
	int32 parentid;
	int   usernum;             //用户数目
	uint32 textcolor;          //文字颜色
	byte  reserve_01;        
	byte  bhaschild;           //是否有子?    
	byte  bshowusernum;        //是否显示房间人数?
	byte  bfontbold;           //是否是粗体
	char  groupname[NAMELEN];  //名字
	char  iconname[NAMELEN];
	char  url[URLLEN4];         //内容
}RoomGroupData_t;

//rich字体信息
typedef struct tag_RichFontData
{
	unsigned char szFontName[NAMELEN];   //字体名字
	unsigned int dwTextColor;
	int  isize;                  //高度
	bool bBold;
	bool bUnderline;
	bool bItalic;
}RichFontData_t;

//跑道礼物信息
typedef struct tag_FlyGiftInfo
{    
	uint32 vcbid;            
	uint32 srcid;
	uint32 toid;
	uint32 totype;   //
	uint32 tovcbid;  //
	uint32 giftid;                //礼物id
	uint32 giftnum;               //赠送数目
	byte  banonymous;             //是否匿名。0表示不匿名，1表示匿名
	uint32 dtime;                 //发起时间
	char   srcalias[NAMELEN];
	char   toalias[NAMELEN];
	char   srcvcbname[NAMELEN];   //
    char   tovcbname[NAMELEN];    //
	char   sztext[GIFTTEXTLEN];   //定义64,实际使用最多18个汉字或英文（最多占36个长度)
}FlyGiftInfo_t;

//加入房间信息
typedef struct tag_WantToJoinRoomInfo
{
	int vcbid;
	int joinmode;
	unsigned char szgateaddr[GATEADDRLEN];
	unsigned char szroompwd[PWDLEN];
}WantToJoinRoomInfo_t;

//中奖倍数次数
typedef struct tag_JiangCiShu_t
{
   int beishu;
   int count;
}tag_JiangCiShu_t;

typedef struct tag_AudioDevName
{
   unsigned char szDevName[DEVICENAMELEN];
}AudioDevName_t;

//群发用户信息
typedef struct tag_QunshuaUserItem
{
	int userId;  //用户id
	int giftId;  //礼物id
	int giftNum;  //礼物数量
	int giftprice; //礼物单价
}QunshuaUserItem_t;

//密友用户信息
typedef struct tag_ClosedFriendItem
{
	unsigned int userid;   //用户id
	char szDate[12];   //增加日期
	char szTime[12];   //增加时间
}ClosedFriendItem_t;


#endif //__MOON_DEFINES_HH__


