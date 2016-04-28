#ifndef __LOGIN_MESSAGE_H__
#define __LOGIN_MESSAGE_H__



#include <string>
#include "Log.h"
#include "login_cmd_vchat.h"
using std::string;


class UserLogonReq
{

private:

	uint32	_userid;
	uint32	_nversion;
	uint32	_nmask;
	string	_cuserpwd;
	string	_cserial;
	string	_cmacaddr;
	uint32	_nimstate;
	uint32	_nmobile;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 nversion() { return _nversion; } const 

	 inline void set_nversion(const uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 

	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 

	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 

	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 

	 inline void set_nimstate(const uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 

	 inline void set_nmobile(const uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq* cmd = (protocol::tag_CMDUserLogonReq*) data;
		cmd->userid = _userid;
		cmd->nversion = _nversion;
		cmd->nmask = _nmask;
		strcpy(cmd->cuserpwd, _cuserpwd.c_str());
		strcpy(cmd->cSerial, _cserial.c_str());
		strcpy(cmd->cMacAddr, _cmacaddr.c_str());
		cmd->nimstate = _nimstate;
		cmd->nmobile = _nmobile;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq* cmd = (protocol::tag_CMDUserLogonReq*) data;
		_userid = cmd->userid;
		_nversion = cmd->nversion;
		_nmask = cmd->nmask;
		_cuserpwd = cmd->cuserpwd;
		_cserial = cmd->cSerial;
		_cmacaddr = cmd->cMacAddr;
		_nimstate = cmd->nimstate;
		_nmobile = cmd->nmobile;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonReq---------");
		LOG("userid = %d", _userid);
		LOG("nversion = %d", _nversion);
		LOG("nmask = %d", _nmask);
		LOG("cuserpwd = %s", _cuserpwd.c_str());
		LOG("cserial = %s", _cserial.c_str());
		LOG("cmacaddr = %s", _cmacaddr.c_str());
		LOG("nimstate = %d", _nimstate);
		LOG("nmobile = %d", _nmobile);
	}

};


class UserLogonReq2
{

private:

	uint32	_userid;
	uint32	_nversion;
	uint32	_nmask;
	string	_cuserpwd;
	string	_cserial;
	string	_cmacaddr;
	string	_cipaddr;
	uint32	_nimstate;
	uint32	_nmobile;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 nversion() { return _nversion; } const 

	 inline void set_nversion(const uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 

	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 

	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 

	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 

	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 

	 inline void set_nimstate(const uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 

	 inline void set_nmobile(const uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonReq2); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq2* cmd = (protocol::tag_CMDUserLogonReq2*) data;
		cmd->userid = _userid;
		cmd->nversion = _nversion;
		cmd->nmask = _nmask;
		strcpy(cmd->cuserpwd, _cuserpwd.c_str());
		strcpy(cmd->cSerial, _cserial.c_str());
		strcpy(cmd->cMacAddr, _cmacaddr.c_str());
		strcpy(cmd->cIpAddr, _cipaddr.c_str());
		cmd->nimstate = _nimstate;
		cmd->nmobile = _nmobile;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq2* cmd = (protocol::tag_CMDUserLogonReq2*) data;
		_userid = cmd->userid;
		_nversion = cmd->nversion;
		_nmask = cmd->nmask;
		_cuserpwd = cmd->cuserpwd;
		_cserial = cmd->cSerial;
		_cmacaddr = cmd->cMacAddr;
		_cipaddr = cmd->cIpAddr;
		_nimstate = cmd->nimstate;
		_nmobile = cmd->nmobile;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonReq2---------");
		LOG("userid = %d", _userid);
		LOG("nversion = %d", _nversion);
		LOG("nmask = %d", _nmask);
		LOG("cuserpwd = %s", _cuserpwd.c_str());
		LOG("cserial = %s", _cserial.c_str());
		LOG("cmacaddr = %s", _cmacaddr.c_str());
		LOG("cipaddr = %s", _cipaddr.c_str());
		LOG("nimstate = %d", _nimstate);
		LOG("nmobile = %d", _nmobile);
	}

};


class UserLogonReq3
{

private:

	uint32	_userid;
	uint32	_nversion;
	uint32	_nmask;
	string	_cuserpwd;
	string	_cserial;
	string	_cmacaddr;
	string	_cipaddr;
	uint32	_nimstate;
	uint32	_nmobile;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 nversion() { return _nversion; } const 

	 inline void set_nversion(const uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 

	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 

	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 

	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 

	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 

	 inline void set_nimstate(const uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 

	 inline void set_nmobile(const uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonReq3); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq3* cmd = (protocol::tag_CMDUserLogonReq3*) data;
		cmd->userid = _userid;
		cmd->nversion = _nversion;
		cmd->nmask = _nmask;
		strcpy(cmd->cuserpwd, _cuserpwd.c_str());
		strcpy(cmd->cSerial, _cserial.c_str());
		strcpy(cmd->cMacAddr, _cmacaddr.c_str());
		strcpy(cmd->cIpAddr, _cipaddr.c_str());
		cmd->nimstate = _nimstate;
		cmd->nmobile = _nmobile;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq3* cmd = (protocol::tag_CMDUserLogonReq3*) data;
		_userid = cmd->userid;
		_nversion = cmd->nversion;
		_nmask = cmd->nmask;
		_cuserpwd = cmd->cuserpwd;
		_cserial = cmd->cSerial;
		_cmacaddr = cmd->cMacAddr;
		_cipaddr = cmd->cIpAddr;
		_nimstate = cmd->nimstate;
		_nmobile = cmd->nmobile;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonReq3---------");
		LOG("userid = %d", _userid);
		LOG("nversion = %d", _nversion);
		LOG("nmask = %d", _nmask);
		LOG("cuserpwd = %s", _cuserpwd.c_str());
		LOG("cserial = %s", _cserial.c_str());
		LOG("cmacaddr = %s", _cmacaddr.c_str());
		LOG("cipaddr = %s", _cipaddr.c_str());
		LOG("nimstate = %d", _nimstate);
		LOG("nmobile = %d", _nmobile);
	}

};


class UserLogonReq4
{

private:

	uint32	_nmessageid;
	string	_cloginid;
	uint32	_nversion;
	uint32	_nmask;
	string	_cuserpwd;
	string	_cserial;
	string	_cmacaddr;
	string	_cipaddr;
	uint32	_nimstate;
	uint32	_nmobile;


public:

	 inline uint32 nmessageid() { return _nmessageid; } const 

	 inline void set_nmessageid(const uint32 value) { _nmessageid = value; }

	 inline string& cloginid() { return _cloginid; } const 

	 inline void set_cloginid(const string& value) { _cloginid = value; }

	 inline uint32 nversion() { return _nversion; } const 

	 inline void set_nversion(const uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 

	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 

	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 

	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 

	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 

	 inline void set_nimstate(const uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 

	 inline void set_nmobile(const uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonReq4); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq4* cmd = (protocol::tag_CMDUserLogonReq4*) data;
		cmd->nmessageid = _nmessageid;
		strcpy(cmd->cloginid, _cloginid.c_str());
		cmd->nversion = _nversion;
		cmd->nmask = _nmask;
		strcpy(cmd->cuserpwd, _cuserpwd.c_str());
		strcpy(cmd->cSerial, _cserial.c_str());
		strcpy(cmd->cMacAddr, _cmacaddr.c_str());
		strcpy(cmd->cIpAddr, _cipaddr.c_str());
		cmd->nimstate = _nimstate;
		cmd->nmobile = _nmobile;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq4* cmd = (protocol::tag_CMDUserLogonReq4*) data;
		_nmessageid = cmd->nmessageid;
		_cloginid = cmd->cloginid;
		_nversion = cmd->nversion;
		_nmask = cmd->nmask;
		_cuserpwd = cmd->cuserpwd;
		_cserial = cmd->cSerial;
		_cmacaddr = cmd->cMacAddr;
		_cipaddr = cmd->cIpAddr;
		_nimstate = cmd->nimstate;
		_nmobile = cmd->nmobile;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonReq4---------");
		LOG("nmessageid = %d", _nmessageid);
		LOG("cloginid = %s", _cloginid.c_str());
		LOG("nversion = %d", _nversion);
		LOG("nmask = %d", _nmask);
		LOG("cuserpwd = %s", _cuserpwd.c_str());
		LOG("cserial = %s", _cserial.c_str());
		LOG("cmacaddr = %s", _cmacaddr.c_str());
		LOG("cipaddr = %s", _cipaddr.c_str());
		LOG("nimstate = %d", _nimstate);
		LOG("nmobile = %d", _nmobile);
	}

};


class UserLogonReq5
{

private:

	uint32	_nmessageid;
	uint32	_userid;
	string	_openid;
	string	_opentoken;
	uint32	_platformtype;
	uint32	_nversion;
	uint32	_nmask;
	string	_cserial;
	string	_cmacaddr;
	string	_cipaddr;
	uint32	_nimstate;
	uint32	_nmobile;


public:

	 inline uint32 nmessageid() { return _nmessageid; } const 

	 inline void set_nmessageid(const uint32 value) { _nmessageid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& openid() { return _openid; } const 

	 inline void set_openid(const string& value) { _openid = value; }

	 inline string& opentoken() { return _opentoken; } const 

	 inline void set_opentoken(const string& value) { _opentoken = value; }

	 inline uint32 platformtype() { return _platformtype; } const 

	 inline void set_platformtype(const uint32 value) { _platformtype = value; }

	 inline uint32 nversion() { return _nversion; } const 

	 inline void set_nversion(const uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline string& cserial() { return _cserial; } const 

	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 

	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 

	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 

	 inline void set_nimstate(const uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 

	 inline void set_nmobile(const uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonReq5); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq5* cmd = (protocol::tag_CMDUserLogonReq5*) data;
		cmd->nmessageid = _nmessageid;
		cmd->userid = _userid;
		strcpy(cmd->openid, _openid.c_str());
		strcpy(cmd->opentoken, _opentoken.c_str());
		cmd->platformType = _platformtype;
		cmd->nversion = _nversion;
		cmd->nmask = _nmask;
		strcpy(cmd->cSerial, _cserial.c_str());
		strcpy(cmd->cMacAddr, _cmacaddr.c_str());
		strcpy(cmd->cIpAddr, _cipaddr.c_str());
		cmd->nimstate = _nimstate;
		cmd->nmobile = _nmobile;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonReq5* cmd = (protocol::tag_CMDUserLogonReq5*) data;
		_nmessageid = cmd->nmessageid;
		_userid = cmd->userid;
		_openid = cmd->openid;
		_opentoken = cmd->opentoken;
		_platformtype = cmd->platformType;
		_nversion = cmd->nversion;
		_nmask = cmd->nmask;
		_cserial = cmd->cSerial;
		_cmacaddr = cmd->cMacAddr;
		_cipaddr = cmd->cIpAddr;
		_nimstate = cmd->nimstate;
		_nmobile = cmd->nmobile;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonReq5---------");
		LOG("nmessageid = %d", _nmessageid);
		LOG("userid = %d", _userid);
		LOG("openid = %s", _openid.c_str());
		LOG("opentoken = %s", _opentoken.c_str());
		LOG("platformtype = %d", _platformtype);
		LOG("nversion = %d", _nversion);
		LOG("nmask = %d", _nmask);
		LOG("cserial = %s", _cserial.c_str());
		LOG("cmacaddr = %s", _cmacaddr.c_str());
		LOG("cipaddr = %s", _cipaddr.c_str());
		LOG("nimstate = %d", _nimstate);
		LOG("nmobile = %d", _nmobile);
	}

};


class UserLogonErr
{

private:

	uint32	_errid;
	uint32	_data1;
	uint32	_data2;


public:

	 inline uint32 errid() { return _errid; } const 

	 inline void set_errid(const uint32 value) { _errid = value; }

	 inline uint32 data1() { return _data1; } const 

	 inline void set_data1(const uint32 value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 

	 inline void set_data2(const uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonErr); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonErr* cmd = (protocol::tag_CMDUserLogonErr*) data;
		cmd->errid = _errid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonErr* cmd = (protocol::tag_CMDUserLogonErr*) data;
		_errid = cmd->errid;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonErr---------");
		LOG("errid = %d", _errid);
		LOG("data1 = %d", _data1);
		LOG("data2 = %d", _data2);
	}

};


class UserLogonErr2
{

private:

	uint32	_nmessageid;
	uint32	_errid;
	uint32	_data1;
	uint32	_data2;


public:

	 inline uint32 nmessageid() { return _nmessageid; } const 

	 inline void set_nmessageid(const uint32 value) { _nmessageid = value; }

	 inline uint32 errid() { return _errid; } const 

	 inline void set_errid(const uint32 value) { _errid = value; }

	 inline uint32 data1() { return _data1; } const 

	 inline void set_data1(const uint32 value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 

	 inline void set_data2(const uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonErr2); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonErr2* cmd = (protocol::tag_CMDUserLogonErr2*) data;
		cmd->nmessageid = _nmessageid;
		cmd->errid = _errid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonErr2* cmd = (protocol::tag_CMDUserLogonErr2*) data;
		_nmessageid = cmd->nmessageid;
		_errid = cmd->errid;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonErr2---------");
		LOG("nmessageid = %d", _nmessageid);
		LOG("errid = %d", _errid);
		LOG("data1 = %d", _data1);
		LOG("data2 = %d", _data2);
	}

};


class UserQuanxianInfo
{

private:

	uint32	_qxid;
	uint32	_qxtype;
	uint32	_srclevel;
	uint32	_tolevel;


public:

	 inline uint32 qxid() { return _qxid; } const 

	 inline void set_qxid(const uint32 value) { _qxid = value; }

	 inline uint32 qxtype() { return _qxtype; } const 

	 inline void set_qxtype(const uint32 value) { _qxtype = value; }

	 inline uint32 srclevel() { return _srclevel; } const 

	 inline void set_srclevel(const uint32 value) { _srclevel = value; }

	 inline uint32 tolevel() { return _tolevel; } const 

	 inline void set_tolevel(const uint32 value) { _tolevel = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserQuanxianInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserQuanxianInfo* cmd = (protocol::tag_CMDUserQuanxianInfo*) data;
		cmd->qxid = _qxid;
		cmd->qxtype = _qxtype;
		cmd->srclevel = _srclevel;
		cmd->tolevel = _tolevel;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserQuanxianInfo* cmd = (protocol::tag_CMDUserQuanxianInfo*) data;
		_qxid = cmd->qxid;
		_qxtype = cmd->qxtype;
		_srclevel = cmd->srclevel;
		_tolevel = cmd->tolevel;
	}

	void Log()
	{
		LOG("--------Receive message: UserQuanxianInfo---------");
		LOG("qxid = %d", _qxid);
		LOG("qxtype = %d", _qxtype);
		LOG("srclevel = %d", _srclevel);
		LOG("tolevel = %d", _tolevel);
	}

};


class UserLogonSuccess
{

private:

	int64	_nk;
	int64	_nb;
	int64	_nd;
	uint32	_nmask;
	uint32	_userid;
	uint32	_langid;
	uint32	_langidexptime;
	uint32	_servertime;
	uint32	_version;
	uint32	_headid;
	uint32	_viplevel;
	uint32	_yiyuanlevel;
	uint32	_shoufulevel;
	uint32	_zhonglevel;
	uint32	_caifulevel;
	uint32	_lastmonthcostlevel;
	uint32	_thismonthcostlevel;
	uint32	_thismonthcostgrade;
	uint32	_ngender;
	uint32	_blangidexp;
	uint32	_bxiaoshou;
	string	_cuseralias;


public:

	 inline int64 nk() { return _nk; } const 

	 inline void set_nk(const int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 

	 inline void set_nb(const int64 value) { _nb = value; }

	 inline int64 nd() { return _nd; } const 

	 inline void set_nd(const int64 value) { _nd = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 langid() { return _langid; } const 

	 inline void set_langid(const uint32 value) { _langid = value; }

	 inline uint32 langidexptime() { return _langidexptime; } const 

	 inline void set_langidexptime(const uint32 value) { _langidexptime = value; }

	 inline uint32 servertime() { return _servertime; } const 

	 inline void set_servertime(const uint32 value) { _servertime = value; }

	 inline uint32 version() { return _version; } const 

	 inline void set_version(const uint32 value) { _version = value; }

	 inline uint32 headid() { return _headid; } const 

	 inline void set_headid(const uint32 value) { _headid = value; }

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

	 inline uint32 ngender() { return _ngender; } const 

	 inline void set_ngender(const uint32 value) { _ngender = value; }

	 inline uint32 blangidexp() { return _blangidexp; } const 

	 inline void set_blangidexp(const uint32 value) { _blangidexp = value; }

	 inline uint32 bxiaoshou() { return _bxiaoshou; } const 

	 inline void set_bxiaoshou(const uint32 value) { _bxiaoshou = value; }

	 inline string& cuseralias() { return _cuseralias; } const 

	 inline void set_cuseralias(const string& value) { _cuseralias = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonSuccess); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonSuccess* cmd = (protocol::tag_CMDUserLogonSuccess*) data;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->nd = _nd;
		cmd->nmask = _nmask;
		cmd->userid = _userid;
		cmd->langid = _langid;
		cmd->langidexptime = _langidexptime;
		cmd->servertime = _servertime;
		cmd->version = _version;
		cmd->headid = _headid;
		cmd->viplevel = _viplevel;
		cmd->yiyuanlevel = _yiyuanlevel;
		cmd->shoufulevel = _shoufulevel;
		cmd->zhonglevel = _zhonglevel;
		cmd->caifulevel = _caifulevel;
		cmd->lastmonthcostlevel = _lastmonthcostlevel;
		cmd->thismonthcostlevel = _thismonthcostlevel;
		cmd->thismonthcostgrade = _thismonthcostgrade;
		cmd->ngender = _ngender;
		cmd->blangidexp = _blangidexp;
		cmd->bxiaoshou = _bxiaoshou;
		strcpy(cmd->cuseralias, _cuseralias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonSuccess* cmd = (protocol::tag_CMDUserLogonSuccess*) data;
		_nk = cmd->nk;
		_nb = cmd->nb;
		_nd = cmd->nd;
		_nmask = cmd->nmask;
		_userid = cmd->userid;
		_langid = cmd->langid;
		_langidexptime = cmd->langidexptime;
		_servertime = cmd->servertime;
		_version = cmd->version;
		_headid = cmd->headid;
		_viplevel = cmd->viplevel;
		_yiyuanlevel = cmd->yiyuanlevel;
		_shoufulevel = cmd->shoufulevel;
		_zhonglevel = cmd->zhonglevel;
		_caifulevel = cmd->caifulevel;
		_lastmonthcostlevel = cmd->lastmonthcostlevel;
		_thismonthcostlevel = cmd->thismonthcostlevel;
		_thismonthcostgrade = cmd->thismonthcostgrade;
		_ngender = cmd->ngender;
		_blangidexp = cmd->blangidexp;
		_bxiaoshou = cmd->bxiaoshou;
		_cuseralias = cmd->cuseralias;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonSuccess---------");
		LOG("nk = %lld", _nk);
		LOG("nb = %lld", _nb);
		LOG("nd = %lld", _nd);
		LOG("nmask = %d", _nmask);
		LOG("userid = %d", _userid);
		LOG("langid = %d", _langid);
		LOG("langidexptime = %d", _langidexptime);
		LOG("servertime = %d", _servertime);
		LOG("version = %d", _version);
		LOG("headid = %d", _headid);
		LOG("viplevel = %d", _viplevel);
		LOG("yiyuanlevel = %d", _yiyuanlevel);
		LOG("shoufulevel = %d", _shoufulevel);
		LOG("zhonglevel = %d", _zhonglevel);
		LOG("caifulevel = %d", _caifulevel);
		LOG("lastmonthcostlevel = %d", _lastmonthcostlevel);
		LOG("thismonthcostlevel = %d", _thismonthcostlevel);
		LOG("thismonthcostgrade = %d", _thismonthcostgrade);
		LOG("ngender = %d", _ngender);
		LOG("blangidexp = %d", _blangidexp);
		LOG("bxiaoshou = %d", _bxiaoshou);
		LOG("cuseralias = %s", _cuseralias.c_str());
	}

};


class UserLogonSuccess2
{

private:

	uint32	_nmessageid;
	int64	_nk;
	int64	_nb;
	int64	_nd;
	uint32	_nmask;
	uint32	_userid;
	uint32	_langid;
	uint32	_langidexptime;
	uint32	_servertime;
	uint32	_version;
	uint32	_headid;
	uint32	_viplevel;
	uint32	_yiyuanlevel;
	uint32	_shoufulevel;
	uint32	_zhonglevel;
	uint32	_caifulevel;
	uint32	_lastmonthcostlevel;
	uint32	_thismonthcostlevel;
	uint32	_thismonthcostgrade;
	uint32	_ngender;
	uint32	_blangidexp;
	uint32	_bxiaoshou;
	string	_cuseralias;
	uint32	_nloginflag;
	uint32	_bloginsource;
	uint32	_bboundtel;
	string	_csid;


public:

	 inline uint32 nmessageid() { return _nmessageid; } const 

	 inline void set_nmessageid(const uint32 value) { _nmessageid = value; }

	 inline int64 nk() { return _nk; } const 

	 inline void set_nk(const int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 

	 inline void set_nb(const int64 value) { _nb = value; }

	 inline int64 nd() { return _nd; } const 

	 inline void set_nd(const int64 value) { _nd = value; }

	 inline uint32 nmask() { return _nmask; } const 

	 inline void set_nmask(const uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 langid() { return _langid; } const 

	 inline void set_langid(const uint32 value) { _langid = value; }

	 inline uint32 langidexptime() { return _langidexptime; } const 

	 inline void set_langidexptime(const uint32 value) { _langidexptime = value; }

	 inline uint32 servertime() { return _servertime; } const 

	 inline void set_servertime(const uint32 value) { _servertime = value; }

	 inline uint32 version() { return _version; } const 

	 inline void set_version(const uint32 value) { _version = value; }

	 inline uint32 headid() { return _headid; } const 

	 inline void set_headid(const uint32 value) { _headid = value; }

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

	 inline uint32 ngender() { return _ngender; } const 

	 inline void set_ngender(const uint32 value) { _ngender = value; }

	 inline uint32 blangidexp() { return _blangidexp; } const 

	 inline void set_blangidexp(const uint32 value) { _blangidexp = value; }

	 inline uint32 bxiaoshou() { return _bxiaoshou; } const 

	 inline void set_bxiaoshou(const uint32 value) { _bxiaoshou = value; }

	 inline string& cuseralias() { return _cuseralias; } const 

	 inline void set_cuseralias(const string& value) { _cuseralias = value; }

	 inline uint32 nloginflag() { return _nloginflag; } const 

	 inline void set_nloginflag(const uint32 value) { _nloginflag = value; }

	 inline uint32 bloginsource() { return _bloginsource; } const 

	 inline void set_bloginsource(const uint32 value) { _bloginsource = value; }

	 inline uint32 bboundtel() { return _bboundtel; } const 

	 inline void set_bboundtel(const uint32 value) { _bboundtel = value; }

	 inline string& csid() { return _csid; } const 

	 inline void set_csid(const string& value) { _csid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserLogonSuccess2); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonSuccess2* cmd = (protocol::tag_CMDUserLogonSuccess2*) data;
		cmd->nmessageid = _nmessageid;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->nd = _nd;
		cmd->nmask = _nmask;
		cmd->userid = _userid;
		cmd->langid = _langid;
		cmd->langidexptime = _langidexptime;
		cmd->servertime = _servertime;
		cmd->version = _version;
		cmd->headid = _headid;
		cmd->viplevel = _viplevel;
		cmd->yiyuanlevel = _yiyuanlevel;
		cmd->shoufulevel = _shoufulevel;
		cmd->zhonglevel = _zhonglevel;
		cmd->caifulevel = _caifulevel;
		cmd->lastmonthcostlevel = _lastmonthcostlevel;
		cmd->thismonthcostlevel = _thismonthcostlevel;
		cmd->thismonthcostgrade = _thismonthcostgrade;
		cmd->ngender = _ngender;
		cmd->blangidexp = _blangidexp;
		cmd->bxiaoshou = _bxiaoshou;
		strcpy(cmd->cuseralias, _cuseralias.c_str());
		cmd->nloginflag = _nloginflag;
		cmd->bloginSource = _bloginsource;
		cmd->bBoundTel = _bboundtel;
		strcpy(cmd->csid, _csid.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserLogonSuccess2* cmd = (protocol::tag_CMDUserLogonSuccess2*) data;
		_nmessageid = cmd->nmessageid;
		_nk = cmd->nk;
		_nb = cmd->nb;
		_nd = cmd->nd;
		_nmask = cmd->nmask;
		_userid = cmd->userid;
		_langid = cmd->langid;
		_langidexptime = cmd->langidexptime;
		_servertime = cmd->servertime;
		_version = cmd->version;
		_headid = cmd->headid;
		_viplevel = cmd->viplevel;
		_yiyuanlevel = cmd->yiyuanlevel;
		_shoufulevel = cmd->shoufulevel;
		_zhonglevel = cmd->zhonglevel;
		_caifulevel = cmd->caifulevel;
		_lastmonthcostlevel = cmd->lastmonthcostlevel;
		_thismonthcostlevel = cmd->thismonthcostlevel;
		_thismonthcostgrade = cmd->thismonthcostgrade;
		_ngender = cmd->ngender;
		_blangidexp = cmd->blangidexp;
		_bxiaoshou = cmd->bxiaoshou;
		_cuseralias = cmd->cuseralias;
		_nloginflag = cmd->nloginflag;
		_bloginsource = cmd->bloginSource;
		_bboundtel = cmd->bBoundTel;
		_csid = cmd->csid;
	}

	void Log()
	{
		LOG("--------Receive message: UserLogonSuccess2---------");
		LOG("nmessageid = %d", _nmessageid);
		LOG("nk = %lld", _nk);
		LOG("nb = %lld", _nb);
		LOG("nd = %lld", _nd);
		LOG("nmask = %d", _nmask);
		LOG("userid = %d", _userid);
		LOG("langid = %d", _langid);
		LOG("langidexptime = %d", _langidexptime);
		LOG("servertime = %d", _servertime);
		LOG("version = %d", _version);
		LOG("headid = %d", _headid);
		LOG("viplevel = %d", _viplevel);
		LOG("yiyuanlevel = %d", _yiyuanlevel);
		LOG("shoufulevel = %d", _shoufulevel);
		LOG("zhonglevel = %d", _zhonglevel);
		LOG("caifulevel = %d", _caifulevel);
		LOG("lastmonthcostlevel = %d", _lastmonthcostlevel);
		LOG("thismonthcostlevel = %d", _thismonthcostlevel);
		LOG("thismonthcostgrade = %d", _thismonthcostgrade);
		LOG("ngender = %d", _ngender);
		LOG("blangidexp = %d", _blangidexp);
		LOG("bxiaoshou = %d", _bxiaoshou);
		LOG("cuseralias = %s", _cuseralias.c_str());
		LOG("nloginflag = %d", _nloginflag);
		LOG("bloginsource = %d", _bloginsource);
		LOG("bboundtel = %d", _bboundtel);
		LOG("csid = %s", _csid.c_str());
	}

};


class SetUserProfileReq
{

private:

	uint32	_userid;
	uint32	_headid;
	uint32	_ngender;
	string	_cbirthday;
	string	_cuseralias;
	string	_province;
	string	_city;
	int32	_introducelen;
	string	_introduce;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 headid() { return _headid; } const 

	 inline void set_headid(const uint32 value) { _headid = value; }

	 inline uint32 ngender() { return _ngender; } const 

	 inline void set_ngender(const uint32 value) { _ngender = value; }

	 inline string& cbirthday() { return _cbirthday; } const 

	 inline void set_cbirthday(const string& value) { _cbirthday = value; }

	 inline string& cuseralias() { return _cuseralias; } const 

	 inline void set_cuseralias(const string& value) { _cuseralias = value; }

	 inline string& province() { return _province; } const 

	 inline void set_province(const string& value) { _province = value; }

	 inline string& city() { return _city; } const 

	 inline void set_city(const string& value) { _city = value; }

	 inline int32 introducelen() { return _introducelen; } const 

	 inline void set_introducelen(const int32 value) { _introducelen = value; }

	 inline string& introduce() { return _introduce; } const 

	 inline void set_introduce(const string& value) { _introduce = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserProfileReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserProfileReq* cmd = (protocol::tag_CMDSetUserProfileReq*) data;
		cmd->userid = _userid;
		cmd->headid = _headid;
		cmd->ngender = _ngender;
		strcpy(cmd->cbirthday, _cbirthday.c_str());
		strcpy(cmd->cuseralias, _cuseralias.c_str());
		strcpy(cmd->province, _province.c_str());
		strcpy(cmd->city, _city.c_str());
		cmd->introducelen = _introducelen;
		strcpy(cmd->introduce, _introduce.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserProfileReq* cmd = (protocol::tag_CMDSetUserProfileReq*) data;
		_userid = cmd->userid;
		_headid = cmd->headid;
		_ngender = cmd->ngender;
		_cbirthday = cmd->cbirthday;
		_cuseralias = cmd->cuseralias;
		_province = cmd->province;
		_city = cmd->city;
		_introducelen = cmd->introducelen;
		_introduce = cmd->introduce;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserProfileReq---------");
		LOG("userid = %d", _userid);
		LOG("headid = %d", _headid);
		LOG("ngender = %d", _ngender);
		LOG("cbirthday = %s", _cbirthday.c_str());
		LOG("cuseralias = %s", _cuseralias.c_str());
		LOG("province = %s", _province.c_str());
		LOG("city = %s", _city.c_str());
		LOG("introducelen = %d", _introducelen);
		LOG("introduce = %s", _introduce.c_str());
	}

};


class SetUserProfileResp
{

private:

	uint32	_userid;
	int32	_errorid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserProfileResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserProfileResp* cmd = (protocol::tag_CMDSetUserProfileResp*) data;
		cmd->userid = _userid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserProfileResp* cmd = (protocol::tag_CMDSetUserProfileResp*) data;
		_userid = cmd->userid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserProfileResp---------");
		LOG("userid = %d", _userid);
		LOG("errorid = %d", _errorid);
	}

};


class SetUserPwdReq
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_pwdtype;
	string	_oldpwd;
	string	_newpwd;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 pwdtype() { return _pwdtype; } const 

	 inline void set_pwdtype(const uint32 value) { _pwdtype = value; }

	 inline string& oldpwd() { return _oldpwd; } const 

	 inline void set_oldpwd(const string& value) { _oldpwd = value; }

	 inline string& newpwd() { return _newpwd; } const 

	 inline void set_newpwd(const string& value) { _newpwd = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserPwdReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserPwdReq* cmd = (protocol::tag_CMDSetUserPwdReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->pwdtype = _pwdtype;
		strcpy(cmd->oldpwd, _oldpwd.c_str());
		strcpy(cmd->newpwd, _newpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserPwdReq* cmd = (protocol::tag_CMDSetUserPwdReq*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_pwdtype = cmd->pwdtype;
		_oldpwd = cmd->oldpwd;
		_newpwd = cmd->newpwd;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserPwdReq---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("pwdtype = %d", _pwdtype);
		LOG("oldpwd = %s", _oldpwd.c_str());
		LOG("newpwd = %s", _newpwd.c_str());
	}

};


class SetUserPwdResp
{

private:

	uint32	_userid;
	uint32	_vcbid;
	int32	_errorid;
	uint32	_pwdtype;
	string	_cnewpwd;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }

	 inline uint32 pwdtype() { return _pwdtype; } const 

	 inline void set_pwdtype(const uint32 value) { _pwdtype = value; }

	 inline string& cnewpwd() { return _cnewpwd; } const 

	 inline void set_cnewpwd(const string& value) { _cnewpwd = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserPwdResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserPwdResp* cmd = (protocol::tag_CMDSetUserPwdResp*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
		cmd->pwdtype = _pwdtype;
		strcpy(cmd->cnewpwd, _cnewpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserPwdResp* cmd = (protocol::tag_CMDSetUserPwdResp*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
		_pwdtype = cmd->pwdtype;
		_cnewpwd = cmd->cnewpwd;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserPwdResp---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
		LOG("pwdtype = %d", _pwdtype);
		LOG("cnewpwd = %s", _cnewpwd.c_str());
	}

};


class RoomGroupListReq
{

private:

	uint32	_userid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomGroupListReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomGroupListReq* cmd = (protocol::tag_CMDRoomGroupListReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomGroupListReq* cmd = (protocol::tag_CMDRoomGroupListReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: RoomGroupListReq---------");
		LOG("userid = %d", _userid);
	}

};


class RoomGroupItem
{

private:

	uint32	_grouid;
	uint32	_parentid;
	int32	_usernum;
	uint32	_textcolor;
	uint32	_reserve_1;
	uint32	_showusernum;
	uint32	_urllength;
	uint32	_bfontbold;
	string	_cgroupname;
	string	_clienticonname;
	string	_content;


public:

	 inline uint32 grouid() { return _grouid; } const 

	 inline void set_grouid(const uint32 value) { _grouid = value; }

	 inline uint32 parentid() { return _parentid; } const 

	 inline void set_parentid(const uint32 value) { _parentid = value; }

	 inline int32 usernum() { return _usernum; } const 

	 inline void set_usernum(const int32 value) { _usernum = value; }

	 inline uint32 textcolor() { return _textcolor; } const 

	 inline void set_textcolor(const uint32 value) { _textcolor = value; }

	 inline uint32 reserve_1() { return _reserve_1; } const 

	 inline void set_reserve_1(const uint32 value) { _reserve_1 = value; }

	 inline uint32 showusernum() { return _showusernum; } const 

	 inline void set_showusernum(const uint32 value) { _showusernum = value; }

	 inline uint32 urllength() { return _urllength; } const 

	 inline void set_urllength(const uint32 value) { _urllength = value; }

	 inline uint32 bfontbold() { return _bfontbold; } const 

	 inline void set_bfontbold(const uint32 value) { _bfontbold = value; }

	 inline string& cgroupname() { return _cgroupname; } const 

	 inline void set_cgroupname(const string& value) { _cgroupname = value; }

	 inline string& clienticonname() { return _clienticonname; } const 

	 inline void set_clienticonname(const string& value) { _clienticonname = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomGroupItem); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomGroupItem* cmd = (protocol::tag_CMDRoomGroupItem*) data;
		cmd->grouid = _grouid;
		cmd->parentid = _parentid;
		cmd->usernum = _usernum;
		cmd->textcolor = _textcolor;
		cmd->reserve_1 = _reserve_1;
		cmd->showusernum = _showusernum;
		cmd->urllength = _urllength;
		cmd->bfontbold = _bfontbold;
		strcpy(cmd->cgroupname, _cgroupname.c_str());
		strcpy(cmd->clienticonname, _clienticonname.c_str());
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomGroupItem* cmd = (protocol::tag_CMDRoomGroupItem*) data;
		_grouid = cmd->grouid;
		_parentid = cmd->parentid;
		_usernum = cmd->usernum;
		_textcolor = cmd->textcolor;
		_reserve_1 = cmd->reserve_1;
		_showusernum = cmd->showusernum;
		_urllength = cmd->urllength;
		_bfontbold = cmd->bfontbold;
		_cgroupname = cmd->cgroupname;
		_clienticonname = cmd->clienticonname;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: RoomGroupItem---------");
		LOG("grouid = %d", _grouid);
		LOG("parentid = %d", _parentid);
		LOG("usernum = %d", _usernum);
		LOG("textcolor = %d", _textcolor);
		LOG("reserve_1 = %d", _reserve_1);
		LOG("showusernum = %d", _showusernum);
		LOG("urllength = %d", _urllength);
		LOG("bfontbold = %d", _bfontbold);
		LOG("cgroupname = %s", _cgroupname.c_str());
		LOG("clienticonname = %s", _clienticonname.c_str());
		LOG("content = %s", _content.c_str());
	}

};


class RoomGroupStatus
{

private:

	uint32	_grouid;
	uint32	_usernum;


public:

	 inline uint32 grouid() { return _grouid; } const 

	 inline void set_grouid(const uint32 value) { _grouid = value; }

	 inline uint32 usernum() { return _usernum; } const 

	 inline void set_usernum(const uint32 value) { _usernum = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomGroupStatus); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomGroupStatus* cmd = (protocol::tag_CMDRoomGroupStatus*) data;
		cmd->grouid = _grouid;
		cmd->usernum = _usernum;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomGroupStatus* cmd = (protocol::tag_CMDRoomGroupStatus*) data;
		_grouid = cmd->grouid;
		_usernum = cmd->usernum;
	}

	void Log()
	{
		LOG("--------Receive message: RoomGroupStatus---------");
		LOG("grouid = %d", _grouid);
		LOG("usernum = %d", _usernum);
	}

};


class RoomListReq
{

private:

	uint32	_userid;
	uint32	_ntype;
	uint32	_nvcbcount;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 ntype() { return _ntype; } const 

	 inline void set_ntype(const uint32 value) { _ntype = value; }

	 inline uint32 nvcbcount() { return _nvcbcount; } const 

	 inline void set_nvcbcount(const uint32 value) { _nvcbcount = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomListReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomListReq* cmd = (protocol::tag_CMDRoomListReq*) data;
		cmd->userid = _userid;
		cmd->ntype = _ntype;
		cmd->nvcbcount = _nvcbcount;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomListReq* cmd = (protocol::tag_CMDRoomListReq*) data;
		_userid = cmd->userid;
		_ntype = cmd->ntype;
		_nvcbcount = cmd->nvcbcount;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: RoomListReq---------");
		LOG("userid = %d", _userid);
		LOG("ntype = %d", _ntype);
		LOG("nvcbcount = %d", _nvcbcount);
		LOG("content = %s", _content.c_str());
	}

};


class RoomItem
{

private:

	uint32	_roomid;
	uint32	_creatorid;
	uint32	_groupid;
	uint32	_flag;
	string	_cname;
	string	_croompic;
	string	_croomaddr;


public:

	 inline uint32 roomid() { return _roomid; } const 

	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline uint32 creatorid() { return _creatorid; } const 

	 inline void set_creatorid(const uint32 value) { _creatorid = value; }

	 inline uint32 groupid() { return _groupid; } const 

	 inline void set_groupid(const uint32 value) { _groupid = value; }

	 inline uint32 flag() { return _flag; } const 

	 inline void set_flag(const uint32 value) { _flag = value; }

	 inline string& cname() { return _cname; } const 

	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& croompic() { return _croompic; } const 

	 inline void set_croompic(const string& value) { _croompic = value; }

	 inline string& croomaddr() { return _croomaddr; } const 

	 inline void set_croomaddr(const string& value) { _croomaddr = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomItem); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomItem* cmd = (protocol::tag_CMDRoomItem*) data;
		cmd->roomid = _roomid;
		cmd->creatorid = _creatorid;
		cmd->groupid = _groupid;
		cmd->flag = _flag;
		strcpy(cmd->cname, _cname.c_str());
		strcpy(cmd->croompic, _croompic.c_str());
		strcpy(cmd->croomaddr, _croomaddr.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomItem* cmd = (protocol::tag_CMDRoomItem*) data;
		_roomid = cmd->roomid;
		_creatorid = cmd->creatorid;
		_groupid = cmd->groupid;
		_flag = cmd->flag;
		_cname = cmd->cname;
		_croompic = cmd->croompic;
		_croomaddr = cmd->croomaddr;
	}

	void Log()
	{
		LOG("--------Receive message: RoomItem---------");
		LOG("roomid = %d", _roomid);
		LOG("creatorid = %d", _creatorid);
		LOG("groupid = %d", _groupid);
		LOG("flag = %d", _flag);
		LOG("cname = %s", _cname.c_str());
		LOG("croompic = %s", _croompic.c_str());
		LOG("croomaddr = %s", _croomaddr.c_str());
	}

};


class UserMoreInfo
{

private:

	int32	_userid;
	uint32	_birthday_day;
	uint32	_birthday_month;
	uint32	_gender;
	uint32	_bloodgroup;
	int32	_birthday_year;
	string	_country;
	string	_province;
	string	_city;
	uint32	_moodlength;
	uint32	_explainlength;
	string	_content;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }

	 inline uint32 birthday_day() { return _birthday_day; } const 

	 inline void set_birthday_day(const uint32 value) { _birthday_day = value; }

	 inline uint32 birthday_month() { return _birthday_month; } const 

	 inline void set_birthday_month(const uint32 value) { _birthday_month = value; }

	 inline uint32 gender() { return _gender; } const 

	 inline void set_gender(const uint32 value) { _gender = value; }

	 inline uint32 bloodgroup() { return _bloodgroup; } const 

	 inline void set_bloodgroup(const uint32 value) { _bloodgroup = value; }

	 inline int32 birthday_year() { return _birthday_year; } const 

	 inline void set_birthday_year(const int32 value) { _birthday_year = value; }

	 inline string& country() { return _country; } const 

	 inline void set_country(const string& value) { _country = value; }

	 inline string& province() { return _province; } const 

	 inline void set_province(const string& value) { _province = value; }

	 inline string& city() { return _city; } const 

	 inline void set_city(const string& value) { _city = value; }

	 inline uint32 moodlength() { return _moodlength; } const 

	 inline void set_moodlength(const uint32 value) { _moodlength = value; }

	 inline uint32 explainlength() { return _explainlength; } const 

	 inline void set_explainlength(const uint32 value) { _explainlength = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUserMoreInfo); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUserMoreInfo* cmd = (protocol::tag_CMDUserMoreInfo*) data;
		cmd->userid = _userid;
		cmd->birthday_day = _birthday_day;
		cmd->birthday_month = _birthday_month;
		cmd->gender = _gender;
		cmd->bloodgroup = _bloodgroup;
		cmd->birthday_year = _birthday_year;
		strcpy(cmd->country, _country.c_str());
		strcpy(cmd->province, _province.c_str());
		strcpy(cmd->city, _city.c_str());
		cmd->moodlength = _moodlength;
		cmd->explainlength = _explainlength;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUserMoreInfo* cmd = (protocol::tag_CMDUserMoreInfo*) data;
		_userid = cmd->userid;
		_birthday_day = cmd->birthday_day;
		_birthday_month = cmd->birthday_month;
		_gender = cmd->gender;
		_bloodgroup = cmd->bloodgroup;
		_birthday_year = cmd->birthday_year;
		_country = cmd->country;
		_province = cmd->province;
		_city = cmd->city;
		_moodlength = cmd->moodlength;
		_explainlength = cmd->explainlength;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: UserMoreInfo---------");
		LOG("userid = %d", _userid);
		LOG("birthday_day = %d", _birthday_day);
		LOG("birthday_month = %d", _birthday_month);
		LOG("gender = %d", _gender);
		LOG("bloodgroup = %d", _bloodgroup);
		LOG("birthday_year = %d", _birthday_year);
		LOG("country = %s", _country.c_str());
		LOG("province = %s", _province.c_str());
		LOG("city = %s", _city.c_str());
		LOG("moodlength = %d", _moodlength);
		LOG("explainlength = %d", _explainlength);
		LOG("content = %s", _content.c_str());
	}

};


class SetUserMoreInfoResp
{

private:

	uint32	_userid;
	int32	_errorid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline int32 errorid() { return _errorid; } const 

	 inline void set_errorid(const int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSetUserMoreInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSetUserMoreInfoResp* cmd = (protocol::tag_CMDSetUserMoreInfoResp*) data;
		cmd->userid = _userid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSetUserMoreInfoResp* cmd = (protocol::tag_CMDSetUserMoreInfoResp*) data;
		_userid = cmd->userid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserMoreInfoResp---------");
		LOG("userid = %d", _userid);
		LOG("errorid = %d", _errorid);
	}

};


class QuanxianId2Item
{

private:

	int32	_levelid;
	int32	_quanxianid;
	uint32	_quanxianprio;
	uint32	_sortid;
	uint32	_sortprio;


public:

	 inline int32 levelid() { return _levelid; } const 

	 inline void set_levelid(const int32 value) { _levelid = value; }

	 inline int32 quanxianid() { return _quanxianid; } const 

	 inline void set_quanxianid(const int32 value) { _quanxianid = value; }

	 inline uint32 quanxianprio() { return _quanxianprio; } const 

	 inline void set_quanxianprio(const uint32 value) { _quanxianprio = value; }

	 inline uint32 sortid() { return _sortid; } const 

	 inline void set_sortid(const uint32 value) { _sortid = value; }

	 inline uint32 sortprio() { return _sortprio; } const 

	 inline void set_sortprio(const uint32 value) { _sortprio = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQuanxianId2Item); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQuanxianId2Item* cmd = (protocol::tag_CMDQuanxianId2Item*) data;
		cmd->levelid = _levelid;
		cmd->quanxianid = _quanxianid;
		cmd->quanxianprio = _quanxianprio;
		cmd->sortid = _sortid;
		cmd->sortprio = _sortprio;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQuanxianId2Item* cmd = (protocol::tag_CMDQuanxianId2Item*) data;
		_levelid = cmd->levelid;
		_quanxianid = cmd->quanxianid;
		_quanxianprio = cmd->quanxianprio;
		_sortid = cmd->sortid;
		_sortprio = cmd->sortprio;
	}

	void Log()
	{
		LOG("--------Receive message: QuanxianId2Item---------");
		LOG("levelid = %d", _levelid);
		LOG("quanxianid = %d", _quanxianid);
		LOG("quanxianprio = %d", _quanxianprio);
		LOG("sortid = %d", _sortid);
		LOG("sortprio = %d", _sortprio);
	}

};


class QuanxianAction2Item
{

private:

	uint32	_actionid;
	uint32	_actiontype;
	int32	_srcid;
	int32	_toid;


public:

	 inline uint32 actionid() { return _actionid; } const 

	 inline void set_actionid(const uint32 value) { _actionid = value; }

	 inline uint32 actiontype() { return _actiontype; } const 

	 inline void set_actiontype(const uint32 value) { _actiontype = value; }

	 inline int32 srcid() { return _srcid; } const 

	 inline void set_srcid(const int32 value) { _srcid = value; }

	 inline int32 toid() { return _toid; } const 

	 inline void set_toid(const int32 value) { _toid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQuanxianAction2Item); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQuanxianAction2Item* cmd = (protocol::tag_CMDQuanxianAction2Item*) data;
		cmd->actionid = _actionid;
		cmd->actiontype = _actiontype;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQuanxianAction2Item* cmd = (protocol::tag_CMDQuanxianAction2Item*) data;
		_actionid = cmd->actionid;
		_actiontype = cmd->actiontype;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
	}

	void Log()
	{
		LOG("--------Receive message: QuanxianAction2Item---------");
		LOG("actionid = %d", _actionid);
		LOG("actiontype = %d", _actiontype);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
	}

};


class ExitAlertReq
{

private:

	int32	_userid;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDExitAlertReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDExitAlertReq* cmd = (protocol::tag_CMDExitAlertReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDExitAlertReq* cmd = (protocol::tag_CMDExitAlertReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: ExitAlertReq---------");
		LOG("userid = %d", _userid);
	}

};


class ExitAlertResp
{

private:

	int32	_userid;
	string	_email;
	string	_qq;
	string	_tel;
	int32	_hit_gold_egg_time;
	int32	_data1;
	int32	_data2;
	int32	_data3;
	string	_data4;
	string	_data5;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }

	 inline string& email() { return _email; } const 

	 inline void set_email(const string& value) { _email = value; }

	 inline string& qq() { return _qq; } const 

	 inline void set_qq(const string& value) { _qq = value; }

	 inline string& tel() { return _tel; } const 

	 inline void set_tel(const string& value) { _tel = value; }

	 inline int32 hit_gold_egg_time() { return _hit_gold_egg_time; } const 

	 inline void set_hit_gold_egg_time(const int32 value) { _hit_gold_egg_time = value; }

	 inline int32 data1() { return _data1; } const 

	 inline void set_data1(const int32 value) { _data1 = value; }

	 inline int32 data2() { return _data2; } const 

	 inline void set_data2(const int32 value) { _data2 = value; }

	 inline int32 data3() { return _data3; } const 

	 inline void set_data3(const int32 value) { _data3 = value; }

	 inline string& data4() { return _data4; } const 

	 inline void set_data4(const string& value) { _data4 = value; }

	 inline string& data5() { return _data5; } const 

	 inline void set_data5(const string& value) { _data5 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDExitAlertResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDExitAlertResp* cmd = (protocol::tag_CMDExitAlertResp*) data;
		cmd->userid = _userid;
		strcpy(cmd->email, _email.c_str());
		strcpy(cmd->qq, _qq.c_str());
		strcpy(cmd->tel, _tel.c_str());
		cmd->hit_gold_egg_time = _hit_gold_egg_time;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
		cmd->data3 = _data3;
		strcpy(cmd->data4, _data4.c_str());
		strcpy(cmd->data5, _data5.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDExitAlertResp* cmd = (protocol::tag_CMDExitAlertResp*) data;
		_userid = cmd->userid;
		_email = cmd->email;
		_qq = cmd->qq;
		_tel = cmd->tel;
		_hit_gold_egg_time = cmd->hit_gold_egg_time;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
		_data3 = cmd->data3;
		_data4 = cmd->data4;
		_data5 = cmd->data5;
	}

	void Log()
	{
		LOG("--------Receive message: ExitAlertResp---------");
		LOG("userid = %d", _userid);
		LOG("email = %s", _email.c_str());
		LOG("qq = %s", _qq.c_str());
		LOG("tel = %s", _tel.c_str());
		LOG("hit_gold_egg_time = %d", _hit_gold_egg_time);
		LOG("data1 = %d", _data1);
		LOG("data2 = %d", _data2);
		LOG("data3 = %d", _data3);
		LOG("data4 = %s", _data4.c_str());
		LOG("data5 = %s", _data5.c_str());
	}

};


class SecureInfoReq
{

private:

	int32	_userid;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSecureInfoReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSecureInfoReq* cmd = (protocol::tag_CMDSecureInfoReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSecureInfoReq* cmd = (protocol::tag_CMDSecureInfoReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: SecureInfoReq---------");
		LOG("userid = %d", _userid);
	}

};


class SecureInfoResp
{

private:

	string	_email;
	string	_qq;
	string	_tel;
	int32	_remindtime;
	int32	_data1;
	int32	_data2;
	int32	_data3;
	string	_data4;
	string	_data5;
	string	_data6;


public:

	 inline string& email() { return _email; } const 

	 inline void set_email(const string& value) { _email = value; }

	 inline string& qq() { return _qq; } const 

	 inline void set_qq(const string& value) { _qq = value; }

	 inline string& tel() { return _tel; } const 

	 inline void set_tel(const string& value) { _tel = value; }

	 inline int32 remindtime() { return _remindtime; } const 

	 inline void set_remindtime(const int32 value) { _remindtime = value; }

	 inline int32 data1() { return _data1; } const 

	 inline void set_data1(const int32 value) { _data1 = value; }

	 inline int32 data2() { return _data2; } const 

	 inline void set_data2(const int32 value) { _data2 = value; }

	 inline int32 data3() { return _data3; } const 

	 inline void set_data3(const int32 value) { _data3 = value; }

	 inline string& data4() { return _data4; } const 

	 inline void set_data4(const string& value) { _data4 = value; }

	 inline string& data5() { return _data5; } const 

	 inline void set_data5(const string& value) { _data5 = value; }

	 inline string& data6() { return _data6; } const 

	 inline void set_data6(const string& value) { _data6 = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSecureInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSecureInfoResp* cmd = (protocol::tag_CMDSecureInfoResp*) data;
		strcpy(cmd->email, _email.c_str());
		strcpy(cmd->qq, _qq.c_str());
		strcpy(cmd->tel, _tel.c_str());
		cmd->remindtime = _remindtime;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
		cmd->data3 = _data3;
		strcpy(cmd->data4, _data4.c_str());
		strcpy(cmd->data5, _data5.c_str());
		strcpy(cmd->data6, _data6.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSecureInfoResp* cmd = (protocol::tag_CMDSecureInfoResp*) data;
		_email = cmd->email;
		_qq = cmd->qq;
		_tel = cmd->tel;
		_remindtime = cmd->remindtime;
		_data1 = cmd->data1;
		_data2 = cmd->data2;
		_data3 = cmd->data3;
		_data4 = cmd->data4;
		_data5 = cmd->data5;
		_data6 = cmd->data6;
	}

	void Log()
	{
		LOG("--------Receive message: SecureInfoResp---------");
		LOG("email = %s", _email.c_str());
		LOG("qq = %s", _qq.c_str());
		LOG("tel = %s", _tel.c_str());
		LOG("remindtime = %d", _remindtime);
		LOG("data1 = %d", _data1);
		LOG("data2 = %d", _data2);
		LOG("data3 = %d", _data3);
		LOG("data4 = %s", _data4.c_str());
		LOG("data5 = %s", _data5.c_str());
		LOG("data6 = %s", _data6.c_str());
	}

};


class MessageNoty
{

private:

	int32	_userid;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDMessageNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDMessageNoty* cmd = (protocol::tag_CMDMessageNoty*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDMessageNoty* cmd = (protocol::tag_CMDMessageNoty*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: MessageNoty---------");
		LOG("userid = %d", _userid);
	}

};


class MessageUnreadResp
{

private:

	int32	_userid;
	uint32	_teacherflag;
	int32	_chatcount;
	int32	_viewcount;
	int32	_answercount;
	int32	_syscount;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }

	 inline uint32 teacherflag() { return _teacherflag; } const 

	 inline void set_teacherflag(const uint32 value) { _teacherflag = value; }

	 inline int32 chatcount() { return _chatcount; } const 

	 inline void set_chatcount(const int32 value) { _chatcount = value; }

	 inline int32 viewcount() { return _viewcount; } const 

	 inline void set_viewcount(const int32 value) { _viewcount = value; }

	 inline int32 answercount() { return _answercount; } const 

	 inline void set_answercount(const int32 value) { _answercount = value; }

	 inline int32 syscount() { return _syscount; } const 

	 inline void set_syscount(const int32 value) { _syscount = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDMessageUnreadResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDMessageUnreadResp* cmd = (protocol::tag_CMDMessageUnreadResp*) data;
		cmd->userid = _userid;
		cmd->teacherflag = _teacherflag;
		cmd->chatcount = _chatcount;
		cmd->viewcount = _viewcount;
		cmd->answercount = _answercount;
		cmd->syscount = _syscount;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDMessageUnreadResp* cmd = (protocol::tag_CMDMessageUnreadResp*) data;
		_userid = cmd->userid;
		_teacherflag = cmd->teacherflag;
		_chatcount = cmd->chatcount;
		_viewcount = cmd->viewcount;
		_answercount = cmd->answercount;
		_syscount = cmd->syscount;
	}

	void Log()
	{
		LOG("--------Receive message: MessageUnreadResp---------");
		LOG("userid = %d", _userid);
		LOG("teacherflag = %d", _teacherflag);
		LOG("chatcount = %d", _chatcount);
		LOG("viewcount = %d", _viewcount);
		LOG("answercount = %d", _answercount);
		LOG("syscount = %d", _syscount);
	}

};


class HallMessageReq
{

private:

	uint32	_userid;
	uint32	_teacherflag;
	int32	_type;
	int64	_messageid;
	int32	_startindex;
	int32	_count;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherflag() { return _teacherflag; } const 

	 inline void set_teacherflag(const uint32 value) { _teacherflag = value; }

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline int64 messageid() { return _messageid; } const 

	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 startindex() { return _startindex; } const 

	 inline void set_startindex(const int32 value) { _startindex = value; }

	 inline int32 count() { return _count; } const 

	 inline void set_count(const int32 value) { _count = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDHallMessageReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDHallMessageReq* cmd = (protocol::tag_CMDHallMessageReq*) data;
		cmd->userid = _userid;
		cmd->teacherflag = _teacherflag;
		cmd->type = _type;
		cmd->messageid = _messageid;
		cmd->startIndex = _startindex;
		cmd->count = _count;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDHallMessageReq* cmd = (protocol::tag_CMDHallMessageReq*) data;
		_userid = cmd->userid;
		_teacherflag = cmd->teacherflag;
		_type = cmd->type;
		_messageid = cmd->messageid;
		_startindex = cmd->startIndex;
		_count = cmd->count;
	}

	void Log()
	{
		LOG("--------Receive message: HallMessageReq---------");
		LOG("userid = %d", _userid);
		LOG("teacherflag = %d", _teacherflag);
		LOG("type = %d", _type);
		LOG("messageid = %lld", _messageid);
		LOG("startindex = %d", _startindex);
		LOG("count = %d", _count);
	}

};


class InteractResp
{

private:

	int32	_type;
	uint32	_userid;
	uint32	_touserid;
	string	_touseralias;
	uint32	_touserheadid;
	int64	_messageid;
	int32	_sortextlen;
	int32	_destextlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 touserid() { return _touserid; } const 

	 inline void set_touserid(const uint32 value) { _touserid = value; }

	 inline string& touseralias() { return _touseralias; } const 

	 inline void set_touseralias(const string& value) { _touseralias = value; }

	 inline uint32 touserheadid() { return _touserheadid; } const 

	 inline void set_touserheadid(const uint32 value) { _touserheadid = value; }

	 inline int64 messageid() { return _messageid; } const 

	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 sortextlen() { return _sortextlen; } const 

	 inline void set_sortextlen(const int32 value) { _sortextlen = value; }

	 inline int32 destextlen() { return _destextlen; } const 

	 inline void set_destextlen(const int32 value) { _destextlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 

	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 

	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDInteractResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDInteractResp* cmd = (protocol::tag_CMDInteractResp*) data;
		cmd->type = _type;
		cmd->userid = _userid;
		cmd->touserid = _touserid;
		strcpy(cmd->touseralias, _touseralias.c_str());
		cmd->touserheadid = _touserheadid;
		cmd->messageid = _messageid;
		cmd->sortextlen = _sortextlen;
		cmd->destextlen = _destextlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDInteractResp* cmd = (protocol::tag_CMDInteractResp*) data;
		_type = cmd->type;
		_userid = cmd->userid;
		_touserid = cmd->touserid;
		_touseralias = cmd->touseralias;
		_touserheadid = cmd->touserheadid;
		_messageid = cmd->messageid;
		_sortextlen = cmd->sortextlen;
		_destextlen = cmd->destextlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: InteractResp---------");
		LOG("type = %d", _type);
		LOG("userid = %d", _userid);
		LOG("touserid = %d", _touserid);
		LOG("touseralias = %s", _touseralias.c_str());
		LOG("touserheadid = %d", _touserheadid);
		LOG("messageid = %lld", _messageid);
		LOG("sortextlen = %d", _sortextlen);
		LOG("destextlen = %d", _destextlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class AnswerResp
{

private:

	int32	_type;
	uint32	_userid;
	uint32	_touserid;
	string	_touseralias;
	uint32	_touserheadid;
	int64	_messageid;
	int32	_answerlen;
	int32	_stokeidlen;
	int32	_questionlen;
	uint64	_messagetime;
	uint32	_commentstype;
	string	_content;


public:

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 touserid() { return _touserid; } const 

	 inline void set_touserid(const uint32 value) { _touserid = value; }

	 inline string& touseralias() { return _touseralias; } const 

	 inline void set_touseralias(const string& value) { _touseralias = value; }

	 inline uint32 touserheadid() { return _touserheadid; } const 

	 inline void set_touserheadid(const uint32 value) { _touserheadid = value; }

	 inline int64 messageid() { return _messageid; } const 

	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 answerlen() { return _answerlen; } const 

	 inline void set_answerlen(const int32 value) { _answerlen = value; }

	 inline int32 stokeidlen() { return _stokeidlen; } const 

	 inline void set_stokeidlen(const int32 value) { _stokeidlen = value; }

	 inline int32 questionlen() { return _questionlen; } const 

	 inline void set_questionlen(const int32 value) { _questionlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 

	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 

	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDAnswerResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDAnswerResp* cmd = (protocol::tag_CMDAnswerResp*) data;
		cmd->type = _type;
		cmd->userid = _userid;
		cmd->touserid = _touserid;
		strcpy(cmd->touseralias, _touseralias.c_str());
		cmd->touserheadid = _touserheadid;
		cmd->messageid = _messageid;
		cmd->answerlen = _answerlen;
		cmd->stokeidlen = _stokeidlen;
		cmd->questionlen = _questionlen;
		cmd->messagetime = _messagetime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDAnswerResp* cmd = (protocol::tag_CMDAnswerResp*) data;
		_type = cmd->type;
		_userid = cmd->userid;
		_touserid = cmd->touserid;
		_touseralias = cmd->touseralias;
		_touserheadid = cmd->touserheadid;
		_messageid = cmd->messageid;
		_answerlen = cmd->answerlen;
		_stokeidlen = cmd->stokeidlen;
		_questionlen = cmd->questionlen;
		_messagetime = cmd->messagetime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: AnswerResp---------");
		LOG("type = %d", _type);
		LOG("userid = %d", _userid);
		LOG("touserid = %d", _touserid);
		LOG("touseralias = %s", _touseralias.c_str());
		LOG("touserheadid = %d", _touserheadid);
		LOG("messageid = %lld", _messageid);
		LOG("answerlen = %d", _answerlen);
		LOG("stokeidlen = %d", _stokeidlen);
		LOG("questionlen = %d", _questionlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class ViewShowResp
{

private:

	int32	_type;
	uint32	_userid;
	uint32	_touserid;
	string	_useralias;
	uint32	_userheadid;
	int64	_commentid;
	int32	_viewtitlelen;
	int32	_viewtextlen;
	int32	_srctextlen;
	int32	_replytextlen;
	uint64	_restime;
	uint32	_commentstype;
	string	_content;


public:

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 touserid() { return _touserid; } const 

	 inline void set_touserid(const uint32 value) { _touserid = value; }

	 inline string& useralias() { return _useralias; } const 

	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline uint32 userheadid() { return _userheadid; } const 

	 inline void set_userheadid(const uint32 value) { _userheadid = value; }

	 inline int64 commentid() { return _commentid; } const 

	 inline void set_commentid(const int64 value) { _commentid = value; }

	 inline int32 viewtitlelen() { return _viewtitlelen; } const 

	 inline void set_viewtitlelen(const int32 value) { _viewtitlelen = value; }

	 inline int32 viewtextlen() { return _viewtextlen; } const 

	 inline void set_viewtextlen(const int32 value) { _viewtextlen = value; }

	 inline int32 srctextlen() { return _srctextlen; } const 

	 inline void set_srctextlen(const int32 value) { _srctextlen = value; }

	 inline int32 replytextlen() { return _replytextlen; } const 

	 inline void set_replytextlen(const int32 value) { _replytextlen = value; }

	 inline uint64 restime() { return _restime; } const 

	 inline void set_restime(const uint64 value) { _restime = value; }

	 inline uint32 commentstype() { return _commentstype; } const 

	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDViewShowResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDViewShowResp* cmd = (protocol::tag_CMDViewShowResp*) data;
		cmd->type = _type;
		cmd->userid = _userid;
		cmd->touserid = _touserid;
		strcpy(cmd->useralias, _useralias.c_str());
		cmd->userheadid = _userheadid;
		cmd->commentid = _commentid;
		cmd->viewTitlelen = _viewtitlelen;
		cmd->viewtextlen = _viewtextlen;
		cmd->srctextlen = _srctextlen;
		cmd->replytextlen = _replytextlen;
		cmd->restime = _restime;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDViewShowResp* cmd = (protocol::tag_CMDViewShowResp*) data;
		_type = cmd->type;
		_userid = cmd->userid;
		_touserid = cmd->touserid;
		_useralias = cmd->useralias;
		_userheadid = cmd->userheadid;
		_commentid = cmd->commentid;
		_viewtitlelen = cmd->viewTitlelen;
		_viewtextlen = cmd->viewtextlen;
		_srctextlen = cmd->srctextlen;
		_replytextlen = cmd->replytextlen;
		_restime = cmd->restime;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: ViewShowResp---------");
		LOG("type = %d", _type);
		LOG("userid = %d", _userid);
		LOG("touserid = %d", _touserid);
		LOG("useralias = %s", _useralias.c_str());
		LOG("userheadid = %d", _userheadid);
		LOG("commentid = %lld", _commentid);
		LOG("viewtitlelen = %d", _viewtitlelen);
		LOG("viewtextlen = %d", _viewtextlen);
		LOG("srctextlen = %d", _srctextlen);
		LOG("replytextlen = %d", _replytextlen);
		LOG("restime = %lld", _restime);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class TeacherFansResp
{

private:

	uint32	_teacherid;
	uint32	_userid;
	string	_useralias;
	uint32	_userheadid;


public:

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& useralias() { return _useralias; } const 

	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline uint32 userheadid() { return _userheadid; } const 

	 inline void set_userheadid(const uint32 value) { _userheadid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTeacherFansResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTeacherFansResp* cmd = (protocol::tag_CMDTeacherFansResp*) data;
		cmd->teacherid = _teacherid;
		cmd->userid = _userid;
		strcpy(cmd->useralias, _useralias.c_str());
		cmd->userheadid = _userheadid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTeacherFansResp* cmd = (protocol::tag_CMDTeacherFansResp*) data;
		_teacherid = cmd->teacherid;
		_userid = cmd->userid;
		_useralias = cmd->useralias;
		_userheadid = cmd->userheadid;
	}

	void Log()
	{
		LOG("--------Receive message: TeacherFansResp---------");
		LOG("teacherid = %d", _teacherid);
		LOG("userid = %d", _userid);
		LOG("useralias = %s", _useralias.c_str());
		LOG("userheadid = %d", _userheadid);
	}

};


class InterestResp
{

private:

	uint32	_userid;
	uint32	_teacherid;
	string	_teacheralias;
	uint32	_teacherheadid;
	int32	_levellen;
	int32	_labellen;
	int32	_introducelen;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 teacherheadid() { return _teacherheadid; } const 

	 inline void set_teacherheadid(const uint32 value) { _teacherheadid = value; }

	 inline int32 levellen() { return _levellen; } const 

	 inline void set_levellen(const int32 value) { _levellen = value; }

	 inline int32 labellen() { return _labellen; } const 

	 inline void set_labellen(const int32 value) { _labellen = value; }

	 inline int32 introducelen() { return _introducelen; } const 

	 inline void set_introducelen(const int32 value) { _introducelen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDInterestResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDInterestResp* cmd = (protocol::tag_CMDInterestResp*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->teacherheadid = _teacherheadid;
		cmd->levellen = _levellen;
		cmd->labellen = _labellen;
		cmd->introducelen = _introducelen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDInterestResp* cmd = (protocol::tag_CMDInterestResp*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_teacheralias = cmd->teacheralias;
		_teacherheadid = cmd->teacherheadid;
		_levellen = cmd->levellen;
		_labellen = cmd->labellen;
		_introducelen = cmd->introducelen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: InterestResp---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("teacherheadid = %d", _teacherheadid);
		LOG("levellen = %d", _levellen);
		LOG("labellen = %d", _labellen);
		LOG("introducelen = %d", _introducelen);
		LOG("content = %s", _content.c_str());
	}

};


class UnInterestResp
{

private:

	uint32	_userid;
	uint32	_teacherid;
	string	_teacheralias;
	uint32	_teacherheadid;
	int32	_levellen;
	int32	_labellen;
	int32	_goodatlen;
	int64	_answers;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 teacherheadid() { return _teacherheadid; } const 

	 inline void set_teacherheadid(const uint32 value) { _teacherheadid = value; }

	 inline int32 levellen() { return _levellen; } const 

	 inline void set_levellen(const int32 value) { _levellen = value; }

	 inline int32 labellen() { return _labellen; } const 

	 inline void set_labellen(const int32 value) { _labellen = value; }

	 inline int32 goodatlen() { return _goodatlen; } const 

	 inline void set_goodatlen(const int32 value) { _goodatlen = value; }

	 inline int64 answers() { return _answers; } const 

	 inline void set_answers(const int64 value) { _answers = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDUnInterestResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDUnInterestResp* cmd = (protocol::tag_CMDUnInterestResp*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->teacherheadid = _teacherheadid;
		cmd->levellen = _levellen;
		cmd->labellen = _labellen;
		cmd->goodatlen = _goodatlen;
		cmd->answers = _answers;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDUnInterestResp* cmd = (protocol::tag_CMDUnInterestResp*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_teacheralias = cmd->teacheralias;
		_teacherheadid = cmd->teacherheadid;
		_levellen = cmd->levellen;
		_labellen = cmd->labellen;
		_goodatlen = cmd->goodatlen;
		_answers = cmd->answers;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: UnInterestResp---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("teacherheadid = %d", _teacherheadid);
		LOG("levellen = %d", _levellen);
		LOG("labellen = %d", _labellen);
		LOG("goodatlen = %d", _goodatlen);
		LOG("answers = %lld", _answers);
		LOG("content = %s", _content.c_str());
	}

};


class TextLivePointListResp
{

private:

	uint32	_userid;
	uint32	_teacherid;
	string	_teacheralias;
	uint32	_teacherheadid;
	int64	_messageid;
	int32	_livetype;
	int32	_textlen;
	uint32	_commentstype;
	uint64	_messagetime;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 

	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 teacherheadid() { return _teacherheadid; } const 

	 inline void set_teacherheadid(const uint32 value) { _teacherheadid = value; }

	 inline int64 messageid() { return _messageid; } const 

	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 livetype() { return _livetype; } const 

	 inline void set_livetype(const int32 value) { _livetype = value; }

	 inline int32 textlen() { return _textlen; } const 

	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint32 commentstype() { return _commentstype; } const 

	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline uint64 messagetime() { return _messagetime; } const 

	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDTextLivePointListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDTextLivePointListResp* cmd = (protocol::tag_CMDTextLivePointListResp*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->teacherheadid = _teacherheadid;
		cmd->messageid = _messageid;
		cmd->livetype = _livetype;
		cmd->textlen = _textlen;
		cmd->commentstype = _commentstype;
		cmd->messagetime = _messagetime;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDTextLivePointListResp* cmd = (protocol::tag_CMDTextLivePointListResp*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_teacheralias = cmd->teacheralias;
		_teacherheadid = cmd->teacherheadid;
		_messageid = cmd->messageid;
		_livetype = cmd->livetype;
		_textlen = cmd->textlen;
		_commentstype = cmd->commentstype;
		_messagetime = cmd->messagetime;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: TextLivePointListResp---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("teacheralias = %s", _teacheralias.c_str());
		LOG("teacherheadid = %d", _teacherheadid);
		LOG("messageid = %lld", _messageid);
		LOG("livetype = %d", _livetype);
		LOG("textlen = %d", _textlen);
		LOG("commentstype = %d", _commentstype);
		LOG("messagetime = %lld", _messagetime);
		LOG("content = %s", _content.c_str());
	}

};


class HallSecretsListResp
{

private:

	int32	_secretsid;
	string	_srcalias;
	int32	_coverlittlelen;
	int32	_titlelen;
	int32	_textlen;
	uint64	_messagetime;
	string	_content;


public:

	 inline int32 secretsid() { return _secretsid; } const 

	 inline void set_secretsid(const int32 value) { _secretsid = value; }

	 inline string& srcalias() { return _srcalias; } const 

	 inline void set_srcalias(const string& value) { _srcalias = value; }

	 inline int32 coverlittlelen() { return _coverlittlelen; } const 

	 inline void set_coverlittlelen(const int32 value) { _coverlittlelen = value; }

	 inline int32 titlelen() { return _titlelen; } const 

	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 textlen() { return _textlen; } const 

	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 

	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDHallSecretsListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDHallSecretsListResp* cmd = (protocol::tag_CMDHallSecretsListResp*) data;
		cmd->secretsid = _secretsid;
		strcpy(cmd->srcalias, _srcalias.c_str());
		cmd->coverlittlelen = _coverlittlelen;
		cmd->titlelen = _titlelen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDHallSecretsListResp* cmd = (protocol::tag_CMDHallSecretsListResp*) data;
		_secretsid = cmd->secretsid;
		_srcalias = cmd->srcalias;
		_coverlittlelen = cmd->coverlittlelen;
		_titlelen = cmd->titlelen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: HallSecretsListResp---------");
		LOG("secretsid = %d", _secretsid);
		LOG("srcalias = %s", _srcalias.c_str());
		LOG("coverlittlelen = %d", _coverlittlelen);
		LOG("titlelen = %d", _titlelen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("content = %s", _content.c_str());
	}

};


class HallSystemInfoListResp
{

private:

	int32	_systeminfosid;
	int32	_titlelen;
	int32	_linklen;
	int32	_textlen;
	uint64	_messagetime;
	string	_content;


public:

	 inline int32 systeminfosid() { return _systeminfosid; } const 

	 inline void set_systeminfosid(const int32 value) { _systeminfosid = value; }

	 inline int32 titlelen() { return _titlelen; } const 

	 inline void set_titlelen(const int32 value) { _titlelen = value; }

	 inline int32 linklen() { return _linklen; } const 

	 inline void set_linklen(const int32 value) { _linklen = value; }

	 inline int32 textlen() { return _textlen; } const 

	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint64 messagetime() { return _messagetime; } const 

	 inline void set_messagetime(const uint64 value) { _messagetime = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDHallSystemInfoListResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDHallSystemInfoListResp* cmd = (protocol::tag_CMDHallSystemInfoListResp*) data;
		cmd->systeminfosid = _systeminfosid;
		cmd->titlelen = _titlelen;
		cmd->linklen = _linklen;
		cmd->textlen = _textlen;
		cmd->messagetime = _messagetime;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDHallSystemInfoListResp* cmd = (protocol::tag_CMDHallSystemInfoListResp*) data;
		_systeminfosid = cmd->systeminfosid;
		_titlelen = cmd->titlelen;
		_linklen = cmd->linklen;
		_textlen = cmd->textlen;
		_messagetime = cmd->messagetime;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: HallSystemInfoListResp---------");
		LOG("systeminfosid = %d", _systeminfosid);
		LOG("titlelen = %d", _titlelen);
		LOG("linklen = %d", _linklen);
		LOG("textlen = %d", _textlen);
		LOG("messagetime = %lld", _messagetime);
		LOG("content = %s", _content.c_str());
	}

};


class ViewAnswerReq
{

private:

	uint32	_fromid;
	uint32	_toid;
	int32	_type;
	int64	_messageid;
	int32	_textlen;
	uint32	_commentstype;
	string	_content;


public:

	 inline uint32 fromid() { return _fromid; } const 

	 inline void set_fromid(const uint32 value) { _fromid = value; }

	 inline uint32 toid() { return _toid; } const 

	 inline void set_toid(const uint32 value) { _toid = value; }

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline int64 messageid() { return _messageid; } const 

	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 textlen() { return _textlen; } const 

	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline uint32 commentstype() { return _commentstype; } const 

	 inline void set_commentstype(const uint32 value) { _commentstype = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDViewAnswerReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDViewAnswerReq* cmd = (protocol::tag_CMDViewAnswerReq*) data;
		cmd->fromid = _fromid;
		cmd->toid = _toid;
		cmd->type = _type;
		cmd->messageid = _messageid;
		cmd->textlen = _textlen;
		cmd->commentstype = _commentstype;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDViewAnswerReq* cmd = (protocol::tag_CMDViewAnswerReq*) data;
		_fromid = cmd->fromid;
		_toid = cmd->toid;
		_type = cmd->type;
		_messageid = cmd->messageid;
		_textlen = cmd->textlen;
		_commentstype = cmd->commentstype;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: ViewAnswerReq---------");
		LOG("fromid = %d", _fromid);
		LOG("toid = %d", _toid);
		LOG("type = %d", _type);
		LOG("messageid = %lld", _messageid);
		LOG("textlen = %d", _textlen);
		LOG("commentstype = %d", _commentstype);
		LOG("content = %s", _content.c_str());
	}

};


class ViewAnswerResp
{

private:

	int32	_userid;
	int32	_type;
	int64	_messageid;
	int32	_result;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }

	 inline int32 type() { return _type; } const 

	 inline void set_type(const int32 value) { _type = value; }

	 inline int64 messageid() { return _messageid; } const 

	 inline void set_messageid(const int64 value) { _messageid = value; }

	 inline int32 result() { return _result; } const 

	 inline void set_result(const int32 value) { _result = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDViewAnswerResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDViewAnswerResp* cmd = (protocol::tag_CMDViewAnswerResp*) data;
		cmd->userid = _userid;
		cmd->type = _type;
		cmd->messageid = _messageid;
		cmd->result = _result;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDViewAnswerResp* cmd = (protocol::tag_CMDViewAnswerResp*) data;
		_userid = cmd->userid;
		_type = cmd->type;
		_messageid = cmd->messageid;
		_result = cmd->result;
	}

	void Log()
	{
		LOG("--------Receive message: ViewAnswerResp---------");
		LOG("userid = %d", _userid);
		LOG("type = %d", _type);
		LOG("messageid = %lld", _messageid);
		LOG("result = %d", _result);
	}

};


class InterestForReq
{

private:

	uint32	_userid;
	uint32	_teacherid;
	int32	_optype;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline int32 optype() { return _optype; } const 

	 inline void set_optype(const int32 value) { _optype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDInterestForReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDInterestForReq* cmd = (protocol::tag_CMDInterestForReq*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDInterestForReq* cmd = (protocol::tag_CMDInterestForReq*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_optype = cmd->optype;
	}

	void Log()
	{
		LOG("--------Receive message: InterestForReq---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("optype = %d", _optype);
	}

};


class InterestForResp
{

private:

	int32	_userid;
	int32	_result;


public:

	 inline int32 userid() { return _userid; } const 

	 inline void set_userid(const int32 value) { _userid = value; }

	 inline int32 result() { return _result; } const 

	 inline void set_result(const int32 value) { _result = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDInterestForResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDInterestForResp* cmd = (protocol::tag_CMDInterestForResp*) data;
		cmd->userid = _userid;
		cmd->result = _result;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDInterestForResp* cmd = (protocol::tag_CMDInterestForResp*) data;
		_userid = cmd->userid;
		_result = cmd->result;
	}

	void Log()
	{
		LOG("--------Receive message: InterestForResp---------");
		LOG("userid = %d", _userid);
		LOG("result = %d", _result);
	}

};


class FansCountReq
{

private:

	uint32	_teacherid;


public:

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDFansCountReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDFansCountReq* cmd = (protocol::tag_CMDFansCountReq*) data;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDFansCountReq* cmd = (protocol::tag_CMDFansCountReq*) data;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: FansCountReq---------");
		LOG("teacherid = %d", _teacherid);
	}

};


class FansCountResp
{

private:

	uint32	_teacherid;
	uint64	_fanscount;


public:

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint64 fanscount() { return _fanscount; } const 

	 inline void set_fanscount(const uint64 value) { _fanscount = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDFansCountResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDFansCountResp* cmd = (protocol::tag_CMDFansCountResp*) data;
		cmd->teacherid = _teacherid;
		cmd->fansCount = _fanscount;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDFansCountResp* cmd = (protocol::tag_CMDFansCountResp*) data;
		_teacherid = cmd->teacherid;
		_fanscount = cmd->fansCount;
	}

	void Log()
	{
		LOG("--------Receive message: FansCountResp---------");
		LOG("teacherid = %d", _teacherid);
		LOG("fanscount = %lld", _fanscount);
	}

};


class SessionTokenReq
{

private:

	uint32	_userid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSessionTokenReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSessionTokenReq* cmd = (protocol::tag_CMDSessionTokenReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSessionTokenReq* cmd = (protocol::tag_CMDSessionTokenReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: SessionTokenReq---------");
		LOG("userid = %d", _userid);
	}

};


class SessionTokenResp
{

private:

	uint32	_userid;
	string	_sessiontoken;
	string	_validtime;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline string& sessiontoken() { return _sessiontoken; } const 

	 inline void set_sessiontoken(const string& value) { _sessiontoken = value; }

	 inline string& validtime() { return _validtime; } const 

	 inline void set_validtime(const string& value) { _validtime = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDSessionTokenResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDSessionTokenResp* cmd = (protocol::tag_CMDSessionTokenResp*) data;
		cmd->userid = _userid;
		strcpy(cmd->sessiontoken, _sessiontoken.c_str());
		strcpy(cmd->validtime, _validtime.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDSessionTokenResp* cmd = (protocol::tag_CMDSessionTokenResp*) data;
		_userid = cmd->userid;
		_sessiontoken = cmd->sessiontoken;
		_validtime = cmd->validtime;
	}

	void Log()
	{
		LOG("--------Receive message: SessionTokenResp---------");
		LOG("userid = %d", _userid);
		LOG("sessiontoken = %s", _sessiontoken.c_str());
		LOG("validtime = %s", _validtime.c_str());
	}

};


class QueryRoomGateAddrReq
{

private:

	uint32	_userid;
	uint32	_roomid;
	uint32	_flags;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 roomid() { return _roomid; } const 

	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline uint32 flags() { return _flags; } const 

	 inline void set_flags(const uint32 value) { _flags = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryRoomGateAddrReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryRoomGateAddrReq* cmd = (protocol::tag_CMDQueryRoomGateAddrReq*) data;
		cmd->userid = _userid;
		cmd->roomid = _roomid;
		cmd->flags = _flags;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryRoomGateAddrReq* cmd = (protocol::tag_CMDQueryRoomGateAddrReq*) data;
		_userid = cmd->userid;
		_roomid = cmd->roomid;
		_flags = cmd->flags;
	}

	void Log()
	{
		LOG("--------Receive message: QueryRoomGateAddrReq---------");
		LOG("userid = %d", _userid);
		LOG("roomid = %d", _roomid);
		LOG("flags = %d", _flags);
	}

};


class QueryRoomGateAddrResp
{

private:

	uint32	_errorid;
	uint32	_userid;
	uint32	_roomid;
	uint32	_flags;
	int32	_textlen;
	string	_content;


public:

	 inline uint32 errorid() { return _errorid; } const 

	 inline void set_errorid(const uint32 value) { _errorid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 roomid() { return _roomid; } const 

	 inline void set_roomid(const uint32 value) { _roomid = value; }

	 inline uint32 flags() { return _flags; } const 

	 inline void set_flags(const uint32 value) { _flags = value; }

	 inline int32 textlen() { return _textlen; } const 

	 inline void set_textlen(const int32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDQueryRoomGateAddrResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDQueryRoomGateAddrResp* cmd = (protocol::tag_CMDQueryRoomGateAddrResp*) data;
		cmd->errorid = _errorid;
		cmd->userid = _userid;
		cmd->roomid = _roomid;
		cmd->flags = _flags;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDQueryRoomGateAddrResp* cmd = (protocol::tag_CMDQueryRoomGateAddrResp*) data;
		_errorid = cmd->errorid;
		_userid = cmd->userid;
		_roomid = cmd->roomid;
		_flags = cmd->flags;
		_textlen = cmd->textlen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: QueryRoomGateAddrResp---------");
		LOG("errorid = %d", _errorid);
		LOG("userid = %d", _userid);
		LOG("roomid = %d", _roomid);
		LOG("flags = %d", _flags);
		LOG("textlen = %d", _textlen);
		LOG("content = %s", _content.c_str());
	}

};


class ConfigSvrNoty
{

private:

	uint32	_type;
	uint32	_data_ver;


public:

	 inline uint32 type() { return _type; } const 

	 inline void set_type(const uint32 value) { _type = value; }

	 inline uint32 data_ver() { return _data_ver; } const 

	 inline void set_data_ver(const uint32 value) { _data_ver = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDConfigSvrNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDConfigSvrNoty* cmd = (protocol::tag_CMDConfigSvrNoty*) data;
		cmd->type = _type;
		cmd->data_ver = _data_ver;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDConfigSvrNoty* cmd = (protocol::tag_CMDConfigSvrNoty*) data;
		_type = cmd->type;
		_data_ver = cmd->data_ver;
	}

	void Log()
	{
		LOG("--------Receive message: ConfigSvrNoty---------");
		LOG("type = %d", _type);
		LOG("data_ver = %d", _data_ver);
	}

};


class PushGateMask
{

private:

	uint32	_userid;
	uint32	_termtype;
	uint32	_type;
	uint32	_needresp;
	uint32	_validtime;
	uint32	_versionflag;
	uint32	_version;
	uint32	_length;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 termtype() { return _termtype; } const 

	 inline void set_termtype(const uint32 value) { _termtype = value; }

	 inline uint32 type() { return _type; } const 

	 inline void set_type(const uint32 value) { _type = value; }

	 inline uint32 needresp() { return _needresp; } const 

	 inline void set_needresp(const uint32 value) { _needresp = value; }

	 inline uint32 validtime() { return _validtime; } const 

	 inline void set_validtime(const uint32 value) { _validtime = value; }

	 inline uint32 versionflag() { return _versionflag; } const 

	 inline void set_versionflag(const uint32 value) { _versionflag = value; }

	 inline uint32 version() { return _version; } const 

	 inline void set_version(const uint32 value) { _version = value; }

	 inline uint32 length() { return _length; } const 

	 inline void set_length(const uint32 value) { _length = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDPushGateMask); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDPushGateMask* cmd = (protocol::tag_CMDPushGateMask*) data;
		cmd->userid = _userid;
		cmd->termtype = _termtype;
		cmd->type = _type;
		cmd->needresp = _needresp;
		cmd->validtime = _validtime;
		cmd->versionflag = _versionflag;
		cmd->version = _version;
		cmd->length = _length;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDPushGateMask* cmd = (protocol::tag_CMDPushGateMask*) data;
		_userid = cmd->userid;
		_termtype = cmd->termtype;
		_type = cmd->type;
		_needresp = cmd->needresp;
		_validtime = cmd->validtime;
		_versionflag = cmd->versionflag;
		_version = cmd->version;
		_length = cmd->length;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: PushGateMask---------");
		LOG("userid = %d", _userid);
		LOG("termtype = %d", _termtype);
		LOG("type = %d", _type);
		LOG("needresp = %d", _needresp);
		LOG("validtime = %d", _validtime);
		LOG("versionflag = %d", _versionflag);
		LOG("version = %d", _version);
		LOG("length = %d", _length);
		LOG("content = %s", _content.c_str());
	}

};


class BayWindow
{

private:

	uint32	_ntime;
	string	_title;
	uint32	_contlen;
	uint32	_urllen;
	string	_content;


public:

	 inline uint32 ntime() { return _ntime; } const 

	 inline void set_ntime(const uint32 value) { _ntime = value; }

	 inline string& title() { return _title; } const 

	 inline void set_title(const string& value) { _title = value; }

	 inline uint32 contlen() { return _contlen; } const 

	 inline void set_contlen(const uint32 value) { _contlen = value; }

	 inline uint32 urllen() { return _urllen; } const 

	 inline void set_urllen(const uint32 value) { _urllen = value; }

	 inline string& content() { return _content; } const 

	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDBayWindow); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDBayWindow* cmd = (protocol::tag_CMDBayWindow*) data;
		cmd->ntime = _ntime;
		strcpy(cmd->title, _title.c_str());
		cmd->contlen = _contlen;
		cmd->urllen = _urllen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDBayWindow* cmd = (protocol::tag_CMDBayWindow*) data;
		_ntime = cmd->ntime;
		_title = cmd->title;
		_contlen = cmd->contlen;
		_urllen = cmd->urllen;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: BayWindow---------");
		LOG("ntime = %d", _ntime);
		LOG("title = %s", _title.c_str());
		LOG("contlen = %d", _contlen);
		LOG("urllen = %d", _urllen);
		LOG("content = %s", _content.c_str());
	}

};


class GetUserMoreInfReq
{

private:

	uint32	_userid;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetUserMoreInfReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetUserMoreInfReq* cmd = (protocol::tag_CMDGetUserMoreInfReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetUserMoreInfReq* cmd = (protocol::tag_CMDGetUserMoreInfReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: GetUserMoreInfReq---------");
		LOG("userid = %d", _userid);
	}

};


class GetUserMoreInfResp
{

private:

	string	_tel;
	string	_birth;
	string	_email;
	int32	_autographlen;
	string	_autograph;


public:

	 inline string& tel() { return _tel; } const 

	 inline void set_tel(const string& value) { _tel = value; }

	 inline string& birth() { return _birth; } const 

	 inline void set_birth(const string& value) { _birth = value; }

	 inline string& email() { return _email; } const 

	 inline void set_email(const string& value) { _email = value; }

	 inline int32 autographlen() { return _autographlen; } const 

	 inline void set_autographlen(const int32 value) { _autographlen = value; }

	 inline string& autograph() { return _autograph; } const 

	 inline void set_autograph(const string& value) { _autograph = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDGetUserMoreInfResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDGetUserMoreInfResp* cmd = (protocol::tag_CMDGetUserMoreInfResp*) data;
		strcpy(cmd->tel, _tel.c_str());
		strcpy(cmd->birth, _birth.c_str());
		strcpy(cmd->email, _email.c_str());
		cmd->autographlen = _autographlen;
		strcpy(cmd->autograph, _autograph.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDGetUserMoreInfResp* cmd = (protocol::tag_CMDGetUserMoreInfResp*) data;
		_tel = cmd->tel;
		_birth = cmd->birth;
		_email = cmd->email;
		_autographlen = cmd->autographlen;
		_autograph = cmd->autograph;
	}

	void Log()
	{
		LOG("--------Receive message: GetUserMoreInfResp---------");
		LOG("tel = %s", _tel.c_str());
		LOG("birth = %s", _birth.c_str());
		LOG("email = %s", _email.c_str());
		LOG("autographlen = %d", _autographlen);
		LOG("autograph = %s", _autograph.c_str());
	}

};


class RoomTeacherOnMicResp
{

private:

	uint32	_teacherid;
	uint32	_vcbid;
	string	_alias;


public:

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline string& alias() { return _alias; } const 

	 inline void set_alias(const string& value) { _alias = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDRoomTeacherOnMicResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDRoomTeacherOnMicResp* cmd = (protocol::tag_CMDRoomTeacherOnMicResp*) data;
		cmd->teacherid = _teacherid;
		cmd->vcbid = _vcbid;
		strcpy(cmd->alias, _alias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDRoomTeacherOnMicResp* cmd = (protocol::tag_CMDRoomTeacherOnMicResp*) data;
		_teacherid = cmd->teacherid;
		_vcbid = cmd->vcbid;
		_alias = cmd->alias;
	}

	void Log()
	{
		LOG("--------Receive message: RoomTeacherOnMicResp---------");
		LOG("teacherid = %d", _teacherid);
		LOG("vcbid = %d", _vcbid);
		LOG("alias = %s", _alias.c_str());
	}

};


class HitGoldEggClientNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint64	_money;


public:

	 inline uint32 vcbid() { return _vcbid; } const 

	 inline void set_vcbid(const uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint64 money() { return _money; } const 

	 inline void set_money(const uint64 value) { _money = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDHitGoldEggClientNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDHitGoldEggClientNoty* cmd = (protocol::tag_CMDHitGoldEggClientNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->money = _money;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDHitGoldEggClientNoty* cmd = (protocol::tag_CMDHitGoldEggClientNoty*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_money = cmd->money;
	}

	void Log()
	{
		LOG("--------Receive message: HitGoldEggClientNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("money = %lld", _money);
	}

};


class BuyPrivateVipReq
{

private:

	uint32	_userid;
	uint32	_teacherid;
	uint32	_viptype;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 viptype() { return _viptype; } const 

	 inline void set_viptype(const uint32 value) { _viptype = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDBuyPrivateVipReq); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDBuyPrivateVipReq* cmd = (protocol::tag_CMDBuyPrivateVipReq*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->viptype = _viptype;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDBuyPrivateVipReq* cmd = (protocol::tag_CMDBuyPrivateVipReq*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_viptype = cmd->viptype;
	}

	void Log()
	{
		LOG("--------Receive message: BuyPrivateVipReq---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("viptype = %d", _viptype);
	}

};


class BuyPrivateVipResp
{

private:

	uint32	_userid;
	uint32	_teacherid;
	uint32	_viptype;
	uint64	_nk;


public:

	 inline uint32 userid() { return _userid; } const 

	 inline void set_userid(const uint32 value) { _userid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 

	 inline void set_teacherid(const uint32 value) { _teacherid = value; }

	 inline uint32 viptype() { return _viptype; } const 

	 inline void set_viptype(const uint32 value) { _viptype = value; }

	 inline uint64 nk() { return _nk; } const 

	 inline void set_nk(const uint64 value) { _nk = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDBuyPrivateVipResp); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDBuyPrivateVipResp* cmd = (protocol::tag_CMDBuyPrivateVipResp*) data;
		cmd->userid = _userid;
		cmd->teacherid = _teacherid;
		cmd->viptype = _viptype;
		cmd->nk = _nk;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDBuyPrivateVipResp* cmd = (protocol::tag_CMDBuyPrivateVipResp*) data;
		_userid = cmd->userid;
		_teacherid = cmd->teacherid;
		_viptype = cmd->viptype;
		_nk = cmd->nk;
	}

	void Log()
	{
		LOG("--------Receive message: BuyPrivateVipResp---------");
		LOG("userid = %d", _userid);
		LOG("teacherid = %d", _teacherid);
		LOG("viptype = %d", _viptype);
		LOG("nk = %lld", _nk);
	}

};


class EmailNewMsgNoty
{

private:

	uint32	_bemailtype;
	uint32	_messageid;


public:

	 inline uint32 bemailtype() { return _bemailtype; } const 

	 inline void set_bemailtype(const uint32 value) { _bemailtype = value; }

	 inline uint32 messageid() { return _messageid; } const 

	 inline void set_messageid(const uint32 value) { _messageid = value; }


	int ByteSize() { return sizeof(protocol::tag_CMDEmailNewMsgNoty); }

	void SerializeToArray(void* data, int size)
	{
		protocol::tag_CMDEmailNewMsgNoty* cmd = (protocol::tag_CMDEmailNewMsgNoty*) data;
		cmd->bEmailType = _bemailtype;
		cmd->messageid = _messageid;
	}

	void ParseFromArray(void* data, int size)
	{
		protocol::tag_CMDEmailNewMsgNoty* cmd = (protocol::tag_CMDEmailNewMsgNoty*) data;
		_bemailtype = cmd->bEmailType;
		_messageid = cmd->messageid;
	}

	void Log()
	{
		LOG("--------Receive message: EmailNewMsgNoty---------");
		LOG("bemailtype = %d", _bemailtype);
		LOG("messageid = %d", _messageid);
	}

};







#endif
