#ifndef __VIDEOROOM_MESSAGE_H__
#define __VIDEOROOM_MESSAGE_H__



#include <string>
#include "Log.h"
#include "videoroom_cmd_vchat.h"
using std::string;


class GateJoinRoomReq
{

private:

	uint32	_userid;
	uint32	_vcbid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGateJoinRoomReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGateJoinRoomReq* cmd = (protocol::tag_CMDGateJoinRoomReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGateJoinRoomReq* cmd = (protocol::tag_CMDGateJoinRoomReq*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
	}

	void Log()
	{
		LOG("--------Receive message: GateJoinRoomReq---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
	}

};


class RoomPubMicState
{

private:

	int32	_micid;
	int32	_mictimetype;
	uint32	_userid;
	int32	_userlefttime;


public:

	 inline int32 micid() { return _micid; } const 

	 inline void set_micid(const int32 value) { _micid = value; }

	 inline int32 mictimetype() { return _mictimetype; } const 

	 inline void set_mictimetype(const int32 value) { _mictimetype = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 userlefttime() { return _userlefttime; } const 

	 inline void set_userlefttime(const int32 value) { _userlefttime = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomPubMicState); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomPubMicState* cmd = (protocol::tag_CMDRoomPubMicState*) data;
		cmd->micid = _micid;
		cmd->mictimetype = _mictimetype;
		cmd->userid = _userid;
		cmd->userlefttime = _userlefttime;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomPubMicState* cmd = (protocol::tag_CMDRoomPubMicState*) data;
		_micid = cmd->micid;
		_mictimetype = cmd->mictimetype;
		_userid = cmd->userid;
		_userlefttime = cmd->userlefttime;
	}

	void Log()
	{
		LOG("--------Receive message: RoomPubMicState---------");
		LOG("micid = %d", _micid);
		LOG("mictimetype = %d", _mictimetype);
		LOG("userid = %d", _userid);
		LOG("userlefttime = %d", _userlefttime);
	}

};


class RoomChatMsg
{

private:

	uint32	_vcbid;
	uint32	_tocbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_srcviplevel;
	uint32	_msgtype;
	uint32	_textlen;
	string	_srcalias;
	string	_toalias;
	string	_vcbname;
	string	_tocbname;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 tocbid() { return _tocbid; } const 

	 inline void set_tocbid(const uint32 value) { _tocbid = value; }

	 inline uint32 srcid() { return _srcid; } const 

	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 

	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 srcviplevel() { return _srcviplevel; } const 

	 inline void set_srcviplevel(const uint32 value) { _srcviplevel = value; }

	 inline uint32 msgtype() { return _msgtype; } const 

	 inline void set_msgtype(const uint32 value) { _msgtype = value; }

	 inline uint32 textlen() { return _textlen; } const 

	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& srcalias() { return _srcalias; } const 

	 inline void set_srcalias(const string& value) { _srcalias = value; }

	 inline string& toalias() { return _toalias; } const 

	 inline void set_toalias(const string& value) { _toalias = value; }

	 inline string& vcbname() { return _vcbname; } const 

	 inline void set_vcbname(const string& value) { _vcbname = value; }

	 inline string& tocbname() { return _tocbname; } const 

	 inline void set_tocbname(const string& value) { _tocbname = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomChatMsg); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomChatMsg* cmd = (protocol::tag_CMDRoomChatMsg*) data;
		cmd->vcbid = _vcbid;
		cmd->tocbid = _tocbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->srcviplevel = _srcviplevel;
		cmd->msgtype = _msgtype;
		cmd->textlen = _textlen;
		strcpy(cmd->srcalias, _srcalias.c_str());
		strcpy(cmd->toalias, _toalias.c_str());
		strcpy(cmd->vcbname, _vcbname.c_str());
		strcpy(cmd->tocbname, _tocbname.c_str());
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomChatMsg* cmd = (protocol::tag_CMDRoomChatMsg*) data;
		_vcbid = cmd->vcbid;
		_tocbid = cmd->tocbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_srcviplevel = cmd->srcviplevel;
		_msgtype = cmd->msgtype;
		_textlen = cmd->textlen;
		_srcalias = cmd->srcalias;
		_toalias = cmd->toalias;
		_vcbname = cmd->vcbname;
		_tocbname = cmd->tocbname;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: RoomChatMsg---------");
		LOG("vcbid = %d", _vcbid);
		LOG("tocbid = %d", _tocbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("srcviplevel = %d", _srcviplevel);
		LOG("msgtype = %d", _msgtype);
		LOG("textlen = %d", _textlen);
		LOG("srcalias = %s", _srcalias.c_str());
		LOG("toalias = %s", _toalias.c_str());
		LOG("vcbname = %s", _vcbname.c_str());
		LOG("tocbname = %s", _tocbname.c_str());
		LOG("content = %s", _content.c_str());
	}

};


class RoomNotice
{

private:

	uint32	_vcbid;
	uint32	_index;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 index() { return _index; } const 

	 inline void set_index(const uint32 value) { _index = value; }

	 inline uint32 textlen() { return _textlen; } const 

	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomNotice); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomNotice* cmd = (protocol::tag_CMDRoomNotice*) data;
		cmd->vcbid = _vcbid;
		cmd->index = _index;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomNotice* cmd = (protocol::tag_CMDRoomNotice*) data;
		_vcbid = cmd->vcbid;
		_index = cmd->index;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: RoomNotice---------");
		LOG("vcbid = %d", _vcbid);
		LOG("index = %d", _index);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class SysCastNotice
{

private:

	uint32	_msgtype;
	uint32	_reserve;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 msgtype() { return _msgtype; } const 

	 inline void set_msgtype(const uint32 value) { _msgtype = value; }

	 inline uint32 reserve() { return _reserve; } const 

	 inline void set_reserve(const uint32 value) { _reserve = value; }

	 inline uint32 textlen() { return _textlen; } const 

	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSysCastNotice); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSysCastNotice* cmd = (protocol::tag_CMDSysCastNotice*) data;
		cmd->msgtype = _msgtype;
		cmd->reserve = _reserve;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSysCastNotice* cmd = (protocol::tag_CMDSysCastNotice*) data;
		_msgtype = cmd->msgtype;
		_reserve = cmd->reserve;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: SysCastNotice---------");
		LOG("msgtype = %d", _msgtype);
		LOG("reserve = %d", _reserve);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class RoomManagerInfo
{

private:

	uint32	_vcbid;
	uint32	_num;
	uint32	_members[0];


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 num() { return _num; } const 

	 inline void set_num(const uint32 value) { _num = value; }

	 inline uint32* members() { return _members; } const 


	int ByteSize() { return sizeof(protocol::tag_CMDRoomManagerInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomManagerInfo* cmd = (protocol::tag_CMDRoomManagerInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->num = _num;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomManagerInfo* cmd = (protocol::tag_CMDRoomManagerInfo*) data;
		_vcbid = cmd->vcbid;
		_num = cmd->num;
		for (int i = 0; i < 0; i++)
		{
			_members[i] = cmd->members[i];
		}
	}

	void Log()
	{
		LOG("--------Receive message: RoomManagerInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("num = %d", _num);
	}

};


class UserExitRoomInfo_ext
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


	int ByteSize() { return sizeof(protocol::tag_CMDUserExitRoomInfo_ext); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserExitRoomInfo_ext* cmd = (protocol::tag_CMDUserExitRoomInfo_ext*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserExitRoomInfo_ext* cmd = (protocol::tag_CMDUserExitRoomInfo_ext*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: UserExitRoomInfo_ext---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class UserExceptExitRoomInfo
{

private:

	uint32	_userid;
	uint32	_vcbid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserExceptExitRoomInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserExceptExitRoomInfo* cmd = (protocol::tag_CMDUserExceptExitRoomInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserExceptExitRoomInfo* cmd = (protocol::tag_CMDUserExceptExitRoomInfo*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
	}

	void Log()
	{
		LOG("--------Receive message: UserExceptExitRoomInfo---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
	}

};


class QueryUserAccountReq
{

private:

	uint32	_vcbid;
	uint32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryUserAccountReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserAccountReq* cmd = (protocol::tag_CMDQueryUserAccountReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserAccountReq* cmd = (protocol::tag_CMDQueryUserAccountReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: QueryUserAccountReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
	}

};


class QueryUserAccountResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_nk;
	int64	_nb;
	int64	_nkdeposit;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 nk() { return _nk; } const 

	 inline void set_nk(const int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 

	 inline void set_nb(const int64 value) { _nb = value; }

	 inline int64 nkdeposit() { return _nkdeposit; } const 

	 inline void set_nkdeposit(const int64 value) { _nkdeposit = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryUserAccountResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserAccountResp* cmd = (protocol::tag_CMDQueryUserAccountResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->nkdeposit = _nkdeposit;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserAccountResp* cmd = (protocol::tag_CMDQueryUserAccountResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_nk = cmd->nk;
		_nb = cmd->nb;
		_nkdeposit = cmd->nkdeposit;
	}

	void Log()
	{
		LOG("--------Receive message: QueryUserAccountResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("nk = %lld", _nk);
		LOG("nb = %lld", _nb);
		LOG("nkdeposit = %lld", _nkdeposit);
	}

};


class UserAccountInfo
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_nk;
	int64	_nb;
	uint32	_dtime;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 nk() { return _nk; } const 

	 inline void set_nk(const int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 

	 inline void set_nb(const int64 value) { _nb = value; }

	 inline uint32 dtime() { return _dtime; } const 

	 inline void set_dtime(const uint32 value) { _dtime = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserAccountInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserAccountInfo* cmd = (protocol::tag_CMDUserAccountInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->dtime = _dtime;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserAccountInfo* cmd = (protocol::tag_CMDUserAccountInfo*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_nk = cmd->nk;
		_nb = cmd->nb;
		_dtime = cmd->dtime;
	}

	void Log()
	{
		LOG("--------Receive message: UserAccountInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("nk = %lld", _nk);
		LOG("nb = %lld", _nb);
		LOG("dtime = %d", _dtime);
	}

};


class UserMicState
{

private:

	uint32	_vcbid;
	uint32	_runid;
	uint32	_toid;
	int32	_giftid;
	int32	_giftnum;
	uint32	_micstate;
	uint32	_micindex;
	uint32	_optype;
	uint32	_reserve11;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runid() { return _runid; } const 

	 inline void set_runid(const uint32 value) { _runid = value; }

	 inline uint32 toid() { return _toid; } const 

	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline int32 giftid() { return _giftid; } const 

	 inline void set_giftid(const int32 value) { _giftid = value; }

	 inline int32 giftnum() { return _giftnum; } const 

	 inline void set_giftnum(const int32 value) { _giftnum = value; }

	 inline uint32 micstate() { return _micstate; } const 

	 inline void set_micstate(const uint32 value) { _micstate = value; }

	 inline uint32 micindex() { return _micindex; } const 

	 inline void set_micindex(const uint32 value) { _micindex = value; }

	 inline uint32 optype() { return _optype; } const 

	 inline void set_optype(const uint32 value) { _optype = value; }

	 inline uint32 reserve11() { return _reserve11; } const 

	 inline void set_reserve11(const uint32 value) { _reserve11 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserMicState); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserMicState* cmd = (protocol::tag_CMDUserMicState*) data;
		cmd->vcbid = _vcbid;
		cmd->runid = _runid;
		cmd->toid = _toid;
		cmd->giftid = _giftid;
		cmd->giftnum = _giftnum;
		cmd->micstate = _micstate;
		cmd->micindex = _micindex;
		cmd->optype = _optype;
		cmd->reserve11 = _reserve11;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserMicState* cmd = (protocol::tag_CMDUserMicState*) data;
		_vcbid = cmd->vcbid;
		_runid = cmd->runid;
		_toid = cmd->toid;
		_giftid = cmd->giftid;
		_giftnum = cmd->giftnum;
		_micstate = cmd->micstate;
		_micindex = cmd->micindex;
		_optype = cmd->optype;
		_reserve11 = cmd->reserve11;
	}

	void Log()
	{
		LOG("--------Receive message: UserMicState---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runid = %d", _runid);
		LOG("toid = %d", _toid);
		LOG("giftid = %d", _giftid);
		LOG("giftnum = %d", _giftnum);
		LOG("micstate = %d", _micstate);
		LOG("micindex = %d", _micindex);
		LOG("optype = %d", _optype);
		LOG("reserve11 = %d", _reserve11);
	}

};


class UserDevState
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_audiostate;
	uint32	_videostate;
	uint32	_userinroomstate;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 audiostate() { return _audiostate; } const 

	 inline void set_audiostate(const uint32 value) { _audiostate = value; }

	 inline uint32 videostate() { return _videostate; } const 

	 inline void set_videostate(const uint32 value) { _videostate = value; }

	 inline uint32 userinroomstate() { return _userinroomstate; } const 

	 inline void set_userinroomstate(const uint32 value) { _userinroomstate = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserDevState); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserDevState* cmd = (protocol::tag_CMDUserDevState*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->audiostate = _audiostate;
		cmd->videostate = _videostate;
		cmd->userinroomstate = _userinroomstate;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserDevState* cmd = (protocol::tag_CMDUserDevState*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_audiostate = cmd->audiostate;
		_videostate = cmd->videostate;
		_userinroomstate = cmd->userinroomstate;
	}

	void Log()
	{
		LOG("--------Receive message: UserDevState---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("audiostate = %d", _audiostate);
		LOG("videostate = %d", _videostate);
		LOG("userinroomstate = %d", _userinroomstate);
	}

};


class TransMediaInfo
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_action;
	uint32	_vvflag;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 

	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 

	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 action() { return _action; } const 

	 inline void set_action(const uint32 value) { _action = value; }

	 inline uint32 vvflag() { return _vvflag; } const 

	 inline void set_vvflag(const uint32 value) { _vvflag = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTransMediaInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTransMediaInfo* cmd = (protocol::tag_CMDTransMediaInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->action = _action;
		cmd->vvflag = _vvflag;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTransMediaInfo* cmd = (protocol::tag_CMDTransMediaInfo*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_action = cmd->action;
		_vvflag = cmd->vvflag;
	}

	void Log()
	{
		LOG("--------Receive message: TransMediaInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("action = %d", _action);
		LOG("vvflag = %d", _vvflag);
	}

};


class RoomMediaInfo
{

private:

	uint32	_vcbid;
	uint32	_userid;
	string	_caddr;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& caddr() { return _caddr; } const 

	 inline void set_caddr(const string& value) { _caddr = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomMediaInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomMediaInfo* cmd = (protocol::tag_CMDRoomMediaInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		strcpy(cmd->caddr, _caddr.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomMediaInfo* cmd = (protocol::tag_CMDRoomMediaInfo*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_caddr = cmd->caddr;
	}

	void Log()
	{
		LOG("--------Receive message: RoomMediaInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("caddr = %s", _caddr.c_str());
	}

};


class ChangePubMicStateNoty
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_micid;
	uint32	_optype;
	int32	_param1;
	uint32	_userid;
	int32	_userlefttime;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 

	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 micid() { return _micid; } const 

	 inline void set_micid(const uint32 value) { _micid = value; }

	 inline uint32 optype() { return _optype; } const 

	 inline void set_optype(const uint32 value) { _optype = value; }

	 inline int32 param1() { return _param1; } const 

	 inline void set_param1(const int32 value) { _param1 = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 userlefttime() { return _userlefttime; } const 

	 inline void set_userlefttime(const int32 value) { _userlefttime = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDChangePubMicStateNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDChangePubMicStateNoty* cmd = (protocol::tag_CMDChangePubMicStateNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->micid = _micid;
		cmd->optype = _optype;
		cmd->param1 = _param1;
		cmd->userid = _userid;
		cmd->userlefttime = _userlefttime;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDChangePubMicStateNoty* cmd = (protocol::tag_CMDChangePubMicStateNoty*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_micid = cmd->micid;
		_optype = cmd->optype;
		_param1 = cmd->param1;
		_userid = cmd->userid;
		_userlefttime = cmd->userlefttime;
	}

	void Log()
	{
		LOG("--------Receive message: ChangePubMicStateNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("micid = %d", _micid);
		LOG("optype = %d", _optype);
		LOG("param1 = %d", _param1);
		LOG("userid = %d", _userid);
		LOG("userlefttime = %d", _userlefttime);
	}

};


class UpWaitMic
{

private:

	uint32	_vcbid;
	uint32	_ruunerid;
	uint32	_touser;
	int32	_nmicindex;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 

	 inline void set_ruunerid(const uint32 value) { _ruunerid = value; }

	 inline uint32 touser() { return _touser; } const 

	 inline void set_touser(const uint32 value) { _touser = value; }

	 inline int32 nmicindex() { return _nmicindex; } const 

	 inline void set_nmicindex(const int32 value) { _nmicindex = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUpWaitMic); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUpWaitMic* cmd = (protocol::tag_CMDUpWaitMic*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->touser = _touser;
		cmd->nmicindex = _nmicindex;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUpWaitMic* cmd = (protocol::tag_CMDUpWaitMic*) data;
		_vcbid = cmd->vcbid;
		_ruunerid = cmd->ruunerid;
		_touser = cmd->touser;
		_nmicindex = cmd->nmicindex;
	}

	void Log()
	{
		LOG("--------Receive message: UpWaitMic---------");
		LOG("vcbid = %d", _vcbid);
		LOG("ruunerid = %d", _ruunerid);
		LOG("touser = %d", _touser);
		LOG("nmicindex = %d", _nmicindex);
	}

};


class OperateWaitMic
{

private:

	uint32	_vcbid;
	uint32	_ruunerid;
	uint32	_userid;
	int32	_micid;
	int32	_optype;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 

	 inline void set_ruunerid(const uint32 value) { _ruunerid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 

	 inline void set_micid(const int32 value) { _micid = value; }

	 inline int32 optype() { return _optype; } const 

	 inline void set_optype(const int32 value) { _optype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDOperateWaitMic); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDOperateWaitMic* cmd = (protocol::tag_CMDOperateWaitMic*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDOperateWaitMic* cmd = (protocol::tag_CMDOperateWaitMic*) data;
		_vcbid = cmd->vcbid;
		_ruunerid = cmd->ruunerid;
		_userid = cmd->userid;
		_micid = cmd->micid;
		_optype = cmd->optype;
	}

	void Log()
	{
		LOG("--------Receive message: OperateWaitMic---------");
		LOG("vcbid = %d", _vcbid);
		LOG("ruunerid = %d", _ruunerid);
		LOG("userid = %d", _userid);
		LOG("micid = %d", _micid);
		LOG("optype = %d", _optype);
	}

};


class ChangeWaitMicIndexNoty
{

private:

	uint32	_vcbid;
	uint32	_ruunerid;
	uint32	_userid;
	int32	_micid;
	int32	_optype;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 

	 inline void set_ruunerid(const uint32 value) { _ruunerid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 

	 inline void set_micid(const int32 value) { _micid = value; }

	 inline int32 optype() { return _optype; } const 

	 inline void set_optype(const int32 value) { _optype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDChangeWaitMicIndexNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDChangeWaitMicIndexNoty* cmd = (protocol::tag_CMDChangeWaitMicIndexNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDChangeWaitMicIndexNoty* cmd = (protocol::tag_CMDChangeWaitMicIndexNoty*) data;
		_vcbid = cmd->vcbid;
		_ruunerid = cmd->ruunerid;
		_userid = cmd->userid;
		_micid = cmd->micid;
		_optype = cmd->optype;
	}

	void Log()
	{
		LOG("--------Receive message: ChangeWaitMicIndexNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("ruunerid = %d", _ruunerid);
		LOG("userid = %d", _userid);
		LOG("micid = %d", _micid);
		LOG("optype = %d", _optype);
	}

};


class LootUserMicReq
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_userid;
	int32	_micid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 

	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 

	 inline void set_micid(const int32 value) { _micid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDLootUserMicReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDLootUserMicReq* cmd = (protocol::tag_CMDLootUserMicReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDLootUserMicReq* cmd = (protocol::tag_CMDLootUserMicReq*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_userid = cmd->userid;
		_micid = cmd->micid;
	}

	void Log()
	{
		LOG("--------Receive message: LootUserMicReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("userid = %d", _userid);
		LOG("micid = %d", _micid);
	}

};


class LootUserMicResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDLootUserMicResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDLootUserMicResp* cmd = (protocol::tag_CMDLootUserMicResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDLootUserMicResp* cmd = (protocol::tag_CMDLootUserMicResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: LootUserMicResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
	}

};


class LootUserMicNoty
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_userid;
	int32	_micid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 

	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 

	 inline void set_micid(const int32 value) { _micid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDLootUserMicNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDLootUserMicNoty* cmd = (protocol::tag_CMDLootUserMicNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDLootUserMicNoty* cmd = (protocol::tag_CMDLootUserMicNoty*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_userid = cmd->userid;
		_micid = cmd->micid;
	}

	void Log()
	{
		LOG("--------Receive message: LootUserMicNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("userid = %d", _userid);
		LOG("micid = %d", _micid);
	}

};


class SetRoomInfoReq
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_creatorid;
	uint32	_op1id;
	uint32	_op2id;
	uint32	_op3id;
	uint32	_op4id;
	int32	_busepwd;
	string	_cname;
	string	_cpwd;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 

	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

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

	 inline int32 busepwd() { return _busepwd; } const 

	 inline void set_busepwd(const int32 value) { _busepwd = value; }

	 inline string& cname() { return _cname; } const 

	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cpwd() { return _cpwd; } const 

	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomInfoReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomInfoReq* cmd = (protocol::tag_CMDSetRoomInfoReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->creatorid = _creatorid;
		cmd->op1id = _op1id;
		cmd->op2id = _op2id;
		cmd->op3id = _op3id;
		cmd->op4id = _op4id;
		cmd->busepwd = _busepwd;
		strcpy(cmd->cname, _cname.c_str());
		strcpy(cmd->cpwd, _cpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomInfoReq* cmd = (protocol::tag_CMDSetRoomInfoReq*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_creatorid = cmd->creatorid;
		_op1id = cmd->op1id;
		_op2id = cmd->op2id;
		_op3id = cmd->op3id;
		_op4id = cmd->op4id;
		_busepwd = cmd->busepwd;
		_cname = cmd->cname;
		_cpwd = cmd->cpwd;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomInfoReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("creatorid = %d", _creatorid);
		LOG("op1id = %d", _op1id);
		LOG("op2id = %d", _op2id);
		LOG("op3id = %d", _op3id);
		LOG("op4id = %d", _op4id);
		LOG("busepwd = %d", _busepwd);
		LOG("cname = %s", _cname.c_str());
		LOG("cpwd = %s", _cpwd.c_str());
	}

};


class SetRoomOPStatusReq
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_opstatus;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 

	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 opstatus() { return _opstatus; } const 

	 inline void set_opstatus(const uint32 value) { _opstatus = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomOPStatusReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomOPStatusReq* cmd = (protocol::tag_CMDSetRoomOPStatusReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->opstatus = _opstatus;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomOPStatusReq* cmd = (protocol::tag_CMDSetRoomOPStatusReq*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_opstatus = cmd->opstatus;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomOPStatusReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("opstatus = %d", _opstatus);
	}

};


class SetRoomOPStatusResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomOPStatusResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomOPStatusResp* cmd = (protocol::tag_CMDSetRoomOPStatusResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomOPStatusResp* cmd = (protocol::tag_CMDSetRoomOPStatusResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomOPStatusResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
	}

};


class SetRoomNoticeReq
{

private:

	uint32	_vcbid;
	uint32	_ruunerid;
	uint32	_index;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 

	 inline void set_ruunerid(const uint32 value) { _ruunerid = value; }

	 inline uint32 index() { return _index; } const 

	 inline void set_index(const uint32 value) { _index = value; }

	 inline uint32 textlen() { return _textlen; } const 

	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomNoticeReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomNoticeReq* cmd = (protocol::tag_CMDSetRoomNoticeReq*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->index = _index;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomNoticeReq* cmd = (protocol::tag_CMDSetRoomNoticeReq*) data;
		_vcbid = cmd->vcbid;
		_ruunerid = cmd->ruunerid;
		_index = cmd->index;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomNoticeReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("ruunerid = %d", _ruunerid);
		LOG("index = %d", _index);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class SetRoomNoticeResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetRoomNoticeResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomNoticeResp* cmd = (protocol::tag_CMDSetRoomNoticeResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetRoomNoticeResp* cmd = (protocol::tag_CMDSetRoomNoticeResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomNoticeResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
	}

};


class PropsFlashPlayTaskItem
{

private:

	uint32	_ntasktype;
	uint32	_narg;


public:

	 inline uint32 ntasktype() { return _ntasktype; } const 

	 inline void set_ntasktype(const uint32 value) { _ntasktype = value; }

	 inline uint32 narg() { return _narg; } const 

	 inline void set_narg(const uint32 value) { _narg = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDPropsFlashPlayTaskItem); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDPropsFlashPlayTaskItem* cmd = (protocol::tag_CMDPropsFlashPlayTaskItem*) data;
		cmd->nTaskType = _ntasktype;
		cmd->nArg = _narg;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDPropsFlashPlayTaskItem* cmd = (protocol::tag_CMDPropsFlashPlayTaskItem*) data;
		_ntasktype = cmd->nTaskType;
		_narg = cmd->nArg;
	}

	void Log()
	{
		LOG("--------Receive message: PropsFlashPlayTaskItem---------");
		LOG("ntasktype = %d", _ntasktype);
		LOG("narg = %d", _narg);
	}

};


class QueryVcbExistReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_queryvcbid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 queryvcbid() { return _queryvcbid; } const 

	 inline void set_queryvcbid(const uint32 value) { _queryvcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryVcbExistReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryVcbExistReq* cmd = (protocol::tag_CMDQueryVcbExistReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryvcbid = _queryvcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryVcbExistReq* cmd = (protocol::tag_CMDQueryVcbExistReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_queryvcbid = cmd->queryvcbid;
	}

	void Log()
	{
		LOG("--------Receive message: QueryVcbExistReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("queryvcbid = %d", _queryvcbid);
	}

};


class QueryVcbExistResp
{

private:

	int32	_errorid;
	uint32	_vcbid;
	uint32	_userid;
	uint32	_queryvcbid;
	string	_cqueryvcbname;


public:

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 queryvcbid() { return _queryvcbid; } const 

	 inline void set_queryvcbid(const uint32 value) { _queryvcbid = value; }

	 inline string& cqueryvcbname() { return _cqueryvcbname; } const 

	 inline void set_cqueryvcbname(const string& value) { _cqueryvcbname = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryVcbExistResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryVcbExistResp* cmd = (protocol::tag_CMDQueryVcbExistResp*) data;
		cmd->errorid = _errorid;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryvcbid = _queryvcbid;
		strcpy(cmd->cqueryvcbname, _cqueryvcbname.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryVcbExistResp* cmd = (protocol::tag_CMDQueryVcbExistResp*) data;
		_errorid = cmd->errorid;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_queryvcbid = cmd->queryvcbid;
		_cqueryvcbname = cmd->cqueryvcbname;
	}

	void Log()
	{
		LOG("--------Receive message: QueryVcbExistResp---------");
		LOG("errorid = %d", _errorid);
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("queryvcbid = %d", _queryvcbid);
		LOG("cqueryvcbname = %s", _cqueryvcbname.c_str());
	}

};


class QueryUserExistReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_queryuserid;
	uint32	_specvcbid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 queryuserid() { return _queryuserid; } const 

	 inline void set_queryuserid(const uint32 value) { _queryuserid = value; }

	 inline uint32 specvcbid() { return _specvcbid; } const 

	 inline void set_specvcbid(const uint32 value) { _specvcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryUserExistReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserExistReq* cmd = (protocol::tag_CMDQueryUserExistReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryuserid = _queryuserid;
		cmd->specvcbid = _specvcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserExistReq* cmd = (protocol::tag_CMDQueryUserExistReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_queryuserid = cmd->queryuserid;
		_specvcbid = cmd->specvcbid;
	}

	void Log()
	{
		LOG("--------Receive message: QueryUserExistReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("queryuserid = %d", _queryuserid);
		LOG("specvcbid = %d", _specvcbid);
	}

};


class QueryUserExistResp
{

private:

	int32	_errorid;
	uint32	_vcbid;
	uint32	_userid;
	uint32	_queryuserid;
	uint32	_specvcbid;
	uint32	_queryuserviplevel;
	string	_cspecvcbname;
	string	_cqueryuseralias;


public:

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 queryuserid() { return _queryuserid; } const 

	 inline void set_queryuserid(const uint32 value) { _queryuserid = value; }

	 inline uint32 specvcbid() { return _specvcbid; } const 

	 inline void set_specvcbid(const uint32 value) { _specvcbid = value; }

	 inline uint32 queryuserviplevel() { return _queryuserviplevel; } const 

	 inline void set_queryuserviplevel(const uint32 value) { _queryuserviplevel = value; }

	 inline string& cspecvcbname() { return _cspecvcbname; } const 

	 inline void set_cspecvcbname(const string& value) { _cspecvcbname = value; }

	 inline string& cqueryuseralias() { return _cqueryuseralias; } const 

	 inline void set_cqueryuseralias(const string& value) { _cqueryuseralias = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryUserExistResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserExistResp* cmd = (protocol::tag_CMDQueryUserExistResp*) data;
		cmd->errorid = _errorid;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryuserid = _queryuserid;
		cmd->specvcbid = _specvcbid;
		cmd->queryuserviplevel = _queryuserviplevel;
		strcpy(cmd->cspecvcbname, _cspecvcbname.c_str());
		strcpy(cmd->cqueryuseralias, _cqueryuseralias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryUserExistResp* cmd = (protocol::tag_CMDQueryUserExistResp*) data;
		_errorid = cmd->errorid;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_queryuserid = cmd->queryuserid;
		_specvcbid = cmd->specvcbid;
		_queryuserviplevel = cmd->queryuserviplevel;
		_cspecvcbname = cmd->cspecvcbname;
		_cqueryuseralias = cmd->cqueryuseralias;
	}

	void Log()
	{
		LOG("--------Receive message: QueryUserExistResp---------");
		LOG("errorid = %d", _errorid);
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("queryuserid = %d", _queryuserid);
		LOG("specvcbid = %d", _specvcbid);
		LOG("queryuserviplevel = %d", _queryuserviplevel);
		LOG("cspecvcbname = %s", _cspecvcbname.c_str());
		LOG("cqueryuseralias = %s", _cqueryuseralias.c_str());
	}

};


class OpenChestReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_openresult_type;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 openresult_type() { return _openresult_type; } const 

	 inline void set_openresult_type(const int32 value) { _openresult_type = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDOpenChestReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDOpenChestReq* cmd = (protocol::tag_CMDOpenChestReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->openresult_type = _openresult_type;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDOpenChestReq* cmd = (protocol::tag_CMDOpenChestReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_openresult_type = cmd->openresult_type;
	}

	void Log()
	{
		LOG("--------Receive message: OpenChestReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("openresult_type = %d", _openresult_type);
	}

};


class MobZhuboInfo
{

private:

	uint32	_vcbid;
	uint32	_userid;
	string	_alias;
	string	_headurl;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& alias() { return _alias; } const 

	 inline void set_alias(const string& value) { _alias = value; }

	 inline string& headurl() { return _headurl; } const 

	 inline void set_headurl(const string& value) { _headurl = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDMobZhuboInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDMobZhuboInfo* cmd = (protocol::tag_CMDMobZhuboInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		strcpy(cmd->alias, _alias.c_str());
		strcpy(cmd->headurl, _headurl.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDMobZhuboInfo* cmd = (protocol::tag_CMDMobZhuboInfo*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_alias = cmd->alias;
		_headurl = cmd->headurl;
	}

	void Log()
	{
		LOG("--------Receive message: MobZhuboInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("alias = %s", _alias.c_str());
		LOG("headurl = %s", _headurl.c_str());
	}

};


class UserCaifuCostLevelInfo
{

private:

	uint32	_userid;
	uint32	_vcbid;
	int32	_ncaifulevel;
	int32	_nlastmonthcostlevel;
	int32	_nthismonthcostlevel;
	int32	_nthismonthcostgrade;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 ncaifulevel() { return _ncaifulevel; } const 

	 inline void set_ncaifulevel(const int32 value) { _ncaifulevel = value; }

	 inline int32 nlastmonthcostlevel() { return _nlastmonthcostlevel; } const 

	 inline void set_nlastmonthcostlevel(const int32 value) { _nlastmonthcostlevel = value; }

	 inline int32 nthismonthcostlevel() { return _nthismonthcostlevel; } const 

	 inline void set_nthismonthcostlevel(const int32 value) { _nthismonthcostlevel = value; }

	 inline int32 nthismonthcostgrade() { return _nthismonthcostgrade; } const 

	 inline void set_nthismonthcostgrade(const int32 value) { _nthismonthcostgrade = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserCaifuCostLevelInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserCaifuCostLevelInfo* cmd = (protocol::tag_CMDUserCaifuCostLevelInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->ncaifulevel = _ncaifulevel;
		cmd->nlastmonthcostlevel = _nlastmonthcostlevel;
		cmd->nthismonthcostlevel = _nthismonthcostlevel;
		cmd->nthismonthcostgrade = _nthismonthcostgrade;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserCaifuCostLevelInfo* cmd = (protocol::tag_CMDUserCaifuCostLevelInfo*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_ncaifulevel = cmd->ncaifulevel;
		_nlastmonthcostlevel = cmd->nlastmonthcostlevel;
		_nthismonthcostlevel = cmd->nthismonthcostlevel;
		_nthismonthcostgrade = cmd->nthismonthcostgrade;
	}

	void Log()
	{
		LOG("--------Receive message: UserCaifuCostLevelInfo---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("ncaifulevel = %d", _ncaifulevel);
		LOG("nlastmonthcostlevel = %d", _nlastmonthcostlevel);
		LOG("nthismonthcostlevel = %d", _nthismonthcostlevel);
		LOG("nthismonthcostgrade = %d", _nthismonthcostgrade);
	}

};


class CloseGateObjectReq
{

private:

	uint64	_object;
	uint64	_objectid;


public:

	 inline uint64 object() { return _object; } const 

	 inline void set_object(const uint64 value) { _object = value; }

	 inline uint64 objectid() { return _objectid; } const 

	 inline void set_objectid(const uint64 value) { _objectid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDCloseGateObjectReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDCloseGateObjectReq* cmd = (protocol::tag_CMDCloseGateObjectReq*) data;
		cmd->object = _object;
		cmd->objectid = _objectid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDCloseGateObjectReq* cmd = (protocol::tag_CMDCloseGateObjectReq*) data;
		_object = cmd->object;
		_objectid = cmd->objectid;
	}

	void Log()
	{
		LOG("--------Receive message: CloseGateObjectReq---------");
		LOG("object = %lld", _object);
		LOG("objectid = %lld", _objectid);
	}

};


class CloseRoomNoty
{

private:

	uint32	_vcbid;
	string	_closereason;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline string& closereason() { return _closereason; } const 

	 inline void set_closereason(const string& value) { _closereason = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDCloseRoomNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDCloseRoomNoty* cmd = (protocol::tag_CMDCloseRoomNoty*) data;
		cmd->vcbid = _vcbid;
		strcpy(cmd->closereason, _closereason.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDCloseRoomNoty* cmd = (protocol::tag_CMDCloseRoomNoty*) data;
		_vcbid = cmd->vcbid;
		_closereason = cmd->closereason;
	}

	void Log()
	{
		LOG("--------Receive message: CloseRoomNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("closereason = %s", _closereason.c_str());
	}

};


class SetUserHideStateReq
{

private:

	uint32	_userid;
	uint32	_vcbid;
	int32	_hidestate;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 hidestate() { return _hidestate; } const 

	 inline void set_hidestate(const int32 value) { _hidestate = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserHideStateReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserHideStateReq* cmd = (protocol::tag_CMDSetUserHideStateReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->hidestate = _hidestate;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserHideStateReq* cmd = (protocol::tag_CMDSetUserHideStateReq*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_hidestate = cmd->hidestate;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserHideStateReq---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("hidestate = %d", _hidestate);
	}

};


class AdKeywordInfo
{

private:

	int32	_naction;
	int32	_ntype;
	int32	_nrunerid;
	string	_createtime;
	string	_keyword;


public:

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


	int ByteSize() { return sizeof(protocol::tag_CMDAdKeywordInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordInfo* cmd = (protocol::tag_CMDAdKeywordInfo*) data;
		cmd->naction = _naction;
		cmd->ntype = _ntype;
		cmd->nrunerid = _nrunerid;
		strcpy(cmd->createtime, _createtime.c_str());
		strcpy(cmd->keyword, _keyword.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAdKeywordInfo* cmd = (protocol::tag_CMDAdKeywordInfo*) data;
		_naction = cmd->naction;
		_ntype = cmd->ntype;
		_nrunerid = cmd->nrunerid;
		_createtime = cmd->createtime;
		_keyword = cmd->keyword;
	}

	void Log()
	{
		LOG("--------Receive message: AdKeywordInfo---------");
		LOG("naction = %d", _naction);
		LOG("ntype = %d", _ntype);
		LOG("nrunerid = %d", _nrunerid);
		LOG("createtime = %s", _createtime.c_str());
		LOG("keyword = %s", _keyword.c_str());
	}

};


class TeacherScoreReq
{

private:

	uint32	_teacher_userid;
	string	_teacheralias;
	uint32	_vcbid;
	int64	_data1;
	string	_data2;


public:

	 inline uint32 teacher_userid() { return _teacher_userid; } const 

	 inline void set_teacher_userid(const uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int64 data1() { return _data1; } const 

	 inline void set_data1(const int64 value) { _data1 = value; }

	 inline string& data2() { return _data2; } const 

	 inline void set_data2(const string& value) { _data2 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherScoreReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreReq* cmd = (protocol::tag_CMDTeacherScoreReq*) data;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->vcbid = _vcbid;
		cmd->data1 = _data1;
		strcpy(cmd->data2, _data2.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreReq* cmd = (protocol::tag_CMDTeacherScoreReq*) data;
		_teacher_userid = cmd->teacher_userid;
		_teacheralias = cmd->teacheralias;
		_vcbid = cmd->vcbid;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherScoreReq---------");
		LOG("teacher_userid = %d", _teacher_userid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("vcbid = %d", _vcbid);
		LOG("data1 = %lld", _data1);
		LOG("data2 = %s", _data2.c_str());
	}

};


class TeacherScoreResp
{

private:

	int32	_type;
	uint32	_teacher_userid;
	string	_teacheralias;
	int32	_vcbid;


public:

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline uint32 teacher_userid() { return _teacher_userid; } const 

	 inline void set_teacher_userid(const uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline int32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const int32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherScoreResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreResp* cmd = (protocol::tag_CMDTeacherScoreResp*) data;
		cmd->type = _type;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreResp* cmd = (protocol::tag_CMDTeacherScoreResp*) data;
		_type = cmd->type;
		_teacher_userid = cmd->teacher_userid;
		_teacheralias = cmd->teacheralias;
		_vcbid = cmd->vcbid;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherScoreResp---------");
		LOG("type = %d", _type);
		LOG("teacher_userid = %d", _teacher_userid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("vcbid = %d", _vcbid);
	}

};


class TeacherScoreRecordReq
{

private:

	uint32	_teacher_userid;
	string	_teacheralias;
	uint32	_userid;
	string	_alias;
	uint32	_usertype;
	uint32	_score;
	string	_logtime;
	uint32	_vcbid;
	int64	_data1;
	int64	_data2;
	int64	_data3;
	string	_data4;
	string	_data5;


public:

	 inline uint32 teacher_userid() { return _teacher_userid; } const 

	 inline void set_teacher_userid(const uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& alias() { return _alias; } const 

	 inline void set_alias(const string& value) { _alias = value; }

	 inline uint32 usertype() { return _usertype; } const 

	 inline void set_usertype(const uint32 value) { _usertype = value; }

	 inline uint32 score() { return _score; } const 

	 inline void set_score(const uint32 value) { _score = value; }

	 inline string& logtime() { return _logtime; } const 

	 inline void set_logtime(const string& value) { _logtime = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int64 data1() { return _data1; } const 

	 inline void set_data1(const int64 value) { _data1 = value; }

	 inline int64 data2() { return _data2; } const 

	 inline void set_data2(const int64 value) { _data2 = value; }

	 inline int64 data3() { return _data3; } const 

	 inline void set_data3(const int64 value) { _data3 = value; }

	 inline string& data4() { return _data4; } const 

	 inline void set_data4(const string& value) { _data4 = value; }

	 inline string& data5() { return _data5; } const 

	 inline void set_data5(const string& value) { _data5 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherScoreRecordReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreRecordReq* cmd = (protocol::tag_CMDTeacherScoreRecordReq*) data;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->userid = _userid;
		strcpy(cmd->alias, _alias.c_str());
		cmd->usertype = _usertype;
		cmd->score = _score;
		strcpy(cmd->logtime, _logtime.c_str());
		cmd->vcbid = _vcbid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
		cmd->data3 = _data3;
		strcpy(cmd->data4, _data4.c_str());
		strcpy(cmd->data5, _data5.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreRecordReq* cmd = (protocol::tag_CMDTeacherScoreRecordReq*) data;
		_teacher_userid = cmd->teacher_userid;
		_teacheralias = cmd->teacheralias;
		_userid = cmd->userid;
		_alias = cmd->alias;
		_usertype = cmd->usertype;
		_score = cmd->score;
		_logtime = cmd->logtime;
		_vcbid = cmd->vcbid;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
		_data3 = cmd->data3;
		_data4 = cmd->data4;
		_data5 = cmd->data5;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherScoreRecordReq---------");
		LOG("teacher_userid = %d", _teacher_userid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("userid = %d", _userid);
		LOG("alias = %s", _alias.c_str());
		LOG("usertype = %d", _usertype);
		LOG("score = %d", _score);
		LOG("logtime = %s", _logtime.c_str());
		LOG("vcbid = %d", _vcbid);
		LOG("data1 = %lld", _data1);
		LOG("data2 = %lld", _data2);
		LOG("data3 = %lld", _data3);
		LOG("data4 = %s", _data4.c_str());
		LOG("data5 = %s", _data5.c_str());
	}

};


class TeacherScoreRecordResp
{

private:

	uint32	_teacher_userid;
	string	_teacheralias;
	int32	_type;


public:

	 inline uint32 teacher_userid() { return _teacher_userid; } const 

	 inline void set_teacher_userid(const uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherScoreRecordResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreRecordResp* cmd = (protocol::tag_CMDTeacherScoreRecordResp*) data;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->type = _type;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherScoreRecordResp* cmd = (protocol::tag_CMDTeacherScoreRecordResp*) data;
		_teacher_userid = cmd->teacher_userid;
		_teacheralias = cmd->teacheralias;
		_type = cmd->type;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherScoreRecordResp---------");
		LOG("teacher_userid = %d", _teacher_userid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("type = %d", _type);
	}

};


class RobotTeacherIdNoty
{

private:

	uint32	_vcbid;
	uint32	_roborid;
	uint32	_teacherid;
	string	_teacheralias;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 roborid() { return _roborid; } const 

	 inline void set_roborid(const uint32 value) { _roborid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRobotTeacherIdNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRobotTeacherIdNoty* cmd = (protocol::tag_CMDRobotTeacherIdNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->roborid = _roborid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRobotTeacherIdNoty* cmd = (protocol::tag_CMDRobotTeacherIdNoty*) data;
		_vcbid = cmd->vcbid;
		_roborid = cmd->roborid;
		_teacherid = cmd->teacherid;
		_teacheralias = cmd->teacheralias;
	}

	void Log()
	{
		LOG("--------Receive message: RobotTeacherIdNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("roborid = %d", _roborid);
		LOG("teacherid = %d", _teacherid);
		LOG("teacheralias = %s", _teacheralias.c_str());
	}

};


class TeacherGiftListReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherGiftListReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGiftListReq* cmd = (protocol::tag_CMDTeacherGiftListReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGiftListReq* cmd = (protocol::tag_CMDTeacherGiftListReq*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherGiftListReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
	}

};


class TeacherGiftListResp
{

private:

	uint32	_seqid;
	uint32	_vcbid;
	uint32	_teacherid;
	string	_useralias;
	uint64	_t_num;


public:

	 inline uint32 seqid() { return _seqid; } const 

	 inline void set_seqid(const uint32 value) { _seqid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline string& useralias() { return _useralias; } const 

	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline uint64 t_num() { return _t_num; } const 

	 inline void set_t_num(const uint64 value) { _t_num = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherGiftListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGiftListResp* cmd = (protocol::tag_CMDTeacherGiftListResp*) data;
		cmd->seqid = _seqid;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->useralias, _useralias.c_str());
		cmd->t_num = _t_num;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGiftListResp* cmd = (protocol::tag_CMDTeacherGiftListResp*) data;
		_seqid = cmd->seqid;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_useralias = cmd->useralias;
		_t_num = cmd->t_num;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherGiftListResp---------");
		LOG("seqid = %d", _seqid);
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("useralias = %s", _useralias.c_str());
		LOG("t_num = %lld", _t_num);
	}

};


class RoomAndSubRoomIdNoty
{

private:

	uint32	_roomid;
	uint32	_subroomid;


public:

	 inline uint32 roomid() { return _roomid; } const 

	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline uint32 subroomid() { return _subroomid; } const 

	 inline void set_subroomid(const uint32 value) { _subroomid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomAndSubRoomIdNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomAndSubRoomIdNoty* cmd = (protocol::tag_CMDRoomAndSubRoomIdNoty*) data;
		cmd->roomid = _roomid;
		cmd->subroomid = _subroomid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomAndSubRoomIdNoty* cmd = (protocol::tag_CMDRoomAndSubRoomIdNoty*) data;
		_roomid = cmd->roomid;
		_subroomid = cmd->subroomid;
	}

	void Log()
	{
		LOG("--------Receive message: RoomAndSubRoomIdNoty---------");
		LOG("roomid = %d", _roomid);
		LOG("subroomid = %d", _subroomid);
	}

};


class TeacherAvarageScoreNoty
{

private:

	uint32	_teacherid;
	uint32	_roomid;
	float	_avarage_score;
	string	_data1;
	uint32	_data2;


public:

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 roomid() { return _roomid; } const 

	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline float avarage_score() { return _avarage_score; } const 

	 inline void set_avarage_score(const float value) { _avarage_score = value; }

	 inline string& data1() { return _data1; } const 

	 inline void set_data1(const string& value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 

	 inline void set_data2(const uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherAvarageScoreNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherAvarageScoreNoty* cmd = (protocol::tag_CMDTeacherAvarageScoreNoty*) data;
		cmd->teacherid = _teacherid;
		cmd->roomid = _roomid;
		cmd->avarage_score = _avarage_score;
		strcpy(cmd->data1, _data1.c_str());
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherAvarageScoreNoty* cmd = (protocol::tag_CMDTeacherAvarageScoreNoty*) data;
		_teacherid = cmd->teacherid;
		_roomid = cmd->roomid;
		_avarage_score = cmd->avarage_score;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherAvarageScoreNoty---------");
		LOG("teacherid = %d", _teacherid);
		LOG("roomid = %d", _roomid);
		LOG("avarage_score = %f", _avarage_score);
		LOG("data1 = %s", _data1.c_str());
		LOG("data2 = %d", _data2);
	}

};


class RoomsvrNotify
{

private:

	uint32	_svrid;
	uint32	_gateid;
	uint32	_vcbid;
	uint32	_userid;
	string	_codis_ip;
	uint32	_codis_port;
	uint32	_action;


public:

	 inline uint32 svrid() { return _svrid; } const 

	 inline void set_svrid(const uint32 value) { _svrid = value; }

	 inline uint32 gateid() { return _gateid; } const 

	 inline void set_gateid(const uint32 value) { _gateid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& codis_ip() { return _codis_ip; } const 

	 inline void set_codis_ip(const string& value) { _codis_ip = value; }

	 inline uint32 codis_port() { return _codis_port; } const 

	 inline void set_codis_port(const uint32 value) { _codis_port = value; }

	 inline uint32 action() { return _action; } const 

	 inline void set_action(const uint32 value) { _action = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomsvrNotify); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomsvrNotify* cmd = (protocol::tag_CMDRoomsvrNotify*) data;
		cmd->svrid = _svrid;
		cmd->gateid = _gateid;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		strcpy(cmd->codis_ip, _codis_ip.c_str());
		cmd->codis_port = _codis_port;
		cmd->action = _action;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomsvrNotify* cmd = (protocol::tag_CMDRoomsvrNotify*) data;
		_svrid = cmd->svrid;
		_gateid = cmd->gateid;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_codis_ip = cmd->codis_ip;
		_codis_port = cmd->codis_port;
		_action = cmd->action;
	}

	void Log()
	{
		LOG("--------Receive message: RoomsvrNotify---------");
		LOG("svrid = %d", _svrid);
		LOG("gateid = %d", _gateid);
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("codis_ip = %s", _codis_ip.c_str());
		LOG("codis_port = %d", _codis_port);
		LOG("action = %d", _action);
	}

};


class HitGoldEggWebNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDHitGoldEggWebNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDHitGoldEggWebNoty* cmd = (protocol::tag_CMDHitGoldEggWebNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDHitGoldEggWebNoty* cmd = (protocol::tag_CMDHitGoldEggWebNoty*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: HitGoldEggWebNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
	}

};


class UserScoreNoty
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int32	_score;
	int32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 score() { return _score; } const 

	 inline void set_score(const int32 value) { _score = value; }

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserScoreNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserScoreNoty* cmd = (protocol::tag_CMDUserScoreNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->score = _score;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserScoreNoty* cmd = (protocol::tag_CMDUserScoreNoty*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_score = cmd->score;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: UserScoreNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("score = %d", _score);
		LOG("userid = %d", _userid);
	}

};


class ResetConnInfo
{

private:

	uint32	_vcbid;
	int32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDResetConnInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDResetConnInfo* cmd = (protocol::tag_CMDResetConnInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDResetConnInfo* cmd = (protocol::tag_CMDResetConnInfo*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: ResetConnInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
	}

};


class UserOnlineBaseInfoNoty
{

private:

	uint32	_userid;
	uint32	_sessionid;
	uint32	_devicetype;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 sessionid() { return _sessionid; } const 

	 inline void set_sessionid(const uint32 value) { _sessionid = value; }

	 inline uint32 devicetype() { return _devicetype; } const 

	 inline void set_devicetype(const uint32 value) { _devicetype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserOnlineBaseInfoNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserOnlineBaseInfoNoty* cmd = (protocol::tag_CMDUserOnlineBaseInfoNoty*) data;
		cmd->userid = _userid;
		cmd->sessionid = _sessionid;
		cmd->devicetype = _devicetype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserOnlineBaseInfoNoty* cmd = (protocol::tag_CMDUserOnlineBaseInfoNoty*) data;
		_userid = cmd->userid;
		_sessionid = cmd->sessionid;
		_devicetype = cmd->devicetype;
	}

	void Log()
	{
		LOG("--------Receive message: UserOnlineBaseInfoNoty---------");
		LOG("userid = %d", _userid);
		LOG("sessionid = %d", _sessionid);
		LOG("devicetype = %d", _devicetype);
	}

};


class LogonStasticsReq
{

private:

	uint32	_userid;
	uint32	_device_type;
	string	_cipaddr;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 device_type() { return _device_type; } const 

	 inline void set_device_type(const uint32 value) { _device_type = value; }

	 inline string& cipaddr() { return _cipaddr; } const 

	 inline void set_cipaddr(const string& value) { _cipaddr = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDLogonStasticsReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDLogonStasticsReq* cmd = (protocol::tag_CMDLogonStasticsReq*) data;
		cmd->userid = _userid;
		cmd->device_type = _device_type;
		strcpy(cmd->cIpAddr, _cipaddr.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDLogonStasticsReq* cmd = (protocol::tag_CMDLogonStasticsReq*) data;
		_userid = cmd->userid;
		_device_type = cmd->device_type;
		_cipaddr = cmd->cIpAddr;
	}

	void Log()
	{
		LOG("--------Receive message: LogonStasticsReq---------");
		LOG("userid = %d", _userid);
		LOG("device_type = %d", _device_type);
		LOG("cipaddr = %s", _cipaddr.c_str());
	}

};


class LogonClientInf
{

private:

	uint32	_m_userid;
	uint32	_m_bmobile;
	uint32	_m_logontime;


public:

	 inline uint32 m_userid() { return _m_userid; } const 

	 inline void set_m_userid(const uint32 value) { _m_userid = value; }

	 inline uint32 m_bmobile() { return _m_bmobile; } const 

	 inline void set_m_bmobile(const uint32 value) { _m_bmobile = value; }

	 inline uint32 m_logontime() { return _m_logontime; } const 

	 inline void set_m_logontime(const uint32 value) { _m_logontime = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDLogonClientInf); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDLogonClientInf* cmd = (protocol::tag_CMDLogonClientInf*) data;
		cmd->m_userid = _m_userid;
		cmd->m_bmobile = _m_bmobile;
		cmd->m_logontime = _m_logontime;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDLogonClientInf* cmd = (protocol::tag_CMDLogonClientInf*) data;
		_m_userid = cmd->m_userid;
		_m_bmobile = cmd->m_bmobile;
		_m_logontime = cmd->m_logontime;
	}

	void Log()
	{
		LOG("--------Receive message: LogonClientInf---------");
		LOG("m_userid = %d", _m_userid);
		LOG("m_bmobile = %d", _m_bmobile);
		LOG("m_logontime = %d", _m_logontime);
	}

};


class ClientExistNoty
{

private:

	uint32	_userid;
	uint32	_m_ntype;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 m_ntype() { return _m_ntype; } const 

	 inline void set_m_ntype(const uint32 value) { _m_ntype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDClientExistNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDClientExistNoty* cmd = (protocol::tag_CMDClientExistNoty*) data;
		cmd->userid = _userid;
		cmd->m_ntype = _m_ntype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDClientExistNoty* cmd = (protocol::tag_CMDClientExistNoty*) data;
		_userid = cmd->userid;
		_m_ntype = cmd->m_ntype;
	}

	void Log()
	{
		LOG("--------Receive message: ClientExistNoty---------");
		LOG("userid = %d", _userid);
		LOG("m_ntype = %d", _m_ntype);
	}

};


class Syscast
{

private:

	uint32	_newtype;
	uint64	_nid;
	string	_title;
	string	_content;


public:

	 inline uint32 newtype() { return _newtype; } const 

	 inline void set_newtype(const uint32 value) { _newtype = value; }

	 inline uint64 nid() { return _nid; } const 

	 inline void set_nid(const uint64 value) { _nid = value; }

	 inline string& title() { return _title; } const 

	 inline void set_title(const string& value) { _title = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSyscast); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSyscast* cmd = (protocol::tag_CMDSyscast*) data;
		cmd->newType = _newtype;
		cmd->nid = _nid;
		strcpy(cmd->title, _title.c_str());
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSyscast* cmd = (protocol::tag_CMDSyscast*) data;
		_newtype = cmd->newType;
		_nid = cmd->nid;
		_title = cmd->title;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: Syscast---------");
		LOG("newtype = %d", _newtype);
		LOG("nid = %lld", _nid);
		LOG("title = %s", _title.c_str());
		LOG("content = %s", _content.c_str());
	}

};


class RelieveUserInfo
{

private:

	uint32	_nscopeid;
	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_toid;
	uint32	_isrelieve;


public:

	 inline uint32 nscopeid() { return _nscopeid; } const 

	 inline void set_nscopeid(const uint32 value) { _nscopeid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 

	 inline void set_runnerid(const uint32 value) { _runnerid = value; }

	 inline uint32 toid() { return _toid; } const 

	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 isrelieve() { return _isrelieve; } const 

	 inline void set_isrelieve(const uint32 value) { _isrelieve = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRelieveUserInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRelieveUserInfo* cmd = (protocol::tag_CMDRelieveUserInfo*) data;
		cmd->nscopeid = _nscopeid;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->toid = _toid;
		cmd->isRelieve = _isrelieve;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRelieveUserInfo* cmd = (protocol::tag_CMDRelieveUserInfo*) data;
		_nscopeid = cmd->nscopeid;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_toid = cmd->toid;
		_isrelieve = cmd->isRelieve;
	}

	void Log()
	{
		LOG("--------Receive message: RelieveUserInfo---------");
		LOG("nscopeid = %d", _nscopeid);
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("toid = %d", _toid);
		LOG("isrelieve = %d", _isrelieve);
	}

};


class MgrRefreshList
{

private:

	uint32	_vcbid;
	uint32	_userid;
	string	_name;
	uint32	_srcid;
	int32	_actionid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& name() { return _name; } const 

	 inline void set_name(const string& value) { _name = value; }

	 inline uint32 srcid() { return _srcid; } const 

	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline int32 actionid() { return _actionid; } const 

	 inline void set_actionid(const int32 value) { _actionid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDMgrRefreshList); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDMgrRefreshList* cmd = (protocol::tag_CMDMgrRefreshList*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		strcpy(cmd->name, _name.c_str());
		cmd->srcid = _srcid;
		cmd->actionid = _actionid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDMgrRefreshList* cmd = (protocol::tag_CMDMgrRefreshList*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_name = cmd->name;
		_srcid = cmd->srcid;
		_actionid = cmd->actionid;
	}

	void Log()
	{
		LOG("--------Receive message: MgrRefreshList---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("name = %s", _name.c_str());
		LOG("srcid = %d", _srcid);
		LOG("actionid = %d", _actionid);
	}

};


class TeacherSubscriptionStateQueryReq
{

private:

	uint32	_nmask;
	uint32	_userid;
	uint32	_teacherid;


public:

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherSubscriptionStateQueryReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionStateQueryReq* cmd = (protocol::tag_CMDTeacherSubscriptionStateQueryReq*) data;
		cmd->nmask = _nmask;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionStateQueryReq* cmd = (protocol::tag_CMDTeacherSubscriptionStateQueryReq*) data;
		_nmask = cmd->nmask;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherSubscriptionStateQueryReq---------");
		LOG("nmask = %d", _nmask);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
	}

};


class TeacherSubscriptionStateQueryResp
{

private:

	uint32	_nmask;
	uint32	_userid;
	uint32	_state;


public:

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 state() { return _state; } const 

	 inline void set_state(const uint32 value) { _state = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherSubscriptionStateQueryResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionStateQueryResp* cmd = (protocol::tag_CMDTeacherSubscriptionStateQueryResp*) data;
		cmd->nmask = _nmask;
		cmd->userid = _userid;
		cmd->state = _state;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherSubscriptionStateQueryResp* cmd = (protocol::tag_CMDTeacherSubscriptionStateQueryResp*) data;
		_nmask = cmd->nmask;
		_userid = cmd->userid;
		_state = cmd->state;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherSubscriptionStateQueryResp---------");
		LOG("nmask = %d", _nmask);
		LOG("userid = %d", _userid);
		LOG("state = %d", _state);
	}

};


class ExpertNewViewNoty
{

private:

	uint32	_nmessageid;
	uint32	_nvcbid;
	uint32	_teamid;
	string	_sname;
	string	_sicon;
	string	_spublictime;
	uint32	_ncommentcnt;
	uint32	_nlikecnt;
	uint32	_nflowercnt;
	uint32	_contlen;
	string	_content;


public:

	 inline uint32 nmessageid() { return _nmessageid; } const 

	 inline void set_nmessageid(const uint32 value) { _nmessageid = value; }

	 inline uint32 nvcbid() { return _nvcbid; } const 

	 inline void set_nvcbid(const uint32 value) { _nvcbid = value; }

	 inline uint32 teamid() { return _teamid; } const 

	 inline void set_teamid(const uint32 value) { _teamid = value; }

	 inline string& sname() { return _sname; } const 

	 inline void set_sname(const string& value) { _sname = value; }

	 inline string& sicon() { return _sicon; } const 

	 inline void set_sicon(const string& value) { _sicon = value; }

	 inline string& spublictime() { return _spublictime; } const 

	 inline void set_spublictime(const string& value) { _spublictime = value; }

	 inline uint32 ncommentcnt() { return _ncommentcnt; } const 

	 inline void set_ncommentcnt(const uint32 value) { _ncommentcnt = value; }

	 inline uint32 nlikecnt() { return _nlikecnt; } const 

	 inline void set_nlikecnt(const uint32 value) { _nlikecnt = value; }

	 inline uint32 nflowercnt() { return _nflowercnt; } const 

	 inline void set_nflowercnt(const uint32 value) { _nflowercnt = value; }

	 inline uint32 contlen() { return _contlen; } const 

	 inline void set_contlen(const uint32 value) { _contlen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDExpertNewViewNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDExpertNewViewNoty* cmd = (protocol::tag_CMDExpertNewViewNoty*) data;
		cmd->nmessageid = _nmessageid;
		cmd->nvcbid = _nvcbid;
		cmd->teamid = _teamid;
		strcpy(cmd->sName, _sname.c_str());
		strcpy(cmd->sIcon, _sicon.c_str());
		strcpy(cmd->sPublicTime, _spublictime.c_str());
		cmd->nCommentCnt = _ncommentcnt;
		cmd->nLikeCnt = _nlikecnt;
		cmd->nFlowerCnt = _nflowercnt;
		cmd->contlen = _contlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDExpertNewViewNoty* cmd = (protocol::tag_CMDExpertNewViewNoty*) data;
		_nmessageid = cmd->nmessageid;
		_nvcbid = cmd->nvcbid;
		_teamid = cmd->teamid;
		_sname = cmd->sName;
		_sicon = cmd->sIcon;
		_spublictime = cmd->sPublicTime;
		_ncommentcnt = cmd->nCommentCnt;
		_nlikecnt = cmd->nLikeCnt;
		_nflowercnt = cmd->nFlowerCnt;
		_contlen = cmd->contlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: ExpertNewViewNoty---------");
		LOG("nmessageid = %d", _nmessageid);
		LOG("nvcbid = %d", _nvcbid);
		LOG("teamid = %d", _teamid);
		LOG("sname = %s", _sname.c_str());
		LOG("sicon = %s", _sicon.c_str());
		LOG("spublictime = %s", _spublictime.c_str());
		LOG("ncommentcnt = %d", _ncommentcnt);
		LOG("nlikecnt = %d", _nlikecnt);
		LOG("nflowercnt = %d", _nflowercnt);
		LOG("contlen = %d", _contlen);
		LOG("content = %s", _content.c_str());
	}

};


class TeamTopNReq
{

private:

	uint32	_userid;
	uint32	_vcbid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeamTopNReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeamTopNReq* cmd = (protocol::tag_CMDTeamTopNReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeamTopNReq* cmd = (protocol::tag_CMDTeamTopNReq*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
	}

	void Log()
	{
		LOG("--------Receive message: TeamTopNReq---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
	}

};


class TeamTopNResp
{

private:

	uint32	_vcbid;
	string	_teamname;
	uint64	_giftmoney;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline string& teamname() { return _teamname; } const 

	 inline void set_teamname(const string& value) { _teamname = value; }

	 inline uint64 giftmoney() { return _giftmoney; } const 

	 inline void set_giftmoney(const uint64 value) { _giftmoney = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeamTopNResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeamTopNResp* cmd = (protocol::tag_CMDTeamTopNResp*) data;
		cmd->vcbid = _vcbid;
		strcpy(cmd->teamname, _teamname.c_str());
		cmd->giftmoney = _giftmoney;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeamTopNResp* cmd = (protocol::tag_CMDTeamTopNResp*) data;
		_vcbid = cmd->vcbid;
		_teamname = cmd->teamname;
		_giftmoney = cmd->giftmoney;
	}

	void Log()
	{
		LOG("--------Receive message: TeamTopNResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teamname = %s", _teamname.c_str());
		LOG("giftmoney = %lld", _giftmoney);
	}

};


class AskQuestionReq
{

private:

	uint32	_roomid;
	uint32	_userid;
	uint32	_teamid;
	string	_stock;
	uint32	_questionlen;
	string	_question;


public:

	 inline uint32 roomid() { return _roomid; } const 

	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teamid() { return _teamid; } const 

	 inline void set_teamid(const uint32 value) { _teamid = value; }

	 inline string& stock() { return _stock; } const 

	 inline void set_stock(const string& value) { _stock = value; }

	 inline uint32 questionlen() { return _questionlen; } const 

	 inline void set_questionlen(const uint32 value) { _questionlen = value; }

	 inline string& question() { return _question; } const 

	 inline void set_question(const string& value) { _question = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDAskQuestionReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAskQuestionReq* cmd = (protocol::tag_CMDAskQuestionReq*) data;
		cmd->roomid = _roomid;
		cmd->userid = _userid;
		cmd->teamid = _teamid;
		strcpy(cmd->stock, _stock.c_str());
		cmd->questionlen = _questionlen;
		strcpy(cmd->question, _question.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAskQuestionReq* cmd = (protocol::tag_CMDAskQuestionReq*) data;
		_roomid = cmd->roomid;
		_userid = cmd->userid;
		_teamid = cmd->teamid;
		_stock = cmd->stock;
		_questionlen = cmd->questionlen;
		_question = cmd->question;
	}

	void Log()
	{
		LOG("--------Receive message: AskQuestionReq---------");
		LOG("roomid = %d", _roomid);
		LOG("userid = %d", _userid);
		LOG("teamid = %d", _teamid);
		LOG("stock = %s", _stock.c_str());
		LOG("questionlen = %d", _questionlen);
		LOG("question = %s", _question.c_str());
	}

};


class AskQuestionResp
{

private:

	uint64	_nk;
	uint32	_questionid;
	uint32	_userid;
	uint32	_teamid;
	string	_stock;
	uint32	_questionlen;
	string	_question;


public:

	 inline uint64 nk() { return _nk; } const 

	 inline void set_nk(const uint64 value) { _nk = value; }

	 inline uint32 questionid() { return _questionid; } const 

	 inline void set_questionid(const uint32 value) { _questionid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teamid() { return _teamid; } const 

	 inline void set_teamid(const uint32 value) { _teamid = value; }

	 inline string& stock() { return _stock; } const 

	 inline void set_stock(const string& value) { _stock = value; }

	 inline uint32 questionlen() { return _questionlen; } const 

	 inline void set_questionlen(const uint32 value) { _questionlen = value; }

	 inline string& question() { return _question; } const 

	 inline void set_question(const string& value) { _question = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDAskQuestionResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAskQuestionResp* cmd = (protocol::tag_CMDAskQuestionResp*) data;
		cmd->nk = _nk;
		cmd->questionid = _questionid;
		cmd->userid = _userid;
		cmd->teamid = _teamid;
		strcpy(cmd->stock, _stock.c_str());
		cmd->questionlen = _questionlen;
		strcpy(cmd->question, _question.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAskQuestionResp* cmd = (protocol::tag_CMDAskQuestionResp*) data;
		_nk = cmd->nk;
		_questionid = cmd->questionid;
		_userid = cmd->userid;
		_teamid = cmd->teamid;
		_stock = cmd->stock;
		_questionlen = cmd->questionlen;
		_question = cmd->question;
	}

	void Log()
	{
		LOG("--------Receive message: AskQuestionResp---------");
		LOG("nk = %lld", _nk);
		LOG("questionid = %d", _questionid);
		LOG("userid = %d", _userid);
		LOG("teamid = %d", _teamid);
		LOG("stock = %s", _stock.c_str());
		LOG("questionlen = %d", _questionlen);
		LOG("question = %s", _question.c_str());
	}

};







#endif
