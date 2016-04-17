#ifndef _TEXT_MESSAGE_H_
#define _TEXT_MESSAGE_H_



#include <string>
#include "Log.h"
#include "textroom_cmd_vchat.h"
using std::string;


class TextRoomTeacherReq
{

private:

	uint32	_vcbid;
	uint32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomTeacherReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomTeacherReq* cmd = (protocol::tag_CMDTextRoomTeacherReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomTeacherReq* cmd = (protocol::tag_CMDTextRoomTeacherReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomTeacherReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
	}

};


class TextRoomTeacherNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	string	_teacheralias;
	uint32	_headid;
	int32	_levellen;
	int32	_labellen;
	int32	_goodatlen;
	int32	_introducelen;
	int64	_historymoods;
	int64	_fans;
	int64	_zans;
	int64	_todaymoods;
	int64	_historylives;
	int32	_liveflag;
	int32	_fansflag;
	int32	_bstudent;
	int32	_rteacherliveroom;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 
	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(const uint32 value) { _headid = value; }

	 inline int32 levellen() { return _levellen; } const 
	 inline void set_levellen(const int32 value) { _levellen = value; }

	 inline int32 labellen() { return _labellen; } const 
	 inline void set_labellen(const int32 value) { _labellen = value; }

	 inline int32 goodatlen() { return _goodatlen; } const 
	 inline void set_goodatlen(const int32 value) { _goodatlen = value; }

	 inline int32 introducelen() { return _introducelen; } const 
	 inline void set_introducelen(const int32 value) { _introducelen = value; }

	 inline int64 historymoods() { return _historymoods; } const 
	 inline void set_historymoods(const int64 value) { _historymoods = value; }

	 inline int64 fans() { return _fans; } const 
	 inline void set_fans(const int64 value) { _fans = value; }

	 inline int64 zans() { return _zans; } const 
	 inline void set_zans(const int64 value) { _zans = value; }

	 inline int64 todaymoods() { return _todaymoods; } const 
	 inline void set_todaymoods(const int64 value) { _todaymoods = value; }

	 inline int64 historylives() { return _historylives; } const 
	 inline void set_historylives(const int64 value) { _historylives = value; }

	 inline int32 liveflag() { return _liveflag; } const 
	 inline void set_liveflag(const int32 value) { _liveflag = value; }

	 inline int32 fansflag() { return _fansflag; } const 
	 inline void set_fansflag(const int32 value) { _fansflag = value; }

	 inline int32 bstudent() { return _bstudent; } const 
	 inline void set_bstudent(const int32 value) { _bstudent = value; }

	 inline int32 rteacherliveroom() { return _rteacherliveroom; } const 
	 inline void set_rteacherliveroom(const int32 value) { _rteacherliveroom = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomTeacherNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomTeacherNoty* cmd = (protocol::tag_CMDTextRoomTeacherNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->headid = _headid;
		cmd->levellen = _levellen;
		cmd->labellen = _labellen;
		cmd->goodatlen = _goodatlen;
		cmd->introducelen = _introducelen;
		cmd->historymoods = _historymoods;
		cmd->fans = _fans;
		cmd->zans = _zans;
		cmd->todaymoods = _todaymoods;
		cmd->historyLives = _historylives;
		cmd->liveflag = _liveflag;
		cmd->fansflag = _fansflag;
		cmd->bstudent = _bstudent;
		cmd->rTeacherLiveRoom = _rteacherliveroom;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomTeacherNoty* cmd = (protocol::tag_CMDTextRoomTeacherNoty*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_teacheralias = cmd->teacheralias;
		_headid = cmd->headid;
		_levellen = cmd->levellen;
		_labellen = cmd->labellen;
		_goodatlen = cmd->goodatlen;
		_introducelen = cmd->introducelen;
		_historymoods = cmd->historymoods;
		_fans = cmd->fans;
		_zans = cmd->zans;
		_todaymoods = cmd->todaymoods;
		_historylives = cmd->historyLives;
		_liveflag = cmd->liveflag;
		_fansflag = cmd->fansflag;
		_bstudent = cmd->bstudent;
		_rteacherliveroom = cmd->rTeacherLiveRoom;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomTeacherNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("headid = %d", _headid);
		LOG("levellen = %d", _levellen);
		LOG("labellen = %d", _labellen);
		LOG("goodatlen = %d", _goodatlen);
		LOG("introducelen = %d", _introducelen);
		LOG("historymoods = %lld", _historymoods);
		LOG("fans = %lld", _fans);
		LOG("zans = %lld", _zans);
		LOG("todaymoods = %lld", _todaymoods);
		LOG("historylives = %lld", _historylives);
		LOG("liveflag = %d", _liveflag);
		LOG("fansflag = %d", _fansflag);
		LOG("bstudent = %d", _bstudent);
		LOG("rteacherliveroom = %d", _rteacherliveroom);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLiveListReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_type;
	int64	_messageid;
	int32	_count;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 type() { return _type; } const 
	 inline void set_type(const int32 value) { _type = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 count() { return _count; } const 
	 inline void set_count(const int32 value) { _count = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveListReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveListReq* cmd = (protocol::tag_CMDTextRoomLiveListReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->type = _type;
		cmd->messageid = _messageid;
		cmd->count = _count;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveListReq* cmd = (protocol::tag_CMDTextRoomLiveListReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_type = cmd->type;
		_messageid = cmd->messageid;
		_count = cmd->count;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveListReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("type = %d", _type);
		LOG("messageid = %lld", _messageid);
		LOG("count = %d", _count);
	}

};


class TextRoomLiveListNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	uint32	_srcuserid;
	string	_srcuseralias;
	int64	_messageid;
	int32	_pointflag;
	int32	_forecastflag;
	int32	_livetype;
	int64	_viewid;
	int32	_textlen;
	int32	_destextlen;
	uint64	_messagetime;
	int64	_zans;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 srcuserid() { return _srcuserid; } const 
	 inline void set_srcuserid(const uint32 value) { _srcuserid = value; }

	 inline string& srcuseralias() { return _srcuseralias; } const 
	 inline void set_srcuseralias(const string& value) { _srcuseralias = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 pointflag() { return _pointflag; } const 
	 inline void set_pointflag(const int32 value) { _pointflag = value; }

	 inline int32 forecastflag() { return _forecastflag; } const 
	 inline void set_forecastflag(const int32 value) { _forecastflag = value; }

	 inline int32 livetype() { return _livetype; } const 
	 inline void set_livetype(const int32 value) { _livetype = value; }

	 inline int64 viewid() { return _viewid; } const 
	 inline void set_viewid(const int64 value) { _viewid = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline int32 destextlen() { return _destextlen; } const 
	 inline void set_destextlen(const int32 value) { _destextlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline int64 zans() { return _zans; } const 
	 inline void set_zans(const int64 value) { _zans = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveListNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveListNoty* cmd = (protocol::tag_CMDTextRoomLiveListNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->srcuserid = _srcuserid;
		strcpy(cmd->srcuseralias, _srcuseralias.c_str());
		cmd->messageid = _messageid;
		cmd->pointflag = _pointflag;
		cmd->forecastflag = _forecastflag;
		cmd->livetype = _livetype;
		cmd->viewid = _viewid;
		cmd->textlen = _textlen;
		cmd->destextlen = _destextlen;
		cmd->messagetime = _messagetime;
		cmd->zans = _zans;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveListNoty* cmd = (protocol::tag_CMDTextRoomLiveListNoty*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_srcuserid = cmd->srcuserid;
		_srcuseralias = cmd->srcuseralias;
		_messageid = cmd->messageid;
		_pointflag = cmd->pointflag;
		_forecastflag = cmd->forecastflag;
		_livetype = cmd->livetype;
		_viewid = cmd->viewid;
		_textlen = cmd->textlen;
		_destextlen = cmd->destextlen;
		_messagetime = cmd->messagetime;
		_zans = cmd->zans;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveListNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("srcuserid = %d", _srcuserid);
		LOG("srcuseralias = %s", _srcuseralias.c_str());
		LOG("messageid = %lld", _messageid);
		LOG("pointflag = %d", _pointflag);
		LOG("forecastflag = %d", _forecastflag);
		LOG("livetype = %d", _livetype);
		LOG("viewid = %lld", _viewid);
		LOG("textlen = %d", _textlen);
		LOG("destextlen = %d", _destextlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("zans = %lld", _zans);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLivePointNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int64	_messageid;
	int32	_livetype;
	int32	_textlen;
	uint64	_messagetime;
	int64	_zans;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 livetype() { return _livetype; } const 
	 inline void set_livetype(const int32 value) { _livetype = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline int64 zans() { return _zans; } const 
	 inline void set_zans(const int64 value) { _zans = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLivePointNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLivePointNoty* cmd = (protocol::tag_CMDTextRoomLivePointNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->messageid = _messageid;
		cmd->livetype = _livetype;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->zans = _zans;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLivePointNoty* cmd = (protocol::tag_CMDTextRoomLivePointNoty*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_messageid = cmd->messageid;
		_livetype = cmd->livetype;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_zans = cmd->zans;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLivePointNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("messageid = %lld", _messageid);
		LOG("livetype = %d", _livetype);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("zans = %lld", _zans);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLiveMessageReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int32	_pointflag;
	int32	_forecastflag;
	int32	_livetype;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 pointflag() { return _pointflag; } const 
	 inline void set_pointflag(const int32 value) { _pointflag = value; }

	 inline int32 forecastflag() { return _forecastflag; } const 
	 inline void set_forecastflag(const int32 value) { _forecastflag = value; }

	 inline int32 livetype() { return _livetype; } const 
	 inline void set_livetype(const int32 value) { _livetype = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveMessageReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveMessageReq* cmd = (protocol::tag_CMDTextRoomLiveMessageReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->pointflag = _pointflag;
		cmd->forecastflag = _forecastflag;
		cmd->livetype = _livetype;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveMessageReq* cmd = (protocol::tag_CMDTextRoomLiveMessageReq*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_pointflag = cmd->pointflag;
		_forecastflag = cmd->forecastflag;
		_livetype = cmd->livetype;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveMessageReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("pointflag = %d", _pointflag);
		LOG("forecastflag = %d", _forecastflag);
		LOG("livetype = %d", _livetype);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLiveMessageResp
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int64	_messageid;
	int32	_pointflag;
	int32	_forecastflag;
	int32	_livetype;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 pointflag() { return _pointflag; } const 
	 inline void set_pointflag(const int32 value) { _pointflag = value; }

	 inline int32 forecastflag() { return _forecastflag; } const 
	 inline void set_forecastflag(const int32 value) { _forecastflag = value; }

	 inline int32 livetype() { return _livetype; } const 
	 inline void set_livetype(const int32 value) { _livetype = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveMessageResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveMessageResp* cmd = (protocol::tag_CMDTextRoomLiveMessageResp*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->messageid = _messageid;
		cmd->pointflag = _pointflag;
		cmd->forecastflag = _forecastflag;
		cmd->livetype = _livetype;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveMessageResp* cmd = (protocol::tag_CMDTextRoomLiveMessageResp*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_messageid = cmd->messageid;
		_pointflag = cmd->pointflag;
		_forecastflag = cmd->forecastflag;
		_livetype = cmd->livetype;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveMessageResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("messageid = %lld", _messageid);
		LOG("pointflag = %d", _pointflag);
		LOG("forecastflag = %d", _forecastflag);
		LOG("livetype = %d", _livetype);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomInterestForReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_optype;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 optype() { return _optype; } const 
	 inline void set_optype(const int32 value) { _optype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomInterestForReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomInterestForReq* cmd = (protocol::tag_CMDTextRoomInterestForReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomInterestForReq* cmd = (protocol::tag_CMDTextRoomInterestForReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_optype = cmd->optype;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomInterestForReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("optype = %d", _optype);
	}

};


class TextRoomInterestForResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_result;
	uint32	_teacherid;
	int32	_optype;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 optype() { return _optype; } const 
	 inline void set_optype(const int32 value) { _optype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomInterestForResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomInterestForResp* cmd = (protocol::tag_CMDTextRoomInterestForResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->result = _result;
		cmd->teacherid = _teacherid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomInterestForResp* cmd = (protocol::tag_CMDTextRoomInterestForResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_result = cmd->result;
		_teacherid = cmd->teacherid;
		_optype = cmd->optype;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomInterestForResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
		LOG("teacherid = %d", _teacherid);
		LOG("optype = %d", _optype);
	}

};


class TextRoomGetUserGoodStatusReq
{

private:

	uint32	_userid;
	uint32	_salerid;
	uint32	_type;
	uint32	_goodclassid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 salerid() { return _salerid; } const 
	 inline void set_salerid(const uint32 value) { _salerid = value; }

	 inline uint32 type() { return _type; } const 
	 inline void set_type(const uint32 value) { _type = value; }

	 inline uint32 goodclassid() { return _goodclassid; } const 
	 inline void set_goodclassid(const uint32 value) { _goodclassid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomGetUserGoodStatusReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomGetUserGoodStatusReq* cmd = (protocol::tag_CMDTextRoomGetUserGoodStatusReq*) data;
		cmd->userid = _userid;
		cmd->salerid = _salerid;
		cmd->type = _type;
		cmd->goodclassid = _goodclassid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomGetUserGoodStatusReq* cmd = (protocol::tag_CMDTextRoomGetUserGoodStatusReq*) data;
		_userid = cmd->userid;
		_salerid = cmd->salerid;
		_type = cmd->type;
		_goodclassid = cmd->goodclassid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomGetUserGoodStatusReq---------");
		LOG("userid = %d", _userid);
		LOG("salerid = %d", _salerid);
		LOG("type = %d", _type);
		LOG("goodclassid = %d", _goodclassid);
	}

};


class TextRoomGetUserGoodStatusResp
{

private:

	uint32	_userid;
	uint32	_salerid;
	uint32	_num;
	int32	_result;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 salerid() { return _salerid; } const 
	 inline void set_salerid(const uint32 value) { _salerid = value; }

	 inline uint32 num() { return _num; } const 
	 inline void set_num(const uint32 value) { _num = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomGetUserGoodStatusResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomGetUserGoodStatusResp* cmd = (protocol::tag_CMDTextRoomGetUserGoodStatusResp*) data;
		cmd->userid = _userid;
		cmd->salerid = _salerid;
		cmd->num = _num;
		cmd->result = _result;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomGetUserGoodStatusResp* cmd = (protocol::tag_CMDTextRoomGetUserGoodStatusResp*) data;
		_userid = cmd->userid;
		_salerid = cmd->salerid;
		_num = cmd->num;
		_result = cmd->result;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomGetUserGoodStatusResp---------");
		LOG("userid = %d", _userid);
		LOG("salerid = %d", _salerid);
		LOG("num = %d", _num);
		LOG("result = %d", _result);
	}

};


class TextRoomQuestionReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	uint32	_userid;
	int32	_stocklen;
	int32	_textlen;
	uint32	_commentstype;
	uint64	_messagetime;
	uint32	_isfree;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 stocklen() { return _stocklen; } const 
	 inline void set_stocklen(const int32 value) { _stocklen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 isfree() { return _isfree; } const 
	 inline void set_isfree(const uint32 value) { _isfree = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomQuestionReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomQuestionReq* cmd = (protocol::tag_CMDTextRoomQuestionReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->userid = _userid;
		cmd->stocklen = _stocklen;
		cmd->textlen = _textlen;
		cmd->commentstype = _commentstype;
		cmd->messagetime = _messagetime;
		cmd->isfree = _isfree;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomQuestionReq* cmd = (protocol::tag_CMDTextRoomQuestionReq*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_userid = cmd->userid;
		_stocklen = cmd->stocklen;
		_textlen = cmd->textlen;
		_commentstype = cmd->commentstype;
		_messagetime = cmd->messagetime;
		_isfree = cmd->isfree;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomQuestionReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("userid = %d", _userid);
		LOG("stocklen = %d", _stocklen);
		LOG("textlen = %d", _textlen);
		LOG("commentstype = %d", _commentstype);
		LOG("messagetime = %lld", _messagetime);
		LOG("isfree = %d", _isfree);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomQuestionResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_result;
	int64	_messageid;
	uint64	_nk;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline uint64 nk() { return _nk; } const 
	 inline void set_nk(const uint64 value) { _nk = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomQuestionResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomQuestionResp* cmd = (protocol::tag_CMDTextRoomQuestionResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->result = _result;
		cmd->messageid = _messageid;
		cmd->nk = _nk;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomQuestionResp* cmd = (protocol::tag_CMDTextRoomQuestionResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_result = cmd->result;
		_messageid = cmd->messageid;
		_nk = cmd->nk;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomQuestionResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
		LOG("messageid = %lld", _messageid);
		LOG("nk = %lld", _nk);
	}

};


class TextRoomLiveActionResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_result;
	int64	_messageid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveActionResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveActionResp* cmd = (protocol::tag_CMDTextRoomLiveActionResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->result = _result;
		cmd->messageid = _messageid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveActionResp* cmd = (protocol::tag_CMDTextRoomLiveActionResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_result = cmd->result;
		_messageid = cmd->messageid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveActionResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
		LOG("messageid = %lld", _messageid);
	}

};


class TextRoomZanForReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_messageid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomZanForReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomZanForReq* cmd = (protocol::tag_CMDTextRoomZanForReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->messageid = _messageid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomZanForReq* cmd = (protocol::tag_CMDTextRoomZanForReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_messageid = cmd->messageid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomZanForReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("messageid = %lld", _messageid);
	}

};


class TextRoomZanForResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_result;
	int64	_messageid;
	int64	_recordzans;
	int64	_totalzans;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int64 recordzans() { return _recordzans; } const 
	 inline void set_recordzans(const int64 value) { _recordzans = value; }

	 inline int64 totalzans() { return _totalzans; } const 
	 inline void set_totalzans(const int64 value) { _totalzans = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomZanForResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomZanForResp* cmd = (protocol::tag_CMDTextRoomZanForResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->result = _result;
		cmd->messageid = _messageid;
		cmd->recordzans = _recordzans;
		cmd->totalzans = _totalzans;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomZanForResp* cmd = (protocol::tag_CMDTextRoomZanForResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_result = cmd->result;
		_messageid = cmd->messageid;
		_recordzans = cmd->recordzans;
		_totalzans = cmd->totalzans;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomZanForResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
		LOG("messageid = %lld", _messageid);
		LOG("recordzans = %lld", _recordzans);
		LOG("totalzans = %lld", _totalzans);
	}

};


class RoomLiveChatReq
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_msgtype;
	uint64	_messagetime;
	uint32	_textlen;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint32 msgtype() { return _msgtype; } const 
	 inline void set_msgtype(const uint32 value) { _msgtype = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomLiveChatReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomLiveChatReq* cmd = (protocol::tag_CMDRoomLiveChatReq*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->msgtype = _msgtype;
		cmd->messagetime = _messagetime;
		cmd->textlen = _textlen;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomLiveChatReq* cmd = (protocol::tag_CMDRoomLiveChatReq*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_msgtype = cmd->msgtype;
		_messagetime = cmd->messagetime;
		_textlen = cmd->textlen;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: RoomLiveChatReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("msgtype = %d", _msgtype);
		LOG("messagetime = %lld", _messagetime);
		LOG("textlen = %d", _textlen);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLiveChatResp
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	string	_srcalias;
	uint32	_srcheadid;
	uint32	_toid;
	string	_toalias;
	uint32	_toheadid;
	uint32	_msgtype;
	uint64	_messagetime;
	uint32	_textlen;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline string& srcalias() { return _srcalias; } const 
	 inline void set_srcalias(const string& value) { _srcalias = value; }

	 inline uint32 srcheadid() { return _srcheadid; } const 
	 inline void set_srcheadid(const uint32 value) { _srcheadid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline string& toalias() { return _toalias; } const 
	 inline void set_toalias(const string& value) { _toalias = value; }

	 inline uint32 toheadid() { return _toheadid; } const 
	 inline void set_toheadid(const uint32 value) { _toheadid = value; }

	 inline uint32 msgtype() { return _msgtype; } const 
	 inline void set_msgtype(const uint32 value) { _msgtype = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(const uint32 value) { _textlen = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveChatResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveChatResp* cmd = (protocol::tag_CMDTextRoomLiveChatResp*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		strcpy(cmd->srcalias, _srcalias.c_str());
		cmd->srcheadid = _srcheadid;
		cmd->toid = _toid;
		strcpy(cmd->toalias, _toalias.c_str());
		cmd->toheadid = _toheadid;
		cmd->msgtype = _msgtype;
		cmd->messagetime = _messagetime;
		cmd->textlen = _textlen;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveChatResp* cmd = (protocol::tag_CMDTextRoomLiveChatResp*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_srcalias = cmd->srcalias;
		_srcheadid = cmd->srcheadid;
		_toid = cmd->toid;
		_toalias = cmd->toalias;
		_toheadid = cmd->toheadid;
		_msgtype = cmd->msgtype;
		_messagetime = cmd->messagetime;
		_textlen = cmd->textlen;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveChatResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("srcalias = %s", _srcalias.c_str());
		LOG("srcheadid = %d", _srcheadid);
		LOG("toid = %d", _toid);
		LOG("toalias = %s", _toalias.c_str());
		LOG("toheadid = %d", _toheadid);
		LOG("msgtype = %d", _msgtype);
		LOG("messagetime = %lld", _messagetime);
		LOG("textlen = %d", _textlen);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextLiveChatReplyReq
{

private:

	uint32	_vcbid;
	uint32	_fromid;
	uint32	_toid;
	uint64	_messagetime;
	uint32	_reqtextlen;
	uint32	_restextlen;
	uint32	_liveflag;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 fromid() { return _fromid; } const 
	 inline void set_fromid(const uint32 value) { _fromid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 reqtextlen() { return _reqtextlen; } const 
	 inline void set_reqtextlen(const uint32 value) { _reqtextlen = value; }

	 inline uint32 restextlen() { return _restextlen; } const 
	 inline void set_restextlen(const uint32 value) { _restextlen = value; }

	 inline uint32 liveflag() { return _liveflag; } const 
	 inline void set_liveflag(const uint32 value) { _liveflag = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveChatReplyReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveChatReplyReq* cmd = (protocol::tag_CMDTextLiveChatReplyReq*) data;
		cmd->vcbid = _vcbid;
		cmd->fromid = _fromid;
		cmd->toid = _toid;
		cmd->messagetime = _messagetime;
		cmd->reqtextlen = _reqtextlen;
		cmd->restextlen = _restextlen;
		cmd->liveflag = _liveflag;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveChatReplyReq* cmd = (protocol::tag_CMDTextLiveChatReplyReq*) data;
		_vcbid = cmd->vcbid;
		_fromid = cmd->fromid;
		_toid = cmd->toid;
		_messagetime = cmd->messagetime;
		_reqtextlen = cmd->reqtextlen;
		_restextlen = cmd->restextlen;
		_liveflag = cmd->liveflag;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveChatReplyReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("fromid = %d", _fromid);
		LOG("toid = %d", _toid);
		LOG("messagetime = %lld", _messagetime);
		LOG("reqtextlen = %d", _reqtextlen);
		LOG("restextlen = %d", _restextlen);
		LOG("liveflag = %d", _liveflag);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextLiveChatReplyResp
{

private:

	uint32	_vcbid;
	uint32	_fromid;
	string	_fromalias;
	uint32	_fromheadid;
	uint32	_toid;
	string	_toalias;
	uint32	_toheadid;
	uint64	_messagetime;
	uint32	_reqtextlen;
	uint32	_restextlen;
	uint32	_liveflag;
	uint32	_commentstype;
	int64	_messageid;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 fromid() { return _fromid; } const 
	 inline void set_fromid(const uint32 value) { _fromid = value; }

	 inline string& fromalias() { return _fromalias; } const 
	 inline void set_fromalias(const string& value) { _fromalias = value; }

	 inline uint32 fromheadid() { return _fromheadid; } const 
	 inline void set_fromheadid(const uint32 value) { _fromheadid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline string& toalias() { return _toalias; } const 
	 inline void set_toalias(const string& value) { _toalias = value; }

	 inline uint32 toheadid() { return _toheadid; } const 
	 inline void set_toheadid(const uint32 value) { _toheadid = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 reqtextlen() { return _reqtextlen; } const 
	 inline void set_reqtextlen(const uint32 value) { _reqtextlen = value; }

	 inline uint32 restextlen() { return _restextlen; } const 
	 inline void set_restextlen(const uint32 value) { _restextlen = value; }

	 inline uint32 liveflag() { return _liveflag; } const 
	 inline void set_liveflag(const uint32 value) { _liveflag = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveChatReplyResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveChatReplyResp* cmd = (protocol::tag_CMDTextLiveChatReplyResp*) data;
		cmd->vcbid = _vcbid;
		cmd->fromid = _fromid;
		strcpy(cmd->fromalias, _fromalias.c_str());
		cmd->fromheadid = _fromheadid;
		cmd->toid = _toid;
		strcpy(cmd->toalias, _toalias.c_str());
		cmd->toheadid = _toheadid;
		cmd->messagetime = _messagetime;
		cmd->reqtextlen = _reqtextlen;
		cmd->restextlen = _restextlen;
		cmd->liveflag = _liveflag;
		cmd->commentstype = _commentstype;
		cmd->messageid = _messageid;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveChatReplyResp* cmd = (protocol::tag_CMDTextLiveChatReplyResp*) data;
		_vcbid = cmd->vcbid;
		_fromid = cmd->fromid;
		_fromalias = cmd->fromalias;
		_fromheadid = cmd->fromheadid;
		_toid = cmd->toid;
		_toalias = cmd->toalias;
		_toheadid = cmd->toheadid;
		_messagetime = cmd->messagetime;
		_reqtextlen = cmd->reqtextlen;
		_restextlen = cmd->restextlen;
		_liveflag = cmd->liveflag;
		_commentstype = cmd->commentstype;
		_messageid = cmd->messageid;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveChatReplyResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("fromid = %d", _fromid);
		LOG("fromalias = %s", _fromalias.c_str());
		LOG("fromheadid = %d", _fromheadid);
		LOG("toid = %d", _toid);
		LOG("toalias = %s", _toalias.c_str());
		LOG("toheadid = %d", _toheadid);
		LOG("messagetime = %lld", _messagetime);
		LOG("reqtextlen = %d", _reqtextlen);
		LOG("restextlen = %d", _restextlen);
		LOG("liveflag = %d", _liveflag);
		LOG("commentstype = %d", _commentstype);
		LOG("messageid = %lld", _messageid);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLiveViewGroupReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveViewGroupReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewGroupReq* cmd = (protocol::tag_CMDTextRoomLiveViewGroupReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewGroupReq* cmd = (protocol::tag_CMDTextRoomLiveViewGroupReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveViewGroupReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
	}

};


class TextRoomViewGroupResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_viewtypeid;
	int32	_totalcount;
	int32	_viewtypelen;
	string	_viewtypename;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 viewtypeid() { return _viewtypeid; } const 
	 inline void set_viewtypeid(const int32 value) { _viewtypeid = value; }

	 inline int32 totalcount() { return _totalcount; } const 
	 inline void set_totalcount(const int32 value) { _totalcount = value; }

	 inline int32 viewtypelen() { return _viewtypelen; } const 
	 inline void set_viewtypelen(const int32 value) { _viewtypelen = value; }

	 inline string& viewtypename() { return _viewtypename; } const 
	 inline void set_viewtypename(const string& value) { _viewtypename = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewGroupResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewGroupResp* cmd = (protocol::tag_CMDTextRoomViewGroupResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->viewtypeid = _viewtypeid;
		cmd->totalcount = _totalcount;
		cmd->viewtypelen = _viewtypelen;
		strcpy(cmd->viewtypename, _viewtypename.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewGroupResp* cmd = (protocol::tag_CMDTextRoomViewGroupResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_viewtypeid = cmd->viewtypeid;
		_totalcount = cmd->totalcount;
		_viewtypelen = cmd->viewtypelen;
		_viewtypename = cmd->viewtypename;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewGroupResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("viewtypeid = %d", _viewtypeid);
		LOG("totalcount = %d", _totalcount);
		LOG("viewtypelen = %d", _viewtypelen);
		LOG("viewtypename = %s", _viewtypename.c_str());
	}

};


class TextRoomLiveViewListReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_viewtypeid;
	int64	_messageid;
	int32	_startindex;
	uint32	_count;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 viewtypeid() { return _viewtypeid; } const 
	 inline void set_viewtypeid(const int32 value) { _viewtypeid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 startindex() { return _startindex; } const 
	 inline void set_startindex(const int32 value) { _startindex = value; }

	 inline uint32 count() { return _count; } const 
	 inline void set_count(const uint32 value) { _count = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveViewListReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewListReq* cmd = (protocol::tag_CMDTextRoomLiveViewListReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->viewtypeid = _viewtypeid;
		cmd->messageid = _messageid;
		cmd->startIndex = _startindex;
		cmd->count = _count;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewListReq* cmd = (protocol::tag_CMDTextRoomLiveViewListReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_viewtypeid = cmd->viewtypeid;
		_messageid = cmd->messageid;
		_startindex = cmd->startIndex;
		_count = cmd->count;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveViewListReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("viewtypeid = %d", _viewtypeid);
		LOG("messageid = %lld", _messageid);
		LOG("startindex = %d", _startindex);
		LOG("count = %d", _count);
	}

};


class TextRoomViewListReq_mobile
{

private:

	string	_uuid;
	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_viewtypeid;
	int64	_messageid;
	int32	_startindex;
	uint32	_count;


public:

	 inline string& uuid() { return _uuid; } const 
	 inline void set_uuid(const string& value) { _uuid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 viewtypeid() { return _viewtypeid; } const 
	 inline void set_viewtypeid(const int32 value) { _viewtypeid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 startindex() { return _startindex; } const 
	 inline void set_startindex(const int32 value) { _startindex = value; }

	 inline uint32 count() { return _count; } const 
	 inline void set_count(const uint32 value) { _count = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewListReq_mobile); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewListReq_mobile* cmd = (protocol::tag_CMDTextRoomViewListReq_mobile*) data;
		strcpy(cmd->uuid, _uuid.c_str());
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->viewtypeid = _viewtypeid;
		cmd->messageid = _messageid;
		cmd->startIndex = _startindex;
		cmd->count = _count;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewListReq_mobile* cmd = (protocol::tag_CMDTextRoomViewListReq_mobile*) data;
		_uuid = cmd->uuid;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_viewtypeid = cmd->viewtypeid;
		_messageid = cmd->messageid;
		_startindex = cmd->startIndex;
		_count = cmd->count;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewListReq_mobile---------");
		LOG("uuid = %s", _uuid.c_str());
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("viewtypeid = %d", _viewtypeid);
		LOG("messageid = %lld", _messageid);
		LOG("startindex = %d", _startindex);
		LOG("count = %d", _count);
	}

};


class TextRoomLiveViewResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_viewtypeid;
	int64	_viewid;
	int32	_livetype;
	int32	_viewtitlelen;
	int32	_viewtextlen;
	uint64	_messagetime;
	int64	_looks;
	int64	_zans;
	int64	_comments;
	int64	_flowers;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 viewtypeid() { return _viewtypeid; } const 
	 inline void set_viewtypeid(const int32 value) { _viewtypeid = value; }

	 inline int64 viewid() { return _viewid; } const 
	 inline void set_viewid(const int64 value) { _viewid = value; }

	 inline int32 livetype() { return _livetype; } const 
	 inline void set_livetype(const int32 value) { _livetype = value; }

	 inline int32 viewtitlelen() { return _viewtitlelen; } const 
	 inline void set_viewtitlelen(const int32 value) { _viewtitlelen = value; }

	 inline int32 viewtextlen() { return _viewtextlen; } const 
	 inline void set_viewtextlen(const int32 value) { _viewtextlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline int64 looks() { return _looks; } const 
	 inline void set_looks(const int64 value) { _looks = value; }

	 inline int64 zans() { return _zans; } const 
	 inline void set_zans(const int64 value) { _zans = value; }

	 inline int64 comments() { return _comments; } const 
	 inline void set_comments(const int64 value) { _comments = value; }

	 inline int64 flowers() { return _flowers; } const 
	 inline void set_flowers(const int64 value) { _flowers = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveViewResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewResp* cmd = (protocol::tag_CMDTextRoomLiveViewResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->viewtypeid = _viewtypeid;
		cmd->viewid = _viewid;
		cmd->livetype = _livetype;
		cmd->viewTitlelen = _viewtitlelen;
		cmd->viewtextlen = _viewtextlen;
		cmd->messagetime = _messagetime;
		cmd->looks = _looks;
		cmd->zans = _zans;
		cmd->comments = _comments;
		cmd->flowers = _flowers;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewResp* cmd = (protocol::tag_CMDTextRoomLiveViewResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_viewtypeid = cmd->viewtypeid;
		_viewid = cmd->viewid;
		_livetype = cmd->livetype;
		_viewtitlelen = cmd->viewTitlelen;
		_viewtextlen = cmd->viewtextlen;
		_messagetime = cmd->messagetime;
		_looks = cmd->looks;
		_zans = cmd->zans;
		_comments = cmd->comments;
		_flowers = cmd->flowers;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveViewResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("viewtypeid = %d", _viewtypeid);
		LOG("viewid = %lld", _viewid);
		LOG("livetype = %d", _livetype);
		LOG("viewtitlelen = %d", _viewtitlelen);
		LOG("viewtextlen = %d", _viewtextlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("looks = %lld", _looks);
		LOG("zans = %lld", _zans);
		LOG("comments = %lld", _comments);
		LOG("flowers = %lld", _flowers);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomLiveViewDetailReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_viewid;
	int64	_messageid;
	int64	_startcommentpos;
	uint32	_count;
	uint32	_type;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 viewid() { return _viewid; } const 
	 inline void set_viewid(const int64 value) { _viewid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int64 startcommentpos() { return _startcommentpos; } const 
	 inline void set_startcommentpos(const int64 value) { _startcommentpos = value; }

	 inline uint32 count() { return _count; } const 
	 inline void set_count(const uint32 value) { _count = value; }

	 inline uint32 type() { return _type; } const 
	 inline void set_type(const uint32 value) { _type = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLiveViewDetailReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewDetailReq* cmd = (protocol::tag_CMDTextRoomLiveViewDetailReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->viewid = _viewid;
		cmd->messageid = _messageid;
		cmd->startcommentpos = _startcommentpos;
		cmd->count = _count;
		cmd->type = _type;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLiveViewDetailReq* cmd = (protocol::tag_CMDTextRoomLiveViewDetailReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_viewid = cmd->viewid;
		_messageid = cmd->messageid;
		_startcommentpos = cmd->startcommentpos;
		_count = cmd->count;
		_type = cmd->type;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLiveViewDetailReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("viewid = %lld", _viewid);
		LOG("messageid = %lld", _messageid);
		LOG("startcommentpos = %lld", _startcommentpos);
		LOG("count = %d", _count);
		LOG("type = %d", _type);
	}

};


class TextRoomViewInfoResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_viewid;
	int64	_commentid;
	uint32	_viewuserid;
	string	_useralias;
	int32	_textlen;
	uint64	_messagetime;
	int64	_srcinteractid;
	string	_srcuseralias;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 viewid() { return _viewid; } const 
	 inline void set_viewid(const int64 value) { _viewid = value; }

	 inline int64 commentid() { return _commentid; } const 
	 inline void set_commentid(const int64 value) { _commentid = value; }

	 inline uint32 viewuserid() { return _viewuserid; } const 
	 inline void set_viewuserid(const uint32 value) { _viewuserid = value; }

	 inline string& useralias() { return _useralias; } const 
	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline int64 srcinteractid() { return _srcinteractid; } const 
	 inline void set_srcinteractid(const int64 value) { _srcinteractid = value; }

	 inline string& srcuseralias() { return _srcuseralias; } const 
	 inline void set_srcuseralias(const string& value) { _srcuseralias = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewInfoResp* cmd = (protocol::tag_CMDTextRoomViewInfoResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->viewid = _viewid;
		cmd->commentid = _commentid;
		cmd->viewuserid = _viewuserid;
		strcpy(cmd->useralias, _useralias.c_str());
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->srcinteractid = _srcinteractid;
		strcpy(cmd->srcuseralias, _srcuseralias.c_str());
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewInfoResp* cmd = (protocol::tag_CMDTextRoomViewInfoResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_viewid = cmd->viewid;
		_commentid = cmd->commentid;
		_viewuserid = cmd->viewuserid;
		_useralias = cmd->useralias;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_srcinteractid = cmd->srcinteractid;
		_srcuseralias = cmd->srcuseralias;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewInfoResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("viewid = %lld", _viewid);
		LOG("commentid = %lld", _commentid);
		LOG("viewuserid = %d", _viewuserid);
		LOG("useralias = %s", _useralias.c_str());
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("srcinteractid = %lld", _srcinteractid);
		LOG("srcuseralias = %s", _srcuseralias.c_str());
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomViewTypeReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int32	_actiontypeid;
	int32	_viewtypeid;
	string	_viewtypename;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 actiontypeid() { return _actiontypeid; } const 
	 inline void set_actiontypeid(const int32 value) { _actiontypeid = value; }

	 inline int32 viewtypeid() { return _viewtypeid; } const 
	 inline void set_viewtypeid(const int32 value) { _viewtypeid = value; }

	 inline string& viewtypename() { return _viewtypename; } const 
	 inline void set_viewtypename(const string& value) { _viewtypename = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewTypeReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewTypeReq* cmd = (protocol::tag_CMDTextRoomViewTypeReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->actiontypeid = _actiontypeid;
		cmd->viewtypeid = _viewtypeid;
		strcpy(cmd->viewtypename, _viewtypename.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewTypeReq* cmd = (protocol::tag_CMDTextRoomViewTypeReq*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_actiontypeid = cmd->actiontypeid;
		_viewtypeid = cmd->viewtypeid;
		_viewtypename = cmd->viewtypename;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewTypeReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("actiontypeid = %d", _actiontypeid);
		LOG("viewtypeid = %d", _viewtypeid);
		LOG("viewtypename = %s", _viewtypename.c_str());
	}

};


class TextRoomViewTypeResp
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int32	_result;
	int32	_viewtypeid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline int32 viewtypeid() { return _viewtypeid; } const 
	 inline void set_viewtypeid(const int32 value) { _viewtypeid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewTypeResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewTypeResp* cmd = (protocol::tag_CMDTextRoomViewTypeResp*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->result = _result;
		cmd->viewtypeid = _viewtypeid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewTypeResp* cmd = (protocol::tag_CMDTextRoomViewTypeResp*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_result = cmd->result;
		_viewtypeid = cmd->viewtypeid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewTypeResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("result = %d", _result);
		LOG("viewtypeid = %d", _viewtypeid);
	}

};


class TextRoomViewMessageReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_messageid;
	int32	_viewtype;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 viewtype() { return _viewtype; } const 
	 inline void set_viewtype(const int32 value) { _viewtype = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewMessageReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewMessageReq* cmd = (protocol::tag_CMDTextRoomViewMessageReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->messageid = _messageid;
		cmd->viewtype = _viewtype;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewMessageReq* cmd = (protocol::tag_CMDTextRoomViewMessageReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_messageid = cmd->messageid;
		_viewtype = cmd->viewtype;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewMessageReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("messageid = %lld", _messageid);
		LOG("viewtype = %d", _viewtype);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomViewMessageReqResp
{

private:

	uint32	_userid;
	int64	_messageid;
	int32	_titlelen;
	uint64	_messagetime;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewMessageReqResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewMessageReqResp* cmd = (protocol::tag_CMDTextRoomViewMessageReqResp*) data;
		cmd->userid = _userid;
		cmd->messageid = _messageid;
		cmd->titlelen = _titlelen;
		cmd->messagetime = _messagetime;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewMessageReqResp* cmd = (protocol::tag_CMDTextRoomViewMessageReqResp*) data;
		_userid = cmd->userid;
		_messageid = cmd->messageid;
		_titlelen = cmd->titlelen;
		_messagetime = cmd->messagetime;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewMessageReqResp---------");
		LOG("userid = %d", _userid);
		LOG("messageid = %lld", _messageid);
		LOG("titlelen = %d", _titlelen);
		LOG("messagetime = %lld", _messagetime);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomViewDeleteReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_viewid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 viewid() { return _viewid; } const 
	 inline void set_viewid(const int64 value) { _viewid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewDeleteReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewDeleteReq* cmd = (protocol::tag_CMDTextRoomViewDeleteReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->viewid = _viewid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewDeleteReq* cmd = (protocol::tag_CMDTextRoomViewDeleteReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_viewid = cmd->viewid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewDeleteReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("viewid = %lld", _viewid);
	}

};


class TextRoomViewDeleteResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_viewid;
	int32	_result;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 viewid() { return _viewid; } const 
	 inline void set_viewid(const int64 value) { _viewid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewDeleteResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewDeleteResp* cmd = (protocol::tag_CMDTextRoomViewDeleteResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->viewid = _viewid;
		cmd->result = _result;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewDeleteResp* cmd = (protocol::tag_CMDTextRoomViewDeleteResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_viewid = cmd->viewid;
		_result = cmd->result;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewDeleteResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("viewid = %lld", _viewid);
		LOG("result = %d", _result);
	}

};


class TextLiveViewFlowerReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int64	_messageid;
	int32	_count;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 count() { return _count; } const 
	 inline void set_count(const int32 value) { _count = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveViewFlowerReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveViewFlowerReq* cmd = (protocol::tag_CMDTextLiveViewFlowerReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->messageid = _messageid;
		cmd->count = _count;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveViewFlowerReq* cmd = (protocol::tag_CMDTextLiveViewFlowerReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_messageid = cmd->messageid;
		_count = cmd->count;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveViewFlowerReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("messageid = %lld", _messageid);
		LOG("count = %d", _count);
	}

};


class TextLiveViewFlowerResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_result;
	int64	_messageid;
	int64	_recordflowers;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int64 recordflowers() { return _recordflowers; } const 
	 inline void set_recordflowers(const int64 value) { _recordflowers = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveViewFlowerResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveViewFlowerResp* cmd = (protocol::tag_CMDTextLiveViewFlowerResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->result = _result;
		cmd->messageid = _messageid;
		cmd->recordflowers = _recordflowers;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveViewFlowerResp* cmd = (protocol::tag_CMDTextLiveViewFlowerResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_result = cmd->result;
		_messageid = cmd->messageid;
		_recordflowers = cmd->recordflowers;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveViewFlowerResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
		LOG("messageid = %lld", _messageid);
		LOG("recordflowers = %lld", _recordflowers);
	}

};


class TextRoomViewCommentReq
{

private:

	uint32	_vcbid;
	uint32	_fromid;
	uint32	_toid;
	int64	_messageid;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	int64	_srcinteractid;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 fromid() { return _fromid; } const 
	 inline void set_fromid(const uint32 value) { _fromid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline int64 srcinteractid() { return _srcinteractid; } const 
	 inline void set_srcinteractid(const int64 value) { _srcinteractid = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewCommentReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewCommentReq* cmd = (protocol::tag_CMDTextRoomViewCommentReq*) data;
		cmd->vcbid = _vcbid;
		cmd->fromid = _fromid;
		cmd->toid = _toid;
		cmd->messageid = _messageid;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		cmd->srcinteractid = _srcinteractid;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewCommentReq* cmd = (protocol::tag_CMDTextRoomViewCommentReq*) data;
		_vcbid = cmd->vcbid;
		_fromid = cmd->fromid;
		_toid = cmd->toid;
		_messageid = cmd->messageid;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_srcinteractid = cmd->srcinteractid;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewCommentReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("fromid = %d", _fromid);
		LOG("toid = %d", _toid);
		LOG("messageid = %lld", _messageid);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("srcinteractid = %lld", _srcinteractid);
		LOG("content = %s", _content.c_str());
	}

};


class TextLiveHistoryListReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_count;
	int32	_fromindex;
	int32	_toindex;
	int32	_fromdate;
	uint32	_binc;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 count() { return _count; } const 
	 inline void set_count(const int32 value) { _count = value; }

	 inline int32 fromindex() { return _fromindex; } const 
	 inline void set_fromindex(const int32 value) { _fromindex = value; }

	 inline int32 toindex() { return _toindex; } const 
	 inline void set_toindex(const int32 value) { _toindex = value; }

	 inline int32 fromdate() { return _fromdate; } const 
	 inline void set_fromdate(const int32 value) { _fromdate = value; }

	 inline uint32 binc() { return _binc; } const 
	 inline void set_binc(const uint32 value) { _binc = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveHistoryListReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveHistoryListReq* cmd = (protocol::tag_CMDTextLiveHistoryListReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->count = _count;
		cmd->fromIndex = _fromindex;
		cmd->toIndex = _toindex;
		cmd->fromdate = _fromdate;
		cmd->bInc = _binc;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveHistoryListReq* cmd = (protocol::tag_CMDTextLiveHistoryListReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_count = cmd->count;
		_fromindex = cmd->fromIndex;
		_toindex = cmd->toIndex;
		_fromdate = cmd->fromdate;
		_binc = cmd->bInc;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveHistoryListReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("count = %d", _count);
		LOG("fromindex = %d", _fromindex);
		LOG("toindex = %d", _toindex);
		LOG("fromdate = %d", _fromdate);
		LOG("binc = %d", _binc);
	}

};


class TextLiveHistoryListResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	uint32	_datetime;
	uint64	_begintime;
	uint64	_endtime;
	uint32	_renqi;
	uint32	_canswer;
	uint32	_totalcount;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 datetime() { return _datetime; } const 
	 inline void set_datetime(const uint32 value) { _datetime = value; }

	 inline uint64 begintime() { return _begintime; } const 
	 inline void set_begintime(const uint64 value) { _begintime = value; }

	 inline uint64 endtime() { return _endtime; } const 
	 inline void set_endtime(const uint64 value) { _endtime = value; }

	 inline uint32 renqi() { return _renqi; } const 
	 inline void set_renqi(const uint32 value) { _renqi = value; }

	 inline uint32 canswer() { return _canswer; } const 
	 inline void set_canswer(const uint32 value) { _canswer = value; }

	 inline uint32 totalcount() { return _totalcount; } const 
	 inline void set_totalcount(const uint32 value) { _totalcount = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveHistoryListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveHistoryListResp* cmd = (protocol::tag_CMDTextLiveHistoryListResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->datetime = _datetime;
		cmd->beginTime = _begintime;
		cmd->endTime = _endtime;
		cmd->renQi = _renqi;
		cmd->cAnswer = _canswer;
		cmd->totalCount = _totalcount;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveHistoryListResp* cmd = (protocol::tag_CMDTextLiveHistoryListResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_datetime = cmd->datetime;
		_begintime = cmd->beginTime;
		_endtime = cmd->endTime;
		_renqi = cmd->renQi;
		_canswer = cmd->cAnswer;
		_totalcount = cmd->totalCount;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveHistoryListResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("datetime = %d", _datetime);
		LOG("begintime = %lld", _begintime);
		LOG("endtime = %lld", _endtime);
		LOG("renqi = %d", _renqi);
		LOG("canswer = %d", _canswer);
		LOG("totalcount = %d", _totalcount);
	}

};


class TextLiveHistoryDaylyReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_type;
	int64	_messageid;
	int32	_count;
	int32	_startindex;
	uint32	_datetime;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 type() { return _type; } const 
	 inline void set_type(const int32 value) { _type = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 count() { return _count; } const 
	 inline void set_count(const int32 value) { _count = value; }

	 inline int32 startindex() { return _startindex; } const 
	 inline void set_startindex(const int32 value) { _startindex = value; }

	 inline uint32 datetime() { return _datetime; } const 
	 inline void set_datetime(const uint32 value) { _datetime = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLiveHistoryDaylyReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveHistoryDaylyReq* cmd = (protocol::tag_CMDTextLiveHistoryDaylyReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->type = _type;
		cmd->messageid = _messageid;
		cmd->count = _count;
		cmd->startindex = _startindex;
		cmd->datetime = _datetime;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLiveHistoryDaylyReq* cmd = (protocol::tag_CMDTextLiveHistoryDaylyReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_type = cmd->type;
		_messageid = cmd->messageid;
		_count = cmd->count;
		_startindex = cmd->startindex;
		_datetime = cmd->datetime;
	}

	void Log()
	{
		LOG("--------Receive message: TextLiveHistoryDaylyReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("type = %d", _type);
		LOG("messageid = %lld", _messageid);
		LOG("count = %d", _count);
		LOG("startindex = %d", _startindex);
		LOG("datetime = %d", _datetime);
	}

};


class TeacherComeNotify
{

private:

	int64	_recordzans;


public:

	 inline int64 recordzans() { return _recordzans; } const 
	 inline void set_recordzans(const int64 value) { _recordzans = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherComeNotify); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherComeNotify* cmd = (protocol::tag_CMDTeacherComeNotify*) data;
		cmd->recordzans = _recordzans;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherComeNotify* cmd = (protocol::tag_CMDTeacherComeNotify*) data;
		_recordzans = cmd->recordzans;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherComeNotify---------");
		LOG("recordzans = %lld", _recordzans);
	}

};


class TextRoomLists_mobile
{

private:

	string	_uuid;


public:

	 inline string& uuid() { return _uuid; } const 
	 inline void set_uuid(const string& value) { _uuid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomLists_mobile); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLists_mobile* cmd = (protocol::tag_CMDTextRoomLists_mobile*) data;
		strcpy(cmd->uuid, _uuid.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomLists_mobile* cmd = (protocol::tag_CMDTextRoomLists_mobile*) data;
		_uuid = cmd->uuid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomLists_mobile---------");
		LOG("uuid = %s", _uuid.c_str());
	}

};


class TextRoomViewPHPReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int64	_messageid;
	int64	_businessid;
	uint32	_viewtype;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int64 businessid() { return _businessid; } const 
	 inline void set_businessid(const int64 value) { _businessid = value; }

	 inline uint32 viewtype() { return _viewtype; } const 
	 inline void set_viewtype(const uint32 value) { _viewtype = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewPHPReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewPHPReq* cmd = (protocol::tag_CMDTextRoomViewPHPReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->messageid = _messageid;
		cmd->businessid = _businessid;
		cmd->viewtype = _viewtype;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewPHPReq* cmd = (protocol::tag_CMDTextRoomViewPHPReq*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_messageid = cmd->messageid;
		_businessid = cmd->businessid;
		_viewtype = cmd->viewtype;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewPHPReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("messageid = %lld", _messageid);
		LOG("businessid = %lld", _businessid);
		LOG("viewtype = %d", _viewtype);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomViewPHPResp
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int64	_messageid;
	int64	_businessid;
	uint32	_viewtype;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int64 businessid() { return _businessid; } const 
	 inline void set_businessid(const int64 value) { _businessid = value; }

	 inline uint32 viewtype() { return _viewtype; } const 
	 inline void set_viewtype(const uint32 value) { _viewtype = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomViewPHPResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewPHPResp* cmd = (protocol::tag_CMDTextRoomViewPHPResp*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->messageid = _messageid;
		cmd->businessid = _businessid;
		cmd->viewtype = _viewtype;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomViewPHPResp* cmd = (protocol::tag_CMDTextRoomViewPHPResp*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_messageid = cmd->messageid;
		_businessid = cmd->businessid;
		_viewtype = cmd->viewtype;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomViewPHPResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("messageid = %lld", _messageid);
		LOG("businessid = %lld", _businessid);
		LOG("viewtype = %d", _viewtype);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class BeTeacherReq
{

private:

	uint32	_userid;
	uint32	_teacherid;
	uint32	_vcbid;
	uint32	_opmode;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 opmode() { return _opmode; } const 
	 inline void set_opmode(const uint32 value) { _opmode = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDBeTeacherReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDBeTeacherReq* cmd = (protocol::tag_CMDBeTeacherReq*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->vcbid = _vcbid;
		cmd->opMode = _opmode;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDBeTeacherReq* cmd = (protocol::tag_CMDBeTeacherReq*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_vcbid = cmd->vcbid;
		_opmode = cmd->opMode;
	}

	void Log()
	{
		LOG("--------Receive message: BeTeacherReq---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("vcbid = %d", _vcbid);
		LOG("opmode = %d", _opmode);
	}

};


class BeTeacherResp
{

private:

	uint32	_userid;
	uint32	_result;
	uint64	_nk;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 result() { return _result; } const 
	 inline void set_result(const uint32 value) { _result = value; }

	 inline uint64 nk() { return _nk; } const 
	 inline void set_nk(const uint64 value) { _nk = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDBeTeacherResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDBeTeacherResp* cmd = (protocol::tag_CMDBeTeacherResp*) data;
		cmd->userid = _userid;
		cmd->result = _result;
		cmd->nk = _nk;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDBeTeacherResp* cmd = (protocol::tag_CMDBeTeacherResp*) data;
		_userid = cmd->userid;
		_result = cmd->result;
		_nk = cmd->nk;
	}

	void Log()
	{
		LOG("--------Receive message: BeTeacherResp---------");
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
		LOG("nk = %lld", _nk);
	}

};


class UserPayReq
{

private:

	uint32	_srcid;
	uint32	_dstid;
	uint32	_vcbid;
	uint32	_ispackage;
	uint32	_goodclassid;
	uint32	_type;
	uint32	_num;


public:

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(const uint32 value) { _srcid = value; }

	 inline uint32 dstid() { return _dstid; } const 
	 inline void set_dstid(const uint32 value) { _dstid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 ispackage() { return _ispackage; } const 
	 inline void set_ispackage(const uint32 value) { _ispackage = value; }

	 inline uint32 goodclassid() { return _goodclassid; } const 
	 inline void set_goodclassid(const uint32 value) { _goodclassid = value; }

	 inline uint32 type() { return _type; } const 
	 inline void set_type(const uint32 value) { _type = value; }

	 inline uint32 num() { return _num; } const 
	 inline void set_num(const uint32 value) { _num = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserPayReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserPayReq* cmd = (protocol::tag_CMDUserPayReq*) data;
		cmd->srcid = _srcid;
		cmd->dstid = _dstid;
		cmd->vcbid = _vcbid;
		cmd->isPackage = _ispackage;
		cmd->goodclassid = _goodclassid;
		cmd->type = _type;
		cmd->num = _num;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserPayReq* cmd = (protocol::tag_CMDUserPayReq*) data;
		_srcid = cmd->srcid;
		_dstid = cmd->dstid;
		_vcbid = cmd->vcbid;
		_ispackage = cmd->isPackage;
		_goodclassid = cmd->goodclassid;
		_type = cmd->type;
		_num = cmd->num;
	}

	void Log()
	{
		LOG("--------Receive message: UserPayReq---------");
		LOG("srcid = %d", _srcid);
		LOG("dstid = %d", _dstid);
		LOG("vcbid = %d", _vcbid);
		LOG("ispackage = %d", _ispackage);
		LOG("goodclassid = %d", _goodclassid);
		LOG("type = %d", _type);
		LOG("num = %d", _num);
	}

};


class UserPayResp
{

private:

	uint32	_userid;
	uint64	_nk;
	uint32	_errid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint64 nk() { return _nk; } const 
	 inline void set_nk(const uint64 value) { _nk = value; }

	 inline uint32 errid() { return _errid; } const 
	 inline void set_errid(const uint32 value) { _errid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserPayResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserPayResp* cmd = (protocol::tag_CMDUserPayResp*) data;
		cmd->userid = _userid;
		cmd->nk = _nk;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserPayResp* cmd = (protocol::tag_CMDUserPayResp*) data;
		_userid = cmd->userid;
		_nk = cmd->nk;
		_errid = cmd->errid;
	}

	void Log()
	{
		LOG("--------Receive message: UserPayResp---------");
		LOG("userid = %d", _userid);
		LOG("nk = %lld", _nk);
		LOG("errid = %d", _errid);
	}

};


class GetUserAccountBalanceReq
{

private:

	uint32	_userid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetUserAccountBalanceReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetUserAccountBalanceReq* cmd = (protocol::tag_CMDGetUserAccountBalanceReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetUserAccountBalanceReq* cmd = (protocol::tag_CMDGetUserAccountBalanceReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: GetUserAccountBalanceReq---------");
		LOG("userid = %d", _userid);
	}

};


class GetUserAccountBalanceResp
{

private:

	uint32	_userid;
	uint64	_nk;
	uint32	_errid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint64 nk() { return _nk; } const 
	 inline void set_nk(const uint64 value) { _nk = value; }

	 inline uint32 errid() { return _errid; } const 
	 inline void set_errid(const uint32 value) { _errid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetUserAccountBalanceResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetUserAccountBalanceResp* cmd = (protocol::tag_CMDGetUserAccountBalanceResp*) data;
		cmd->userid = _userid;
		cmd->nk = _nk;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetUserAccountBalanceResp* cmd = (protocol::tag_CMDGetUserAccountBalanceResp*) data;
		_userid = cmd->userid;
		_nk = cmd->nk;
		_errid = cmd->errid;
	}

	void Log()
	{
		LOG("--------Receive message: GetUserAccountBalanceResp---------");
		LOG("userid = %d", _userid);
		LOG("nk = %lld", _nk);
		LOG("errid = %d", _errid);
	}

};


class TextRoomEmoticonListResp
{

private:

	uint32	_emoticonid;
	string	_emoticonname;
	int32	_prices;
	uint32	_buyflag;


public:

	 inline uint32 emoticonid() { return _emoticonid; } const 
	 inline void set_emoticonid(const uint32 value) { _emoticonid = value; }

	 inline string& emoticonname() { return _emoticonname; } const 
	 inline void set_emoticonname(const string& value) { _emoticonname = value; }

	 inline int32 prices() { return _prices; } const 
	 inline void set_prices(const int32 value) { _prices = value; }

	 inline uint32 buyflag() { return _buyflag; } const 
	 inline void set_buyflag(const uint32 value) { _buyflag = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomEmoticonListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomEmoticonListResp* cmd = (protocol::tag_CMDTextRoomEmoticonListResp*) data;
		cmd->emoticonID = _emoticonid;
		strcpy(cmd->emoticonName, _emoticonname.c_str());
		cmd->prices = _prices;
		cmd->buyflag = _buyflag;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomEmoticonListResp* cmd = (protocol::tag_CMDTextRoomEmoticonListResp*) data;
		_emoticonid = cmd->emoticonID;
		_emoticonname = cmd->emoticonName;
		_prices = cmd->prices;
		_buyflag = cmd->buyflag;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomEmoticonListResp---------");
		LOG("emoticonid = %d", _emoticonid);
		LOG("emoticonname = %s", _emoticonname.c_str());
		LOG("prices = %d", _prices);
		LOG("buyflag = %d", _buyflag);
	}

};


class TextRoomSecretsTotalReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomSecretsTotalReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsTotalReq* cmd = (protocol::tag_CMDTextRoomSecretsTotalReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsTotalReq* cmd = (protocol::tag_CMDTextRoomSecretsTotalReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomSecretsTotalReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
	}

};


class TextRoomSecretsTotalResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_secretsnum;
	int32	_ownsnum;
	uint32	_bstudent;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 secretsnum() { return _secretsnum; } const 
	 inline void set_secretsnum(const int32 value) { _secretsnum = value; }

	 inline int32 ownsnum() { return _ownsnum; } const 
	 inline void set_ownsnum(const int32 value) { _ownsnum = value; }

	 inline uint32 bstudent() { return _bstudent; } const 
	 inline void set_bstudent(const uint32 value) { _bstudent = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomSecretsTotalResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsTotalResp* cmd = (protocol::tag_CMDTextRoomSecretsTotalResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->secretsnum = _secretsnum;
		cmd->ownsnum = _ownsnum;
		cmd->bStudent = _bstudent;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsTotalResp* cmd = (protocol::tag_CMDTextRoomSecretsTotalResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_secretsnum = cmd->secretsnum;
		_ownsnum = cmd->ownsnum;
		_bstudent = cmd->bStudent;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomSecretsTotalResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("secretsnum = %d", _secretsnum);
		LOG("ownsnum = %d", _ownsnum);
		LOG("bstudent = %d", _bstudent);
	}

};


class TextRoomListHead
{

private:

	string	_uuid;
	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;


public:

	 inline string& uuid() { return _uuid; } const 
	 inline void set_uuid(const string& value) { _uuid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomListHead); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomListHead* cmd = (protocol::tag_CMDTextRoomListHead*) data;
		strcpy(cmd->uuid, _uuid.c_str());
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomListHead* cmd = (protocol::tag_CMDTextRoomListHead*) data;
		_uuid = cmd->uuid;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomListHead---------");
		LOG("uuid = %s", _uuid.c_str());
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
	}

};


class TextRoomSecretsListResp
{

private:

	int32	_secretsid;
	int32	_coverlittlelen;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	int32	_buynums;
	int32	_prices;
	uint32	_buyflag;
	int32	_goodsid;
	string	_content;


public:

	 inline int32 secretsid() { return _secretsid; } const 
	 inline void set_secretsid(const int32 value) { _secretsid = value; }

	 inline int32 coverlittlelen() { return _coverlittlelen; } const 
	 inline void set_coverlittlelen(const int32 value) { _coverlittlelen = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline int32 buynums() { return _buynums; } const 
	 inline void set_buynums(const int32 value) { _buynums = value; }

	 inline int32 prices() { return _prices; } const 
	 inline void set_prices(const int32 value) { _prices = value; }

	 inline uint32 buyflag() { return _buyflag; } const 
	 inline void set_buyflag(const uint32 value) { _buyflag = value; }

	 inline int32 goodsid() { return _goodsid; } const 
	 inline void set_goodsid(const int32 value) { _goodsid = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomSecretsListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsListResp* cmd = (protocol::tag_CMDTextRoomSecretsListResp*) data;
		cmd->secretsid = _secretsid;
		cmd->coverlittlelen = _coverlittlelen;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->buynums = _buynums;
		cmd->prices = _prices;
		cmd->buyflag = _buyflag;
		cmd->goodsid = _goodsid;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsListResp* cmd = (protocol::tag_CMDTextRoomSecretsListResp*) data;
		_secretsid = cmd->secretsid;
		_coverlittlelen = cmd->coverlittlelen;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_buynums = cmd->buynums;
		_prices = cmd->prices;
		_buyflag = cmd->buyflag;
		_goodsid = cmd->goodsid;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomSecretsListResp---------");
		LOG("secretsid = %d", _secretsid);
		LOG("coverlittlelen = %d", _coverlittlelen);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("buynums = %d", _buynums);
		LOG("prices = %d", _prices);
		LOG("buyflag = %d", _buyflag);
		LOG("goodsid = %d", _goodsid);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomBuySecretsReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_teacherid;
	int32	_secretsid;
	int32	_goodsid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 secretsid() { return _secretsid; } const 
	 inline void set_secretsid(const int32 value) { _secretsid = value; }

	 inline int32 goodsid() { return _goodsid; } const 
	 inline void set_goodsid(const int32 value) { _goodsid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomBuySecretsReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomBuySecretsReq* cmd = (protocol::tag_CMDTextRoomBuySecretsReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->secretsid = _secretsid;
		cmd->goodsid = _goodsid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomBuySecretsReq* cmd = (protocol::tag_CMDTextRoomBuySecretsReq*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_secretsid = cmd->secretsid;
		_goodsid = cmd->goodsid;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomBuySecretsReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("secretsid = %d", _secretsid);
		LOG("goodsid = %d", _goodsid);
	}

};


class TextRoomBuySecretsResp
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_secretsid;
	int32	_result;
	uint64	_nk99;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 secretsid() { return _secretsid; } const 
	 inline void set_secretsid(const int32 value) { _secretsid = value; }

	 inline int32 result() { return _result; } const 
	 inline void set_result(const int32 value) { _result = value; }

	 inline uint64 nk99() { return _nk99; } const 
	 inline void set_nk99(const uint64 value) { _nk99 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomBuySecretsResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomBuySecretsResp* cmd = (protocol::tag_CMDTextRoomBuySecretsResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->secretsid = _secretsid;
		cmd->result = _result;
		cmd->nk99 = _nk99;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomBuySecretsResp* cmd = (protocol::tag_CMDTextRoomBuySecretsResp*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_secretsid = cmd->secretsid;
		_result = cmd->result;
		_nk99 = cmd->nk99;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomBuySecretsResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("secretsid = %d", _secretsid);
		LOG("result = %d", _result);
		LOG("nk99 = %lld", _nk99);
	}

};


class TextRoomSecretsPHPReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int64	_messageid;
	int32	_businessid;
	uint32	_viewtype;
	int32	_coverlittlelen;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	int32	_prices;
	int32	_goodsid;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 businessid() { return _businessid; } const 
	 inline void set_businessid(const int32 value) { _businessid = value; }

	 inline uint32 viewtype() { return _viewtype; } const 
	 inline void set_viewtype(const uint32 value) { _viewtype = value; }

	 inline int32 coverlittlelen() { return _coverlittlelen; } const 
	 inline void set_coverlittlelen(const int32 value) { _coverlittlelen = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline int32 prices() { return _prices; } const 
	 inline void set_prices(const int32 value) { _prices = value; }

	 inline int32 goodsid() { return _goodsid; } const 
	 inline void set_goodsid(const int32 value) { _goodsid = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomSecretsPHPReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsPHPReq* cmd = (protocol::tag_CMDTextRoomSecretsPHPReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->messageid = _messageid;
		cmd->businessid = _businessid;
		cmd->viewtype = _viewtype;
		cmd->coverlittlelen = _coverlittlelen;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		cmd->prices = _prices;
		cmd->goodsid = _goodsid;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsPHPReq* cmd = (protocol::tag_CMDTextRoomSecretsPHPReq*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_messageid = cmd->messageid;
		_businessid = cmd->businessid;
		_viewtype = cmd->viewtype;
		_coverlittlelen = cmd->coverlittlelen;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_prices = cmd->prices;
		_goodsid = cmd->goodsid;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomSecretsPHPReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("messageid = %lld", _messageid);
		LOG("businessid = %d", _businessid);
		LOG("viewtype = %d", _viewtype);
		LOG("coverlittlelen = %d", _coverlittlelen);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("prices = %d", _prices);
		LOG("goodsid = %d", _goodsid);
		LOG("content = %s", _content.c_str());
	}

};


class TextRoomSecretsPHPResp
{

private:

	uint32	_vcbid;
	uint32	_teacherid;
	int64	_messageid;
	int32	_businessid;
	uint32	_viewtype;
	int32	_coverlittlelen;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	uint32	_commentstype;
	int32	_prices;
	int32	_goodsid;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int64 messageid() { return _messageid; } const 
	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 businessid() { return _businessid; } const 
	 inline void set_businessid(const int32 value) { _businessid = value; }

	 inline uint32 viewtype() { return _viewtype; } const 
	 inline void set_viewtype(const uint32 value) { _viewtype = value; }

	 inline int32 coverlittlelen() { return _coverlittlelen; } const 
	 inline void set_coverlittlelen(const int32 value) { _coverlittlelen = value; }

	 inline int32 titlelen() { return _titlelen; } const 
	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 
	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 
	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline int32 prices() { return _prices; } const 
	 inline void set_prices(const int32 value) { _prices = value; }

	 inline int32 goodsid() { return _goodsid; } const 
	 inline void set_goodsid(const int32 value) { _goodsid = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextRoomSecretsPHPResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsPHPResp* cmd = (protocol::tag_CMDTextRoomSecretsPHPResp*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->messageid = _messageid;
		cmd->businessid = _businessid;
		cmd->viewtype = _viewtype;
		cmd->coverlittlelen = _coverlittlelen;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		cmd->prices = _prices;
		cmd->goodsid = _goodsid;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextRoomSecretsPHPResp* cmd = (protocol::tag_CMDTextRoomSecretsPHPResp*) data;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
		_messageid = cmd->messageid;
		_businessid = cmd->businessid;
		_viewtype = cmd->viewtype;
		_coverlittlelen = cmd->coverlittlelen;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_prices = cmd->prices;
		_goodsid = cmd->goodsid;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextRoomSecretsPHPResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
		LOG("messageid = %lld", _messageid);
		LOG("businessid = %d", _businessid);
		LOG("viewtype = %d", _viewtype);
		LOG("coverlittlelen = %d", _coverlittlelen);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("prices = %d", _prices);
		LOG("goodsid = %d", _goodsid);
		LOG("content = %s", _content.c_str());
	}

};


class GetPackagePrivilegeReq
{

private:

	uint32	_userid;
	uint32	_packagenum;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 packagenum() { return _packagenum; } const 
	 inline void set_packagenum(const uint32 value) { _packagenum = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetPackagePrivilegeReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetPackagePrivilegeReq* cmd = (protocol::tag_CMDGetPackagePrivilegeReq*) data;
		cmd->userid = _userid;
		cmd->packageNum = _packagenum;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetPackagePrivilegeReq* cmd = (protocol::tag_CMDGetPackagePrivilegeReq*) data;
		_userid = cmd->userid;
		_packagenum = cmd->packageNum;
	}

	void Log()
	{
		LOG("--------Receive message: GetPackagePrivilegeReq---------");
		LOG("userid = %d", _userid);
		LOG("packagenum = %d", _packagenum);
	}

};


class GetPackagePrivilegeResp
{

private:

	uint32	_userid;
	uint32	_index;
	string	_privilege;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 index() { return _index; } const 
	 inline void set_index(const uint32 value) { _index = value; }

	 inline string& privilege() { return _privilege; } const 
	 inline void set_privilege(const string& value) { _privilege = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetPackagePrivilegeResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetPackagePrivilegeResp* cmd = (protocol::tag_CMDGetPackagePrivilegeResp*) data;
		cmd->userid = _userid;
		cmd->index = _index;
		strcpy(cmd->privilege, _privilege.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetPackagePrivilegeResp* cmd = (protocol::tag_CMDGetPackagePrivilegeResp*) data;
		_userid = cmd->userid;
		_index = cmd->index;
		_privilege = cmd->privilege;
	}

	void Log()
	{
		LOG("--------Receive message: GetPackagePrivilegeResp---------");
		LOG("userid = %d", _userid);
		LOG("index = %d", _index);
		LOG("privilege = %s", _privilege.c_str());
	}

};


class VideoRoomOnMicClientResp
{

private:

	uint32	_userid;
	string	_useralias;
	uint32	_roomid;
	string	_roomname;
	uint32	_state;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& useralias() { return _useralias; } const 
	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline string& roomname() { return _roomname; } const 
	 inline void set_roomname(const string& value) { _roomname = value; }

	 inline uint32 state() { return _state; } const 
	 inline void set_state(const uint32 value) { _state = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDVideoRoomOnMicClientResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDVideoRoomOnMicClientResp* cmd = (protocol::tag_CMDVideoRoomOnMicClientResp*) data;
		cmd->userid = _userid;
		strcpy(cmd->useralias, _useralias.c_str());
		cmd->roomid = _roomid;
		strcpy(cmd->roomName, _roomname.c_str());
		cmd->state = _state;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDVideoRoomOnMicClientResp* cmd = (protocol::tag_CMDVideoRoomOnMicClientResp*) data;
		_userid = cmd->userid;
		_useralias = cmd->useralias;
		_roomid = cmd->roomid;
		_roomname = cmd->roomName;
		_state = cmd->state;
	}

	void Log()
	{
		LOG("--------Receive message: VideoRoomOnMicClientResp---------");
		LOG("userid = %d", _userid);
		LOG("useralias = %s", _useralias.c_str());
		LOG("roomid = %d", _roomid);
		LOG("roomname = %s", _roomname.c_str());
		LOG("state = %d", _state);
	}

};


class GetBeTeacherInfoReq
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_teacherid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetBeTeacherInfoReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetBeTeacherInfoReq* cmd = (protocol::tag_CMDGetBeTeacherInfoReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetBeTeacherInfoReq* cmd = (protocol::tag_CMDGetBeTeacherInfoReq*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: GetBeTeacherInfoReq---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("teacherid = %d", _teacherid);
	}

};


class NormalUserGetBeTeacherInfoRespHead
{

private:

	int32	_userid;
	int32	_price_30;
	int32	_price_90;
	uint32	_teacherid;
	uint32	_cstudent;
	uint32	_bstudent;


public:

	 inline int32 userid() { return _userid; } const 
	 inline void set_userid(const int32 value) { _userid = value; }

	 inline int32 price_30() { return _price_30; } const 
	 inline void set_price_30(const int32 value) { _price_30 = value; }

	 inline int32 price_90() { return _price_90; } const 
	 inline void set_price_90(const int32 value) { _price_90 = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 cstudent() { return _cstudent; } const 
	 inline void set_cstudent(const uint32 value) { _cstudent = value; }

	 inline uint32 bstudent() { return _bstudent; } const 
	 inline void set_bstudent(const uint32 value) { _bstudent = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDNormalUserGetBeTeacherInfoRespHead); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDNormalUserGetBeTeacherInfoRespHead* cmd = (protocol::tag_CMDNormalUserGetBeTeacherInfoRespHead*) data;
		cmd->userid = _userid;
		cmd->price_30 = _price_30;
		cmd->price_90 = _price_90;
		cmd->teacherid = _teacherid;
		cmd->cStudent = _cstudent;
		cmd->bStudent = _bstudent;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDNormalUserGetBeTeacherInfoRespHead* cmd = (protocol::tag_CMDNormalUserGetBeTeacherInfoRespHead*) data;
		_userid = cmd->userid;
		_price_30 = cmd->price_30;
		_price_90 = cmd->price_90;
		_teacherid = cmd->teacherid;
		_cstudent = cmd->cStudent;
		_bstudent = cmd->bStudent;
	}

	void Log()
	{
		LOG("--------Receive message: NormalUserGetBeTeacherInfoRespHead---------");
		LOG("userid = %d", _userid);
		LOG("price_30 = %d", _price_30);
		LOG("price_90 = %d", _price_90);
		LOG("teacherid = %d", _teacherid);
		LOG("cstudent = %d", _cstudent);
		LOG("bstudent = %d", _bstudent);
	}

};


class NormalUserGetBeTeacherInfoRespItem
{

private:

	int32	_nuserid;
	uint64	_starttime;
	uint64	_effecttime;
	int32	_teacherid;
	string	_teacheralias;
	int32	_cquery;
	int32	_cviewflowers;


public:

	 inline int32 nuserid() { return _nuserid; } const 
	 inline void set_nuserid(const int32 value) { _nuserid = value; }

	 inline uint64 starttime() { return _starttime; } const 
	 inline void set_starttime(const uint64 value) { _starttime = value; }

	 inline uint64 effecttime() { return _effecttime; } const 
	 inline void set_effecttime(const uint64 value) { _effecttime = value; }

	 inline int32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(const int32 value) { _teacherid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 
	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline int32 cquery() { return _cquery; } const 
	 inline void set_cquery(const int32 value) { _cquery = value; }

	 inline int32 cviewflowers() { return _cviewflowers; } const 
	 inline void set_cviewflowers(const int32 value) { _cviewflowers = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDNormalUserGetBeTeacherInfoRespItem); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDNormalUserGetBeTeacherInfoRespItem* cmd = (protocol::tag_CMDNormalUserGetBeTeacherInfoRespItem*) data;
		cmd->nuserid = _nuserid;
		cmd->starttime = _starttime;
		cmd->effecttime = _effecttime;
		cmd->teacherid = _teacherid;
		strcpy(cmd->teacherAlias, _teacheralias.c_str());
		cmd->cQuery = _cquery;
		cmd->cViewFlowers = _cviewflowers;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDNormalUserGetBeTeacherInfoRespItem* cmd = (protocol::tag_CMDNormalUserGetBeTeacherInfoRespItem*) data;
		_nuserid = cmd->nuserid;
		_starttime = cmd->starttime;
		_effecttime = cmd->effecttime;
		_teacherid = cmd->teacherid;
		_teacheralias = cmd->teacherAlias;
		_cquery = cmd->cQuery;
		_cviewflowers = cmd->cViewFlowers;
	}

	void Log()
	{
		LOG("--------Receive message: NormalUserGetBeTeacherInfoRespItem---------");
		LOG("nuserid = %d", _nuserid);
		LOG("starttime = %lld", _starttime);
		LOG("effecttime = %lld", _effecttime);
		LOG("teacherid = %d", _teacherid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("cquery = %d", _cquery);
		LOG("cviewflowers = %d", _cviewflowers);
	}

};


class TeacherGetBeTeacherInfoRespHead
{

private:

	int32	_userid;
	int32	_price_30;
	int32	_price_90;


public:

	 inline int32 userid() { return _userid; } const 
	 inline void set_userid(const int32 value) { _userid = value; }

	 inline int32 price_30() { return _price_30; } const 
	 inline void set_price_30(const int32 value) { _price_30 = value; }

	 inline int32 price_90() { return _price_90; } const 
	 inline void set_price_90(const int32 value) { _price_90 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherGetBeTeacherInfoRespHead); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGetBeTeacherInfoRespHead* cmd = (protocol::tag_CMDTeacherGetBeTeacherInfoRespHead*) data;
		cmd->userid = _userid;
		cmd->price_30 = _price_30;
		cmd->price_90 = _price_90;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGetBeTeacherInfoRespHead* cmd = (protocol::tag_CMDTeacherGetBeTeacherInfoRespHead*) data;
		_userid = cmd->userid;
		_price_30 = cmd->price_30;
		_price_90 = cmd->price_90;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherGetBeTeacherInfoRespHead---------");
		LOG("userid = %d", _userid);
		LOG("price_30 = %d", _price_30);
		LOG("price_90 = %d", _price_90);
	}

};


class TeacherGetBeTeacherInfoRespItem
{

private:

	int32	_nuserid;
	uint64	_starttime;
	uint64	_effecttime;
	int32	_studentid;
	string	_studentalias;


public:

	 inline int32 nuserid() { return _nuserid; } const 
	 inline void set_nuserid(const int32 value) { _nuserid = value; }

	 inline uint64 starttime() { return _starttime; } const 
	 inline void set_starttime(const uint64 value) { _starttime = value; }

	 inline uint64 effecttime() { return _effecttime; } const 
	 inline void set_effecttime(const uint64 value) { _effecttime = value; }

	 inline int32 studentid() { return _studentid; } const 
	 inline void set_studentid(const int32 value) { _studentid = value; }

	 inline string& studentalias() { return _studentalias; } const 
	 inline void set_studentalias(const string& value) { _studentalias = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherGetBeTeacherInfoRespItem); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGetBeTeacherInfoRespItem* cmd = (protocol::tag_CMDTeacherGetBeTeacherInfoRespItem*) data;
		cmd->nuserid = _nuserid;
		cmd->starttime = _starttime;
		cmd->effecttime = _effecttime;
		cmd->studentid = _studentid;
		strcpy(cmd->studentAlias, _studentalias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherGetBeTeacherInfoRespItem* cmd = (protocol::tag_CMDTeacherGetBeTeacherInfoRespItem*) data;
		_nuserid = cmd->nuserid;
		_starttime = cmd->starttime;
		_effecttime = cmd->effecttime;
		_studentid = cmd->studentid;
		_studentalias = cmd->studentAlias;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherGetBeTeacherInfoRespItem---------");
		LOG("nuserid = %d", _nuserid);
		LOG("starttime = %lld", _starttime);
		LOG("effecttime = %lld", _effecttime);
		LOG("studentid = %d", _studentid);
		LOG("studentalias = %s", _studentalias.c_str());
	}

};







#endif
