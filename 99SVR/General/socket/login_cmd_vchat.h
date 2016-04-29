// �޸��
//1. λ��
//2. ������Ϣ Ԥ����ȥ�����ֶ�
//3. typedef struct ��
//4. unsigned char/ long long
//5. ö������
//6. int���� openresult_1 members

#ifndef __CMD_LOGIN_VCHAT_H__
#define __CMD_LOGIN_VCHAT_H__

#include "yc_datatypes.h"

#define MAXSTARSIZE		  16  //���ǵ������Ŀ����
//#define __SWITCH_SERVER2__ 
//-----------------------------------------------------------
#pragma pack(1)

namespace protocol
{
	typedef struct tag_CMDUserLogonReq
	{
		uint32 userid;          //0-�ο͵�½,����������ID
		uint32 nversion;        //���ذ汾��?
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		char   cuserpwd[PWDLEN];    //��¼����,�ο͵�¼����Ҫ����,�����뽫����md5����
		char   cSerial[64];  //uuid
		char   cMacAddr[IPADDRLEN]; //mac��ַ
		byte   nimstate;        //IM״̬:�������¼
		byte   nmobile;         //1-�ֻ���¼?
	}CMDUserLogonReq_t;

	typedef struct tag_CMDUserLogonReq2
	{
		uint32 userid;          //0-�ο͵�½,����������ID
		uint32 nversion;        //���ذ汾��?
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		char   cuserpwd[PWDLEN];    //��¼����,�ο͵�¼����Ҫ����,�����뽫����md5����
		char   cSerial[IPADDRLEN];  //uuid
		char   cMacAddr[IPADDRLEN]; //mac��ַ
		char   cIpAddr[IPADDRLEN];  //ip��ַ
		byte   nimstate;        //IM״̬:�������¼
		byte   nmobile;         //1-�ֻ���¼?
	}CMDUserLogonReq2_t;

	typedef struct tag_CMDUserLogonReq3
	{
		uint32 userid;          //0-�ο͵�½,����������ID
		uint32 nversion;        //���ذ汾��?
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		char   cuserpwd[PWDLEN];    //��¼����,�ο͵�¼����Ҫ����,�����뽫����md5����
		char   cSerial[64];  //uuid
		char   cMacAddr[IPADDRLEN]; //mac��ַ
		char   cIpAddr[IPADDRLEN];  //ip��ַ
		byte   nimstate;        //IM״̬:�������¼
		byte   nmobile;         //1-�ֻ���¼?
	}CMDUserLogonReq3_t;

	typedef struct tag_CMDUserLogonReq4
	{
		uint32 nmessageid;      //message id
		char   cloginid[32];    //[0]-�ο͵�½
		uint32 nversion;        //���ذ汾��?
		uint32 nmask;           //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp,
		char   cuserpwd[PWDLEN];    //��¼����,�ο͵�¼����Ҫ����,�����뽫����md5����
		char   cSerial[64];  //uuid
		char   cMacAddr[IPADDRLEN]; //mac��ַ
		char   cIpAddr[IPADDRLEN];  //ip��ַ
		byte   nimstate;        //IM״̬:�������¼
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
		uint32 nversion;            //���ذ汾��?
		uint32 nmask;               //��ʾ,���ڿͻ�����֤�ǲ����Լ�������resp
		char   cSerial[64];         //uuid
		char   cMacAddr[IPADDRLEN]; //mac��ַ
		char   cIpAddr[IPADDRLEN];  //ip��ַ
		byte   nimstate;            //IM״̬:�������¼
		byte   nmobile;             //0-PC,1-Android,2-IOS,3-web
	}CMDUserLogonReq5_t;

	//��¼������Ϣ
	//4 bytes
	typedef struct tag_CMDUserLogonErr
	{
		uint32 errid;       //����id,�ͻ��˱����жϴ���,�����汾����(��Ҫ����),��ɱ
		uint32 data1;       //����1
		uint32 data2;       //����2
	}CMDUserLogonErr_t;

	//��¼������Ϣ
	typedef struct tag_CMDUserLogonErr2
	{
		uint32 nmessageid;  //message id
		uint32 errid;       //����id,�ͻ��˱����жϴ���,�����汾����(��Ҫ����),��ɱ
		uint32 data1;       //����1
		uint32 data2;       //����2
	}CMDUserLogonErr2_t;

	//�û�Ȩ����Ӧ��Ϣ(10 bytes)
	typedef struct tag_CMDUserQuanxianInfo
	{
		uint8 qxid;
		uint8 qxtype;
		uint32 srclevel;
		uint32 tolevel;
	}CMDUserQuanxianInfo_t;

	//��¼�ɹ���Ӧ��Ϣ
	//71 bytess
	typedef struct tag_CMDUserLogonSuccess
	{
		int64 nk;                    //���
		int64 nb;                    //�������,���Ի���һ�һ�RMB
		int64 nd;                    //��Ϸ��
		uint32 nmask;                 //��־λ, ���ڿͻ�����֤�ǲ����Լ�������resp,
		uint32 userid;                //����
		uint32 langid;                //����id
		uint32 langidexptime;         //����id����ʱ��
		uint32 servertime;            //������ʱ��,��ʾ�ͻ���,��������֮���ʱ��鿴
		uint32 version;               //�������汾��,������������ͬ������µ�½�ɹ����ط�����DB�еİ汾��
		uint32 headid;                //�û�ͷ��id
		byte   viplevel;              //��Ա�ȼ�(��������ʱ�ȼ�)
		byte   yiyuanlevel;           //��Ա�ȼ�,��
		byte   shoufulevel;           //�ػ��ߵȼ�
		byte   zhonglevel;            //�����ȼ�,��������(1~150)
		byte   caifulevel;            //�Ƹ��ȼ�
		byte   lastmonthcostlevel;     //������������
		byte   thismonthcostlevel;     //������������
		byte   thismonthcostgrade;    //�����ۼ����ѵȼ�
		byte   ngender;               //�Ա�
		byte   blangidexp;            //�����Ƿ����
		byte   bxiaoshou;             //�ǲ������۱�־
		char   cuseralias[NAMELEN];   //�س�
	}CMDUserLogonSuccess_t;

	typedef struct tag_CMDUserLogonSuccess2
	{
		uint32 nmessageid;            //message id
		int64 nk;                     //���
		int64 nb;                     //�������,���Ի���һ�һ�RMB
		int64 nd;                     //��Ϸ��
		uint32 nmask;                 //��־λ, ���ڿͻ�����֤�ǲ����Լ�������resp,
		uint32 userid;                //����
		uint32 langid;                //����id
		uint32 langidexptime;         //����id����ʱ��
		uint32 servertime;            //������ʱ��,��ʾ�ͻ���,��������֮���ʱ��鿴
		uint32 version;               //�������汾��,������������ͬ������µ�½�ɹ����ط�����DB�еİ汾��
		uint32 headid;                //�û�ͷ��id
		byte   viplevel;              //��Ա�ȼ�(��������ʱ�ȼ�)
		byte   yiyuanlevel;           //��Ա�ȼ�,��
		byte   shoufulevel;           //�ػ��ߵȼ�
		byte   zhonglevel;            //�����ȼ�,��������(1~150)
		byte   caifulevel;            //�Ƹ��ȼ�
		byte   lastmonthcostlevel;    //������������
		byte   thismonthcostlevel;    //������������
		byte   thismonthcostgrade;    //�����ۼ����ѵȼ�
		byte   ngender;               //�Ա�
		byte   blangidexp;            //�����Ƿ����
		byte   bxiaoshou;             //�ǲ������۱�־
		char   cuseralias[NAMELEN];   //�س�
		byte   nloginflag;            //login flag
		byte   bloginSource;          //local 99 login or other platform login:0-local;1-other platform
		byte   bBoundTel;             //bound telephone number:0-not;1-yes.
		char   csid[48];              //sid for visit web
	}CMDUserLogonSuccess2_t;

	//�����û�����
	typedef struct tag_CMDSetUserProfileReq
	{
		uint32 userid;                 //�û�ID
		uint32 headid;                 //�û�ͷ��ID
		byte   ngender;                //�Ա�
		char   cbirthday[BIRTHLEN];    //����
		char   cuseralias[NAMELEN];    //�û��ǳ�
		char   province[16];           //ʡ��
		char   city[16];               //����
		int16  introducelen;           //����ǩ������
		char   introduce[0];             //��Ϣ���ݣ���ʽ������ǩ��
	}CMDSetUserProfileReq_t;

	typedef struct tag_CMDSetUserProfileResp
	{
		uint32 userid;
		int32  errorid;    //�������
	}CMDSetUserProfileResp_t;

	//�����û�����
	typedef struct tag_CMDSetUserPwdReq
	{
		uint32 userid;         //�û�id
		uint32 vcbid;          //0���������
		char   pwdtype;        //�������ͣ�1-�û���¼����,2-�û���������
		char   oldpwd[PWDLEN];     //������
		char   newpwd[PWDLEN];     //������
	}CMDSetUserPwdReq_t;

	typedef struct tag_CMDSetUserPwdResp
	{
		uint32 userid;
		uint32 vcbid;
		int    errorid;        //�������, 0-�޴���
		char   pwdtype;
		char   cnewpwd[PWDLEN];     //���óɹ���������
	}CMDSetUserPwdResp_t;

	//���󷿼����б���Ϣ
	//12...-bytes
	typedef struct tag_CMDRoomGroupListReq
	{
		uint32 userid;               //�����ߵ�id
	}CMDRooGroupListReq_t;

	//�������б�������� (�Ѿ�����õ�,��parent����[+������] һ����������,����У������php˵��)
	//29 + n bytes
	typedef struct tag_CMDRoomGroupItem
	{
		uint32 grouid;                //��id
		uint32 parentid;              //��id,0-û��
		int32  usernum;               //�û���Ŀ
		uint32 textcolor;             //������ɫ
		byte   reserve_1;
		byte   showusernum;           //�Ƿ���ʾ����
		byte   urllength;             //���ݳ���
		byte   bfontbold;             //�����Ƿ��Ǵ���
		char   cgroupname[NAMELEN];   //������
		char   clienticonname[NAMELEN];  //ͼ������
		char   content[0];            //URL����
	}CMDRoomGroupItem_t;

	//������״̬��Ϣ
	typedef struct tag_CMDRoomGroupStatus
	{
		uint32 grouid;                //��id
		uint32 usernum;               //������
	}CMDRoomGroupStatus_t;

	//���󷿼��б���Ϣ
	//4 bytes
	typedef struct tag_CMDRoomListReq
	{
		uint32 userid;               //�����ߵ�id
		uint32 ntype;                //-1,ָ��vcb_id�б�,>0,���Ƿ�����id
		uint32 nvcbcount;
		char   content[0];          //vcb_id�б�
	}CMDRoomListReq_t;

	//�����б��������
	//112 byte -- ����ʹ��,��Ȼʹ��web�ķ�ʽ����
	typedef struct tag_CMDRoomItem
	{
		uint32 roomid;            //����id
		uint32 creatorid;         //���䴴����id
		uint32 groupid;           //������id, ���ﲻ�ʺ�ʹ�ö�����ͬһ������ķ�ʽ,����Ƕ�����ͬһ������,Ӧ�õ����и���/�����Ӧ��
		uint32 flag;              //
		char   cname[NAMELEN];         //��������
		char   croompic[NAMELEN];      //����ͼƬ
		char   croomaddr[GATEADDRLEN];       //ֻ��һ��roomaddr,�������ص�ַ
	}CMDRoomItem_t;

	//gch++ �û���ϸ��Ϣ
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
		int32  errorid;    //�������
	}CMDSetUserMoreInfoResp_t;

	typedef struct tag_CMDQuanxianId2Item
	{
		int16 levelid;  //��(-)
		int16 quanxianid;  //��(-)
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

	//�û��˳������������ʾ
	typedef struct tag_CMDExitAlertReq
	{
		int32 userid;                      //�û�ID
	}CMDExitAlertReq_t;

	typedef struct tag_CMDExitAlertResp
	{
		int32 userid;
		char email[32];                 //����
		char qq[32];                    //qq����
		char tel[32];                   //�ֻ�����
		int32 hit_gold_egg_time;        //�������ҵ��Ĵ���
		int32 data1;
		int32 data2;
		int32 data3;
		char data4[32];
		char data5[32];
	}CMDExitAlertResp_t;

	//�û���ȫ��Ϣ��ѯ����
	typedef struct tag_CMDSecureInfoReq
	{
		int32 userid;                      //�û�ID
	}CMDSecureInfoReq_t;

	//�û���ȫ��Ϣ��ѯ��Ӧ
	typedef struct tag_CMDSecureInfoResp
	{
		char email[32];                 //����
		char qq[32];                    //qq����
		char tel[32];                   //�ֻ�����
		int32 remindtime;                 //�����Ѵ���
		int32 data1;
		int32 data2;
		int32 data3;
		char data4[32];
		char data5[32];
		char data6[32];
	}CMDSecureInfoResp_t;

	////////////////////////////////////////
	//����С������ѣ��������������ͣ�
	typedef struct tag_CMDMessageNoty
	{
		int32 userid;					//�û�ID
	}CMDMessageNoty_t;

	//����δ����¼������
	typedef struct tag_CMDMessageUnreadResp
	{
		int32 userid;				      //�û�ID
		int8  teacherflag;                //�Ƿ�ʦ��0-���ǣ�1-�ǣ�
		int32 chatcount;                  //�����ظ�δ����¼��
		int32 viewcount;                  //�۵�ظ�δ����¼��
		int32 answercount;                //�ʴ�����δ����¼��
		int32 syscount;                   //ϵͳ��Ϣδ����¼��
	}CMDMessageUnreadResp_t;

	//�鿴���䣨��ͬ����������ͬһ����Ϣ���ͼ��ṹ��
	typedef struct tag_CMDHallMessageReq
	{
		uint32 userid;                 //�û�ID
		int8   teacherflag;            //�Ƿ�ʦ��0-���ǣ�1-�ǣ�
		int16  type;                   //���ࣺ1.�����ظ���11.�յ��Ļ������û�����12.�����Ļ�������ʦ��������
		//2.�۵�ظ���21.�յ��Ĺ۵�ظ���22.�����Ĺ۵����ۣ�����
		//3.�ʴ����ѣ�31. δ�ش����ʣ�32.�ѻش����ʣ�����
		//4.�ҵĹ�ע��41.�ҵķ�˿��42.�ҵĹ�ע��43.����Ԥ�⣩��
		//5.ϵͳ��Ϣ��
		int64  messageid;              //����õ��������ϢID����һ��Ϊ0
		int32  startIndex;             //��ʼ����
		int16  count;                  //�����¼��
	}CMDHallMessageReq_t;

	//�鿴�����ظ����鿴�ʴ�����
	typedef struct tag_CMDInteractResp
	{
		int16  type;                   //���ࣺ�����ظ���11.�յ��Ļ������û�����12.�����Ļ�������ʦ�������� �ʴ����ѣ�31. δ�ش����ʣ�32.�ѻش����ʣ�����
		uint32 userid;                 //�����û�ID
		uint32 touserid;               //�����û�ID
		char   touseralias[NAMELEN];   //�����û��ǳ�
		uint32 touserheadid;           //�����û�ͷ��
		int64  messageid;              //��ϢID�����ڻظ�ʱ�ҵ���Ӧ�ļ�¼��
		int16  sortextlen;             //Դ���ݳ���
		int16  destextlen;             //�ظ����ݳ��ȣ�type=3ʱֵΪ0��ʾδ�ش�����ʣ������ʾ�ѻش�����ʣ�
		uint64 messagetime;            //�ظ�ʱ��(yyyymmddhhmmss)
		int8   commentstype;           //�ͻ������� 0:PC�� 1:��׿ 2:IOS  3:WEB
		char   content[0];             //��Ϣ���ݣ���ʽ��Դ����+�ظ�����
	}CMDInteractResp_t;

	//�ʴ�ظ�-��������
	typedef struct tag_CMDAnswerResp
	{
		int16   type;                   //���ࣺ�����ظ���11.�յ��Ļ������û�����12.�����Ļ�������ʦ�������� �ʴ����ѣ�31. δ�ش����ʣ�32.�ѻش����ʣ�����
		uint32  userid;                 //���͸�������û�ID
		uint32  touserid;               //�Զ��û�ID
		char    touseralias[NAMELEN];   //�����û��ǳ�
		uint32  touserheadid;           //�����û�ͷ��
		int64   messageid;              //��ϢID�����ڻظ�ʱ�ҵ���Ӧ�ļ�¼��
		int16   answerlen;             //�ظ����ݳ���
		int16   stokeidlen;             //��ƱID����
		int16   questionlen;           //���ⳤ��
		uint64  messagetime;           //�ظ�ʱ��(yyyymmddhhmmss)
		int8    commentstype;           //�ͻ������� 0:PC�� 1:��׿ 2:IOS  3:WEB
		char    content[0];             //��Ϣ���ݣ���ʽ���ش�+��ƱID+����
	}CMDAnswerResp_t;

	//�鿴�۵�ظ�
	typedef struct tag_CMDViewShowResp
	{
		int16  type;                   //���ࣺ �۵�ظ���21.�յ��Ĺ۵�ظ���22.�����Ĺ۵����ۣ�����
		uint32 userid;                 //�����û�ID
		uint32 touserid;               //�����û�ID
		char   useralias[NAMELEN];     //�����û��ǳ�
		uint32 userheadid;             //�����û�ͷ��
		int64  commentid;              //����ID�����ڻظ�ʱ�ҵ���Ӧ�ļ�¼��
		int16  viewTitlelen;           //�۵���ⳤ��
		int16  viewtextlen;            //�۵����ݳ���
		int16  srctextlen;             //�������ݳ���
		int16  replytextlen;           //�ظ����ݳ��ȣ������û�ֵΪ0��ʾ�����Ĺ۵����ۣ������ʾ�յ��Ĺ۵�ظ���
		//���ڽ�ʦֵΪ0��ʾ�յ��Ĺ۵����ۣ������ʾ�����Ĺ۵�ظ�;
		uint64 restime;                //�ظ�ʱ��
		int8   commentstype;           //�ͻ������� 0:PC�� 1:��׿ 2:IOS  3:WEB
		char   content[0];             //��Ϣ���ݣ���ʽ���۵����+�۵�����+��������+�ظ�����
	}CMDViewShowResp_t;

	//�鿴�ҵķ�˿
	typedef struct tag_CMDTeacherFansResp
	{
		uint32 teacherid;              //��ʦID
		uint32 userid;                 //�û�ID
		char   useralias[NAMELEN];     //�û��ǳ�
		uint32 userheadid;             //�û�ͷ��
	}CMDTeacherFansResp_t;

	//�鿴�ҵĹ�ע���ѹ�ע��ʦ��
	typedef struct tag_CMDInterestResp
	{
		uint32 userid;                 //�û�ID
		uint32 teacherid;              //��ʦID
		char   teacheralias[NAMELEN];  //��ʦ�ǳ�
		uint32 teacherheadid;          //��ʦͷ��
		int16  levellen;               //��ʦ�ȼ�����
		int16  labellen;               //��ʦ��ǩ����
		int16  introducelen;           //��ʦ��鳤��
		char   content[0];             //��Ϣ���ݣ���ʽ����ʦ�ȼ�+��ʦ��ǩ+��ʦ���
	}CMDInterestResp_t;

	//�鿴�ҵĹ�ע���޹�ע��ʦ��
	typedef struct tag_CMDUnInterestResp
	{
		uint32 userid;                 //�û�ID
		uint32 teacherid;              //��ʦID
		char   teacheralias[NAMELEN];  //��ʦ�ǳ�
		uint32 teacherheadid;          //��ʦͷ��
		int16  levellen;               //��ʦ�ȼ�����
		int16  labellen;               //��ʦ��ǩ����
		int16  goodatlen;              //��ʦ�ó����򳤶�
		int64  answers;                //�ѻش��������Ŀ
		char   content[0];             //��Ϣ���ݣ���ʽ����ʦ�ȼ�+��ʦ��ǩ+��ʦ�ó�����
	}CMDUnInterestResp_t;

	//�鿴����Ԥ�⣨�ѹ�ע�Ľ�ʦ��
	typedef struct tag_CMDTextLivePointListResp
	{
		uint32 userid;                 //�û�ID
		uint32 teacherid;              //��ʦID
		char   teacheralias[NAMELEN];  //��ʦ�ǳ�
		uint32 teacherheadid;          //��ʦͷ��
		int64  messageid;              //��ϢID
		int16  livetype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ;
		int16  textlen;                //��Ϣ����
		int8   commentstype;           //�ͻ������� 0:PC�� 1:��׿ 2:IOS  3:WEB
		uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
		char   content[0];             //��Ϣ����
	}CMDTextLivePointListResp_t;

	//�����ؼ������б�
	typedef struct tag_CMDHallSecretsListResp
	{
		int32  secretsid;              //�ؼ�ID
		char	 srcalias[NAMELEN];      //��ʦ�ǳ�
		int16  coverlittlelen;         //����Сͼ���Ƴ���
		int16  titlelen;               //�ؼ����ⳤ��
		int16  textlen;                //�ؼ���鳤��
		uint64 messagetime;            //����ʱ��(yyyymmdd)
		char  content[0];              //��Ϣ���ݣ���ʽ������Сͼ����+�ؼ�����+�ؼ����
	}CMDHallSecretsListResp_t;

	//ϵͳ��Ϣ���������б�
	typedef struct tag_CMDHallSystemInfoListResp
	{
		int32  systeminfosid;          //ϵͳ��ϢID
		int16  titlelen;               //���ⳤ��
		int16  linklen;         			 //���ӳ���
		int16  textlen;                //���ݳ���
		uint64 messagetime;            //����ʱ��(yyyymmdd)
		char  content[0];              //��Ϣ���ݣ���ʽ������+����+����
	}CMDHallSystemInfoListResp_t;
	/*---------------------------------------------------------------------------------*/


	//��ʦ�ظ��������۵�ظ��ͻش����ʣ�
	typedef struct tag_CMDViewAnswerReq
	{
		uint32 fromid;              //������
		uint32 toid;                //������
		int16  type;                //���ࣺ1.�����ظ���2.�۵�ظ���3.�ʴ����ѣ��������޻ظ���
		int64  messageid;           //��ϢID
		int16  textlen;             //�۵�ظ�����
		int8   commentstype;        //�ͻ������� 0:PC�� 1:��׿ 2:IOS  3:WEB
		char   content[0];          //�۵�ظ�����
	}CMDViewAnswerReq_t;

	//��ʦ�ظ���Ӧ
	typedef struct tag_CMDViewAnswerResp
	{
		int32 userid;				    //�û�ID
		int16 type;                     //���ࣺ1.�����ظ���2.�۵�ظ���3.�ʴ����ѣ�
		int64 messageid;                //�����ɹ��Ķ�Ӧ��ϢID
		int16 result;                   //�ظ��Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	}CMDViewAnswerResp_t;

	//��ע���޹�ע��ʦʱ�������н�ʦ�б������ע��
	typedef struct tag_CMDInterestForReq
	{
		uint32 userid;                 //�û�ID
		uint32 teacherid;              //��ʦID
		int16  optype;                 //�������ͣ�1�ǹ�ע��2��ȡ����ע
	}CMDInterestForReq_t;

	//��ע��Ӧ
	typedef struct tag_CMDInterestForResp
	{
		int32 userid;				  //�û�ID
		int16 result;                 //�ظ��Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	}CMDInterestForResp_t;

	//���ؽ�ʦ�ķ�˿����
	typedef struct tag_CMDFansCountReq
	{
		uint32 teacherid;              //��ʦID
	}CMDFansCountReq_t;

	typedef struct tag_CMDFansCountResp
	{
		uint32 teacherid;              //��ʦID
		uint64 fansCount;              //��˿����
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
		uint32 flags;    //�Զ��崫����������ش���
	}CMDQueryRoomGateAddrReq_t;

	typedef struct tag_CMDQueryRoomGateAddrResp
	{
		uint32 errorid;   //����id
		uint32 userid;
		uint32 roomid;
		uint32 flags;    //�Զ��崫�����
		int16 textlen;   //��ַ���ȱ䳤
		char content[0];
	}CMDQueryRoomGateAddrResp_t;


	typedef struct tag_CMDConfigSvrNoty
	{
		byte type;         //1����̬�������ݣ�2�������б�����
		uint32 data_ver;    //���ݵİ汾��
	}CMDConfigSvrNoty_t;

	typedef struct tag_CMDPushGateMask
	{
		uint32 userid;      //�û�ID���㲥�û���0
		byte termtype;     //��½���ͣ�0��PC��1��Android��2��IOS��3��Web��4���������ͣ�
		byte type;         //ҵ�����ͣ�1. ���÷���������;2. ֪ͨ�ͻ��˴�ӡ��־;3. �ͻ�����������;4. �ҽ�;5. Ʈ����ʾ;9.������Ϣ����
		byte needresp;      //�Ƿ���Ҫȷ��
		uint16 validtime;    //��Чʱ��
		byte versionflag;    //0�����У�1�����ڣ�2�����ڵ��ڣ�3��С�ڵ���
		uint32 version;     //�汾�ţ�0����û�а汾����
		uint16 length;      //����ҵ�����ݳ��ȣ������ҽ𵰽ṹ�峤��
		char content[0];    //����ҵ�����ݣ������ҽ𵰽ṹ������
	}CMDPushGateMask_t;

	typedef struct tag_CMDBayWindow
	{
		uint32  ntime;         //Ʈ��ʱ��
		char   title[64];     //Ʈ������
		uint16 contlen;       //Ʈ�����ݳ���
		uint8  urllen;        //���ӳ���
		char   content[0];    //Ʈ������+������Ϣ
	}CMDBayWindow_t;

	typedef struct tag_CMDGetUserMoreInfReq
	{
		uint32 userid;
	}CMDGetUserMoreInfReq_t;

	typedef struct tag_CMDGetUserMoreInfResp
	{
		char   tel[32];                   //�ֻ�����
		char   birth[16];                 //����
		char   email[40];                 //email
		int16  autographlen;              //����ǩ������
		char   autograph[0];              //����ǩ������
	}CMDGetUserMoreInfResp_t;

	typedef struct tag_CMDRoomTeacherOnMicResp
	{
		uint32  teacherid;      //��ʦID
		uint32  vcbid;          //����ID
		char    alias[NAMELEN]; //��ʦ�ǳ�
	}CMDRoomTeacherOnMicResp_t;

	//�����֪ͨ�ͻ���
	typedef struct tag_CMDHitGoldEggClientNoty
	{
		uint32 vcbid;
		uint32 userid;
		uint64 money;
	}CMDHitGoldEggClientNoty_t;

	//˽�˶��ƹ�������
	typedef struct tag_CMDBuyPrivateVipReq
	{
		uint32 userid;          //�û�ID
		uint32 teacherid;     	//��ʦID
		uint32 viptype;     	//vip�ȼ�ID
	}CMDBuyPrivateVipReq_t;

	//˽�˶��ƹ�����Ӧ
	typedef struct tag_CMDBuyPrivateVipResp
	{
		uint32 userid;          //�û�ID
		uint32 teacherid;     	//��ʦID
		uint32 viptype;     		//vip�ȼ�ID
		uint64 nk;        	    //�˻����
	}CMDBuyPrivateVipResp_t;

	//��������Ϣ��ʾ
	typedef struct tag_CMDEmailNewMsgNoty
	{
	  byte bEmailType;        //1 ˽�˶��� 2ϵͳ��Ϣ 3���ۻظ� 4���ʻظ�
	  uint32 messageid;       //��ϢID
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

