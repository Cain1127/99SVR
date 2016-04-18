#ifndef _TEXTROOM_MESSAGE_H_
#define _TEXTROOM_MESSAGE_H_

#include <string>
#include "Log.h"
#include "commonroom_cmd_vchat.h"
using std::string;


class ClientPingResp
{

private:

	uint32	_userid;
	uint32	_roomid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(const uint32 value) { _roomid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDClientPingResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDClientPingResp* cmd = (protocol::tag_CMDClientPingResp*) data;
		cmd->userid = _userid;
		cmd->roomid = _roomid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDClientPingResp* cmd = (protocol::tag_CMDClientPingResp*) data;
		_userid = cmd->userid;
		_roomid = cmd->roomid;
	}

	void Log()
	{
		LOG("--------Receive message: ClientPingResp---------");
		LOG("userid = %d", _userid);
		LOG("roomid = %d", _roomid);
	}

};


class JoinRoomReq2
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_devtype;
	uint32	_time;
	uint32	_crc32;
	uint32	_coremessagever;
	string	_cuserpwd;
	string	_croompwd;
	string	_cserial;
	string	_cmacaddr;
	string	_cipaddr;
	uint32	_bloginsource;
	uint32	_reserve1;
	uint32	_reserve2;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 devtype() { return _devtype; } const 
	 inline void set_devtype(const uint32 value) { _devtype = value; }

	 inline uint32 time() { return _time; } const 
	 inline void set_time(const uint32 value) { _time = value; }

	 inline uint32 crc32() { return _crc32; } const 
	 inline void set_crc32(const uint32 value) { _crc32 = value; }

	 inline uint32 coremessagever() { return _coremessagever; } const 
	 inline void set_coremessagever(const uint32 value) { _coremessagever = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 
	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& croompwd() { return _croompwd; } const 
	 inline void set_croompwd(const string& value) { _croompwd = value; }

	 inline string& cserial() { return _cserial; } const 
	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 
	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 
	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 bloginsource() { return _bloginsource; } const 
	 inline void set_bloginsource(const uint32 value) { _bloginsource = value; }

	 inline uint32 reserve1() { return _reserve1; } const 
	 inline void set_reserve1(const uint32 value) { _reserve1 = value; }

	 inline uint32 reserve2() { return _reserve2; } const 
	 inline void set_reserve2(const uint32 value) { _reserve2 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDJoinRoomReq2); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDJoinRoomReq2* cmd = (protocol::tag_CMDJoinRoomReq2*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->devtype = _devtype;
		cmd->time = _time;
		cmd->crc32 = _crc32;
		cmd->coremessagever = _coremessagever;
		strcpy(cmd->cuserpwd, _cuserpwd.c_str());
		strcpy(cmd->croompwd, _croompwd.c_str());
		strcpy(cmd->cSerial, _cserial.c_str());
		strcpy(cmd->cMacAddr, _cmacaddr.c_str());
		strcpy(cmd->cIpAddr, _cipaddr.c_str());
		cmd->bloginSource = _bloginsource;
		cmd->reserve1 = _reserve1;
		cmd->reserve2 = _reserve2;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDJoinRoomReq2* cmd = (protocol::tag_CMDJoinRoomReq2*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_devtype = cmd->devtype;
		_time = cmd->time;
		_crc32 = cmd->crc32;
		_coremessagever = cmd->coremessagever;
		_cuserpwd = cmd->cuserpwd;
		_croompwd = cmd->croompwd;
		_cserial = cmd->cSerial;
		_cmacaddr = cmd->cMacAddr;
		_cipaddr = cmd->cIpAddr;
		_bloginsource = cmd->bloginSource;
		_reserve1 = cmd->reserve1;
		_reserve2 = cmd->reserve2;
	}

	void Log()
	{
		LOG("--------Receive message: JoinRoomReq2---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("devtype = %d", _devtype);
		LOG("time = %d", _time);
		LOG("crc32 = %d", _crc32);
		LOG("coremessagever = %d", _coremessagever);
		LOG("cuserpwd = %s", _cuserpwd.c_str());
		LOG("croompwd = %s", _croompwd.c_str());
		LOG("cserial = %s", _cserial.c_str());
		LOG("cmacaddr = %s", _cmacaddr.c_str());
		LOG("cipaddr = %s", _cipaddr.c_str());
		LOG("bloginsource = %d", _bloginsource);
		LOG("reserve1 = %d", _reserve1);
		LOG("reserve2 = %d", _reserve2);
	}

};


class JoinRoomResp
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_roomtype;
	uint32	_seats;
	uint32	_groupid;
	uint32	_runstate;
	uint32	_creatorid;
	uint32	_op1id;
	uint32	_op2id;
	uint32	_op3id;
	uint32	_op4id;
	uint32	_inroomstate;
	int64	_nk;
	int64	_nb;
	int64	_nlotterypool;
	int32	_nchestnum;
	int32	_ncarid;
	string	_carname;
	string	_cname;
	string	_cmediaaddr;
	string	_cpwd;
    byte _collotRoom;

public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 roomtype() { return _roomtype; } const 
	 inline void set_roomtype(const uint32 value) { _roomtype = value; }

	 inline uint32 seats() { return _seats; } const 
	 inline void set_seats(const uint32 value) { _seats = value; }

	 inline uint32 groupid() { return _groupid; } const 
	 inline void set_groupid(const uint32 value) { _groupid = value; }

	 inline uint32 runstate() { return _runstate; } const 
	 inline void set_runstate(const uint32 value) { _runstate = value; }

	 inline uint32 creatorid() { return _creatorid; } const 
	 inline void set_creatorid(const uint32 value) { _creatorid = value; }

	 inline uint32 op1id() { return _op1id; } const 
	 inline void set_op1id(const uint32 value) { _op1id = value; }

	 inline uint32 op2id() { return _op2id; } const 
	 inline void set_op2id(const uint32 value) { _op2id = value; }

	 inline uint32 op3id() { return _op3id; } const 
	 inline void set_op3id(const uint32 value) { _op3id = value; }

	 inline uint32 op4id() { return _op4id; } const 
	 inline void set_op4id(const uint32 value) { _op4id = value; }

	 inline uint32 inroomstate() { return _inroomstate; } const 
	 inline void set_inroomstate(const uint32 value) { _inroomstate = value; }

	 inline int64 nk() { return _nk; } const 
	 inline void set_nk(const int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 
	 inline void set_nb(const int64 value) { _nb = value; }

	 inline int64 nlotterypool() { return _nlotterypool; } const 
	 inline void set_nlotterypool(const int64 value) { _nlotterypool = value; }

	 inline int32 nchestnum() { return _nchestnum; } const 
	 inline void set_nchestnum(const int32 value) { _nchestnum = value; }

	 inline int32 ncarid() { return _ncarid; } const 
	 inline void set_ncarid(const int32 value) { _ncarid = value; }
    
     inline byte bColletRoom() { return _collotRoom; } const
     inline void set_bColletRoom(byte value) { _collotRoom = value; }

	 inline string& carname() { return _carname; } const 
	 inline void set_carname(const string& value) { _carname = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cmediaaddr() { return _cmediaaddr; } const 
	 inline void set_cmediaaddr(const string& value) { _cmediaaddr = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDJoinRoomResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDJoinRoomResp* cmd = (protocol::tag_CMDJoinRoomResp*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->roomtype = _roomtype;
		cmd->seats = _seats;
		cmd->groupid = _groupid;
		cmd->runstate = _runstate;
		cmd->creatorid = _creatorid;
		cmd->op1id = _op1id;
		cmd->op2id = _op2id;
		cmd->op3id = _op3id;
		cmd->op4id = _op4id;
		cmd->inroomstate = _inroomstate;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->nlotterypool = _nlotterypool;
		cmd->nchestnum = _nchestnum;
		cmd->ncarid = _ncarid;
        cmd->bIsCollectRoom = _collotRoom;
		strcpy(cmd->carname, _carname.c_str());
		strcpy(cmd->cname, _cname.c_str());
		strcpy(cmd->cmediaaddr, _cmediaaddr.c_str());
		strcpy(cmd->cpwd, _cpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDJoinRoomResp* cmd = (protocol::tag_CMDJoinRoomResp*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_roomtype = cmd->roomtype;
		_seats = cmd->seats;
		_groupid = cmd->groupid;
		_runstate = cmd->runstate;
		_creatorid = cmd->creatorid;
		_op1id = cmd->op1id;
		_op2id = cmd->op2id;
		_op3id = cmd->op3id;
		_op4id = cmd->op4id;
		_inroomstate = cmd->inroomstate;
		_nk = cmd->nk;
		_nb = cmd->nb;
		_nlotterypool = cmd->nlotterypool;
		_nchestnum = cmd->nchestnum;
		_ncarid = cmd->ncarid;
		_carname = cmd->carname;
		_cname = cmd->cname;
		_cmediaaddr = cmd->cmediaaddr;
		_cpwd = cmd->cpwd;
        _collotRoom = cmd->bIsCollectRoom;
	}

	void Log()
	{
		LOG("--------Receive message: JoinRoomResp---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("roomtype = %d", _roomtype);
		LOG("seats = %d", _seats);
		LOG("groupid = %d", _groupid);
		LOG("runstate = %d", _runstate);
		LOG("creatorid = %d", _creatorid);
		LOG("op1id = %d", _op1id);
		LOG("op2id = %d", _op2id);
		LOG("op3id = %d", _op3id);
		LOG("op4id = %d", _op4id);
		LOG("inroomstate = %d", _inroomstate);
		LOG("nk = %lld", _nk);
		LOG("nb = %lld", _nb);
		LOG("nlotterypool = %lld", _nlotterypool);
		LOG("nchestnum = %d", _nchestnum);
		LOG("ncarid = %d", _ncarid);
		LOG("carname = %s", _carname.c_str());
		LOG("cname = %s", _cname.c_str());
		LOG("cmediaaddr = %s", _cmediaaddr.c_str());
		LOG("cpwd = %s", _cpwd.c_str());
	}

};


class JoinRoomErr
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_errid;
	uint32	_data1;
	uint32	_data2;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 errid() { return _errid; } const 
	 inline void set_errid(const uint32 value) { _errid = value; }

	 inline uint32 data1() { return _data1; } const 
	 inline void set_data1(const uint32 value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 
	 inline void set_data2(const uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDJoinRoomErr); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDJoinRoomErr* cmd = (protocol::tag_CMDJoinRoomErr*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->errid = _errid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDJoinRoomErr* cmd = (protocol::tag_CMDJoinRoomErr*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_errid = cmd->errid;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
	}

	void Log()
	{
		LOG("--------Receive message: JoinRoomErr---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("errid = %d", _errid);
		LOG("data1 = %d", _data1);
		LOG("data2 = %d", _data2);
	}

};


class UserExitRoomInfo
{

private:

	uint32	_userid;
	uint32	_vcbid;

public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserExitRoomInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserExitRoomInfo* cmd = (protocol::tag_CMDUserExitRoomInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserExitRoomInfo* cmd = (protocol::tag_CMDUserExitRoomInfo*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
	}

	void Log()
	{
		LOG("--------Receive message: UserExitRoomInfo---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
	}

};


class UserKickoutRoomInfo
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	int32	_resonid;
	uint32	_mins;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline int32 resonid() { return _resonid; } const 
	 inline void set_resonid(const int32 value) { _resonid = value; }

	 inline uint32 mins() { return _mins; } const 
	 inline void set_mins(const uint32 value) { _mins = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserKickoutRoomInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserKickoutRoomInfo* cmd = (protocol::tag_CMDUserKickoutRoomInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->resonid = _resonid;
		cmd->mins = _mins;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserKickoutRoomInfo* cmd = (protocol::tag_CMDUserKickoutRoomInfo*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_resonid = cmd->resonid;
		_mins = cmd->mins;
	}

	void Log()
	{
		LOG("--------Receive message: UserKickoutRoomInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("resonid = %d", _resonid);
		LOG("mins = %d", _mins);
	}

};


class RoomUserInfo
{

private:
	uint32	_userid;
	uint32	_vcbid;
	uint32	_viplevel;
	uint32	_yiyuanlevel;
	uint32	_shoufulevel;
	uint32	_zhonglevel;
	uint32	_caifulevel;
	uint32	_lastmonthcostlevel;
	uint32	_thismonthcostlevel;
	uint32	_thismonthcostgrade;
	uint32	_pubmicindex;
	uint32	_roomlevel;
	uint32	_usertype;
	uint32	_sealid;
	uint32	_cometime;
	uint32	_headicon;
	uint32	_micgiftid;
	uint32	_micgiftnum;
	uint32	_sealexpiretime;
	uint32	_userstate;
	uint32	_starflag;
	uint32	_activityflag;
	uint32	_flowernum;
	uint32	_ticket1num;
	uint32	_ticket2num;
	uint32	_ticket3num;
	int32	_bforbidinviteupmic;
	int32	_bforbidchat;
	int32	_ncarid;
	string	_useralias;
	string	_carname;

public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 viplevel() { return _viplevel; } const 
	 inline void set_viplevel(const uint32 value) { _viplevel = value; }

	 inline uint32 yiyuanlevel() { return _yiyuanlevel; } const 
	 inline void set_yiyuanlevel(const uint32 value) { _yiyuanlevel = value; }

	 inline uint32 shoufulevel() { return _shoufulevel; } const 
	 inline void set_shoufulevel(const uint32 value) { _shoufulevel = value; }

	 inline uint32 zhonglevel() { return _zhonglevel; } const 
	 inline void set_zhonglevel(const uint32 value) { _zhonglevel = value; }

	 inline uint32 caifulevel() { return _caifulevel; } const 
	 inline void set_caifulevel(const uint32 value) { _caifulevel = value; }

	 inline uint32 lastmonthcostlevel() { return _lastmonthcostlevel; } const 
	 inline void set_lastmonthcostlevel(const uint32 value) { _lastmonthcostlevel = value; }

	 inline uint32 thismonthcostlevel() { return _thismonthcostlevel; } const 
	 inline void set_thismonthcostlevel(const uint32 value) { _thismonthcostlevel = value; }

	 inline uint32 thismonthcostgrade() { return _thismonthcostgrade; } const 
	 inline void set_thismonthcostgrade(const uint32 value) { _thismonthcostgrade = value; }

	 inline uint32 pubmicindex() { return _pubmicindex; } const 
	 inline void set_pubmicindex(const uint32 value) { _pubmicindex = value; }

	 inline uint32 roomlevel() { return _roomlevel; } const 
	 inline void set_roomlevel(const uint32 value) { _roomlevel = value; }

	 inline uint32 usertype() { return _usertype; } const 
	 inline void set_usertype(const uint32 value) { _usertype = value; }

	 inline uint32 sealid() { return _sealid; } const 
	 inline void set_sealid(const uint32 value) { _sealid = value; }

	 inline uint32 cometime() { return _cometime; } const 
	 inline void set_cometime(const uint32 value) { _cometime = value; }

	 inline uint32 headicon() { return _headicon; } const 
	 inline void set_headicon(const uint32 value) { _headicon = value; }

	 inline uint32 micgiftid() { return _micgiftid; } const 
	 inline void set_micgiftid(const uint32 value) { _micgiftid = value; }

	 inline uint32 micgiftnum() { return _micgiftnum; } const 
	 inline void set_micgiftnum(const uint32 value) { _micgiftnum = value; }

	 inline uint32 sealexpiretime() { return _sealexpiretime; } const 
	 inline void set_sealexpiretime(const uint32 value) { _sealexpiretime = value; }

	 inline uint32 userstate() { return _userstate; } const 
	 inline void set_userstate(const uint32 value) { _userstate = value; }

	 inline uint32 starflag() { return _starflag; } const 
	 inline void set_starflag(const uint32 value) { _starflag = value; }

	 inline uint32 activityflag() { return _activityflag; } const 
	 inline void set_activityflag(const uint32 value) { _activityflag = value; }

	 inline uint32 flowernum() { return _flowernum; } const 
	 inline void set_flowernum(const uint32 value) { _flowernum = value; }

	 inline uint32 ticket1num() { return _ticket1num; } const 
	 inline void set_ticket1num(const uint32 value) { _ticket1num = value; }

	 inline uint32 ticket2num() { return _ticket2num; } const 
	 inline void set_ticket2num(const uint32 value) { _ticket2num = value; }

	 inline uint32 ticket3num() { return _ticket3num; } const 
	 inline void set_ticket3num(const uint32 value) { _ticket3num = value; }

	 inline int32 bforbidinviteupmic() { return _bforbidinviteupmic; } const 
	 inline void set_bforbidinviteupmic(const int32 value) { _bforbidinviteupmic = value; }

	 inline int32 bforbidchat() { return _bforbidchat; } const 
	 inline void set_bforbidchat(const int32 value) { _bforbidchat = value; }

	 inline int32 ncarid() { return _ncarid; } const 
	 inline void set_ncarid(const int32 value) { _ncarid = value; }

	 inline string& useralias() { return _useralias; } const 
	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline string& carname() { return _carname; } const 
	 inline void set_carname(const string& value) { _carname = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomUserInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomUserInfo* cmd = (protocol::tag_CMDRoomUserInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->viplevel = _viplevel;
		cmd->yiyuanlevel = _yiyuanlevel;
		cmd->shoufulevel = _shoufulevel;
		cmd->zhonglevel = _zhonglevel;
		cmd->caifulevel = _caifulevel;
		cmd->lastmonthcostlevel = _lastmonthcostlevel;
		cmd->thismonthcostlevel = _thismonthcostlevel;
		cmd->thismonthcostgrade = _thismonthcostgrade;
		cmd->pubmicindex = _pubmicindex;
		cmd->roomlevel = _roomlevel;
		cmd->usertype = _usertype;
		cmd->sealid = _sealid;
		cmd->cometime = _cometime;
		cmd->headicon = _headicon;
		cmd->micgiftid = _micgiftid;
		cmd->micgiftnum = _micgiftnum;
		cmd->sealexpiretime = _sealexpiretime;
		cmd->userstate = _userstate;
		cmd->starflag = _starflag;
		cmd->activityflag = _activityflag;
		cmd->flowernum = _flowernum;
		cmd->ticket1num = _ticket1num;
		cmd->ticket2num = _ticket2num;
		cmd->ticket3num = _ticket3num;
		cmd->bforbidinviteupmic = _bforbidinviteupmic;
		cmd->bforbidchat = _bforbidchat;
		cmd->ncarid = _ncarid;
		strcpy(cmd->useralias, _useralias.c_str());
		strcpy(cmd->carname, _carname.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomUserInfo* cmd = (protocol::tag_CMDRoomUserInfo*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_viplevel = cmd->viplevel;
		_yiyuanlevel = cmd->yiyuanlevel;
		_shoufulevel = cmd->shoufulevel;
		_zhonglevel = cmd->zhonglevel;
		_caifulevel = cmd->caifulevel;
		_lastmonthcostlevel = cmd->lastmonthcostlevel;
		_thismonthcostlevel = cmd->thismonthcostlevel;
		_thismonthcostgrade = cmd->thismonthcostgrade;
		_pubmicindex = cmd->pubmicindex;
		_roomlevel = cmd->roomlevel;
		_usertype = cmd->usertype;
		_sealid = cmd->sealid;
		_cometime = cmd->cometime;
		_headicon = cmd->headicon;
		_micgiftid = cmd->micgiftid;
		_micgiftnum = cmd->micgiftnum;
		_sealexpiretime = cmd->sealexpiretime;
		_userstate = cmd->userstate;
		_starflag = cmd->starflag;
		_activityflag = cmd->activityflag;
		_flowernum = cmd->flowernum;
		_ticket1num = cmd->ticket1num;
		_ticket2num = cmd->ticket2num;
		_ticket3num = cmd->ticket3num;
		_bforbidinviteupmic = cmd->bforbidinviteupmic;
		_bforbidchat = cmd->bforbidchat;
		_ncarid = cmd->ncarid;
		_useralias = cmd->useralias;
		_carname = cmd->carname;
	}

	void Log()
	{
		LOG("--------Receive message: RoomUserInfo---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("viplevel = %d", _viplevel);
		LOG("yiyuanlevel = %d", _yiyuanlevel);
		LOG("shoufulevel = %d", _shoufulevel);
		LOG("zhonglevel = %d", _zhonglevel);
		LOG("caifulevel = %d", _caifulevel);
		LOG("lastmonthcostlevel = %d", _lastmonthcostlevel);
		LOG("thismonthcostlevel = %d", _thismonthcostlevel);
		LOG("thismonthcostgrade = %d", _thismonthcostgrade);
		LOG("pubmicindex = %d", _pubmicindex);
		LOG("roomlevel = %d", _roomlevel);
		LOG("usertype = %d", _usertype);
		LOG("sealid = %d", _sealid);
		LOG("cometime = %d", _cometime);
		LOG("headicon = %d", _headicon);
		LOG("micgiftid = %d", _micgiftid);
		LOG("micgiftnum = %d", _micgiftnum);
		LOG("sealexpiretime = %d", _sealexpiretime);
		LOG("userstate = %d", _userstate);
		LOG("starflag = %d", _starflag);
		LOG("activityflag = %d", _activityflag);
		LOG("flowernum = %d", _flowernum);
		LOG("ticket1num = %d", _ticket1num);
		LOG("ticket2num = %d", _ticket2num);
		LOG("ticket3num = %d", _ticket3num);
		LOG("bforbidinviteupmic = %d", _bforbidinviteupmic);
		LOG("bforbidchat = %d", _bforbidchat);
		LOG("ncarid = %d", _ncarid);
		LOG("useralias = %s", _useralias.c_str());
		LOG("carname = %s", _carname.c_str());
	}

};


class AdKeywordsReq
{

private:

	int32	_num;
	int32	_naction;
	int32	_ntype;
	int32	_nrunerid;
	string	_createtime;
	string	_keyword;


public:

	 inline int32 num() { return _num; } const 
	 inline void set_num(const int32 value) { _num = value; }

	 inline int32 naction() { return _naction; } const 
	 inline void set_naction(const int32 value) { _naction = value; }

	 inline int32 ntype() { return _ntype; } const 
	 inline void set_ntype(const int32 value) { _ntype = value; }

	 inline int32 nrunerid() { return _nrunerid; } const 
	 inline void set_nrunerid(const int32 value) { _nrunerid = value; }

	 inline string& createtime() { return _createtime; } const 
	 inline void set_createtime(const string& value) { _createtime = value; }

	 inline string& keyword() { return _keyword; } const 
	 inline void set_keyword(const string& value) { _keyword = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDAdKeywordsReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordsReq* cmd = (protocol::tag_CMDAdKeywordsReq*) data;
		cmd->num = _num;
		cmd->naction = _naction;
		cmd->ntype = _ntype;
		cmd->nrunerid = _nrunerid;
		strcpy(cmd->createtime, _createtime.c_str());
		strcpy(cmd->keyword, _keyword.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordsReq* cmd = (protocol::tag_CMDAdKeywordsReq*) data;
		_num = cmd->num;
		_naction = cmd->naction;
		_ntype = cmd->ntype;
		_nrunerid = cmd->nrunerid;
		_createtime = cmd->createtime;
		_keyword = cmd->keyword;
	}

	void Log()
	{
		LOG("--------Receive message: AdKeywordsReq---------");
		LOG("num = %d", _num);
		LOG("naction = %d", _naction);
		LOG("ntype = %d", _ntype);
		LOG("nrunerid = %d", _nrunerid);
		LOG("createtime = %s", _createtime.c_str());
		LOG("keyword = %s", _keyword.c_str());
	}

};


class AdKeywordsNotify
{

private:

	int32	_num;
	string	_keywod;


public:

	 inline int32 num() { return _num; } const 
	 inline void set_num(const int32 value) { _num = value; }

	 inline string& keywod() { return _keywod; } const 
	 inline void set_keywod(const string& value) { _keywod = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDAdKeywordsNotify); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordsNotify* cmd = (protocol::tag_CMDAdKeywordsNotify*) data;
		cmd->num = _num;
		strcpy(cmd->keywod, _keywod.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordsNotify* cmd = (protocol::tag_CMDAdKeywordsNotify*) data;
		_num = cmd->num;
		_keywod = cmd->keywod;
	}

	void Log()
	{
		LOG("--------Receive message: AdKeywordsNotify---------");
		LOG("num = %d", _num);
		LOG("keywod = %s", _keywod.c_str());
	}

};


class AdKeywordsResp
{

private:

	int32	_errid;
	uint32	_userid;


public:

	 inline int32 errid() { return _errid; } const 
	 inline void set_errid(const int32 value) { _errid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDAdKeywordsResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordsResp* cmd = (protocol::tag_CMDAdKeywordsResp*) data;
		cmd->errid = _errid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordsResp* cmd = (protocol::tag_CMDAdKeywordsResp*) data;
		_errid = cmd->errid;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: AdKeywordsResp---------");
		LOG("errid = %d", _errid);
		LOG("userid = %d", _userid);
	}

};


class SetRoomInfoReq_v2
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_nallowjoinmode;
	uint32	_ncloseroom;
	uint32	_nclosepubchat;
	uint32	_nclosecolorbar;
	uint32	_nclosefreemic;
	uint32	_ncloseinoutmsg;
	uint32	_ncloseprvchat;
	string	_cname;
	string	_cpwd;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 nallowjoinmode() { return _nallowjoinmode; } const 
	 inline void set_nallowjoinmode(const uint32 value) { _nallowjoinmode = value; }

	 inline uint32 ncloseroom() { return _ncloseroom; } const 
	 inline void set_ncloseroom(const uint32 value) { _ncloseroom = value; }

	 inline uint32 nclosepubchat() { return _nclosepubchat; } const 
	 inline void set_nclosepubchat(const uint32 value) { _nclosepubchat = value; }

	 inline uint32 nclosecolorbar() { return _nclosecolorbar; } const 
	 inline void set_nclosecolorbar(const uint32 value) { _nclosecolorbar = value; }

	 inline uint32 nclosefreemic() { return _nclosefreemic; } const 
	 inline void set_nclosefreemic(const uint32 value) { _nclosefreemic = value; }

	 inline uint32 ncloseinoutmsg() { return _ncloseinoutmsg; } const 
	 inline void set_ncloseinoutmsg(const uint32 value) { _ncloseinoutmsg = value; }

	 inline uint32 ncloseprvchat() { return _ncloseprvchat; } const 
	 inline void set_ncloseprvchat(const uint32 value) { _ncloseprvchat = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomInfoReq_v2); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomInfoReq_v2* cmd = (protocol::tag_CMDSetRoomInfoReq_v2*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->nallowjoinmode = _nallowjoinmode;
		cmd->ncloseroom = _ncloseroom;
		cmd->nclosepubchat = _nclosepubchat;
		cmd->nclosecolorbar = _nclosecolorbar;
		cmd->nclosefreemic = _nclosefreemic;
		cmd->ncloseinoutmsg = _ncloseinoutmsg;
		cmd->ncloseprvchat = _ncloseprvchat;
		strcpy(cmd->cname, _cname.c_str());
		strcpy(cmd->cpwd, _cpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomInfoReq_v2* cmd = (protocol::tag_CMDSetRoomInfoReq_v2*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_nallowjoinmode = cmd->nallowjoinmode;
		_ncloseroom = cmd->ncloseroom;
		_nclosepubchat = cmd->nclosepubchat;
		_nclosecolorbar = cmd->nclosecolorbar;
		_nclosefreemic = cmd->nclosefreemic;
		_ncloseinoutmsg = cmd->ncloseinoutmsg;
		_ncloseprvchat = cmd->ncloseprvchat;
		_cname = cmd->cname;
		_cpwd = cmd->cpwd;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomInfoReq_v2---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("nallowjoinmode = %d", _nallowjoinmode);
		LOG("ncloseroom = %d", _ncloseroom);
		LOG("nclosepubchat = %d", _nclosepubchat);
		LOG("nclosecolorbar = %d", _nclosecolorbar);
		LOG("nclosefreemic = %d", _nclosefreemic);
		LOG("ncloseinoutmsg = %d", _ncloseinoutmsg);
		LOG("ncloseprvchat = %d", _ncloseprvchat);
		LOG("cname = %s", _cname.c_str());
		LOG("cpwd = %s", _cpwd.c_str());
	}

};


class SetRoomInfoResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomInfoResp* cmd = (protocol::tag_CMDSetRoomInfoResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomInfoResp* cmd = (protocol::tag_CMDSetRoomInfoResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomInfoResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
	}

};


class RoomBaseInfo
{

private:

	uint32	_vcbid;
	uint32	_groupid;
	uint32	_level;
	uint32	_busepwd;
	uint32	_seats;
	uint32	_creatorid;
	uint32	_op1id;
	uint32	_op2id;
	uint32	_op3id;
	uint32	_op4id;
	uint32	_opstate;
	string	_cname;
	string	_cpwd;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 groupid() { return _groupid; } const 
	 inline void set_groupid(const uint32 value) { _groupid = value; }

	 inline uint32 level() { return _level; } const 
	 inline void set_level(const uint32 value) { _level = value; }

	 inline uint32 busepwd() { return _busepwd; } const 
	 inline void set_busepwd(const uint32 value) { _busepwd = value; }

	 inline uint32 seats() { return _seats; } const 
	 inline void set_seats(const uint32 value) { _seats = value; }

	 inline uint32 creatorid() { return _creatorid; } const 
	 inline void set_creatorid(const uint32 value) { _creatorid = value; }

	 inline uint32 op1id() { return _op1id; } const 
	 inline void set_op1id(const uint32 value) { _op1id = value; }

	 inline uint32 op2id() { return _op2id; } const 
	 inline void set_op2id(const uint32 value) { _op2id = value; }

	 inline uint32 op3id() { return _op3id; } const 
	 inline void set_op3id(const uint32 value) { _op3id = value; }

	 inline uint32 op4id() { return _op4id; } const 
	 inline void set_op4id(const uint32 value) { _op4id = value; }

	 inline uint32 opstate() { return _opstate; } const 
	 inline void set_opstate(const uint32 value) { _opstate = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomBaseInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomBaseInfo* cmd = (protocol::tag_CMDRoomBaseInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->groupid = _groupid;
		cmd->level = _level;
		cmd->busepwd = _busepwd;
		cmd->seats = _seats;
		cmd->creatorid = _creatorid;
		cmd->op1id = _op1id;
		cmd->op2id = _op2id;
		cmd->op3id = _op3id;
		cmd->op4id = _op4id;
		cmd->opstate = _opstate;
		strcpy(cmd->cname, _cname.c_str());
		strcpy(cmd->cpwd, _cpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomBaseInfo* cmd = (protocol::tag_CMDRoomBaseInfo*) data;
		_vcbid = cmd->vcbid;
		_groupid = cmd->groupid;
		_level = cmd->level;
		_busepwd = cmd->busepwd;
		_seats = cmd->seats;
		_creatorid = cmd->creatorid;
		_op1id = cmd->op1id;
		_op2id = cmd->op2id;
		_op3id = cmd->op3id;
		_op4id = cmd->op4id;
		_opstate = cmd->opstate;
		_cname = cmd->cname;
		_cpwd = cmd->cpwd;
	}

	void Log()
	{
		LOG("--------Receive message: RoomBaseInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("groupid = %d", _groupid);
		LOG("level = %d", _level);
		LOG("busepwd = %d", _busepwd);
		LOG("seats = %d", _seats);
		LOG("creatorid = %d", _creatorid);
		LOG("op1id = %d", _op1id);
		LOG("op2id = %d", _op2id);
		LOG("op3id = %d", _op3id);
		LOG("op4id = %d", _op4id);
		LOG("opstate = %d", _opstate);
		LOG("cname = %s", _cname.c_str());
		LOG("cpwd = %s", _cpwd.c_str());
	}

};


class RoomOpState
{

private:

	uint32	_vcbid;
	uint32	_opstate;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 opstate() { return _opstate; } const 
	 inline void set_opstate(const uint32 value) { _opstate = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomOpState); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomOpState* cmd = (protocol::tag_CMDRoomOpState*) data;
		cmd->vcbid = _vcbid;
		cmd->opstate = _opstate;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomOpState* cmd = (protocol::tag_CMDRoomOpState*) data;
		_vcbid = cmd->vcbid;
		_opstate = cmd->opstate;
	}

	void Log()
	{
		LOG("--------Receive message: RoomOpState---------");
		LOG("vcbid = %d", _vcbid);
		LOG("opstate = %d", _opstate);
	}

};


class ForbidUserChat
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_ttime;
	uint32	_action;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 ttime() { return _ttime; } const 
	 inline void set_ttime(const uint32 value) { _ttime = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(const uint32 value) { _action = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDForbidUserChat); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDForbidUserChat* cmd = (protocol::tag_CMDForbidUserChat*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->ttime = _ttime;
		cmd->action = _action;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDForbidUserChat* cmd = (protocol::tag_CMDForbidUserChat*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_ttime = cmd->ttime;
		_action = cmd->action;
	}

	void Log()
	{
		LOG("--------Receive message: ForbidUserChat---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("ttime = %d", _ttime);
		LOG("action = %d", _action);
	}

};


class ThrowUserInfoResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDThrowUserInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDThrowUserInfoResp* cmd = (protocol::tag_CMDThrowUserInfoResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDThrowUserInfoResp* cmd = (protocol::tag_CMDThrowUserInfoResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: ThrowUserInfoResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
	}

};


class ThrowUserInfo
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_toid;
	uint32	_viplevel;
	uint32	_nscopeid;
	uint32	_ntimeid;
	uint32	_nreasionid;
	string	_szip;
	string	_szserial;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 viplevel() { return _viplevel; } const 
	 inline void set_viplevel(const uint32 value) { _viplevel = value; }

	 inline uint32 nscopeid() { return _nscopeid; } const 
	 inline void set_nscopeid(const uint32 value) { _nscopeid = value; }

	 inline uint32 ntimeid() { return _ntimeid; } const 
	 inline void set_ntimeid(const uint32 value) { _ntimeid = value; }

	 inline uint32 nreasionid() { return _nreasionid; } const 
	 inline void set_nreasionid(const uint32 value) { _nreasionid = value; }

	 inline string& szip() { return _szip; } const 
	 inline void set_szip(const string& value) { _szip = value; }

	 inline string& szserial() { return _szserial; } const 
	 inline void set_szserial(const string& value) { _szserial = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDThrowUserInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDThrowUserInfo* cmd = (protocol::tag_CMDThrowUserInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->toid = _toid;
		cmd->viplevel = _viplevel;
		cmd->nscopeid = _nscopeid;
		cmd->ntimeid = _ntimeid;
		cmd->nreasionid = _nreasionid;
		strcpy(cmd->szip, _szip.c_str());
		strcpy(cmd->szserial, _szserial.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDThrowUserInfo* cmd = (protocol::tag_CMDThrowUserInfo*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_toid = cmd->toid;
		_viplevel = cmd->viplevel;
		_nscopeid = cmd->nscopeid;
		_ntimeid = cmd->ntimeid;
		_nreasionid = cmd->nreasionid;
		_szip = cmd->szip;
		_szserial = cmd->szserial;
	}

	void Log()
	{
		LOG("--------Receive message: ThrowUserInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("toid = %d", _toid);
		LOG("viplevel = %d", _viplevel);
		LOG("nscopeid = %d", _nscopeid);
		LOG("ntimeid = %d", _ntimeid);
		LOG("nreasionid = %d", _nreasionid);
		LOG("szip = %s", _szip.c_str());
		LOG("szserial = %s", _szserial.c_str());
	}

};


class SetUserPriorityResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserPriorityResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserPriorityResp* cmd = (protocol::tag_CMDSetUserPriorityResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserPriorityResp* cmd = (protocol::tag_CMDSetUserPriorityResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserPriorityResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
	}

};


class SeeUserIpReq
{

private:

	uint32	_vcbid;
	uint32	_runid;
	uint32	_toid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runid() { return _runid; } const 
	 inline void set_runid(const uint32 value) { _runid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSeeUserIpReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSeeUserIpReq* cmd = (protocol::tag_CMDSeeUserIpReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runid = _runid;
		cmd->toid = _toid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSeeUserIpReq* cmd = (protocol::tag_CMDSeeUserIpReq*) data;
		_vcbid = cmd->vcbid;
		_runid = cmd->runid;
		_toid = cmd->toid;
	}

	void Log()
	{
		LOG("--------Receive message: SeeUserIpReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runid = %d", _runid);
		LOG("toid = %d", _toid);
	}

};


class SeeUserIpResp
{

private:

	uint32	_vcbid;
	uint32	_runid;
	uint32	_userid;
	uint32	_textlen;
	uint32	_reserve;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runid() { return _runid; } const 
	 inline void set_runid(const uint32 value) { _runid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline uint32 reserve() { return _reserve; } const 
	 inline void set_reserve(const uint32 value) { _reserve = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSeeUserIpResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSeeUserIpResp* cmd = (protocol::tag_CMDSeeUserIpResp*) data;
		cmd->vcbid = _vcbid;
		cmd->runid = _runid;
		cmd->userid = _userid;
		cmd->textlen = _textlen;
		cmd->reserve = _reserve;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSeeUserIpResp* cmd = (protocol::tag_CMDSeeUserIpResp*) data;
		_vcbid = cmd->vcbid;
		_runid = cmd->runid;
		_userid = cmd->userid;
		_textlen = cmd->textlen;
		_reserve = cmd->reserve;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: SeeUserIpResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runid = %d", _runid);
		LOG("userid = %d", _userid);
		LOG("textlen = %d", _textlen);
		LOG("reserve = %d", _reserve);
		LOG("content = %s", _content.c_str());
	}

};

class ReportMediaGateReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDReportMediaGateReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDReportMediaGateReq* cmd = (protocol::tag_CMDReportMediaGateReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDReportMediaGateReq* cmd = (protocol::tag_CMDReportMediaGateReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: ReportMediaGateReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class ReportMediaGateResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_errid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 errid() { return _errid; } const 
	 inline void set_errid(const int32 value) { _errid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDReportMediaGateResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDReportMediaGateResp* cmd = (protocol::tag_CMDReportMediaGateResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDReportMediaGateResp* cmd = (protocol::tag_CMDReportMediaGateResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_errid = cmd->errid;
	}

	void Log()
	{
		LOG("--------Receive message: ReportMediaGateResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("errid = %d", _errid);
	}

};


class GetUserInfoReq
{

private:

	uint32	_srcuserid;
	uint32	_dstuserid;


public:

	 inline uint32 srcuserid() { return _srcuserid; } const 
	 inline void set_srcuserid(const uint32 value) { _srcuserid = value; }

	 inline uint32 dstuserid() { return _dstuserid; } const 
	 inline void set_dstuserid(const uint32 value) { _dstuserid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetUserInfoReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetUserInfoReq* cmd = (protocol::tag_CMDGetUserInfoReq*) data;
		cmd->srcuserid = _srcuserid;
		cmd->dstuserid = _dstuserid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetUserInfoReq* cmd = (protocol::tag_CMDGetUserInfoReq*) data;
		_srcuserid = cmd->srcuserid;
		_dstuserid = cmd->dstuserid;
	}

	void Log()
	{
		LOG("--------Receive message: GetUserInfoReq---------");
		LOG("srcuserid = %d", _srcuserid);
		LOG("dstuserid = %d", _dstuserid);
	}

};


class TeacherInfoResp
{

private:

	uint32	_teacherid;
	uint32	_headid;
	uint32	_vcbid;
	int32	_introducelen;
	int32	_lablelen;
	int32	_levellen;
	int32	_type;
	uint64	_czans;
	uint64	_moods;
	uint64	_fans;
	uint32	_fansflag;
	uint32	_subflag;
	string	_content;


public:

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(const uint32 value) { _headid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 introducelen() { return _introducelen; } const 
	 inline void set_introducelen(const int32 value) { _introducelen = value; }

	 inline int32 lablelen() { return _lablelen; } const 
	 inline void set_lablelen(const int32 value) { _lablelen = value; }

	 inline int32 levellen() { return _levellen; } const 
	 inline void set_levellen(const int32 value) { _levellen = value; }

	 inline int32 type() { return _type; } const 
	 inline void set_type(const int32 value) { _type = value; }

	 inline uint64 czans() { return _czans; } const 
	 inline void set_czans(const uint64 value) { _czans = value; }

	 inline uint64 moods() { return _moods; } const 
	 inline void set_moods(const uint64 value) { _moods = value; }

	 inline uint64 fans() { return _fans; } const 
	 inline void set_fans(const uint64 value) { _fans = value; }

	 inline uint32 fansflag() { return _fansflag; } const 
	 inline void set_fansflag(const uint32 value) { _fansflag = value; }

	 inline uint32 subflag() { return _subflag; } const 
	 inline void set_subflag(const uint32 value) { _subflag = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherInfoResp* cmd = (protocol::tag_CMDTeacherInfoResp*) data;
		cmd->teacherid = _teacherid;
		cmd->headid = _headid;
		cmd->vcbid = _vcbid;
		cmd->introducelen = _introducelen;
		cmd->lablelen = _lablelen;
		cmd->levellen = _levellen;
		cmd->type = _type;
		cmd->czans = _czans;
		cmd->moods = _moods;
		cmd->fans = _fans;
		cmd->fansflag = _fansflag;
		cmd->subflag = _subflag;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherInfoResp* cmd = (protocol::tag_CMDTeacherInfoResp*) data;
		_teacherid = cmd->teacherid;
		_headid = cmd->headid;
		_vcbid = cmd->vcbid;
		_introducelen = cmd->introducelen;
		_lablelen = cmd->lablelen;
		_levellen = cmd->levellen;
		_type = cmd->type;
		_czans = cmd->czans;
		_moods = cmd->moods;
		_fans = cmd->fans;
		_fansflag = cmd->fansflag;
		_subflag = cmd->subflag;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherInfoResp---------");
		LOG("teacherid = %d", _teacherid);
		LOG("headid = %d", _headid);
		LOG("vcbid = %d", _vcbid);
		LOG("introducelen = %d", _introducelen);
		LOG("lablelen = %d", _lablelen);
		LOG("levellen = %d", _levellen);
		LOG("type = %d", _type);
		LOG("czans = %lld", _czans);
		LOG("moods = %lld", _moods);
		LOG("fans = %lld", _fans);
		LOG("fansflag = %d", _fansflag);
		LOG("subflag = %d", _subflag);
		LOG("content = %s", _content.c_str());
	}

};


class RoomUserInfoResp
{

private:

	uint32	_userid;
	uint32	_headid;
	uint32	_birthday;
	int32	_introducelen;
	int32	_provincelen;
	int32	_citylen;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(const uint32 value) { _headid = value; }

	 inline uint32 birthday() { return _birthday; } const 
	 inline void set_birthday(const uint32 value) { _birthday = value; }

	 inline int32 introducelen() { return _introducelen; } const 
	 inline void set_introducelen(const int32 value) { _introducelen = value; }

	 inline int32 provincelen() { return _provincelen; } const 
	 inline void set_provincelen(const int32 value) { _provincelen = value; }

	 inline int32 citylen() { return _citylen; } const 
	 inline void set_citylen(const int32 value) { _citylen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomUserInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomUserInfoResp* cmd = (protocol::tag_CMDRoomUserInfoResp*) data;
		cmd->userid = _userid;
		cmd->headid = _headid;
		cmd->birthday = _birthday;
		cmd->introducelen = _introducelen;
		cmd->provincelen = _provincelen;
		cmd->citylen = _citylen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomUserInfoResp* cmd = (protocol::tag_CMDRoomUserInfoResp*) data;
		_userid = cmd->userid;
		_headid = cmd->headid;
		_birthday = cmd->birthday;
		_introducelen = cmd->introducelen;
		_provincelen = cmd->provincelen;
		_citylen = cmd->citylen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: RoomUserInfoResp---------");
		LOG("userid = %d", _userid);
		LOG("headid = %d", _headid);
		LOG("birthday = %d", _birthday);
		LOG("introducelen = %d", _introducelen);
		LOG("provincelen = %d", _provincelen);
		LOG("citylen = %d", _citylen);
		LOG("content = %s", _content.c_str());
	}

};


class UserInfoErr
{

private:

	uint32	_userid;
	uint32	_errid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 errid() { return _errid; } const 
	 inline void set_errid(const uint32 value) { _errid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserInfoErr); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserInfoErr* cmd = (protocol::tag_CMDUserInfoErr*) data;
		cmd->userid = _userid;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserInfoErr* cmd = (protocol::tag_CMDUserInfoErr*) data;
		_userid = cmd->userid;
		_errid = cmd->errid;
	}

	void Log()
	{
		LOG("--------Receive message: UserInfoErr---------");
		LOG("userid = %d", _userid);
		LOG("errid = %d", _errid);
	}

};


class FavoriteRoomReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_actionid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 actionid() { return _actionid; } const 
	 inline void set_actionid(const int32 value) { _actionid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDFavoriteRoomReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDFavoriteRoomReq* cmd = (protocol::tag_CMDFavoriteRoomReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->actionid = _actionid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDFavoriteRoomReq* cmd = (protocol::tag_CMDFavoriteRoomReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_actionid = cmd->actionid;
	}

	void Log()
	{
		LOG("--------Receive message: FavoriteRoomReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("actionid = %d", _actionid);
	}

};


class FavoriteRoomResp
{

private:

	int32	_errorid;
	uint32	_vcbid;
	int32	_actionid;


public:

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(const int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 actionid() { return _actionid; } const 
	 inline void set_actionid(const int32 value) { _actionid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDFavoriteRoomResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDFavoriteRoomResp* cmd = (protocol::tag_CMDFavoriteRoomResp*) data;
		cmd->errorid = _errorid;
		cmd->vcbid = _vcbid;
		cmd->actionid = _actionid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDFavoriteRoomResp* cmd = (protocol::tag_CMDFavoriteRoomResp*) data;
		_errorid = cmd->errorid;
		_vcbid = cmd->vcbid;
		_actionid = cmd->actionid;
	}

	void Log()
	{
		LOG("--------Receive message: FavoriteRoomResp---------");
		LOG("errorid = %d", _errorid);
		LOG("vcbid = %d", _vcbid);
		LOG("actionid = %d", _actionid);
	}

};


class TextRoomList_mobile
{

private:

	string	_uuid;


public:

	 inline string& uuid() { return _uuid; } const 

	 inline void set_uuid(const string& value) { _uuid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomList_mobile); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomList_mobile* cmd = (protocol::tag_CMDTextRoomList_mobile*) data;
		strcpy(cmd->uuid, _uuid.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomList_mobile* cmd = (protocol::tag_CMDTextRoomList_mobile*) data;
		_uuid = cmd->uuid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomList_mobile---------");
		LOG("uuid = %s", _uuid.c_str());
	}

};


class UserPriority
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_userid;
	uint32	_action;
	uint32	_priority;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(const uint32 value) { _action = value; }

	 inline uint32 priority() { return _priority; } const 
	 inline void set_priority(const uint32 value) { _priority = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserPriority); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserPriority* cmd = (protocol::tag_CMDUserPriority*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->userid = _userid;
		cmd->action = _action;
		cmd->priority = _priority;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserPriority* cmd = (protocol::tag_CMDUserPriority*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_userid = cmd->userid;
		_action = cmd->action;
		_priority = cmd->priority;
	}

	void Log()
	{
		LOG("--------Receive message: UserPriority---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("userid = %d", _userid);
		LOG("action = %d", _action);
		LOG("priority = %d", _priority);
	}

};


class TradeGiftRecord
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_tovcbid;
	uint32	_totype;
	uint32	_giftid;
	uint32	_giftnum;
	uint32	_action;
	uint32	_servertype;
	uint32	_banonymous;
	uint32	_casttype;
	uint32	_dtime;
	uint32	_oldnum;
	uint32	_flyid;
	string	_srcvcbname;
	string	_tovcbname;
	string	_srcalias;
	string	_toalias;
	string	_sztext;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 tovcbid() { return _tovcbid; } const 
	 inline void set_tovcbid(const uint32 value) { _tovcbid = value; }

	 inline uint32 totype() { return _totype; } const 
	 inline void set_totype(const uint32 value) { _totype = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(const uint32 value) { _giftid = value; }

	 inline uint32 giftnum() { return _giftnum; } const 
	 inline void set_giftnum(const uint32 value) { _giftnum = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(const uint32 value) { _action = value; }

	 inline uint32 servertype() { return _servertype; } const 
	 inline void set_servertype(const uint32 value) { _servertype = value; }

	 inline uint32 banonymous() { return _banonymous; } const 
	 inline void set_banonymous(const uint32 value) { _banonymous = value; }

	 inline uint32 casttype() { return _casttype; } const 
	 inline void set_casttype(const uint32 value) { _casttype = value; }

	 inline uint32 dtime() { return _dtime; } const 
	 inline void set_dtime(const uint32 value) { _dtime = value; }

	 inline uint32 oldnum() { return _oldnum; } const 
	 inline void set_oldnum(const uint32 value) { _oldnum = value; }

	 inline uint32 flyid() { return _flyid; } const 
	 inline void set_flyid(const uint32 value) { _flyid = value; }

	 inline string& srcvcbname() { return _srcvcbname; } const 
	 inline void set_srcvcbname(const string& value) { _srcvcbname = value; }

	 inline string& tovcbname() { return _tovcbname; } const 
	 inline void set_tovcbname(const string& value) { _tovcbname = value; }

	 inline string& srcalias() { return _srcalias; } const 
	 inline void set_srcalias(const string& value) { _srcalias = value; }

	 inline string& toalias() { return _toalias; } const 
	 inline void set_toalias(const string& value) { _toalias = value; }

	 inline string& sztext() { return _sztext; } const 
	 inline void set_sztext(const string& value) { _sztext = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTradeGiftRecord); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTradeGiftRecord* cmd = (protocol::tag_CMDTradeGiftRecord*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->tovcbid = _tovcbid;
		cmd->totype = _totype;
		cmd->giftid = _giftid;
		cmd->giftnum = _giftnum;
		cmd->action = _action;
		cmd->servertype = _servertype;
		cmd->banonymous = _banonymous;
		cmd->casttype = _casttype;
		cmd->dtime = _dtime;
		cmd->oldnum = _oldnum;
		cmd->flyid = _flyid;
		strcpy(cmd->srcvcbname, _srcvcbname.c_str());
		strcpy(cmd->tovcbname, _tovcbname.c_str());
		strcpy(cmd->srcalias, _srcalias.c_str());
		strcpy(cmd->toalias, _toalias.c_str());
		strcpy(cmd->sztext, _sztext.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTradeGiftRecord* cmd = (protocol::tag_CMDTradeGiftRecord*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_tovcbid = cmd->tovcbid;
		_totype = cmd->totype;
		_giftid = cmd->giftid;
		_giftnum = cmd->giftnum;
		_action = cmd->action;
		_servertype = cmd->servertype;
		_banonymous = cmd->banonymous;
		_casttype = cmd->casttype;
		_dtime = cmd->dtime;
		_oldnum = cmd->oldnum;
		_flyid = cmd->flyid;
		_srcvcbname = cmd->srcvcbname;
		_tovcbname = cmd->tovcbname;
		_srcalias = cmd->srcalias;
		_toalias = cmd->toalias;
		_sztext = cmd->sztext;
	}

	void Log()
	{
		LOG("--------Receive message: TradeGiftRecord---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("tovcbid = %d", _tovcbid);
		LOG("totype = %d", _totype);
		LOG("giftid = %d", _giftid);
		LOG("giftnum = %d", _giftnum);
		LOG("action = %d", _action);
		LOG("servertype = %d", _servertype);
		LOG("banonymous = %d", _banonymous);
		LOG("casttype = %d", _casttype);
		LOG("dtime = %d", _dtime);
		LOG("oldnum = %d", _oldnum);
		LOG("flyid = %d", _flyid);
		LOG("srcvcbname = %s", _srcvcbname.c_str());
		LOG("tovcbname = %s", _tovcbname.c_str());
		LOG("srcalias = %s", _srcalias.c_str());
		LOG("toalias = %s", _toalias.c_str());
		LOG("sztext = %s", _sztext.c_str());
	}

};


class TradeGiftResp
{

private:



public:


	int ByteSize() { return sizeof(protocol::tag_CMDTradeGiftResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTradeGiftResp* cmd = (protocol::tag_CMDTradeGiftResp*) data;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTradeGiftResp* cmd = (protocol::tag_CMDTradeGiftResp*) data;
	}

	void Log()
	{
		LOG("--------Receive message: TradeGiftResp---------");
	}

};


class TradeGiftErr
{

private:

	int32	_nerrid;


public:

	 inline int32 nerrid() { return _nerrid; } const 
	 inline void set_nerrid(const int32 value) { _nerrid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTradeGiftErr); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTradeGiftErr* cmd = (protocol::tag_CMDTradeGiftErr*) data;
		cmd->nerrid = _nerrid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTradeGiftErr* cmd = (protocol::tag_CMDTradeGiftErr*) data;
		_nerrid = cmd->nerrid;
	}

	void Log()
	{
		LOG("--------Receive message: TradeGiftErr---------");
		LOG("nerrid = %d", _nerrid);
	}

};


class UserKickoutRoomInfo_ext
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	int32	_resonid;
	uint32	_mins;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline int32 resonid() { return _resonid; } const 
	 inline void set_resonid(const int32 value) { _resonid = value; }

	 inline uint32 mins() { return _mins; } const 
	 inline void set_mins(const uint32 value) { _mins = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserKickoutRoomInfo_ext); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserKickoutRoomInfo_ext* cmd = (protocol::tag_CMDUserKickoutRoomInfo_ext*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->resonid = _resonid;
		cmd->mins = _mins;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserKickoutRoomInfo_ext* cmd = (protocol::tag_CMDUserKickoutRoomInfo_ext*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_resonid = cmd->resonid;
		_mins = cmd->mins;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: UserKickoutRoomInfo_ext---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("resonid = %d", _resonid);
		LOG("mins = %d", _mins);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class UserExceptExitRoomInfo_ext
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserExceptExitRoomInfo_ext); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserExceptExitRoomInfo_ext* cmd = (protocol::tag_CMDUserExceptExitRoomInfo_ext*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserExceptExitRoomInfo_ext* cmd = (protocol::tag_CMDUserExceptExitRoomInfo_ext*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: UserExceptExitRoomInfo_ext---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class TeacherSubscriptionReq
{

private:

	uint32	_nmask;
	uint32	_userid;
	uint32	_teacherid;
	uint32	_bsub;


public:

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 bsub() { return _bsub; } const 
	 inline void set_bsub(const uint32 value) { _bsub = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherSubscriptionReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionReq* cmd = (protocol::tag_CMDTeacherSubscriptionReq*) data;
		cmd->nmask = _nmask;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->bSub = _bsub;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionReq* cmd = (protocol::tag_CMDTeacherSubscriptionReq*) data;
		_nmask = cmd->nmask;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_bsub = cmd->bSub;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherSubscriptionReq---------");
		LOG("nmask = %d", _nmask);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("bsub = %d", _bsub);
	}

};


class TeacherSubscriptionResp
{

private:

	uint32	_nmask;
	uint32	_userid;
	uint32	_errcode;


public:

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 errcode() { return _errcode; } const 
	 inline void set_errcode(const uint32 value) { _errcode = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherSubscriptionResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionResp* cmd = (protocol::tag_CMDTeacherSubscriptionResp*) data;
		cmd->nmask = _nmask;
		cmd->userid = _userid;
		cmd->errcode = _errcode;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionResp* cmd = (protocol::tag_CMDTeacherSubscriptionResp*) data;
		_nmask = cmd->nmask;
		_userid = cmd->userid;
		_errcode = cmd->errcode;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherSubscriptionResp---------");
		LOG("nmask = %d", _nmask);
		LOG("userid = %d", _userid);
		LOG("errcode = %d", _errcode);
	}

};







#endif
