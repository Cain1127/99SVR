#include "Util.h"

void get_out_ip();

//��½ʧ��
void ReportLoginFailed(int login_type, rstring login_id, rstring server_ip);

//ע��ʧ��
void ReportRegisterFailed(int reg_type, rstring server_ip, rstring err);

//��ȡ���������б�ʧ��
void ReportGetRoomListFailed(int userid, int room_type, rstring server_ip);

//������ʧ��
void ReportJoinRoomFailed(int userid, int room_type, int roomid, rstring server_ip, rstring err);

//��ȡ�����Ա�б�ʧ��
void ReportGetRoomUserListFailed(int userid, int room_type, int roomid, rstring server_ip, rstring err);

//ֱ����������
void ReportVideoWarn(int userid, int roomid, int warn_type, rstring server_ip);

//��������
void ReportCrash(rstring os, rstring version_name, rstring err);

//�򿪴�����ҳʧ��
void ReportOpenHomepageFailed(int userid, rstring server_ip);

//�ϱ�������װ����Щ���
void ReportLocalAppData(rstring os, rstring serial_number, rstring version_name, rstring app_list);
