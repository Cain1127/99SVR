#ifndef __CMD_VCHAT_HH_20160401_
#define __CMD_VCHAT_HH_20160401_

#include "yc_datatypes.h"

#pragma pack(1)

namespace protocol
{
//���뷿��ɹ������ͽ�ʦ��Ϣ����
typedef struct tag_CMDTextRoomTeacherReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
}CMDTextRoomTeacherReq_t;

//���뷿��ɹ������ͽ�ʦ��Ϣ��Ӧ
typedef struct tag_CMDTextRoomTeacherNoty
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	char   teacheralias[NAMELEN];  //��ʦ�ǳ�
	uint32 headid;                 //��ʦͷ��ID
	int16  levellen;               //��ʦ�ȼ�����
	int16  labellen;               //��ʦ��ǩ����
	int16  goodatlen;              //��ʦ�ó����򳤶�
	int16  introducelen;           //��ʦ��鳤��
	int64  historymoods;           //ֱ��������
	int64  fans;                   //��˿��
    int64  zans;                   //������
	int64  todaymoods;             //����������
	int64  historyLives;           //ֱ����ʷ��
	int16  liveflag;               //�Ƿ�ֱ���У�0-�����ߣ�1-���ߣ�
	int16  fansflag;               //�Ƿ��Ѿ���ע��ʦ��0-δ��ע��1-�ѹ�ע��
	int16  bstudent;               //�Ƿ��Ѿ���ʦ��0-δ��ʦ��1-�Ѱ�ʦ��
	int32   rTeacherLiveRoom;			//�Ƿ���Ƶֱ���� ����0����û����ֱ����
	char   content[0];             //��Ϣ���ݣ���ʽ����ʦ�ȼ�+��ʦ��ǩ+��ʦ�ó����򣨶���Էֺŷָ���+��ʦ���
}CMDTextRoomTeacherNoty_t;

//����ֱ����¼����
typedef struct tag_CMDTextRoomLiveListReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	int16  type;                   //���ͣ�1-����ֱ����2-ֱ���ص㣻3-����Ԥ�⣨�ѹ�ע���û��ɲ鿴����4-�۵㣻5-�����ؼ���6-�ѹ����ؼ���
	int64  messageid;              //��һ������õ�����С��ϢID����һ��Ϊ0
    int32  count;                  //��ȡ��������¼
}CMDTextRoomLiveListReq_t;

//����ֱ����¼��Ӧ
typedef struct tag_CMDTextRoomLiveListNoty
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	uint32 srcuserid;              //�����û�ID
	char   srcuseralias[NAMELEN];  //�����û��ǳ�
	int64  messageid;              //��ϢID
	int16  pointflag;              //�Ƿ�ֱ���ص�:0-��1-�ǣ�
	int16  forecastflag;           //�Ƿ�����Ԥ��:0-��1-�ǣ�
	int16  livetype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ��4-�����ظ���5-�۵㶯̬��6-�����ؼ���̬��
	int64  viewid;     			   //�۵�ID(5-�۵㶯̬��)/�ؼ�ID(6-�����ؼ���̬��)
	int16  textlen;                //��Ϣ����
	int16  destextlen;             //�����ظ�����
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int64  zans;                   //������
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //��Ϣ���ݣ���ʽ����Ϣ���ݣ����͵�ֱ�������ݣ����͵Ĺ۵��Ǳ��⣬��������Դ���ݣ�+�����ظ�����
}CMDTextRoomLiveListNoty_t;

//���뷿��ɹ�������ֱ���ص������Ԥ���¼
typedef struct tag_CMDTextRoomLivePointNoty
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	int64  messageid;              //��ϢID
	int16  livetype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ;
	int16  textlen;                //��Ϣ����
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int64  zans;                   //������
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //��Ϣ����
}CMDTextRoomLivePointNoty_t;

//��ʦ��������ֱ������
typedef struct tag_CMDTextRoomLiveMessageReq
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //��ʦID
	int16  pointflag;              //�Ƿ�ֱ���ص�:0-��1-�ǣ�
	int16  forecastflag;           //�Ƿ�����Ԥ��:0-��1-�ǣ�
	int16  livetype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ��
	int16  textlen;                //ֱ����Ϣ����
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //ֱ����Ϣ����
}CMDTextRoomLiveMessageReq_t;

//��ʦ��������ֱ����Ӧ
typedef struct tag_CMDTextRoomLiveMessageResp
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //��ʦID
	int64  messageid;              //��ϢID
	int16  pointflag;              //�Ƿ�ֱ���ص�:0-��1-�ǣ�
	int16  forecastflag;           //�Ƿ�����Ԥ��:0-��1-�ǣ�
	int16  livetype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ��
	int16  textlen;                //ֱ����Ϣ����
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //ֱ����Ϣ����
}CMDTextRoomLiveMessageResp_t;

//�û������ע����
typedef struct tag_CMDTextRoomInterestForReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
    int16  optype;                 //�������ͣ�1-��ע  2-ȡ����ע
}CMDTextRoomInterestForReq_t;

//�û������ע��Ӧ
typedef struct tag_CMDTextRoomInterestForResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int16  result;                 //�ظ��Ƿ�ɹ���0ʧ�ܣ�1�ɹ���2�ѹ�ע��
    uint32 teacherid;              //��ʦID
    int16  optype;                 //�������ͣ�1�ǹ�ע��2��ȡ����ע
}CMDTextRoomInterestForResp_t;

//��ѯ�û���Ʒ����
typedef struct tag_CMDTextRoomGetUserGoodStatusReq
{
	uint32 userid;               //�û�ID
	uint32 salerid;              //��ʦID
	uint32 type;                 //����
	uint32 goodclassid;          //��Ʒ����ID
}CMDTextRoomGetUserGoodStatusReq_t;

typedef struct tag_CMDTextRoomGetUserGoodStatusResp
{
	uint32 userid;              //�û�ID
	uint32 salerid;             //��ʦID
	uint32 num;                 //����
	int16  result;							//0 �ɹ� 1 error
}CMDTextRoomGetUserGoodStatusResp_t;

//�û������������
typedef struct tag_CMDTextRoomQuestionReq
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //��ʦID
	uint32 userid;                 //�û�ID
	int16  stocklen;               //�������Ƴ���
	int16  textlen;                //������������
	int8   commentstype;		   		 //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	int8	 isfree;								 //������ʻ��Ǹ�������
	char   content[0];             //��Ϣ���ݣ���ʽ����������+��������
}CMDTextRoomQuestionReq_t;

//�û�������Ӧ
typedef struct tag_CMDTextRoomQuestionResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�����û�ID
	int16  result;                 //�����Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	int64  messageid;              //��ϢID��ͨ�ýӿڣ�ʧ��ʱΪ0��
	uint64 nk;										 //�û����/��ʣ��������ʴ���
}CMDTextRoomQuestionResp_t;

//�û�������Ӧ
typedef struct tag_CMDTextRoomLiveActionResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�����û�ID
	int16  result;                 //�����Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	int64  messageid;              //��ϢID��ͨ�ýӿڣ�ʧ��ʱΪ0��
}CMDTextRoomLiveActionResp_t;

//�û���������
typedef struct tag_CMDTextRoomZanForReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int64  messageid;              //��ϢID
}CMDTextRoomZanForReq_t;

//�û�������Ӧ
typedef struct tag_CMDTextRoomZanForResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int16  result;                 //�ظ��Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	int64  messageid;              //��ϢID
	int64  recordzans;             //��Ϣ������
	int64  totalzans;              //�ܵ�����
}CMDTextRoomZanForResp_t;

//��������
typedef struct tag_CMDRoomLiveChatReq
{
	uint32 vcbid;                  //����ID
	uint32 srcid;                  //������ID
	uint32 toid;                   //�û�ID
	byte   msgtype;                //˽������Ҳ�ڷ�����
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    uint16 textlen;                //�������ݳ���
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //��������
}CMDRoomLiveChatReq_t;

//������Ӧ
typedef struct tag_CMDTextRoomLiveChatResp
{
	uint32 vcbid;                  //����ID
	uint32 srcid;                  //������ID
	char   srcalias[NAMELEN];      //�������ǳ�
	uint32 srcheadid;              //������ͷ��
	uint32 toid;                   //�û�ID
	char   toalias[NAMELEN];       //�û��ǳ�
	uint32 toheadid;               //�û�ͷ��
	byte   msgtype;                //˽������Ҳ�ڷ�����
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	uint16 textlen;                //�������ݳ���
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //��������
}CMDTextRoomLiveChatResp_t;

//����ظ�(����)����
typedef struct tag_CMDTextLiveChatReplyReq
{
	uint32 vcbid;                  //����ID
	uint32 fromid;                 //�ظ���ID
	uint32 toid;                   //���ظ���ID
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	uint16 reqtextlen;             //Դ��Ϣ���ݳ���
	uint16 restextlen;             //�ظ����ݳ���
	int8  liveflag;                //�Ƿ񷢲���ֱ����0-��1-�ǣ�
    	int8   commentstype;	       //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //��Ϣ���ݣ���ʽ��Դ��Ϣ���� + �ظ�����
}CMDTextLiveChatReplyReq_t;

//����ظ�(����)��Ӧ
typedef struct tag_CMDTextLiveChatReplyResp
{
	uint32 vcbid;                  //����ID
	uint32 fromid;                 //�ظ���ID
	char   fromalias[NAMELEN];     //�ظ����ǳ�
	uint32 fromheadid;             //�ظ���ͷ��
	uint32 toid;                   //���ظ���ID
	char   toalias[NAMELEN];       //���ظ����ǳ�
	uint32 toheadid;               //���ظ���ͷ��
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	uint16 reqtextlen;             //Դ��Ϣ���ݳ���
	uint16 restextlen;             //�ظ����ݳ���
	int8   liveflag;               //�Ƿ񷢲���ֱ����0-��1-�ǣ�
        int8   commentstype;	       //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	int64  messageid;              //��ϢID
	char   content[0];             //��Ϣ���ݣ���ʽ��Դ��Ϣ���� + �ظ�����
}CMDTextLiveChatReplyResp_t;

//����鿴�۵���������
typedef struct tag_CMDTextRoomLiveViewGroupReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
    uint32 teacherid;              //��ʦID
}CMDTextRoomLiveViewGroupReq_t;

//�۵������Ӧ
typedef struct tag_CMDTextRoomViewGroupResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
    uint32 teacherid;              //��ʦID
	int32  viewtypeid;             //�۵�����ID
	int32  totalcount;             //�ܹ۵���
	int16  viewtypelen;            //�۵��������Ƴ���
	char   viewtypename[0];        //�۵���������
}CMDTextRoomViewGroupResp_t;

//����۵����ͷ�������
typedef struct tag_CMDTextRoomLiveViewListReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	int32  viewtypeid;             //�۵�����ID�����Ϊ0���򲻷��෵��
	int64  messageid;              //��ϢID��Ϊ����Ĺ۵�����б�����
	int32  startIndex;             //��ʼ����
	uint32 count;                  //�۵����������
}CMDTextRoomLiveViewListReq_t;

//����۵����ͷ�������(�ֻ��汾)������20��
typedef struct tag_CMDTextRoomViewListReq_mobile
{
    char    uuid[16];               //Ψһ��ʶͷ
    uint32  vcbid;                  //����ID
    uint32  userid;                 //�û�ID
    uint32  teacherid;              //��ʦID
    int32   viewtypeid;             //�۵�����ID�����Ϊ0���򲻷��෵��
    int64   messageid;              //��ϢID��Ϊ����Ĺ۵�����б�����
    int32   startIndex;             //��ʼ����
    uint32  count;                  //�۵����������
}CMDTextRoomViewListReq_mobile_t;

//�۵��б���Ӧ
typedef struct tag_CMDTextRoomLiveViewResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int32  viewtypeid;             //�۵�����ID
	int64  viewid;                 //��ϢID
	int16  livetype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ��
	int16  viewTitlelen;           //�۵���ⳤ��
	int16  viewtextlen;            //�۵����ݳ���
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	int64  looks;                  //�������
    int64  zans;                   //������
	int64  comments;               //������
	int64  flowers;                //�ͻ���
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];             //��Ϣ���ݣ���ʽ���۵����+�۵�����
}CMDTextRoomLiveViewResp_t;

//�鿴�۵���������
typedef struct tag_CMDTextRoomLiveViewDetailReq{

	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int64  viewid;                 //�۵�ID
	int64  messageid;              //����ID��Ϊ����Ĺ۵�����б�����,��0��ʼ���� Ϊ���ͬʱ���͹۵�������������б���Ϊ����ֻ���������б�
	int64  startcommentpos;        //��ʼ����
	uint32 count;                  //���ص���������
	int8   type;                   //�������ͣ�1�۵����飬2�۵����ۣ�3�۵�����+����
}CMDTextRoomLiveViewDetailReq_t;

//�鿴������ϸ��Ϣ
typedef struct tag_CMDTextRoomViewInfoResp
{
	uint32 vcbid;                  	//����ID
	uint32 userid;                 	//�����û�ID
	int64  viewid;			        //�۵�ID
	int64  commentid;				//����ID
	uint32 viewuserid;              //�����û�ID
	char   useralias[NAMELEN];		//���۵��û��ǳƣ�����Ӧ������û�ID
	int16  textlen;                	//���۳���
	uint64 messagetime;            	//����ʱ��(yyyymmddhhmmss)
	int64  srcinteractid;			//Դ����ID���ظ���������ʱ��Ҫ��д����0�����û��
	char   srcuseralias[NAMELEN];  	//Դ���۵��û��ǳƣ�û����Ϊ��
    int8   commentstype;			//�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	char   content[0];            	//��������
}CMDTextRoomViewInfoResp_t;


//��ʦ�޸Ĺ۵����ͷ�������
typedef struct tag_CMDTextRoomViewTypeReq
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //�����û�ID
	int16  actiontypeid;           //��������ID��1-������2-�޸ģ�3-ɾ������Ҫɾ�����������й۵��ſɲ�������
	int32  viewtypeid;             //�۵�����ID������ʱΪ0��
	char   viewtypename[NAMELEN];  //�۵���������
}CMDTextRoomViewTypeReq_t;

//��ʦ�޸ĺ������۵����ͷ�����Ӧ
typedef struct tag_CMDTextRoomViewTypeResp
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //�����û�ID
	int16  result;                 //�����Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	int32  viewtypeid;             //�۵�����ID��ͨ�ýӿڣ�ʧ��ʱΪ0��
}CMDTextRoomViewTypeResp_t;

//��ʦ�����۵���޸Ĺ۵�����
typedef struct tag_CMDTextRoomViewMessageReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int64  messageid;              //��ϢID���޸�ʱ���룬����ʱΪ0��
	int16  viewtype;               //����ֱ�����ͣ�1-�����֣�2-����+���ӣ�3-����+ͼƬ��
	int16  titlelen;               //�۵���ⳤ��
	int16  textlen;                //�۵����ݳ���
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
    char   content[0];             //�۵��ʽ���۵����+�۵�����
}CMDTextRoomViewMessageReq_t;

//��ʦ�����۵���޸Ĺ۵���Ӧ
typedef struct tag_CMDTextRoomViewMessageReqResp
{
	uint32 userid;                 //�û�ID
	int64  messageid;              //��ϢID���޸�ʱ���룬����ʱΪ0��
	int16  titlelen;               //�۵���ⳤ��
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	char   content[0];             //�۵��ʽ���۵����
}CMDTextRoomViewMessageReqResp_t;

//��ʦɾ���۵�����
typedef struct tag_CMDTextRoomViewDeleteReq
{
	uint32 vcbid;                  	//����ID
	uint32 userid;                 	//�û�ID
	int64  viewid;              		//�۵�����ID
}CMDTextRoomViewDeleteReq_t;

//��ʦɾ���۵���Ӧ
typedef struct tag_CMDTextRoomViewDeleteResp
{
	uint32 vcbid;                  	//����ID
	uint32 userid;                 	//�û�ID
	int64  viewid;              	//��ϢID
	int16  result;                  //�����Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
}CMDTextRoomViewDeleteResp_t;

//�۵�������ϸҳ�ͻ�����
typedef struct tag_CMDTextLiveViewFlowerReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int64  messageid;              //��ϢID
	int32  count;                  //�Ͷ��ٶ�
}CMDTextLiveViewFlowerReq_t;

//�۵�������ϸҳ�ͻ���Ӧ
typedef struct tag_CMDTextLiveViewFlowerResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int16  result;                 //�ظ��Ƿ�ɹ���0ʧ�ܣ�1�ɹ���
	int64  messageid;              //��ϢID
	int64  recordflowers;          //���ͻ���
}CMDTextLiveViewFlowerResp_t;

//�Թ۵��������
typedef struct tag_CMDTextRoomViewCommentReq
{
	uint32 vcbid;                  //����ID
	uint32 fromid;                 //������ID
	uint32 toid;                   //��������ID
	int64  messageid;              //��ϢID
	int16  textlen;                //���۳���
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
	int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	int64  srcinteractid;          //����Ƕ����۲������ۣ���Ҫ��д���ֶ�
	char   content[0];             //��������
}CMDTextRoomViewCommentReq_t;

//���ֱ����ʷ���ɷ�ҳ����չʾ������
typedef struct tag_CMDTextLiveHistoryListReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
    int32  count;                  //��ȡ��������¼
	int16  fromIndex;              //�ӵڼ�����ʼȡ
	int16  toIndex;                //���ڼ�������
	int32  fromdate;               //����һ��(������)��ʼ
	uint8  bInc;                   //�Ƿ�����0����,1����
}CMDTextLiveHistoryListReq_t;

//���ֱ����ʷ���ɷ�ҳ����չʾ����Ӧ
typedef struct tag_CMDTextLiveHistoryListResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	uint32 datetime;               //����(yyyymmdd)
	uint64 beginTime;              //һ����ֱ����һ����¼��ʱ��(yyyymmddhhmmss)
	uint64 endTime;                //һ�������һ����¼��ʱ��(yyyymmddhhmmss)
	uint32 renQi;                  //��������
	uint32 cAnswer;                //�ش����������
	uint32 totalCount;             //����ֱ����¼����
}CMDTextLiveHistoryListResp_t;

//����ĳһ���ֱ����¼�б��ɷ�ҳ����չʾ������
typedef struct tag_CMDTextLiveHistoryDaylyReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	int16  type;                   //���ͣ�1-����ֱ����2-ֱ���ص㣻3-����Ԥ�⣨�ѹ�ע���û��ɲ鿴����4-�۵㣻
	int64  messageid;              //����õ��������ϢID����һ��Ϊ0
    int32  count;                  //��ȡ��������¼
    int32  startindex;             //��ʼ����
    uint32 datetime;               //��һ��ļ�¼(yyyymmdd)
}CMDTextLiveHistoryDaylyReq_t;

//��ʦ���뷿��㲥��Ϣ
typedef struct tag_CMDTeacherComeNotify
{
	int64  recordzans;             //�����ܵ�����
}CMDTeacherComeNotify_t;

//�б���Ϣͷ(�ֻ��汾)������20��
typedef struct tag_CMDTextRoomLists_mobile
{
    char    uuid[16];               //Ψһ��ʶͷ
}CMDTextRoomLists_mobile_t;

//��ʦͨ��PHPҳ�淢���۵���޸Ĺ۵��ɾ���۵�����
typedef struct tag_CMDTextRoomViewPHPReq
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //�����û�ID
	int64  messageid;              //��ϢID
    int64  businessid;             //�۵�ID
	int8   viewtype;               //�������ͣ�1-������2-�޸ģ�3-ɾ����
	int16  titlelen;               //�۵���ⳤ��
	int16  textlen;                //�۵��鳤��
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
    char   content[0];             //��ʽ���۵����+�۵���
}CMDTextRoomViewPHPReq_t;

//��ʦͨ��PHPҳ�淢���۵���޸Ĺ۵��ɾ���۵���Ӧ
typedef struct tag_CMDTextRoomViewPHPResp
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //�����û�ID
	int64  messageid;              //��ϢID
    int64  businessid;             //�۵�ID
	int8   viewtype;               //�������ͣ�1-������2-�޸ģ�3-ɾ����
	int16  titlelen;               //�۵���ⳤ��
	int16  textlen;                //�۵��鳤��
	uint64 messagetime;            //����ʱ��(yyyymmddhhmmss)
    int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
    char   content[0];             //��ʽ���۵����+�۵���
}CMDTextRoomViewPHPResp_t;

///��ʦ����&&����
typedef struct tag_CMDBeTeacherReq
{
	uint32  userid; //�������Ϣ���û�ID
	uint32  teacherid; //���ݵĽ�ʦ
	uint32  vcbid; //����ID
	uint8   opMode; //0:30�� 1:90��
}CMDBeTeacherReq_t;

typedef struct tag_CMDBeTeacherResp
{
	uint32  userid; //�������Ϣ���û�ID
	uint8   result; //���
	uint64  nk;
}CMDBeTeacherResp_t;

typedef struct tag_CMDUserPayReq
{
	uint32	srcid;				//������ID��һ�����û�ID
	uint32	dstid;				//��������ID��һ���ǽ�ʦ ID
	uint32	vcbid;  			//����ID
	uint8   isPackage;		//�Ƿ���������ͣ���Ʒ������ۣ�
	uint32  goodclassid;	//��Ʒ����ID
	uint32  type;					//����
	uint32	num;					//������������Ҫ��Թ۵��ʻ���������ơ�����һ����1��
}CMDUserPayReq_t;


typedef struct tag_CMDUserPayResp
{
	uint32 userid; //�û�ID
	uint64 nk;   	 //�û����
	uint32 errid;	 //����ԭ��0. �����ɹ� 1.��Ʒ������ 2.���� 3.DB error
}CMDUserPayResp_t;

typedef struct tag_CMDGetUserAccountBalanceReq
{
	uint32 userid;         //�û�ID
}CMDGetUserAccountBalanceReq_t;

typedef struct tag_CMDGetUserAccountBalanceResp
{
	uint32 userid;  //�û�ID
	uint64 nk;   //�û����
	uint32 errid;	//����ԭ��0. �����ɹ� 1.�û������� 2.DB error
}CMDGetUserAccountBalanceResp_t;

//���ѱ����б�
typedef struct tag_CMDTextRoomEmoticonListResp
{
	uint32 emoticonID;             //����ID
	char	 emoticonName[NAMELEN];  //��������
	int32  prices;                 //�۸�
	int8   buyflag;                //�Ƿ���1-�ѹ���0-δ����
}CMDTextRoomEmoticonListResp_t;

//�����ؼ�������Ϣ����
typedef struct tag_CMDTextRoomSecretsTotalReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
}CMDTextRoomSecretsTotalReq_t;

//�����ؼ�������Ϣ��Ӧ
typedef struct tag_CMDTextRoomSecretsTotalResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	int32  secretsnum;             //�ؼ�����
	int32  ownsnum;                //�ѹ����ؼ�����
	int8   bStudent;               //�Ƿ�ͽ�ܣ�0-��1-�ǣ�
}CMDTextRoomSecretsTotalResp_t;

//�����ؼ��б���Ϣͷ
typedef struct tag_CMDTextRoomListHead
{
    char    uuid[16];              //Ψһ��ʶͷ
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
}CMDTextRoomListHead_t;

//�����ؼ��б�
typedef struct tag_CMDTextRoomSecretsListResp
{
	int32  secretsid;              //�ؼ�ID
	int16  coverlittlelen;         //����Сͼ���Ƴ���
	int16  titlelen;               //�ؼ����ⳤ��
	int16  textlen;                //�ؼ���鳤��
	uint64 messagetime;            //ʱ��(yyyymmddhhmmss)
	int32  buynums;                //��������
	int32  prices;                 //���ζ������������
	int8   buyflag;                //�Ƿ���1-�ѹ���0-δ����
	int32  goodsid;                //��ƷID
	char  content[0];              //��Ϣ���ݣ���ʽ������Сͼ����+�ؼ�����+�ؼ����
}CMDTextRoomSecretsListResp_t;

//�����ؼ���������
typedef struct tag_CMDTextRoomBuySecretsReq
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	uint32 teacherid;              //��ʦID
	int32  secretsid;              //�ؼ�ID
	int32  goodsid;                //��ƷID
}CMDTextRoomBuySecretsReq_t;

//�����ؼ�������Ӧ
typedef struct tag_CMDTextRoomBuySecretsResp
{
	uint32 vcbid;                  //����ID
	uint32 userid;                 //�û�ID
	int32  secretsid;              //�ؼ�ID
	int16 result;                  //�ظ��Ƿ�ɹ���0. �����ɹ� 1.��Ʒ������ 2.���� 3.DB error 4.�ѹ���
	uint64  nk99;                  //�û��˻����������ɹ�ʱ��Ҫˢ�¿ͻ�����
}CMDTextRoomBuySecretsResp_t;

//PHP��̨¼������ؼ�������֪ͨ�����
typedef struct tag_CMDTextRoomSecretsPHPReq
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //�����û�ID
	int64  messageid;              //��ϢID
	int32  businessid;             //�ؼ�ID
	int8   viewtype;               //�������ͣ�1-������2-�޸ģ�3-ɾ����
	int16  coverlittlelen;         //����Сͼ���Ƴ���
	int16  titlelen;               //�ؼ����ⳤ��
	int16  textlen;                //�ؼ���鳤��
	uint64 messagetime;            //ʱ��(yyyymmddhhmmss)
	int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	int32  prices;                 //���ζ������������
	int32  goodsid;                //��ƷID
	char  content[0];              //��Ϣ���ݣ���ʽ������Сͼ����+�ؼ�����+�ؼ����
}CMDTextRoomSecretsPHPReq_t;

//PHP��̨¼������ؼ�������֪ͨ����˹㲥���ͻ���
typedef struct tag_CMDTextRoomSecretsPHPResp
{
	uint32 vcbid;                  //����ID
	uint32 teacherid;              //�����û�ID
	int64  messageid;              //��ϢID
	int32  businessid;             //�ؼ�ID
	int8   viewtype;               //�������ͣ�1-������2-�޸ģ�3-ɾ����
	int16  coverlittlelen;         //����Сͼ���Ƴ���
	int16  titlelen;               //�ؼ����ⳤ��
	int16  textlen;                //�ؼ���鳤��
	uint64 messagetime;            //ʱ��(yyyymmddhhmmss)
	int8   commentstype;		   //�ͻ������� 0:PC�� 1:��׿ 2:IOS 3:WEB
	int32  prices;                 //���ζ������������
	int32  goodsid;                //��ƷID
	char  content[0];              //��Ϣ���ݣ���ʽ������Сͼ����+�ؼ�����+�ؼ����
}CMDTextRoomSecretsPHPResp_t;

typedef struct tag_CMDGetPackagePrivilegeReq
{
	uint32 userid;         //�û�ID
	uint32 packageNum;          //
}CMDGetPackagePrivilegeReq_t;

typedef struct tag_CMDGetPackagePrivilegeResp
{
	uint32 userid;         //�û�ID
	uint32 index;          //�±�
	char   privilege[256];       //��Ȩ����
}CMDGetPackagePrivilegeResp_t;

//֪ͨ�ͻ�����״̬�ı�
typedef struct tag_CMDVideoRoomOnMicClientResp
{

	uint32 userid;
	char   useralias[NAMELEN];
	uint32 roomid;	
	char   roomName[NAMELEN];
	uint8  state;
}CMDVideoRoomOnMicClientResp_t;

//��ʦ��Ϣ����汾��
typedef struct tag_CMDGetBeTeacherInfoReq
{
	uint32  userid; //�������Ϣ���û�ID
	uint32  vcbid; //����ID
	uint32  teacherid; //��ʦID
}CMDGetBeTeacherInfoReq_t;

//��ͨ�û���ʦ��Ϣ����resp�汾��
//head
typedef struct tag_CMDNormalUserGetBeTeacherInfoRespHead
{
	int32 userid;   //������ID
    int32 price_30;
	int32 price_90;
    uint32  teacherid; //��ǰ��ݽ�ʦID
	uint32  cStudent; //��ǰ��ʦͽ������
	uint8   bStudent; //���Ƿ�����ͽ��
}CMDNormalUserGetBeTeacherInfoRespHead_t;
//Body
typedef struct tag_CMDNormalUserGetBeTeacherInfoRespItem
{
    int32   nuserid; 
	uint64  starttime; //
	uint64  effecttime; //����ʱ��
	int32 teacherid;
	char  teacherAlias[NAMELEN];
	int32 cQuery;//ʣ������ʹɴ���
	int32 cViewFlowers;//ʣ����ѹ۵��׻�����
}CMDNormalUserGetBeTeacherInfoRespItem_t;

//��ʦ�û���ʦ��Ϣ����resp�汾��
//Head
typedef struct tag_CMDTeacherGetBeTeacherInfoRespHead
{
	int32 userid;   //������ID
    int32 price_30;
	int32 price_90;
}CMDTeacherTeacherGetBeTeacherInfoRespHead_t;
//Body
typedef struct tag_CMDTeacherGetBeTeacherInfoRespItem
{
    int32   nuserid; 
	uint64  starttime; //
	uint64  effecttime; //����ʱ��
	int32 studentid;
	char  studentAlias[NAMELEN];
}CMDTeacherGetBeTeacherInfoRespItem_t;

};

#pragma pack()

#endif //__CMD_VCHAT_HH_20160401_

