// �޸��
//1. λ��
//2. ������Ϣ Ԥ����ȥ�����ֶ�
//3. typedef struct ��
//4. unsigned char/ long long
//5. ö������
//6. int���� openresult_1 members

#ifndef __CMD_VEDIO_ROOM_VCHAT_H__
#define __CMD_VEDIO_ROOM_VCHAT_H__

#include "yc_datatypes.h"

#pragma pack(1)

namespace protocol
{
	//���뷿������
	//248 bytes
	typedef struct tag_CMDJoinRoomReq1
	{
		uint32 userid;         //�û�id,����������id,�������οͺ���
		uint32 vcbid;          //����id
		uint32 devtype;      //0:PC�� 1:��׿ 2:IOS 3:WEB
		uint32 time;
		uint32 crc32;
		uint32 coremessagever;     //�ͻ����ں˰汾
		char   cuserpwd[PWDLEN];   //�û�����,û�о����ο�
		char   croompwd[PWDLEN];   //��������,������
		char   cSerial[32];    //
		char   cMacAddr[IPADDRLEN];   //�ͻ���mac��ַ
		char   cIpAddr[IPADDRLEN];	  //�ͻ���ip��ַ

	}CMDJoinRoomReq1_t;

	//���뷿������
	//280 bytes
	typedef struct tag_CMDJoinRoomReq
	{
		uint32 userid;         //�û�id,����������id,�������οͺ���
		uint32 vcbid;          //����id
		uint32 devtype;       //0:PC�� 1:��׿ 2:IOS 3:WEB
		uint32 time;
		uint32 crc32;
		uint32 coremessagever;     //�ͻ����ں˰汾
		char   cuserpwd[PWDLEN];   //�û�����,û�о����ο�
		char   croompwd[PWDLEN];   //��������,������
		char   cSerial[64];    //uuid
		char   cMacAddr[IPADDRLEN];   //�ͻ���mac��ַ
		char   cIpAddr[IPADDRLEN];	  //�ͻ���ip��ַ
	}CMDJoinRoomReq_t;

	//gate�Զ��л�����������
	typedef struct tag_CMDGateJoinRoomReq
	{
		uint32 userid;         //�û�id
		uint32 vcbid;          //����id
	}CMDGateJoinRoomReq_t;

	//������Ϣ����
	typedef struct tag_CMDSiegeInfo
	{
		uint32	vcbid;
		uint32	srcid;				//������id
		uint32	toid;				//������id
		uint32	giftid;				//����id
		uint32	count;				//������Ŀ
		uint32	time;				//����ʱ��
		char	srcalias[NAMELEN];	    //�������ǳ�
		char	toalias[NAMELEN];	    //�������ǳ�
	}CMDSiegeInfo_t;

	//���乫��״̬
	typedef struct tag_CMDRoomPubMicState
	{
		int16   micid;         //��0��ʼ(0-��һ������),�ͱ��ع����û���micid��Ӧ
		int16   mictimetype;   //
		uint32  userid;        //������û�id,����Ϊ0(������id)
		int16   userlefttime;  //���û�ʣ��ʱ��,
	}CMDRoomPubMicState_t;

	//�������������֪ͨ��������,Ŀǰ�޿�ƽ̨�Ĵ�����(�ͻ������ֻ��һ��ƽ̨)
	typedef struct tag_CMDRoomChatMsg
	{
		uint32 vcbid;      //roomId
		uint32 tocbid;		//new
		uint32 srcid;
		uint32 toid;
		byte srcviplevel;  //�û���viplevel,�Թ㲥��Ϣ����(ǰ׺ͼ��)
		//msgtype����:
		//0-����������Ϣ,1-�����ڹ㲥��Ϣ,2-��ӭ����Ϣ(�յ�����Ϣ�������Զ��ظ�)��3-С������Ϣ(����),4-����������Ϣ,5-����,
		//8-�����ȡ�㲥������Ϣ,10-������˽���Ϣ(��С���ȴ���),11-�Զ��ظ���Ϣ(�յ�����Ϣ�������Զ��ظ�)
		//13-��ɫ����(��������Ŀ��:������ֻ�ڹ�������ʾ),14��������Сֽ����Ϣ(���Լ�˽�Ĵ���),15-������˽����Ϣ 16-�����л
		//20-ϵͳ�㲥��Ϣ
		byte msgtype;      //˽������Ҳ�ڷ�����
		uint16 textlen;    //�������ݳ���
		char   srcalias[NAMELEN];
		char   toalias[NAMELEN];
		char   vcbname[NAMELEN];
		char   tocbname[NAMELEN];//new
		char   content[0];  //��������
	}CMDRoomChatMsg_t;

	//���乫���������
	typedef struct tag_CMDRoomNotice
	{
		uint32 vcbid;     //roomId
		byte   index;     //���乫������idx:0~2(0,1,2)
		uint16 textlen;   //���乫�泤��
		char   content[0];
	}CMDRoomNotice_t;

	//ϵͳ�����������
	//ϵͳ������Ϣ,ע�ⵥ��ʹ�ã����н�����ʾС����,����һ�������������ʾ
	typedef struct tag_CMDSysCastNotice
	{
		byte msgtype;   //��������
		byte reserve;
		uint16 textlen;  //���ֳ���
		char content[0];
	}CMDSysCastNotice_t;
	//msgtype:
	//1-���������д���ʾ,2-����Ϸ��ӮǮ��ʾ, 3-һ���ͳ�������������ʾ, 4-׼�������̻���ʾ
	//5-����ϵͳ������Ϣ(ϵͳ����)

	//���������Ա�б��������
	typedef struct tag_CMDRoomManagerInfo
	{
		uint32 vcbid;
		uint16 num;        //����Ա(����)��Ŀ
		uint32 members[0];
	}CMDRoomManagerInfo_t;

	//�ʻ�������Ϣ
	//����Ϣ����˵��,һ�������Ӧ�� (ͬƽ̨,ͬ������Ӧ��),����������Ʊ��
	typedef struct tag_CMDTradeFlowerRecord
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		uint32 giftid;    //�ʻ�����id
		uint32 sendnum;   //��Ŀ,Ĭ��Ϊ1
		uint32 allnum;    //����,�յ�����¿ͻ���
		char   srcalias[NAMELEN];
		char   toalias[NAMELEN];
	}CMDTradeFlowerRecord_t;

	typedef struct tag_CMDUserExitRoomInfo_ext
	{
		uint32 userid;
		uint32 vcbid;
		uint16 textlen;     // the length of content
		char   content[0];   //user ip and gate ip
	}CMDUserExitRoomInfo_ext_t;

	//�û��˳����������֪ͨ��������
	typedef struct tag_CMDUserExceptExitRoomInfo
	{
		uint32 userid;
		uint32 vcbid;
	}CMDUserExceptExitRoomInfo_t;

	//�û��ʻ���Ϣ����(��ѯ)
	typedef struct tag_CMDQueryUserAccountReq
	{
		uint32  vcbid;
		uint32  userid;
	}CMDQueryUserAccountReq_t;

	typedef struct tag_CMDQueryUserAccountResp
	{
		uint32 vcbid;   //�û����ڵķ���
		uint32 userid;
		int64 nk;       //
		int64 nb;
		int64 nkdeposit;
	}CMDQueryUserAccountResp_t;

	//�û��ʻ���Ϣ(Ӧ��,֪ͨ)
	typedef struct tag_CMDUserAccountInfo
	{
		uint32 vcbid;   //�û����ڵķ���
		uint32 userid;
		int64 nk;       //
		int64 nb;
		uint32 dtime;   //ʱ��
	}CMDUserAccountInfo_t;

	//���״̬�ṹ��
	//�û��ϡ�����ʱʹ��,2013.09.10 ʹ���µķ�ʽ,������ֱ�ӱ������,�����Ǵ���ʱ�ϱ������,��ô�˴α������Ĳ�������ʱ(ɾ������id)?
	// ����,����ͳһ,���������ģʽ��(�������������),���û����ǰ��û��ŵ������б��еĵ�һ��(�ȴ��Զ�ת��?)
	// ����,����, ����ģʽ�¾�û�б�����?
	typedef struct tag_CMDUserMicState
	{
		uint32 vcbid;
		uint32 runid;
		uint32 toid;      //�����û�
		int32  giftid;    //ʹ������id
		int32  giftnum;   //����num
		char   micstate;  //���״̬,ע���������״̬��־
		char   micindex;  //������(notify��������),���޸�,����ʱ����ָ������(����ʱ0~2), -1:��ָ��
		char   optype;    //��������,ע��: �����˸��ֶκ�ͱ�ʾ�������Ǽ򵥵�������
		//gcz++ Ҫ�¼Ӳ���,�ǲ��Ǵ�������(�ڼ���micid, 0-��ʾ����, 1..n ���ǵڼ�����id) ת�ɹ����(�����newmic=����)
		char   reserve11; //�հ�
	}CMDUserMicState_t;

	//�豸״̬�ṹ��
	//�������ر���˷�
	typedef struct tag_CMDUserDevState
	{
		uint32 vcbid;
		uint32 userid;
		byte   audiostate;  //�豸״̬ 0-������, 1-�������뾲�� (�û���ֹshare),2-����δ����(����)
		byte   videostate;  //�豸״̬,0-������, 3-����Ƶ�豸 ,2-����Ƶ�豸(����)�� 1-��Ƶ����(����Ƶ�豸,�������߽�ֹ��������)(�û���ֹshare)
		uint32 userinroomstate;  //���ºϼ�״̬(�ͻ��˸�����Ҫ����)
	}CMDUserDevState_t;

	//�û��ǳƸ��� (req,resp,noty��ʹ�øýṹ)
	typedef struct tag_CMDUserAliasState
	{
		uint32 vcbid;
		uint32 userid;
		uint32 headid;
		char   alias[NAMELEN];
	}CMDUserAliasState_t;

	// ����Ƶ������Ϣ
	typedef struct tag_CMDTransMediaInfo
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 toid;
		byte   action;  //������1��ʾ����򿪶Է�����Ƶ��3��ʾ����رնԷ�����Ƶ��
		byte   vvflag;  //vv��־
	}CMDTransMediaInfo_t;

	//�޸ķ���ý��URL������Ϣ
	typedef struct tag_CMDRoomMediaInfo
	{
		uint32 vcbid;
		uint32 userid;
		char caddr[MEDIAADDRLEN];  //ý�������URL
	}CMDRoomMediaInfo_t;

	//���ù���״̬��������Ϣ
	typedef struct tag_CMDChangePubMicStateReq
	{
		uint32 vcbid;
		uint32 runnerid;   //������Աid
		byte   micid;      //����id
		byte   optype;     //��������:1-�ӳٵ�ǰ�û���ʱ��,2-����������
		int16  param1;     //��ʱ���� ���ӳ�ʱ��(��)
	}CMDChangePubMicStateReq_t;

	//���ù���״̬����Ӧ/������Ϣ
	typedef struct tag_CMDChangePubMicStateResp
	{
		uint32  vcbid;
		int32   errorid;    //�������
	}CMDChangePubMicStateResp_t;

	//���ù���״̬��֪ͨ��Ϣ
	typedef struct tag_CMDChangePubMicStateNoty
	{
		uint32  vcbid;
		uint32  runnerid;      //������Աid
		byte    micid;
		byte    optype;        //ͬ����Ĳ�������
		int16   param1;        //��ʱ���� ���ӳ�ʱ��(��)
		uint32  userid;        //������û�id,����Ϊ0
		int16   userlefttime;  //���û�ʣ��ʱ��,
	}CMDChangePubMicStateNoty_t;

	//gch++
	typedef struct tag_CMDUpWaitMic
	{
		uint32  vcbid;
		uint32  ruunerid;
		uint32  touser;
		int32   nmicindex;   //-1,Ĭ��(�������һ��);1-ͬʱ���뵽��һ��
	}CMDUpWaitMic_t;

	//���������û�index������
	typedef struct tag_CMDOperateWaitMic
	{
		uint32  vcbid;
		uint32  ruunerid;
		uint32  userid;
		int16   micid;      //���û��ĵڼ�������
		int     optype;     //��������: -3,�����������?,-2 ɾ�����û�����������,-1,ɾ��������,1-up,2-down,3-top,4-button
	}CMDOperateWaitMic_t;

	//���������û�index����Ӧ/������Ϣ
	typedef struct tag_CMDChangeWaitMicIndexResp
	{
		uint32  vcbid;
		int32   errorid;     //�������
	}CMDChangeWaitMicIndexResp_t;

	//���������û�index��֪ͨ��Ϣ
	typedef struct tag_CMDChangeWaitMicIndexNoty
	{
		uint32 vcbid;
		uint32 ruunerid;
		uint32 userid;
		int16  micid;      //���û��ĵڼ�������
		int    optype;     //��������: -3,�����������������?,-2 ɾ�����û�����������,-1,ɾ��������,1-up,2-down,3-top,4-button
	}CMDChangeWaitMicIndexNoty_t;

	//���û������������Ϣ
	typedef struct tag_CMDLootUserMicReq
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 userid;
		int16  micid;     //���û����ڵĹ���id
	}CMDLootUserMicReq_t;

	//���û��������Ӧ/������Ϣ
	typedef struct tag_CMDLootUserMicResp
	{
		uint32 vcbid;
		int32  errorid;    //�������
	}CMDLootUserMicResp_t;

	//���û������֪ͨ��Ϣ
	typedef struct tag_CMDLootUserMicNoty
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 userid;
		int16  micid;   
	}CMDLootUserMicNoty_t;

		//���÷�����Ϣ��������Ϣ
	typedef struct tag_CMDSetRoomInfoReq
	{
		uint32 vcbid;   //ֻ��
		uint32 runnerid;
		uint32 creatorid;
		uint32 op1id;
		uint32 op2id;
		uint32 op3id;
		uint32 op4id;
		int    busepwd; //�Ƿ���������
		char   cname[NAMELEN]; //������
		char   cpwd[PWDLEN];  //����(������)
	}CMDSetRoomInfoReq_t;

	//���÷�������״̬/���Ե�������Ϣ
	typedef struct tag_CMDSetRoomOPStatusReq
	{
		uint32 vcbid;
		uint32 runnerid;
		uint32 opstatus;
	}CMDSetRoomOPStatusReq_t;

	//���÷�������״̬/���Ե�Ӧ����Ϣ
	typedef struct tag_CMDSetRoomOPStatusResp
	{
		uint32 vcbid;
		int32  errorid;    //�������
	}CMDSetRoomOPStatusResp_t;

	//���÷��乫���������Ϣ
	typedef struct tag_CMDSetRoomNoticeReq
	{
		uint32 vcbid;
		uint32 ruunerid;
		byte   index;       //���乫������idx:0~2(0,1,2)
		uint16 textlen;     //���乫�泤��
		char   content[0];   //��������
	}CMDSetRoomNoticeReq_t;

	//���÷��乫���Ӧ����Ϣ
	typedef struct tag_CMDSetRoomNoticeResp
	{
		uint32 vcbid;
		int32  errorid;    //�������
	}CMDSetRoomNoticeResp_t;

	//��������ͱ�����֪ͨ/�㲥��������
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

	//�н�����֪ͨ��Ϣ
	//����Ϣֻ����ͬ�����ڹ㲥,��˲���Ҫsrcalias,����������20���н�,������ظ����н���(��10������2��),
	//���ʹ����������ݽṹ,����Ǳ䳤���н����ݡ�
	typedef struct tag_CMDLotteryGiftNotice
	{
		uint32 vcbid;   //����id
		uint32 srcid;   //userid
		uint16 giftid;  //����id
		uint16 noddsnum;   //�������н���¼��Ŀ
		char content[0];   //�н�����:[int16|int16]... ����|����
	}CMDLotteryGiftNotice_t;

	//�н���ը����֪ͨ��Ϣ
	typedef struct tag_CMDBoomGiftNotice
	{
		uint32 vcbid;
		uint32 srcid;
		uint32 giftid; //����id
		int    beishu; //����
		uint64 winmoney;  //��ը�н��ܶ�
	}CMDBoomGiftNotice_t;

	//���˽���֪ͨ��Ϣ
	typedef struct tag_CMDLotteryPoolInfo
	{
		uint64 nlotterypool;
	}CMDLotteryPoolInfo_t;

	//���̻���Ǯ������Ϣ
	typedef struct tag_CMDTradeFireworksReq
	{
		uint32 vcbid;
		uint32 srcid;
		uint16 giftid;   
		uint16 giftnum;
		uint16 sendtype;   //1.���̻�,2.С�̻�
		char   srcalias[NAMELEN]; 
	}CMDTradeFireworksReq_t;

	//���̵�֪ͨ��Ϣ
	typedef struct tag_CMDTradeFireworksNotify
	{ 
		uint32 vcbid;
		uint32 srcid;
		uint16 giftid;   
		uint16 giftnum;
		uint16 sendtype;   //1.���̻�,2.С�̻�
		char   srcalias[NAMELEN]; 
	}CMDTradeFireworksNotify_t;

	typedef struct tag_CMDTradeFireworksErr
	{ 
		uint32 vcbid;
		uint32 userid;
		uint32 giftid;
		int32  errid;
	}CMDTradeFireworksErr_t;

	//���д�ȡ��
	typedef struct tag_CMDMoneyAndPointOp
	{
		uint32 vcbid;
		uint32 srcid; 
		uint32 touserid;   //3-�õ�
		int64 data;        //���/������Ŀ
		uint8 optype;      //1 ���д�� 2 ����ȡ��   3 ת��  4 ���ֶһ����
	}CMDMoneyAndPointOp_t;

	typedef struct tag_CMDSetRoomWaitMicMaxNumLimit
	{
		uint32 vcbid;
		uint32 runnerid; 
		uint32 maxwaitmicuser; //�����������
		uint32 maxuserwaitmic; //ÿ������������
	}CMDSetRoomWaitMicMaxNumLimit_t;

	typedef struct tag_CMDSetForbidInviteUpMic
	{
		uint32 vcbid;
		uint32 userid;
		int32  reserve;
	}CMDSetForbidInviteUpMic_t;

	typedef struct tag_CMDPropsFlashPlayTaskItem
	{
		short nTaskType;
		short nArg;
	}CMDPropsFlashPlayTaskItem_t;//, *PPropsFlashPlayTaskItem_t;

	//��ѯ���������Ϣ
	typedef struct tag_CMDQueryVcbExistReq
	{
		uint32 vcbid;
		uint32 userid;
		uint32 queryvcbid;   //Ҫ��ѯ��vcbid
	}CMDQueryVcbExistReq_t;

	typedef struct tag_CMDQueryVcbExistResp
	{
		int32 errorid;  //0-û�д���
		uint32 vcbid;
		uint32 userid;
		uint32 queryvcbid;
		char   cqueryvcbname[NAMELEN];
	}CMDQueryVcbExistResp_t;

	//�鿴�û��Ƿ������Ϣ
	typedef struct tag_CMDQueryUserExistReq
	{
		uint32 vcbid;   
		uint32 userid; 
		uint32 queryuserid;  //Ҫ��ѯ��userid
		uint32 specvcbid;   //Ҫ��ָ���ķ����ѯ
	}CMDQueryUserExistReq_t;

	typedef struct tag_CMDQueryUserExistResp
	{
		int32 errorid;  //0-û�д���
		uint32 vcbid;   
		uint32 userid;
		uint32 queryuserid;
		uint32 specvcbid; 
		byte   queryuserviplevel;
		char   cspecvcbname[NAMELEN];  //���ָ������
		char   cqueryuseralias[NAMELEN];
	}CMDQueryUserExistResp_t;

	typedef struct tag_CMDOpenChestReq
	{
		uint32 vcbid;
		uint32 userid;
		int32  openresult_type;   //��������, 0-����, 1-ȫ��
	}CMDOpenChestReq_t;

	typedef struct tag_CMDOpenChestResp
	{
		int32 errorid;   //���� !=0
		uint32 vcbid;
		uint32 userid;
		int32 usedchestnum;   //ʹ�õ��ı���
		int32 remainchestnum;  //ʣ��ı���
		int32 openresult_type;   //�������� - ��Ӧ����������
		int32 openresult_0;      //���ν��������idx
		int32 openresult_1[7];   //7������Ĵ���,ע��,�صȽ�ֻ�����һ��
		int64 poolvalue;         //ʣ�ཱ����Ŀ
		int64 tedengvalue;       //�صȽ����
	}CMDOpenChestResp_t;

	typedef struct tag_CMDMobZhuboInfo
	{
		uint32 vcbid;
		uint32 userid;
		char   alias[NAMELEN];
		char   headurl[URLLEN];
	}CMDMobZhuboInfo_t;

	//3.3 gch++ �û��Ƹ��������еȼ�ʵʱ����
	typedef struct tag_CMDUserCaifuCostLevelInfo
	{
		uint32 userid;
		uint32 vcbid;
		int32  ncaifulevel;
		int32  nlastmonthcostlevel;    //������������
		int32  nthismonthcostlevel;    //������������
		int32  nthismonthcostgrade;    //�����ۼ����ѵȼ�
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

	typedef struct tag_CMDSetUserHideStateResp
	{
		uint32 errorid;   //����id
	}CMDSetUserHideStateResp_t;

	typedef struct tag_CMDSetUserHideStateNoty
	{
		uint32 userid;
		uint32 vcbid;
		uint32 inroomstate;  //����״̬
	}CMDSetUserHideStateNoty_t;

	typedef struct tag_CMDUserAddChestNumNoty
	{
		uint32 userid;
		uint32 vcbid;
		uint32 addchestnum; //����������Ŀ
		uint32 totalchestnum; //���б���
	}CMDUserAddChestNumNoty_t;

	//�н���������
	typedef struct tag_CMDJiangCiShu
	{
		int beishu;
		int count;
	}CMDJiangCiShu_t;

	//��������֪ͨ
	typedef struct tag_CMDAddClosedFriendNotify
	{
		uint32 userid;
		uint32 vcbid;
	}CMDAddClosedFriendNotify_t;

	// �ؼ�������
	typedef struct tag_CMDAdKeywordInfo
	{
		int		naction;				//0-ˢ�� 1-���� 2-ɾ��
		int		ntype;					//�������
		int		nrunerid;				//������Id
		char	createtime[32];			//����ʱ��
		char	keyword[64];			//�ؼ���
	}CMDAdKeywordInfo_t;

	//��ʦ������
	typedef struct tag_CMDTeacherScoreReq
	{
		uint32 teacher_userid;             //��ʦID
		char  teacheralias[NAMELEN]; //��ʦ�س�
		uint32  vcbid;                //���ڷ���id
		int64 data1;                  //�����ֶ�1
		char   data2[NAMELEN];        //�����ֶ�2
	}CMDTeacherScoreReq_t;

	//��ʦ�����ֽ��
	typedef struct tag_CMDTeacherScoreResp
	{
		int    type;                  //�����Ƿ�ɹ�
		uint32 teacher_userid;             //��ʦID
		char   teacheralias[NAMELEN]; //��ʦ�س�
		int    vcbid;                 //����id����������ӷ���
	}CMDTeacherScoreResp_t;

	//��ʦ��ּ�¼
	typedef struct tag_CMDTeacherScoreRecordReq
	{
		uint32 teacher_userid;             //��ʦID
		char   teacheralias[NAMELEN]; //��ʦ�س�
		uint32 userid;                //�����ID
		char   alias[NAMELEN];        //������س�
		byte   usertype;              //��ʦ����: 0-��ͨ 1-������
		uint32 score;                 //����
		char   logtime[NAMELEN];      //���ʱ��
		uint32  vcbid;                //���ڷ���id
		int64 data1;                  //�����ֶ�1
		int64 data2;                  //�����ֶ�2
		int64 data3;                  //�����ֶ�3
		char   data4[NAMELEN];        //�����ֶ�4
		char   data5[NAMELEN];        //�����ֶ�5
	}CMDTeacherScoreRecordReq_t;

	//��ʦ��ֽ��
	typedef struct tag_CMDTeacherScoreRecordResp
	{
		uint32 teacher_userid;             //��ʦID
		char   teacheralias[NAMELEN]; //��ʦ�س�
		int    type;                  //�����Ƿ�ɹ�
	}CMDTeacherScoreRecordResp_t;

	//�����˶�Ӧ��ʦID֪ͨ
	typedef struct tag_CMDRobotTeacherIdNoty
	{
		uint32 vcbid;	//����id
		uint32 roborid;//������id
		uint32 teacherid;             //��ʦID
	}CMDRobotTeacherIdNoty_t;

	//��ʦ��ʵ���ܰ�����
	typedef struct tag_CMDTeacherGiftListReq
	{
		uint32 vcbid;					//����id
		uint32 teacherid;				//��ʦID
	}CMDTeacherGiftListReq_t;

	//��ʦ��ʵ���ܰ���Ӧ
	typedef struct tag_CMDTeacherGiftListResp
	{
		uint32 seqid;                   //������Ҳ����ȥ
		uint32 vcbid;					//����id
		uint32 teacherid;				//��ʦID
		char useralias[NAMELEN];	    //�û��ǳ�
		uint64 t_num;					//��ʵ��ֵ
	}CMDTeacherGiftListResp_t;

	//�û����뷿����߽�ʦ���󣬴���һ��������ӷ���ID
	typedef struct tag_CMDRoomAndSubRoomIdNoty
	{
		uint32 roomid;                 //������ID
		uint32 subroomid;              //�ӷ���ID
	}CMDRoomAndSubRoomIdNoty_t;

	typedef struct tag_CMDTeacherAvarageScoreNoty
	{
		uint32 teacherid;
		uint32 roomid;
		float avarage_score;
		char data1[NAMELEN]; //�����ֶ�1
		uint32 data2; //�����ֶ�2
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

	//web������𵰵�֪ͨ��Ϣ
	typedef struct tag_CMDHitGoldEggWebNoty
	{
		uint32 vcbid;
		uint32 userid;
	}CMDHitGoldEggWebNoty_t;

	//�û��Խ�ʦ��������Ӧ
	typedef struct tag_CMDUserScoreNoty
	{
		uint32 vcbid;					//�����
		uint32 teacherid;				//��ʦID
		int32 score;					//�û��Խ�ʦ������
		int32 userid;					//�û�ID
	}CMDUserScoreNoty_t;

	//����ͻ��˵�������Ϣ������gate��roomsvr�Ͽ�ʱ��
	typedef struct tag_CMDResetConnInfo
	{
		uint32 vcbid;					//�����
		int32 userid;					//�û�ID
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
		char   cIpAddr[IPADDRLEN];  //ip��ַ
	}CMDLogonStasticsReq_t;

	//�ն˵�¼��Ϣ
	typedef struct tag_CMDLogonClientInf
	{
		uint32 m_userid;
		byte   m_bmobile;
		uint32 m_logontime;
	}CMDLogonClientInf_t;

	typedef struct tag_CMDClientExistNoty
	{
		uint32 userid;             //�û�ID
		byte m_ntype;                //�˳�����0 �ظ���¼
	}CMDClientExistNoty_t;

	//��������ϵͳ����
	typedef struct tag_CMDSyscast
	{
		uint8 newType;  //0 һ�������� 1
		uint64   nid;        //��¼ID
		char   title[32];    
		char   content[512]; 
	}CMDSyscast_t;

	//�����ɱ
	typedef struct tag_CMDRelieveUserInfo
	{
		uint8   nscopeid;       //��ɱ��Χ :1-����,2-ȫվ
		uint32 vcbid;			//�������ڵķ���
		uint32 runnerid;		//������
		uint32 toid;			//���ID
		uint8	isRelieve;		//true:���ɹ�	false:δ���
	}CMDRelieveUserInfo_t;

	typedef struct tag_CMDMgrRefreshList
	{
		uint32 vcbid;		//����ID
		uint32 userid;		//�û�ID
		char	name[20];	//�û�����
		uint32 srcid;		//������
		int    actionid;  //1:���� 2:������ 3:����
	}CMDMgrRefreshList_t;

	//��ѯ����״̬
	typedef struct tag_CMDTeacherSubscriptionStateQueryReq
	{
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		uint32 userid;
		uint32 teacherid;
	}CMDTeacherSubscriptionStateQueryReq_t;

	typedef struct tag_CMDTeacherSubscriptionStateQueryResp
	{
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		uint32 userid;
		uint8  state;//����״̬ 0:δ���� 1:�Ѷ���
	}CMDTeacherSubscriptionStateQueryResp_t;

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
		FT_ROOMUSER_STATUS_PUBLIC_MIC     = 0x00000001,   //����״̬(�κ��˿�������)
		FT_ROOMUSER_STATUS_PRIVE_MIC      = 0x00000002,   //˽��״̬(�κ��˿�������)
		FT_ROOMUSER_STATUS_SECRET_MIC     = 0x00000004,   //����״̬(����ʱֻ�к����Զ�ͨ������,�����ܾ�,�������ڶ�ҪҪ����֤ͬ��)
		FT_ROOMUSER_STATUS_CHARGE_MIC     = 0x00000010,    //�շ�״̬ (�����շ���)


		//mask:0xF0
		FT_ROOMUSER_STATUS_IS_TEMPOP      = 0x00000020,    //��ʱ���� ��ʶ
		FT_ROOMUSER_STATUS_IS_PIG         = 0x00000040,    //�Ƿ�����ͷ? ��ʶ
		FT_ROOMUSER_STATUS_IS_FORBID      = 0x00000080,    //������(�û�������,����,����˵��,���ܷ���С����) ��ʶ,���Ա����

		//mask:0x0F00(device), �����µ�mic״̬:�շ����� (2012.04.05 by guchengzhi)
		FT_ROOMUSER_STATUS_VIDEOON        = 0x00000100,    //��Ƶ�� (����Ƶ�豸,���Է�������)
		FT_ROOMUSER_STATUS_MICOFF         = 0x00000200,    //��˹ر� (���󣬵���������)
		FT_ROOMUSER_STATUS_VIDEOOFF       = 0x00000400,    //��Ƶ�ر� (����Ƶ�豸������������)
		FT_ROOMUSER_STATUS_IS_HIDE        = 0x00000800,    //����(�ڵ�¼ʱʹ�����������ֶν��г���������뷿�������Ĭ���������)


		//mask: ����(0xF000)
		FT_ROOMUSER_STATUS_IS_SIEGE1      = 0x00002000,    //��ʶ
		FT_ROOMUSER_STATUS_IS_SIEGE2      = 0x00004000,

		//mask: ����(0xF0000)
		FT_ROOMUSER_STATUS_IS_QUZHUANG    = 0x00010000,    //����

	}E_USER_INROOM_STATE;

	typedef enum
	{
		FT_ROOMOPSTATUS_CLOSE_PUBCHAT     = 0x00000001,   //�رչ���/��ֹ����ظ�
		FT_ROOMOPSTATUS_CLOSE_PRIVATECHAT = 0x00000002,   //�ر�˽��/��ֹ�ʹ�
		FT_ROOMOPSTATUS_CLOSE_SAIZI       = 0x00000004,   //�ر�����
		FT_ROOMOPSTATUS_CLOSE_PUBMIC      = 0x00000010,   //�رչ��� (��������)
		FT_ROOMOPSTATUS_CLOSE_PRIVATEMIC  = 0x00000020,   //�ر�˽�� (��������)
		FT_ROOMOPSTATUS_OPEN_AUTOPUBMIC   = 0x00000040,   //�������Զ��Ϲ���
		FT_ROOMOPSTATUS_OPEN_WAITMIC      = 0x00000080,   //��������
		FT_ROOMOPSTATUS_CLOSE_COLORBAR    = 0x00000100,   //���β���
		FT_ROOMOPSTATUS_CLOSE_FREEMIC     = 0x00000200,   //��������/��ֹ����
		FT_ROOMOPSTATUS_CLOSE_INOUTMSG    = 0x00000400,   //�����û�������Ϣ
		FT_ROOMOPSTATUS_CLOSE_ROOM        = 0x00000800,   //�ر�������/���λ�������

	}E_ROOM_OP_STATE;


	typedef enum
	{
		FT_SCOPE_ALL           = 0,     //gcz++ ����
		FT_SCOPE_ROOM          = 1,     //����
		FT_SCOPE_GLOBAL        = 2,     //gcz++ ȫ��
	}E_VIOLATIO_SCOPE;


}
#pragma pack()

#endif
