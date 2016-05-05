#ifndef __CMD_TEXT_ROOM_VCHAT_H__
#define __CMD_TEXT_ROOM_VCHAT_H__

#include "yc_datatypes.h"

#pragma pack(1)

namespace protocol
{
	typedef struct tag_CMDClientPingResp
	{
		uint32 userid;        //�û�id
		uint32 roomid;        //����id
	}CMDClientPingResp_t;

	//���뷿��Ԥ��������
	typedef struct tag_CMDPreJoinRoomReq
	{
		uint32 userid;              //�û�id,����������id,�������οͺ���
		uint32 vcbid;               //����id
	}CMDPreJoinRoomReq_t;

	//���뷿��Ԥ������Ӧ
	typedef struct tag_CMDPreJoinRoomResp
	{
		uint32 userid;          //�û�id,����������id,�������οͺ���
		uint32 vcbid;           //����id
		uint8 result;           //����1λ 1������� 0���䲻���ڣ�2λ 1�ں����� 0���ں�������3λ 1���������Ƿ����� 0��������δ����4λ 1���������� 0����������
	}CMDPreJoinRoomResp_t;

	//���뷿������
	//281 bytes
	typedef struct tag_CMDJoinRoomReq
	{
		uint32 userid;         //�û�id,����������id,�������οͺ���
		uint32 vcbid;          //����id
		uint32 devtype;      //0:PC�� 1:��׿ 2:IOS 3:WEB
		uint32 time;
		uint32 crc32;
		uint32 coremessagever;     //�ͻ����ں˰汾
		char   cuserpwd[PWDLEN];   //�û�����,û�о����ο�
		char   croompwd[PWDLEN];   //��������,������
		char   cSerial[64];    //uuid
		char   cMacAddr[IPADDRLEN];   //�ͻ���mac��ַ
		char   cIpAddr[IPADDRLEN];	  //�ͻ���ip��ַ
		byte   bloginSource;         //local 99 login or other platform login:0-local;1-other platform
		byte   reserve1;
		byte   reserve2;
	}CMDJoinRoomReq_t;

	//���뷿����Ӧ 332 + 88bytes (420byte)
	typedef struct tag_CMDJoinRoomResp
	{
		uint32 userid;       //�û�id
		uint32 vcbid;        //����id
		byte   roomtype;     //��������
		byte   busepwd;      //�Ƿ���Ҫ��������
		byte   bIsCollectRoom;  //�Ƿ񱻸��û��ղ�
		byte   devtype;    //�豸���� PC�� 1:��׿ 2:IOS 3:WEB
		uint16 seats;        //������
		uint32 groupid;        //��id, ���������������ж�?
		uint32 runstate;       //���� ����״̬
		uint32 creatorid;      //����
		uint32 op1id;          //������
		uint32 op2id;        
		uint32 op3id;
		uint32 op4id;
		uint32 inroomstate;  //���뷿����ڷ���״̬��Ŀǰֻ��ʹ�õ�����״̬����.
		int64 nk;                //�û����,nk
		int64 nb;                //�û����,nb
		int64 nlotterypool;      //���˽��زʽ�
		int32 nchestnum;         //�û����б������
		char   cname[NAMELEN];         //��������
		char   cmediaaddr[MEDIAADDRLEN];   //ý���������ַ
		char   cpwd[PWDLEN];     
		uint64 naccess_times;		   //�����������(�˴�)
		uint32 ncollect_times;		   //�����ղش���(��˿��)
	}CMDJoinRoomResp_t;


	//���뷿�����
	typedef struct tag_CMDJoinRoomErr
	{
		uint32 userid;
		uint32 vcbid;
		uint32 errid;
		uint32 data1;
		uint32 data2;
	}CMDJoinRoomErr_t;

	//���뷿��ɹ�������������Ϣ
	typedef struct tag_CMDAfterJoinRoomReq
	{
		uint32 userid;
		uint32 vcbid;
	}CMDAfterJoinRoomReq_t;

	//�û��˳����������֪ͨ��������
	typedef struct tag_CMDUserExitRoomInfo
	{
		uint32 userid;
		uint32 vcbid;
	}CMDUserExitRoomInfo_t;

	//���������֪ͨ��Ϣ��������
	typedef struct tag_CMDUserKickoutRoomInfo
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		int32  resonid; 
		byte   mins;         //���ʱ��id,������(0~255����)
	}CMDUserKickoutRoomInfo_t;

	//������Ա�б�������� 148 bytes
	typedef struct tag_CMDRoomUserInfo
	{
		uint32 userid;                //�û�id,����������id
		uint32 vcbid;                 //����id

		byte   viplevel;              //��Ա�ȼ�(��������ʱ�ȼ�)
		byte   yiyuanlevel;           //��Ա�ȼ�,��
		byte   shoufulevel;           //�ػ��ߵȼ�
		byte   zhonglevel;            //�����ȼ�,��������(1~150)

		byte   caifulevel;            //�Ƹ��ȼ�,��nk,nb������ͼ
		byte   lastmonthcostlevel;     //������������
		byte   thismonthcostlevel;     //������������
		byte   thismonthcostgrade;    //�����ۼ����ѵȼ�

		//byte   isxiaoshou:1;          //�ǲ�������
		//byte   gender:1;              //�Ա�,
		//byte   reserve1:6;            //��ʱ��Ϊ�豸���ͣ�2016-01-22 by shuisheng)
		byte flags;
		char   pubmicindex;           //����λ��
		byte   roomlevel;             //����ȼ�
		byte   usertype;              //�û�����: ��ͨ ������

		uint32 sealid;                //�Ƿ�����(id���65535, 0-����)
		uint32 cometime;
		uint32 headicon;              //ͷ��
		uint32 micgiftid;             //����������id,ֻ��������״̬��Ч
		uint32 micgiftnum;            //��������������,

		uint32 sealexpiretime;        //�µĹ���ʱ��
		uint32 userstate;             //�û�״̬,��ϱ�־
		uint32 starflag;              //���Ǳ�־
		uint32 activityflag;          //��Ǳ�־(���Զ��)
		uint32 flowernum;             //�Լ��Ĳ�������(����), �ر���������
		uint32 ticket1num;            //������Ʊ������Ŀ, �ر���������
		uint32 ticket2num;            //������Ʊ������Ŀ, �ر���������
		uint32 ticket3num;            //���������Ʊ������Ŀ, �ر���������
		int32  bforbidinviteupmic;
		int32  bforbidchat;
		int32  ncarid;               //����id.0-û��
		char   useralias[NAMELEN];   //�س�
		char   carname[NAMELEN];     //��������,��������ݵĻ�

	}CMDRoomUserInfo_t;

	// �ؼ��ֲ�������
	typedef struct tag_CMDAdKeywordsReq{
		int num;
		int		naction;				//0-ˢ�� 1-���� 2-ɾ��
		int		ntype;					//�������
		int		nrunerid;				//������Id
		char	createtime[32];			//����ʱ��
		char	keyword[64];			//�ؼ���
	}CMDAdKeywordsReq_t;

	//�ؼ��ֲ����㲥(Ҳ��Ϊ�û����뷿��󣬿ͻ��˵�һ�λ�ȡ�ؼ����б������
	typedef struct tag_CMDAdKeywordsNotify{	
		int num;
		char keywod[0];
	}CMDAdKeywordsNotify_t;

	//�ؼ��ֲ�����Ӧ
	typedef struct tag_CMDAdKeywordsResp{
		int errid;				// 0 ����ɹ�������ʧ��
		uint32 userid;	
	}CMDAdKeywordsResp_t;

	typedef struct tag_CMDSetRoomInfoReq_v2
	{
		uint32 vcbid;             //ֻ��
		uint32 runnerid;
		//���뷿������
		int8 nallowjoinmode;
		//������������
		int8 ncloseroom;
		int8 nclosepubchat;
		int8 nclosecolorbar;
		int8 nclosefreemic;
		int8 ncloseinoutmsg;
		int8 ncloseprvchat;
		char   cname[NAMELEN];  //������
		char   cpwd[PWDLEN];    //����(������)
	}CMDSetRoomInfoReq_v2_t;

	//���÷�����Ϣ��Ӧ����Ϣ
	typedef struct tag_CMDSetRoomInfoResp
	{
		uint32 vcbid;
		int32  errorid;    //�������
	}CMDSetRoomInfoResp_t;

	// ������Ϣ��Ϣ,�·�ʱʹ��
	typedef struct tag_CMDRoomBaseInfo
	{
		uint32 vcbid;     //ֻ��
		uint32 groupid;   //������ID,ֻ��
		byte   level;     //ֻ��
		byte   busepwd;   //
		uint16 seats;     
		uint32 creatorid;
		uint32 op1id;
		uint32 op2id;
		uint32 op3id;
		uint32 op4id;
		uint32 opstate;   //ʹ��bit,һ�����Է���32��,��1λ:�Ƿ��������Ļ�?
		//                         ��2λ:�Ƿ����������ӣ��ϴ��͹㲥ʱ���ǻ�Ͻ������.
		char   cname[NAMELEN]; //������
		char   cpwd[PWDLEN];  //����(������)
	}CMDRoomBaseInfo_t;

	// ���� �޸ķ���״̬��Ϣ(notify)
	typedef struct tag_CMDRoomOpState
	{
		uint32 vcbid;
		uint32 opstate;  //ʹ��bit,һ�����Է���32��,��1λ:�Ƿ��������Ļ�?
		//                         ��2λ:�Ƿ����������ӣ��ϴ��͹㲥ʱ���ǻ�Ͻ������.
	}CMDRoomOpState_t;

	//����������Ϣ��֪ͨ/�㲥��������
	typedef struct tag_CMDForbidUserChat
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		uint32 ttime;   //����ʱ��
		byte   action;   //������1���� 0���
	}CMDForbidUserChat_t;

	typedef struct tag_CMDThrowUserInfoResp
	{
		uint32 vcbid;
		int32 errorid;
	}CMDThrowUserInfoResp_t;

	//��ɱ�û���Ϣ(req, notify)
	typedef struct tag_CMDThrowUserInfo
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 toid;
		byte   viplevel;       //(roomsvr��д)
		byte   nscopeid;       //��ɱ��Χ :1-����,2-ȫվ
		byte   ntimeid;        //��ɱʱ��
		byte   nreasionid;     //��ɱ����
		char   szip[IPADDRLEN];       //(roomsvr��д)
		char   szserial[IPADDRLEN];   //(roomsvr��д)
	}CMDThrowUserInfo_t;

	//�û�Ȩ�޲��� (req, notify)
	//16 Byte
	typedef struct tag_CMDUserPriority
	{
		uint32 vcbid;       //����id
		uint32 runnerid;    //������Աid
		uint32 userid;      //��������Աid
		byte   action;		//���� ��1->�� 2->ж��
		byte   priority;	//�û�Ȩ�ޣ�1->����Ա��2->��ʱ����Ա��
	}CMDUserPriority_t;

	typedef struct tag_CMDSetUserPriorityResp
	{
		uint32 vcbid;
		int32 errorid;
	}CMDSetUserPriorityResp_t;

	//�鿴�û�IP����
	typedef struct tag_CMDSeeUserIpReq
	{
		uint32 vcbid;
		uint32 runid;
		uint32 toid;
	}CMDSeeUserIpReq_t;

	//�鿴�û�IPӦ��
	typedef struct tag_CMDSeeUserIpResp
	{
		uint32 vcbid;
		uint32 runid;
		uint32 userid;
		//char  ip[IPADDRLEN];
		uint16 textlen;          //������Ϣ����
		uint16 reserve;          //����
		char  content[0];       //��ַ����
	}CMDSeeUserIpResp_t;

	//����ý�������
	typedef struct tag_CMDReportMediaGateReq
	{
		uint32 vcbid;
		uint32 userid;
		uint16 textlen;          //�������ݵĳ���
		char  content[0];       //ip:port����ʽ���ֺ���Ϊ�ָ������á�|�����ŷָ����ط�������ַ��ý���������ַ
	}CMDReportMediaGateReq_t;

	//����ý���������Ӧ
	typedef struct tag_CMDReportMediaGateResp
	{
		uint32 vcbid;
		uint32 userid;
		int errid;
	}CMDReportMediaGateResp_t;

	//��ȡ�û���������ʦ����ͨ�û�����������
	typedef struct tag_CMDGetUserInfoReq
	{
		uint32 srcuserid;    //�û�ID
		uint32 dstuserid;		 //���鿴���û�ID
	}CMDGetUserInfoReq_t;
	
	//��ʦ��������
	typedef struct tag_CMDTeacherInfoResp
	{
		uint32  teacherid;          //��ʦID
		uint32  headid;             //��ʦͷ��ID
		uint32  vcbid;         			//��ʦ��������ֱ������ID
		int16   introducelen;       //���˽��ܳ���
		int16   lablelen;           //���˱�ǩ����
		int16   levellen;						//��ʦ���𳤶ȣ���������ʦ...��
		int16   type;								//��ʦ��� 1-����ֱ����2-��Ƶֱ����3-����+��Ƶֱ����
		uint64  czans;							//��ʦ������
		uint64  moods;							//��ʦ������
		uint64  fans;								//��ʦ��˿��
		int8  	fansflag;           //�Ƿ��Ѿ���ע��ʦ��0-δ��ע��1-�ѹ�ע��
		int8  	subflag;           //�Ƿ��Ѿ����Ľ�ʦ�γ̣�0-δ��ע��1-�ѹ�ע��
		char    content[0];         //��Ϣ���ݣ���ʽ�����˽���+���˱�ǩ+��ʦ����
	}CMDTeacherInfoResp_t;

	//��ͨ�û���������
	typedef struct tag_CMDRoomUserInfoResp
	{
		uint32  userid;          //�û�ID
		uint32  headid;          //�û�ͷ��ID
		uint32  birthday;			   //����
		int16   introducelen;    //���˽��ܳ���
		int16   provincelen;     //ʡ�ݳ���
		int16   citylen;				 //���г���
		char    content[0];      //��Ϣ���ݣ���ʽ�����˽���+ʡ��+����
	}CMDRoomUserInfoResp_t;

	typedef struct tag_CMDUserInfoErr
	{
		uint32 userid;  //�û�ID
		uint32 errid;   //0 �ɹ����ɹ������������1.�û������� 2.DB error 3.teacherflag ����
	}CMDUserInfoErr_t;

		//�ѷ������Favorite
	typedef struct tag_CMDFavoriteRoomReq
	{
		uint32 vcbid;
		uint32 userid;
		int    actionid;  //1:�ղ�, -1:ȡ���ղ�
	}CMDFavoriteRoomReq_t;

	typedef struct tag_CMDFavoriteRoomResp
	{
		int32  errorid;    //�������
		uint32 vcbid;
		int  actionid; //����,ͬ�ղط���
	}CMDFavoriteRoomResp_t;

	//�б���Ϣͷ(�ֻ��汾)������20��
	typedef struct tag_CMDTextRoomList_mobile
	{
		char    uuid[16];               //Ψһ��ʶͷ
	}CMDTextRoomList_mobile_t;

	//�������������֪ͨ��������
	typedef struct tag_CMDTradeGiftRecord
	{
		uint32 vcbid;     //roomId
		uint32 srcid;
		uint32 toid;
		uint32 tovcbid;    //���ܶ������ڵķ���
		uint32 totype;     //���ܶ�������:0-��ͨ�û�,1-�����û�,2-����ע���û�,3-���л�Ա,4-���й���,5-��������
		uint32 giftid;     //����id
		uint32 giftnum;    //������Ŀ
		byte  action;      //���׶���:action=0-�·��ܵ������б�ʱʹ��(null), 2-��ͨ��������,3-�����, 5-�շ�������, 6-�̻�(�ر�,��Ϊ��ʾ��ʽ��һ��)
		byte  servertype;  //������ת�����͡�	0-��ʾ��ͨת��(�����ڣ���1-��ʾͨ��centerSvrת��, 2-��ʾ�����½ʱ��ȡ
		byte  banonymous;  //�Ƿ�������0-��ʾ��������1-��ʾ���� 10-���������� 11-����˫��������
		byte  casttype;    //�Ƿ�㲥��0-��ʾ���㲥��1-��ʾ�㲥,�ͻ������Ƿ���Ҫ��С����֪ͨ 5-���з��乫������ʾ
		uint32 dtime;      //����ʱ��
		uint32 oldnum;     //�·�ʱ��д,�ϴ���Ŀ, �·��ܵ������б�ʱ0(null)
		char   flyid;      //�ܵ�ID,-1û��
		char   srcvcbname[NAMELEN];     //���������ڵķ�������
		char   tovcbname[NAMELEN];      //���������ڵķ�������
		char   srcalias[NAMELEN];
		char   toalias[NAMELEN];
		char   sztext[GIFTTEXTLEN];   //����40,ʵ��ʹ�����18�����ֻ�Ӣ�ģ����ռ36������)
	}CMDTradeGiftRecord_t;

	//�����������Ӧ
	typedef struct tag_CMDTradeGiftResp
	{
		//TODO:
	}CMDTradeGiftResp_t;

	//��������Ĵ�����Ӧ
	typedef struct tag_CMDTradeGiftErr
	{
		int nerrid;    //������
	}CMDTradeGiftErr_t;

	typedef struct tag_CMDUserKickoutRoomInfo_ext
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		int32  resonid;
		byte   mins;         //���ʱ��id,������(0~255����)
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

	//����
	typedef struct tag_CMDTeacherSubscriptionReq
	{
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		uint32 userid;
		uint32 teacherid;
		uint8  bSub; // 0 :ȡ������  1: ����
	}CMDTeacherSubscriptionReq_t;

	typedef struct tag_CMDTeacherSubscriptionResp
	{
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		uint32 userid;
		uint8  errcode;//���ش�����
	}CMDTeacherSubscriptionResp_t;

	//�۵�������������
	typedef struct tag_CMDViewpointTradeGiftReq
	{
	  uint32 userid;     // ������
	  uint32 roomid;     // �͸��ĸ�roomId
	  uint32 teamid;     // �͸��ĸ�teamid
	  uint32 viewid;     // �۵�id
	  uint32 giftid;     // ����id
	  uint32 giftnum;    // ������Ŀ
	}CMDViewpointTradeGiftReq_t;

	//�۵���������֪ͨ
	typedef struct tag_CMDViewpointTradeGiftNoty
	{
	  uint32 userid;     // ������
	  char useralias[NAMELEN];     // �������ǳ�
	  uint32 roomid;     // �͸��ĸ�roomId
	  uint32 teamid;     // �͸��ĸ�teamid
	  char teamalias[NAMELEN];     // team�ǳ�
	  uint32 viewid;     // �۵�id
	  uint32 giftid;     // ����id
	  uint32 giftnum;    // ������Ŀ
	}CMDViewpointTradeGiftNoty_t;

};

#pragma pack()

#endif
