#ifndef _LOGIN_MESSAGE_H_
#define _LOGIN_MESSAGE_H_



#include <string>
#include "Log.h"
#include "cmd_vchat.h"
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 nversion() { return _nversion; } const 
	 inline void set_nversion(uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 
	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 
	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 
	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 
	 inline void set_nimstate(uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 
	 inline void set_nmobile(uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonReq* cmd = (tag_CMDUserLogonReq*) data;
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
		tag_CMDUserLogonReq* cmd = (tag_CMDUserLogonReq*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 nversion() { return _nversion; } const 
	 inline void set_nversion(uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 
	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 
	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 
	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 
	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 
	 inline void set_nimstate(uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 
	 inline void set_nmobile(uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonReq2); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonReq2* cmd = (tag_CMDUserLogonReq2*) data;
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
		tag_CMDUserLogonReq2* cmd = (tag_CMDUserLogonReq2*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 nversion() { return _nversion; } const 
	 inline void set_nversion(uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 
	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 
	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 
	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 
	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 
	 inline void set_nimstate(uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 
	 inline void set_nmobile(uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonReq3); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonReq3* cmd = (tag_CMDUserLogonReq3*) data;
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
		tag_CMDUserLogonReq3* cmd = (tag_CMDUserLogonReq3*) data;
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
	 inline void set_nmessageid(uint32 value) { _nmessageid = value; }

	 inline string& cloginid() { return _cloginid; } const 
	 inline void set_cloginid(const string& value) { _cloginid = value; }

	 inline uint32 nversion() { return _nversion; } const 
	 inline void set_nversion(uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline string& cuserpwd() { return _cuserpwd; } const 
	 inline void set_cuserpwd(const string& value) { _cuserpwd = value; }

	 inline string& cserial() { return _cserial; } const 
	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 
	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 
	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 
	 inline void set_nimstate(uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 
	 inline void set_nmobile(uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonReq4); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonReq4* cmd = (tag_CMDUserLogonReq4*) data;
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
		tag_CMDUserLogonReq4* cmd = (tag_CMDUserLogonReq4*) data;
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
	 inline void set_nmessageid(uint32 value) { _nmessageid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline string& openid() { return _openid; } const 
	 inline void set_openid(const string& value) { _openid = value; }

	 inline string& opentoken() { return _opentoken; } const 
	 inline void set_opentoken(const string& value) { _opentoken = value; }

	 inline uint32 platformtype() { return _platformtype; } const 
	 inline void set_platformtype(uint32 value) { _platformtype = value; }

	 inline uint32 nversion() { return _nversion; } const 
	 inline void set_nversion(uint32 value) { _nversion = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline string& cserial() { return _cserial; } const 
	 inline void set_cserial(const string& value) { _cserial = value; }

	 inline string& cmacaddr() { return _cmacaddr; } const 
	 inline void set_cmacaddr(const string& value) { _cmacaddr = value; }

	 inline string& cipaddr() { return _cipaddr; } const 
	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline uint32 nimstate() { return _nimstate; } const 
	 inline void set_nimstate(uint32 value) { _nimstate = value; }

	 inline uint32 nmobile() { return _nmobile; } const 
	 inline void set_nmobile(uint32 value) { _nmobile = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonReq5); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonReq5* cmd = (tag_CMDUserLogonReq5*) data;
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
		tag_CMDUserLogonReq5* cmd = (tag_CMDUserLogonReq5*) data;
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
	 inline void set_errid(uint32 value) { _errid = value; }

	 inline uint32 data1() { return _data1; } const 
	 inline void set_data1(uint32 value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 
	 inline void set_data2(uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonErr); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonErr* cmd = (tag_CMDUserLogonErr*) data;
		cmd->errid = _errid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserLogonErr* cmd = (tag_CMDUserLogonErr*) data;
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
	 inline void set_nmessageid(uint32 value) { _nmessageid = value; }

	 inline uint32 errid() { return _errid; } const 
	 inline void set_errid(uint32 value) { _errid = value; }

	 inline uint32 data1() { return _data1; } const 
	 inline void set_data1(uint32 value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 
	 inline void set_data2(uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonErr2); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonErr2* cmd = (tag_CMDUserLogonErr2*) data;
		cmd->nmessageid = _nmessageid;
		cmd->errid = _errid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserLogonErr2* cmd = (tag_CMDUserLogonErr2*) data;
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
	 inline void set_qxid(uint32 value) { _qxid = value; }

	 inline uint32 qxtype() { return _qxtype; } const 
	 inline void set_qxtype(uint32 value) { _qxtype = value; }

	 inline uint32 srclevel() { return _srclevel; } const 
	 inline void set_srclevel(uint32 value) { _srclevel = value; }

	 inline uint32 tolevel() { return _tolevel; } const 
	 inline void set_tolevel(uint32 value) { _tolevel = value; }


	int ByteSize() { return sizeof(tag_CMDUserQuanxianInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserQuanxianInfo* cmd = (tag_CMDUserQuanxianInfo*) data;
		cmd->qxid = _qxid;
		cmd->qxtype = _qxtype;
		cmd->srclevel = _srclevel;
		cmd->tolevel = _tolevel;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserQuanxianInfo* cmd = (tag_CMDUserQuanxianInfo*) data;
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
	 inline void set_nk(int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 
	 inline void set_nb(int64 value) { _nb = value; }

	 inline int64 nd() { return _nd; } const 
	 inline void set_nd(int64 value) { _nd = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 langid() { return _langid; } const 
	 inline void set_langid(uint32 value) { _langid = value; }

	 inline uint32 langidexptime() { return _langidexptime; } const 
	 inline void set_langidexptime(uint32 value) { _langidexptime = value; }

	 inline uint32 servertime() { return _servertime; } const 
	 inline void set_servertime(uint32 value) { _servertime = value; }

	 inline uint32 version() { return _version; } const 
	 inline void set_version(uint32 value) { _version = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(uint32 value) { _headid = value; }

	 inline uint32 viplevel() { return _viplevel; } const 
	 inline void set_viplevel(uint32 value) { _viplevel = value; }

	 inline uint32 yiyuanlevel() { return _yiyuanlevel; } const 
	 inline void set_yiyuanlevel(uint32 value) { _yiyuanlevel = value; }

	 inline uint32 shoufulevel() { return _shoufulevel; } const 
	 inline void set_shoufulevel(uint32 value) { _shoufulevel = value; }

	 inline uint32 zhonglevel() { return _zhonglevel; } const 
	 inline void set_zhonglevel(uint32 value) { _zhonglevel = value; }

	 inline uint32 caifulevel() { return _caifulevel; } const 
	 inline void set_caifulevel(uint32 value) { _caifulevel = value; }

	 inline uint32 lastmonthcostlevel() { return _lastmonthcostlevel; } const 
	 inline void set_lastmonthcostlevel(uint32 value) { _lastmonthcostlevel = value; }

	 inline uint32 thismonthcostlevel() { return _thismonthcostlevel; } const 
	 inline void set_thismonthcostlevel(uint32 value) { _thismonthcostlevel = value; }

	 inline uint32 thismonthcostgrade() { return _thismonthcostgrade; } const 
	 inline void set_thismonthcostgrade(uint32 value) { _thismonthcostgrade = value; }

	 inline uint32 ngender() { return _ngender; } const 
	 inline void set_ngender(uint32 value) { _ngender = value; }

	 inline uint32 blangidexp() { return _blangidexp; } const 
	 inline void set_blangidexp(uint32 value) { _blangidexp = value; }

	 inline uint32 bxiaoshou() { return _bxiaoshou; } const 
	 inline void set_bxiaoshou(uint32 value) { _bxiaoshou = value; }

	 inline string& cuseralias() { return _cuseralias; } const 
	 inline void set_cuseralias(const string& value) { _cuseralias = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonSuccess); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonSuccess* cmd = (tag_CMDUserLogonSuccess*) data;
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
		tag_CMDUserLogonSuccess* cmd = (tag_CMDUserLogonSuccess*) data;
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
		LOG("nk = %d", _nk);
		LOG("nb = %d", _nb);
		LOG("nd = %d", _nd);
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
	 inline void set_nmessageid(uint32 value) { _nmessageid = value; }

	 inline int64 nk() { return _nk; } const 
	 inline void set_nk(int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 
	 inline void set_nb(int64 value) { _nb = value; }

	 inline int64 nd() { return _nd; } const 
	 inline void set_nd(int64 value) { _nd = value; }

	 inline uint32 nmask() { return _nmask; } const 
	 inline void set_nmask(uint32 value) { _nmask = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 langid() { return _langid; } const 
	 inline void set_langid(uint32 value) { _langid = value; }

	 inline uint32 langidexptime() { return _langidexptime; } const 
	 inline void set_langidexptime(uint32 value) { _langidexptime = value; }

	 inline uint32 servertime() { return _servertime; } const 
	 inline void set_servertime(uint32 value) { _servertime = value; }

	 inline uint32 version() { return _version; } const 
	 inline void set_version(uint32 value) { _version = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(uint32 value) { _headid = value; }

	 inline uint32 viplevel() { return _viplevel; } const 
	 inline void set_viplevel(uint32 value) { _viplevel = value; }

	 inline uint32 yiyuanlevel() { return _yiyuanlevel; } const 
	 inline void set_yiyuanlevel(uint32 value) { _yiyuanlevel = value; }

	 inline uint32 shoufulevel() { return _shoufulevel; } const 
	 inline void set_shoufulevel(uint32 value) { _shoufulevel = value; }

	 inline uint32 zhonglevel() { return _zhonglevel; } const 
	 inline void set_zhonglevel(uint32 value) { _zhonglevel = value; }

	 inline uint32 caifulevel() { return _caifulevel; } const 
	 inline void set_caifulevel(uint32 value) { _caifulevel = value; }

	 inline uint32 lastmonthcostlevel() { return _lastmonthcostlevel; } const 
	 inline void set_lastmonthcostlevel(uint32 value) { _lastmonthcostlevel = value; }

	 inline uint32 thismonthcostlevel() { return _thismonthcostlevel; } const 
	 inline void set_thismonthcostlevel(uint32 value) { _thismonthcostlevel = value; }

	 inline uint32 thismonthcostgrade() { return _thismonthcostgrade; } const 
	 inline void set_thismonthcostgrade(uint32 value) { _thismonthcostgrade = value; }

	 inline uint32 ngender() { return _ngender; } const 
	 inline void set_ngender(uint32 value) { _ngender = value; }

	 inline uint32 blangidexp() { return _blangidexp; } const 
	 inline void set_blangidexp(uint32 value) { _blangidexp = value; }

	 inline uint32 bxiaoshou() { return _bxiaoshou; } const 
	 inline void set_bxiaoshou(uint32 value) { _bxiaoshou = value; }

	 inline string& cuseralias() { return _cuseralias; } const 
	 inline void set_cuseralias(const string& value) { _cuseralias = value; }

	 inline uint32 nloginflag() { return _nloginflag; } const 
	 inline void set_nloginflag(uint32 value) { _nloginflag = value; }

	 inline uint32 bloginsource() { return _bloginsource; } const 
	 inline void set_bloginsource(uint32 value) { _bloginsource = value; }

	 inline uint32 bboundtel() { return _bboundtel; } const 
	 inline void set_bboundtel(uint32 value) { _bboundtel = value; }

	 inline string& csid() { return _csid; } const 
	 inline void set_csid(const string& value) { _csid = value; }


	int ByteSize() { return sizeof(tag_CMDUserLogonSuccess2); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserLogonSuccess2* cmd = (tag_CMDUserLogonSuccess2*) data;
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
		tag_CMDUserLogonSuccess2* cmd = (tag_CMDUserLogonSuccess2*) data;
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
		LOG("nk = %d", _nk);
		LOG("nb = %d", _nb);
		LOG("nd = %d", _nd);
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


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(uint32 value) { _headid = value; }

	 inline uint32 ngender() { return _ngender; } const 
	 inline void set_ngender(uint32 value) { _ngender = value; }

	 inline string& cbirthday() { return _cbirthday; } const 
	 inline void set_cbirthday(const string& value) { _cbirthday = value; }

	 inline string& cuseralias() { return _cuseralias; } const 
	 inline void set_cuseralias(const string& value) { _cuseralias = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserProfileReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserProfileReq* cmd = (tag_CMDSetUserProfileReq*) data;
		cmd->userid = _userid;
		cmd->headid = _headid;
		cmd->ngender = _ngender;
		strcpy(cmd->cbirthday, _cbirthday.c_str());
		strcpy(cmd->cuseralias, _cuseralias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserProfileReq* cmd = (tag_CMDSetUserProfileReq*) data;
		_userid = cmd->userid;
		_headid = cmd->headid;
		_ngender = cmd->ngender;
		_cbirthday = cmd->cbirthday;
		_cuseralias = cmd->cuseralias;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserProfileReq---------");
		LOG("userid = %d", _userid);
		LOG("headid = %d", _headid);
		LOG("ngender = %d", _ngender);
		LOG("cbirthday = %s", _cbirthday.c_str());
		LOG("cuseralias = %s", _cuseralias.c_str());
	}

};


class SetUserProfileResp
{

private:

	uint32	_userid;
	int32	_errorid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserProfileResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserProfileResp* cmd = (tag_CMDSetUserProfileResp*) data;
		cmd->userid = _userid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserProfileResp* cmd = (tag_CMDSetUserProfileResp*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 pwdtype() { return _pwdtype; } const 
	 inline void set_pwdtype(uint32 value) { _pwdtype = value; }

	 inline string& oldpwd() { return _oldpwd; } const 
	 inline void set_oldpwd(const string& value) { _oldpwd = value; }

	 inline string& newpwd() { return _newpwd; } const 
	 inline void set_newpwd(const string& value) { _newpwd = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserPwdReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserPwdReq* cmd = (tag_CMDSetUserPwdReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->pwdtype = _pwdtype;
		strcpy(cmd->oldpwd, _oldpwd.c_str());
		strcpy(cmd->newpwd, _newpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserPwdReq* cmd = (tag_CMDSetUserPwdReq*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }

	 inline uint32 pwdtype() { return _pwdtype; } const 
	 inline void set_pwdtype(uint32 value) { _pwdtype = value; }

	 inline string& cnewpwd() { return _cnewpwd; } const 
	 inline void set_cnewpwd(const string& value) { _cnewpwd = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserPwdResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserPwdResp* cmd = (tag_CMDSetUserPwdResp*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
		cmd->pwdtype = _pwdtype;
		strcpy(cmd->cnewpwd, _cnewpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserPwdResp* cmd = (tag_CMDSetUserPwdResp*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDRoomGroupListReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomGroupListReq* cmd = (tag_CMDRoomGroupListReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomGroupListReq* cmd = (tag_CMDRoomGroupListReq*) data;
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
	 inline void set_grouid(uint32 value) { _grouid = value; }

	 inline uint32 parentid() { return _parentid; } const 
	 inline void set_parentid(uint32 value) { _parentid = value; }

	 inline int32 usernum() { return _usernum; } const 
	 inline void set_usernum(int32 value) { _usernum = value; }

	 inline uint32 textcolor() { return _textcolor; } const 
	 inline void set_textcolor(uint32 value) { _textcolor = value; }

	 inline uint32 reserve_1() { return _reserve_1; } const 
	 inline void set_reserve_1(uint32 value) { _reserve_1 = value; }

	 inline uint32 showusernum() { return _showusernum; } const 
	 inline void set_showusernum(uint32 value) { _showusernum = value; }

	 inline uint32 urllength() { return _urllength; } const 
	 inline void set_urllength(uint32 value) { _urllength = value; }

	 inline uint32 bfontbold() { return _bfontbold; } const 
	 inline void set_bfontbold(uint32 value) { _bfontbold = value; }

	 inline string& cgroupname() { return _cgroupname; } const 
	 inline void set_cgroupname(const string& value) { _cgroupname = value; }

	 inline string& clienticonname() { return _clienticonname; } const 
	 inline void set_clienticonname(const string& value) { _clienticonname = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDRoomGroupItem); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomGroupItem* cmd = (tag_CMDRoomGroupItem*) data;
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
		tag_CMDRoomGroupItem* cmd = (tag_CMDRoomGroupItem*) data;
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
	 inline void set_grouid(uint32 value) { _grouid = value; }

	 inline uint32 usernum() { return _usernum; } const 
	 inline void set_usernum(uint32 value) { _usernum = value; }


	int ByteSize() { return sizeof(tag_CMDRoomGroupStatus); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomGroupStatus* cmd = (tag_CMDRoomGroupStatus*) data;
		cmd->grouid = _grouid;
		cmd->usernum = _usernum;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomGroupStatus* cmd = (tag_CMDRoomGroupStatus*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 ntype() { return _ntype; } const 
	 inline void set_ntype(uint32 value) { _ntype = value; }

	 inline uint32 nvcbcount() { return _nvcbcount; } const 
	 inline void set_nvcbcount(uint32 value) { _nvcbcount = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDRoomListReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomListReq* cmd = (tag_CMDRoomListReq*) data;
		cmd->userid = _userid;
		cmd->ntype = _ntype;
		cmd->nvcbcount = _nvcbcount;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomListReq* cmd = (tag_CMDRoomListReq*) data;
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
	 inline void set_roomid(uint32 value) { _roomid = value; }

	 inline uint32 creatorid() { return _creatorid; } const 
	 inline void set_creatorid(uint32 value) { _creatorid = value; }

	 inline uint32 groupid() { return _groupid; } const 
	 inline void set_groupid(uint32 value) { _groupid = value; }

	 inline uint32 flag() { return _flag; } const 
	 inline void set_flag(uint32 value) { _flag = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& croompic() { return _croompic; } const 
	 inline void set_croompic(const string& value) { _croompic = value; }

	 inline string& croomaddr() { return _croomaddr; } const 
	 inline void set_croomaddr(const string& value) { _croomaddr = value; }


	int ByteSize() { return sizeof(tag_CMDRoomItem); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomItem* cmd = (tag_CMDRoomItem*) data;
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
		tag_CMDRoomItem* cmd = (tag_CMDRoomItem*) data;
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


class JoinRoomReq1
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


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 devtype() { return _devtype; } const 
	 inline void set_devtype(uint32 value) { _devtype = value; }

	 inline uint32 time() { return _time; } const 
	 inline void set_time(uint32 value) { _time = value; }

	 inline uint32 crc32() { return _crc32; } const 
	 inline void set_crc32(uint32 value) { _crc32 = value; }

	 inline uint32 coremessagever() { return _coremessagever; } const 
	 inline void set_coremessagever(uint32 value) { _coremessagever = value; }

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


	int ByteSize() { return sizeof(CMDJoinRoomReq1_t); }

	void SerializeToArray(void* data, int size)
	{
		CMDJoinRoomReq1_t* cmd = (CMDJoinRoomReq1_t*) data;
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
	}

	void ParseFromArray(void* data, int size)
	{
		CMDJoinRoomReq1_t* cmd = (CMDJoinRoomReq1_t*) data;
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
	}

	void Log()
	{
		LOG("--------Receive message: JoinRoomReq1---------");
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
	}

};


class JoinRoomReq
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


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 devtype() { return _devtype; } const 
	 inline void set_devtype(uint32 value) { _devtype = value; }

	 inline uint32 time() { return _time; } const 
	 inline void set_time(uint32 value) { _time = value; }

	 inline uint32 crc32() { return _crc32; } const 
	 inline void set_crc32(uint32 value) { _crc32 = value; }

	 inline uint32 coremessagever() { return _coremessagever; } const 
	 inline void set_coremessagever(uint32 value) { _coremessagever = value; }

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


	int ByteSize() { return sizeof(CMDJoinRoomReq_t); }

	void SerializeToArray(void* data, int size)
	{
		CMDJoinRoomReq_t* cmd = (CMDJoinRoomReq_t*) data;
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
	}

	void ParseFromArray(void* data, int size)
	{
		CMDJoinRoomReq_t* cmd = (CMDJoinRoomReq_t*) data;
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
	}

	void Log()
	{
		LOG("--------Receive message: JoinRoomReq---------");
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 devtype() { return _devtype; } const 
	 inline void set_devtype(uint32 value) { _devtype = value; }

	 inline uint32 time() { return _time; } const 
	 inline void set_time(uint32 value) { _time = value; }

	 inline uint32 crc32() { return _crc32; } const 
	 inline void set_crc32(uint32 value) { _crc32 = value; }

	 inline uint32 coremessagever() { return _coremessagever; } const 
	 inline void set_coremessagever(uint32 value) { _coremessagever = value; }

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
	 inline void set_bloginsource(uint32 value) { _bloginsource = value; }

	 inline uint32 reserve1() { return _reserve1; } const 
	 inline void set_reserve1(uint32 value) { _reserve1 = value; }

	 inline uint32 reserve2() { return _reserve2; } const 
	 inline void set_reserve2(uint32 value) { _reserve2 = value; }


	int ByteSize() { return sizeof(CMDJoinRoomReq2_t); }

	void SerializeToArray(void* data, int size)
	{
		CMDJoinRoomReq2_t* cmd = (CMDJoinRoomReq2_t*) data;
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
		CMDJoinRoomReq2_t* cmd = (CMDJoinRoomReq2_t*) data;
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


class GateJoinRoomReq
{

private:

	uint32	_userid;
	uint32	_vcbid;
	string	_cipaddr;
	string	_uuid;
	uint32	_devtype;
	uint32	_micuserid;
	uint32	_micstate;
	uint32	_micindex;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline string& cipaddr() { return _cipaddr; } const 
	 inline void set_cipaddr(const string& value) { _cipaddr = value; }

	 inline string& uuid() { return _uuid; } const 
	 inline void set_uuid(const string& value) { _uuid = value; }

	 inline uint32 devtype() { return _devtype; } const 
	 inline void set_devtype(uint32 value) { _devtype = value; }

	 inline uint32 micuserid() { return _micuserid; } const 
	 inline void set_micuserid(uint32 value) { _micuserid = value; }

	 inline uint32 micstate() { return _micstate; } const 
	 inline void set_micstate(uint32 value) { _micstate = value; }

	 inline uint32 micindex() { return _micindex; } const 
	 inline void set_micindex(uint32 value) { _micindex = value; }


	int ByteSize() { return sizeof(CMDGateJoinRoomReq_t); }

	void SerializeToArray(void* data, int size)
	{
		CMDGateJoinRoomReq_t* cmd = (CMDGateJoinRoomReq_t*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
//		strcpy(cmd->cIpAddr, _cipaddr.c_str());
//		strcpy(cmd->uuid, _uuid.c_str());
//		cmd->devtype = _devtype;
//		cmd->micuserid = _micuserid;
//		cmd->micstate = _micstate;
//		cmd->micindex = _micindex;
	}

	void ParseFromArray(void* data, int size)
	{
		CMDGateJoinRoomReq_t* cmd = (CMDGateJoinRoomReq_t*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
//		_cipaddr = cmd->cIpAddr;
//		_uuid = cmd->uuid;
//		_devtype = cmd->devtype;
//		_micuserid = cmd->micuserid;
//		_micstate = cmd->micstate;
//		_micindex = cmd->micindex;
	}

	void Log()
	{
		LOG("--------Receive message: GateJoinRoomReq---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("cipaddr = %s", _cipaddr.c_str());
		LOG("uuid = %s", _uuid.c_str());
		LOG("devtype = %d", _devtype);
		LOG("micuserid = %d", _micuserid);
		LOG("micstate = %d", _micstate);
		LOG("micindex = %d", _micindex);
	}

};


class SiegeInfo
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_giftid;
	uint32	_count;
	uint32	_time;
	string	_srcalias;
	string	_toalias;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline uint32 count() { return _count; } const 
	 inline void set_count(uint32 value) { _count = value; }

	 inline uint32 time() { return _time; } const 
	 inline void set_time(uint32 value) { _time = value; }

	 inline string& srcalias() { return _srcalias; } const 
	 inline void set_srcalias(const string& value) { _srcalias = value; }

	 inline string& toalias() { return _toalias; } const 
	 inline void set_toalias(const string& value) { _toalias = value; }


	int ByteSize() { return sizeof(tag_SiegeInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_SiegeInfo* cmd = (tag_SiegeInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->giftid = _giftid;
		cmd->count = _count;
		cmd->time = _time;
		strcpy(cmd->srcalias, _srcalias.c_str());
		strcpy(cmd->toalias, _toalias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_SiegeInfo* cmd = (tag_SiegeInfo*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_giftid = cmd->giftid;
		_count = cmd->count;
		_time = cmd->time;
		_srcalias = cmd->srcalias;
		_toalias = cmd->toalias;
	}

	void Log()
	{
		LOG("--------Receive message: SiegeInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("giftid = %d", _giftid);
		LOG("count = %d", _count);
		LOG("time = %d", _time);
		LOG("srcalias = %s", _srcalias.c_str());
		LOG("toalias = %s", _toalias.c_str());
	}

};


class JoinRoomResp
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_roomtype;
	uint32	_flags;
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


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 roomtype() { return _roomtype; } const 
	 inline void set_roomtype(uint32 value) { _roomtype = value; }

	 inline uint32 flags() { return _flags; } const 
	 inline void set_flags(uint32 value) { _flags = value; }

	 inline uint32 seats() { return _seats; } const 
	 inline void set_seats(uint32 value) { _seats = value; }

	 inline uint32 groupid() { return _groupid; } const 
	 inline void set_groupid(uint32 value) { _groupid = value; }

	 inline uint32 runstate() { return _runstate; } const 
	 inline void set_runstate(uint32 value) { _runstate = value; }

	 inline uint32 creatorid() { return _creatorid; } const 
	 inline void set_creatorid(uint32 value) { _creatorid = value; }

	 inline uint32 op1id() { return _op1id; } const 
	 inline void set_op1id(uint32 value) { _op1id = value; }

	 inline uint32 op2id() { return _op2id; } const 
	 inline void set_op2id(uint32 value) { _op2id = value; }

	 inline uint32 op3id() { return _op3id; } const 
	 inline void set_op3id(uint32 value) { _op3id = value; }

	 inline uint32 op4id() { return _op4id; } const 
	 inline void set_op4id(uint32 value) { _op4id = value; }

	 inline uint32 inroomstate() { return _inroomstate; } const 
	 inline void set_inroomstate(uint32 value) { _inroomstate = value; }

	 inline int64 nk() { return _nk; } const 
	 inline void set_nk(int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 
	 inline void set_nb(int64 value) { _nb = value; }

	 inline int64 nlotterypool() { return _nlotterypool; } const 
	 inline void set_nlotterypool(int64 value) { _nlotterypool = value; }

	 inline int32 nchestnum() { return _nchestnum; } const 
	 inline void set_nchestnum(int32 value) { _nchestnum = value; }

	 inline int32 ncarid() { return _ncarid; } const 
	 inline void set_ncarid(int32 value) { _ncarid = value; }

	 inline string& carname() { return _carname; } const 
	 inline void set_carname(const string& value) { _carname = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cmediaaddr() { return _cmediaaddr; } const 
	 inline void set_cmediaaddr(const string& value) { _cmediaaddr = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(tag_CMDJoinRoomResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDJoinRoomResp* cmd = (tag_CMDJoinRoomResp*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->roomtype = _roomtype;
//		cmd->flags = _flags;
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
		strcpy(cmd->carname, _carname.c_str());
		strcpy(cmd->cname, _cname.c_str());
		strcpy(cmd->cmediaaddr, _cmediaaddr.c_str());
		strcpy(cmd->cpwd, _cpwd.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDJoinRoomResp* cmd = (tag_CMDJoinRoomResp*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_roomtype = cmd->roomtype;
//		_flags = cmd->flags;
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
	}

	void Log()
	{
		LOG("--------Receive message: JoinRoomResp---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("roomtype = %d", _roomtype);
		LOG("flags = %d", _flags);
		LOG("seats = %d", _seats);
		LOG("groupid = %d", _groupid);
		LOG("runstate = %d", _runstate);
		LOG("creatorid = %d", _creatorid);
		LOG("op1id = %d", _op1id);
		LOG("op2id = %d", _op2id);
		LOG("op3id = %d", _op3id);
		LOG("op4id = %d", _op4id);
		LOG("inroomstate = %d", _inroomstate);
		LOG("nk = %d", _nk);
		LOG("nb = %d", _nb);
		LOG("nlotterypool = %d", _nlotterypool);
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 errid() { return _errid; } const 
	 inline void set_errid(uint32 value) { _errid = value; }

	 inline uint32 data1() { return _data1; } const 
	 inline void set_data1(uint32 value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 
	 inline void set_data2(uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(tag_CMDJoinRoomErr); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDJoinRoomErr* cmd = (tag_CMDJoinRoomErr*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->errid = _errid;
		cmd->data1 = _data1;
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDJoinRoomErr* cmd = (tag_CMDJoinRoomErr*) data;
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


class JoinOtherRoomNoty
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_curip;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 curip() { return _curip; } const 
	 inline void set_curip(uint32 value) { _curip = value; }


	int ByteSize() { return sizeof(tag_CMDJoinOtherRoomNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDJoinOtherRoomNoty* cmd = (tag_CMDJoinOtherRoomNoty*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->curip = _curip;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDJoinOtherRoomNoty* cmd = (tag_CMDJoinOtherRoomNoty*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_curip = cmd->curip;
	}

	void Log()
	{
		LOG("--------Receive message: JoinOtherRoomNoty---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("curip = %d", _curip);
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
	uint32	_flags;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 viplevel() { return _viplevel; } const 
	 inline void set_viplevel(uint32 value) { _viplevel = value; }

	 inline uint32 yiyuanlevel() { return _yiyuanlevel; } const 
	 inline void set_yiyuanlevel(uint32 value) { _yiyuanlevel = value; }

	 inline uint32 shoufulevel() { return _shoufulevel; } const 
	 inline void set_shoufulevel(uint32 value) { _shoufulevel = value; }

	 inline uint32 zhonglevel() { return _zhonglevel; } const 
	 inline void set_zhonglevel(uint32 value) { _zhonglevel = value; }

	 inline uint32 caifulevel() { return _caifulevel; } const 
	 inline void set_caifulevel(uint32 value) { _caifulevel = value; }

	 inline uint32 lastmonthcostlevel() { return _lastmonthcostlevel; } const 
	 inline void set_lastmonthcostlevel(uint32 value) { _lastmonthcostlevel = value; }

	 inline uint32 thismonthcostlevel() { return _thismonthcostlevel; } const 
	 inline void set_thismonthcostlevel(uint32 value) { _thismonthcostlevel = value; }

	 inline uint32 thismonthcostgrade() { return _thismonthcostgrade; } const 
	 inline void set_thismonthcostgrade(uint32 value) { _thismonthcostgrade = value; }

	 inline uint32 flags() { return _flags; } const 
	 inline void set_flags(uint32 value) { _flags = value; }

	 inline uint32 pubmicindex() { return _pubmicindex; } const 
	 inline void set_pubmicindex(uint32 value) { _pubmicindex = value; }

	 inline uint32 roomlevel() { return _roomlevel; } const 
	 inline void set_roomlevel(uint32 value) { _roomlevel = value; }

	 inline uint32 usertype() { return _usertype; } const 
	 inline void set_usertype(uint32 value) { _usertype = value; }

	 inline uint32 sealid() { return _sealid; } const 
	 inline void set_sealid(uint32 value) { _sealid = value; }

	 inline uint32 cometime() { return _cometime; } const 
	 inline void set_cometime(uint32 value) { _cometime = value; }

	 inline uint32 headicon() { return _headicon; } const 
	 inline void set_headicon(uint32 value) { _headicon = value; }

	 inline uint32 micgiftid() { return _micgiftid; } const 
	 inline void set_micgiftid(uint32 value) { _micgiftid = value; }

	 inline uint32 micgiftnum() { return _micgiftnum; } const 
	 inline void set_micgiftnum(uint32 value) { _micgiftnum = value; }

	 inline uint32 sealexpiretime() { return _sealexpiretime; } const 
	 inline void set_sealexpiretime(uint32 value) { _sealexpiretime = value; }

	 inline uint32 userstate() { return _userstate; } const 
	 inline void set_userstate(uint32 value) { _userstate = value; }

	 inline uint32 starflag() { return _starflag; } const 
	 inline void set_starflag(uint32 value) { _starflag = value; }

	 inline uint32 activityflag() { return _activityflag; } const 
	 inline void set_activityflag(uint32 value) { _activityflag = value; }

	 inline uint32 flowernum() { return _flowernum; } const 
	 inline void set_flowernum(uint32 value) { _flowernum = value; }

	 inline uint32 ticket1num() { return _ticket1num; } const 
	 inline void set_ticket1num(uint32 value) { _ticket1num = value; }

	 inline uint32 ticket2num() { return _ticket2num; } const 
	 inline void set_ticket2num(uint32 value) { _ticket2num = value; }

	 inline uint32 ticket3num() { return _ticket3num; } const 
	 inline void set_ticket3num(uint32 value) { _ticket3num = value; }

	 inline int32 bforbidinviteupmic() { return _bforbidinviteupmic; } const 
	 inline void set_bforbidinviteupmic(int32 value) { _bforbidinviteupmic = value; }

	 inline int32 bforbidchat() { return _bforbidchat; } const 
	 inline void set_bforbidchat(int32 value) { _bforbidchat = value; }

	 inline int32 ncarid() { return _ncarid; } const 
	 inline void set_ncarid(int32 value) { _ncarid = value; }

	 inline string& useralias() { return _useralias; } const 
	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline string& carname() { return _carname; } const 
	 inline void set_carname(const string& value) { _carname = value; }


	int ByteSize() { return sizeof(tag_CMDRoomUserInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomUserInfo* cmd = (tag_CMDRoomUserInfo*) data;
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
//		cmd->flags = _flags;
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
		tag_CMDRoomUserInfo* cmd = (tag_CMDRoomUserInfo*) data;
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
//		_flags = cmd->flags;
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
		LOG("flags = %d", _flags);
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


class RoomPubMicState
{

private:

	int32	_micid;
	int32	_mictimetype;
	uint32	_userid;
	int32	_userlefttime;


public:

	 inline int32 micid() { return _micid; } const 
	 inline void set_micid(int32 value) { _micid = value; }

	 inline int32 mictimetype() { return _mictimetype; } const 
	 inline void set_mictimetype(int32 value) { _mictimetype = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 userlefttime() { return _userlefttime; } const 
	 inline void set_userlefttime(int32 value) { _userlefttime = value; }


	int ByteSize() { return sizeof(tag_CMDRoomPubMicState); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomPubMicState* cmd = (tag_CMDRoomPubMicState*) data;
		cmd->micid = _micid;
		cmd->mictimetype = _mictimetype;
		cmd->userid = _userid;
		cmd->userlefttime = _userlefttime;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomPubMicState* cmd = (tag_CMDRoomPubMicState*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 tocbid() { return _tocbid; } const 
	 inline void set_tocbid(uint32 value) { _tocbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 srcviplevel() { return _srcviplevel; } const 
	 inline void set_srcviplevel(uint32 value) { _srcviplevel = value; }

	 inline uint32 msgtype() { return _msgtype; } const 
	 inline void set_msgtype(uint32 value) { _msgtype = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

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


	int ByteSize() { return sizeof(tag_CMDRoomChatMsg); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomChatMsg* cmd = (tag_CMDRoomChatMsg*) data;
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
		tag_CMDRoomChatMsg* cmd = (tag_CMDRoomChatMsg*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 index() { return _index; } const 
	 inline void set_index(uint32 value) { _index = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDRoomNotice); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomNotice* cmd = (tag_CMDRoomNotice*) data;
		cmd->vcbid = _vcbid;
		cmd->index = _index;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomNotice* cmd = (tag_CMDRoomNotice*) data;
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
	 inline void set_msgtype(uint32 value) { _msgtype = value; }

	 inline uint32 reserve() { return _reserve; } const 
	 inline void set_reserve(uint32 value) { _reserve = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDSysCastNotice); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSysCastNotice* cmd = (tag_CMDSysCastNotice*) data;
		cmd->msgtype = _msgtype;
		cmd->reserve = _reserve;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSysCastNotice* cmd = (tag_CMDSysCastNotice*) data;
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


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 num() { return _num; } const 
	 inline void set_num(uint32 value) { _num = value; }


	int ByteSize() { return sizeof(tag_CMDRoomManagerInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomManagerInfo* cmd = (tag_CMDRoomManagerInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->num = _num;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomManagerInfo* cmd = (tag_CMDRoomManagerInfo*) data;
		_vcbid = cmd->vcbid;
		_num = cmd->num;
	}

	void Log()
	{
		LOG("--------Receive message: RoomManagerInfo---------");
		LOG("vcbid = %d", _vcbid);
		LOG("num = %d", _num);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 tovcbid() { return _tovcbid; } const 
	 inline void set_tovcbid(uint32 value) { _tovcbid = value; }

	 inline uint32 totype() { return _totype; } const 
	 inline void set_totype(uint32 value) { _totype = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline uint32 giftnum() { return _giftnum; } const 
	 inline void set_giftnum(uint32 value) { _giftnum = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(uint32 value) { _action = value; }

	 inline uint32 servertype() { return _servertype; } const 
	 inline void set_servertype(uint32 value) { _servertype = value; }

	 inline uint32 banonymous() { return _banonymous; } const 
	 inline void set_banonymous(uint32 value) { _banonymous = value; }

	 inline uint32 casttype() { return _casttype; } const 
	 inline void set_casttype(uint32 value) { _casttype = value; }

	 inline uint32 dtime() { return _dtime; } const 
	 inline void set_dtime(uint32 value) { _dtime = value; }

	 inline uint32 oldnum() { return _oldnum; } const 
	 inline void set_oldnum(uint32 value) { _oldnum = value; }

	 inline uint32 flyid() { return _flyid; } const 
	 inline void set_flyid(uint32 value) { _flyid = value; }

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


	int ByteSize() { return sizeof(tag_CMDTradeGiftRecord); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeGiftRecord* cmd = (tag_CMDTradeGiftRecord*) data;
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
		tag_CMDTradeGiftRecord* cmd = (tag_CMDTradeGiftRecord*) data;
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


	int ByteSize() { return sizeof(tag_CMDTradeGiftResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeGiftResp* cmd = (tag_CMDTradeGiftResp*) data;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTradeGiftResp* cmd = (tag_CMDTradeGiftResp*) data;
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
	 inline void set_nerrid(int32 value) { _nerrid = value; }


	int ByteSize() { return sizeof(tag_CMDTradeGiftErr); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeGiftErr* cmd = (tag_CMDTradeGiftErr*) data;
		cmd->nerrid = _nerrid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTradeGiftErr* cmd = (tag_CMDTradeGiftErr*) data;
		_nerrid = cmd->nerrid;
	}

	void Log()
	{
		LOG("--------Receive message: TradeGiftErr---------");
		LOG("nerrid = %d", _nerrid);
	}

};


class TradeFlowerRecord
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_toid;
	uint32	_giftid;
	uint32	_sendnum;
	uint32	_allnum;
	string	_srcalias;
	string	_toalias;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline uint32 sendnum() { return _sendnum; } const 
	 inline void set_sendnum(uint32 value) { _sendnum = value; }

	 inline uint32 allnum() { return _allnum; } const 
	 inline void set_allnum(uint32 value) { _allnum = value; }

	 inline string& srcalias() { return _srcalias; } const 
	 inline void set_srcalias(const string& value) { _srcalias = value; }

	 inline string& toalias() { return _toalias; } const 
	 inline void set_toalias(const string& value) { _toalias = value; }


	int ByteSize() { return sizeof(tag_CMDTradeFlowerRecord); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeFlowerRecord* cmd = (tag_CMDTradeFlowerRecord*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->giftid = _giftid;
		cmd->sendnum = _sendnum;
		cmd->allnum = _allnum;
		strcpy(cmd->srcalias, _srcalias.c_str());
		strcpy(cmd->toalias, _toalias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTradeFlowerRecord* cmd = (tag_CMDTradeFlowerRecord*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_toid = cmd->toid;
		_giftid = cmd->giftid;
		_sendnum = cmd->sendnum;
		_allnum = cmd->allnum;
		_srcalias = cmd->srcalias;
		_toalias = cmd->toalias;
	}

	void Log()
	{
		LOG("--------Receive message: TradeFlowerRecord---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("toid = %d", _toid);
		LOG("giftid = %d", _giftid);
		LOG("sendnum = %d", _sendnum);
		LOG("allnum = %d", _allnum);
		LOG("srcalias = %s", _srcalias.c_str());
		LOG("toalias = %s", _toalias.c_str());
	}

};


class UserExitRoomInfo
{

private:

	uint32	_userid;
	uint32	_vcbid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(tag_CMDUserExitRoomInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserExitRoomInfo* cmd = (tag_CMDUserExitRoomInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserExitRoomInfo* cmd = (tag_CMDUserExitRoomInfo*) data;
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


class UserExitRoomInfo_ext
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDUserExitRoomInfo_ext); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserExitRoomInfo_ext* cmd = (tag_CMDUserExitRoomInfo_ext*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserExitRoomInfo_ext* cmd = (tag_CMDUserExitRoomInfo_ext*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(tag_CMDUserExceptExitRoomInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserExceptExitRoomInfo* cmd = (tag_CMDUserExceptExitRoomInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserExceptExitRoomInfo* cmd = (tag_CMDUserExceptExitRoomInfo*) data;
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


class UserExceptExitRoomInfo_ext
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDUserExceptExitRoomInfo_ext); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserExceptExitRoomInfo_ext* cmd = (tag_CMDUserExceptExitRoomInfo_ext*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserExceptExitRoomInfo_ext* cmd = (tag_CMDUserExceptExitRoomInfo_ext*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline int32 resonid() { return _resonid; } const 
	 inline void set_resonid(int32 value) { _resonid = value; }

	 inline uint32 mins() { return _mins; } const 
	 inline void set_mins(uint32 value) { _mins = value; }


	int ByteSize() { return sizeof(tag_CMDUserKickoutRoomInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserKickoutRoomInfo* cmd = (tag_CMDUserKickoutRoomInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->resonid = _resonid;
		cmd->mins = _mins;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserKickoutRoomInfo* cmd = (tag_CMDUserKickoutRoomInfo*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline int32 resonid() { return _resonid; } const 
	 inline void set_resonid(int32 value) { _resonid = value; }

	 inline uint32 mins() { return _mins; } const 
	 inline void set_mins(uint32 value) { _mins = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDUserKickoutRoomInfo_ext); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserKickoutRoomInfo_ext* cmd = (tag_CMDUserKickoutRoomInfo_ext*) data;
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
		tag_CMDUserKickoutRoomInfo_ext* cmd = (tag_CMDUserKickoutRoomInfo_ext*) data;
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


class QueryUserAccountReq
{

private:

	uint32	_vcbid;
	uint32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDQueryUserAccountReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryUserAccountReq* cmd = (tag_CMDQueryUserAccountReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryUserAccountReq* cmd = (tag_CMDQueryUserAccountReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int64 nk() { return _nk; } const 
	 inline void set_nk(int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 
	 inline void set_nb(int64 value) { _nb = value; }

	 inline int64 nkdeposit() { return _nkdeposit; } const 
	 inline void set_nkdeposit(int64 value) { _nkdeposit = value; }


	int ByteSize() { return sizeof(tag_CMDQueryUserAccountResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryUserAccountResp* cmd = (tag_CMDQueryUserAccountResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->nkdeposit = _nkdeposit;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryUserAccountResp* cmd = (tag_CMDQueryUserAccountResp*) data;
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
		LOG("nk = %d", _nk);
		LOG("nb = %d", _nb);
		LOG("nkdeposit = %d", _nkdeposit);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int64 nk() { return _nk; } const 
	 inline void set_nk(int64 value) { _nk = value; }

	 inline int64 nb() { return _nb; } const 
	 inline void set_nb(int64 value) { _nb = value; }

	 inline uint32 dtime() { return _dtime; } const 
	 inline void set_dtime(uint32 value) { _dtime = value; }


	int ByteSize() { return sizeof(tag_CMDUserAccountInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserAccountInfo* cmd = (tag_CMDUserAccountInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->nk = _nk;
		cmd->nb = _nb;
		cmd->dtime = _dtime;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserAccountInfo* cmd = (tag_CMDUserAccountInfo*) data;
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
		LOG("nk = %d", _nk);
		LOG("nb = %d", _nb);
		LOG("dtime = %d", _dtime);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 viplevel() { return _viplevel; } const 
	 inline void set_viplevel(uint32 value) { _viplevel = value; }

	 inline uint32 nscopeid() { return _nscopeid; } const 
	 inline void set_nscopeid(uint32 value) { _nscopeid = value; }

	 inline uint32 ntimeid() { return _ntimeid; } const 
	 inline void set_ntimeid(uint32 value) { _ntimeid = value; }

	 inline uint32 nreasionid() { return _nreasionid; } const 
	 inline void set_nreasionid(uint32 value) { _nreasionid = value; }

	 inline string& szip() { return _szip; } const 
	 inline void set_szip(const string& value) { _szip = value; }

	 inline string& szserial() { return _szserial; } const 
	 inline void set_szserial(const string& value) { _szserial = value; }


	int ByteSize() { return sizeof(tag_CMDThrowUserInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDThrowUserInfo* cmd = (tag_CMDThrowUserInfo*) data;
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
		tag_CMDThrowUserInfo* cmd = (tag_CMDThrowUserInfo*) data;
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


class ThrowUserInfoResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDThrowUserInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDThrowUserInfoResp* cmd = (tag_CMDThrowUserInfoResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDThrowUserInfoResp* cmd = (tag_CMDThrowUserInfoResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runid() { return _runid; } const 
	 inline void set_runid(uint32 value) { _runid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline int32 giftid() { return _giftid; } const 
	 inline void set_giftid(int32 value) { _giftid = value; }

	 inline int32 giftnum() { return _giftnum; } const 
	 inline void set_giftnum(int32 value) { _giftnum = value; }

	 inline uint32 micstate() { return _micstate; } const 
	 inline void set_micstate(uint32 value) { _micstate = value; }

	 inline uint32 micindex() { return _micindex; } const 
	 inline void set_micindex(uint32 value) { _micindex = value; }

	 inline uint32 optype() { return _optype; } const 
	 inline void set_optype(uint32 value) { _optype = value; }

	 inline uint32 reserve11() { return _reserve11; } const 
	 inline void set_reserve11(uint32 value) { _reserve11 = value; }


	int ByteSize() { return sizeof(tag_CMDUserMicState); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserMicState* cmd = (tag_CMDUserMicState*) data;
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
		tag_CMDUserMicState* cmd = (tag_CMDUserMicState*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 audiostate() { return _audiostate; } const 
	 inline void set_audiostate(uint32 value) { _audiostate = value; }

	 inline uint32 videostate() { return _videostate; } const 
	 inline void set_videostate(uint32 value) { _videostate = value; }

	 inline uint32 userinroomstate() { return _userinroomstate; } const 
	 inline void set_userinroomstate(uint32 value) { _userinroomstate = value; }


	int ByteSize() { return sizeof(tag_CMDUserDevState); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserDevState* cmd = (tag_CMDUserDevState*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->audiostate = _audiostate;
		cmd->videostate = _videostate;
		cmd->userinroomstate = _userinroomstate;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserDevState* cmd = (tag_CMDUserDevState*) data;
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


class UserAliasState
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_headid;
	string	_alias;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 headid() { return _headid; } const 
	 inline void set_headid(uint32 value) { _headid = value; }

	 inline string& alias() { return _alias; } const 
	 inline void set_alias(const string& value) { _alias = value; }


	int ByteSize() { return sizeof(tag_CMDUserAliasState); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserAliasState* cmd = (tag_CMDUserAliasState*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->headid = _headid;
		strcpy(cmd->alias, _alias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserAliasState* cmd = (tag_CMDUserAliasState*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_headid = cmd->headid;
		_alias = cmd->alias;
	}

	void Log()
	{
		LOG("--------Receive message: UserAliasState---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("headid = %d", _headid);
		LOG("alias = %s", _alias.c_str());
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(uint32 value) { _action = value; }

	 inline uint32 priority() { return _priority; } const 
	 inline void set_priority(uint32 value) { _priority = value; }


	int ByteSize() { return sizeof(tag_CMDUserPriority); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserPriority* cmd = (tag_CMDUserPriority*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->userid = _userid;
		cmd->action = _action;
		cmd->priority = _priority;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserPriority* cmd = (tag_CMDUserPriority*) data;
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


class SetUserPriorityResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserPriorityResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserPriorityResp* cmd = (tag_CMDSetUserPriorityResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserPriorityResp* cmd = (tag_CMDSetUserPriorityResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runid() { return _runid; } const 
	 inline void set_runid(uint32 value) { _runid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }


	int ByteSize() { return sizeof(tag_CMDSeeUserIpReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSeeUserIpReq* cmd = (tag_CMDSeeUserIpReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runid = _runid;
		cmd->toid = _toid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSeeUserIpReq* cmd = (tag_CMDSeeUserIpReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runid() { return _runid; } const 
	 inline void set_runid(uint32 value) { _runid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline uint32 reserve() { return _reserve; } const 
	 inline void set_reserve(uint32 value) { _reserve = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDSeeUserIpResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSeeUserIpResp* cmd = (tag_CMDSeeUserIpResp*) data;
		cmd->vcbid = _vcbid;
		cmd->runid = _runid;
		cmd->userid = _userid;
		cmd->textlen = _textlen;
		cmd->reserve = _reserve;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSeeUserIpResp* cmd = (tag_CMDSeeUserIpResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(uint32 value) { _action = value; }

	 inline uint32 vvflag() { return _vvflag; } const 
	 inline void set_vvflag(uint32 value) { _vvflag = value; }


	int ByteSize() { return sizeof(tag_CMDTransMediaInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTransMediaInfo* cmd = (tag_CMDTransMediaInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->action = _action;
		cmd->vvflag = _vvflag;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTransMediaInfo* cmd = (tag_CMDTransMediaInfo*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 groupid() { return _groupid; } const 
	 inline void set_groupid(uint32 value) { _groupid = value; }

	 inline uint32 level() { return _level; } const 
	 inline void set_level(uint32 value) { _level = value; }

	 inline uint32 busepwd() { return _busepwd; } const 
	 inline void set_busepwd(uint32 value) { _busepwd = value; }

	 inline uint32 seats() { return _seats; } const 
	 inline void set_seats(uint32 value) { _seats = value; }

	 inline uint32 creatorid() { return _creatorid; } const 
	 inline void set_creatorid(uint32 value) { _creatorid = value; }

	 inline uint32 op1id() { return _op1id; } const 
	 inline void set_op1id(uint32 value) { _op1id = value; }

	 inline uint32 op2id() { return _op2id; } const 
	 inline void set_op2id(uint32 value) { _op2id = value; }

	 inline uint32 op3id() { return _op3id; } const 
	 inline void set_op3id(uint32 value) { _op3id = value; }

	 inline uint32 op4id() { return _op4id; } const 
	 inline void set_op4id(uint32 value) { _op4id = value; }

	 inline uint32 opstate() { return _opstate; } const 
	 inline void set_opstate(uint32 value) { _opstate = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(tag_CMDRoomBaseInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomBaseInfo* cmd = (tag_CMDRoomBaseInfo*) data;
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
		tag_CMDRoomBaseInfo* cmd = (tag_CMDRoomBaseInfo*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 opstate() { return _opstate; } const 
	 inline void set_opstate(uint32 value) { _opstate = value; }


	int ByteSize() { return sizeof(tag_CMDRoomOpState); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomOpState* cmd = (tag_CMDRoomOpState*) data;
		cmd->vcbid = _vcbid;
		cmd->opstate = _opstate;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomOpState* cmd = (tag_CMDRoomOpState*) data;
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


class RoomMediaInfo
{

private:

	uint32	_vcbid;
	uint32	_userid;
	string	_caddr;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline string& caddr() { return _caddr; } const 
	 inline void set_caddr(const string& value) { _caddr = value; }


	int ByteSize() { return sizeof(tag_CMDRoomMediaInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomMediaInfo* cmd = (tag_CMDRoomMediaInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		strcpy(cmd->caddr, _caddr.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomMediaInfo* cmd = (tag_CMDRoomMediaInfo*) data;
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


class ChangePubMicStateReq
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_micid;
	uint32	_optype;
	int32	_param1;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 micid() { return _micid; } const 
	 inline void set_micid(uint32 value) { _micid = value; }

	 inline uint32 optype() { return _optype; } const 
	 inline void set_optype(uint32 value) { _optype = value; }

	 inline int32 param1() { return _param1; } const 
	 inline void set_param1(int32 value) { _param1 = value; }


	int ByteSize() { return sizeof(tag_CMDChangePubMicStateReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDChangePubMicStateReq* cmd = (tag_CMDChangePubMicStateReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->micid = _micid;
		cmd->optype = _optype;
		cmd->param1 = _param1;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDChangePubMicStateReq* cmd = (tag_CMDChangePubMicStateReq*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_micid = cmd->micid;
		_optype = cmd->optype;
		_param1 = cmd->param1;
	}

	void Log()
	{
		LOG("--------Receive message: ChangePubMicStateReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("micid = %d", _micid);
		LOG("optype = %d", _optype);
		LOG("param1 = %d", _param1);
	}

};


class ChangePubMicStateResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDChangePubMicStateResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDChangePubMicStateResp* cmd = (tag_CMDChangePubMicStateResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDChangePubMicStateResp* cmd = (tag_CMDChangePubMicStateResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: ChangePubMicStateResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 micid() { return _micid; } const 
	 inline void set_micid(uint32 value) { _micid = value; }

	 inline uint32 optype() { return _optype; } const 
	 inline void set_optype(uint32 value) { _optype = value; }

	 inline int32 param1() { return _param1; } const 
	 inline void set_param1(int32 value) { _param1 = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 userlefttime() { return _userlefttime; } const 
	 inline void set_userlefttime(int32 value) { _userlefttime = value; }


	int ByteSize() { return sizeof(tag_CMDChangePubMicStateNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDChangePubMicStateNoty* cmd = (tag_CMDChangePubMicStateNoty*) data;
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
		tag_CMDChangePubMicStateNoty* cmd = (tag_CMDChangePubMicStateNoty*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 
	 inline void set_ruunerid(uint32 value) { _ruunerid = value; }

	 inline uint32 touser() { return _touser; } const 
	 inline void set_touser(uint32 value) { _touser = value; }

	 inline int32 nmicindex() { return _nmicindex; } const 
	 inline void set_nmicindex(int32 value) { _nmicindex = value; }


	int ByteSize() { return sizeof(tag_CMDUpWaitMic); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUpWaitMic* cmd = (tag_CMDUpWaitMic*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->touser = _touser;
		cmd->nmicindex = _nmicindex;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUpWaitMic* cmd = (tag_CMDUpWaitMic*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 
	 inline void set_ruunerid(uint32 value) { _ruunerid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 
	 inline void set_micid(int32 value) { _micid = value; }

	 inline int32 optype() { return _optype; } const 
	 inline void set_optype(int32 value) { _optype = value; }


	int ByteSize() { return sizeof(tag_CMDOperateWaitMic); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDOperateWaitMic* cmd = (tag_CMDOperateWaitMic*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDOperateWaitMic* cmd = (tag_CMDOperateWaitMic*) data;
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


class ChangeWaitMicIndexResp
{

private:

	uint32	_vcbid;
	int32	_errorid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDChangeWaitMicIndexResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDChangeWaitMicIndexResp* cmd = (tag_CMDChangeWaitMicIndexResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDChangeWaitMicIndexResp* cmd = (tag_CMDChangeWaitMicIndexResp*) data;
		_vcbid = cmd->vcbid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: ChangeWaitMicIndexResp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("errorid = %d", _errorid);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 
	 inline void set_ruunerid(uint32 value) { _ruunerid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 
	 inline void set_micid(int32 value) { _micid = value; }

	 inline int32 optype() { return _optype; } const 
	 inline void set_optype(int32 value) { _optype = value; }


	int ByteSize() { return sizeof(tag_CMDChangeWaitMicIndexNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDChangeWaitMicIndexNoty* cmd = (tag_CMDChangeWaitMicIndexNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDChangeWaitMicIndexNoty* cmd = (tag_CMDChangeWaitMicIndexNoty*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 
	 inline void set_micid(int32 value) { _micid = value; }


	int ByteSize() { return sizeof(tag_CMDLootUserMicReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDLootUserMicReq* cmd = (tag_CMDLootUserMicReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDLootUserMicReq* cmd = (tag_CMDLootUserMicReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDLootUserMicResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDLootUserMicResp* cmd = (tag_CMDLootUserMicResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDLootUserMicResp* cmd = (tag_CMDLootUserMicResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 micid() { return _micid; } const 
	 inline void set_micid(int32 value) { _micid = value; }


	int ByteSize() { return sizeof(tag_CMDLootUserMicNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDLootUserMicNoty* cmd = (tag_CMDLootUserMicNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->userid = _userid;
		cmd->micid = _micid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDLootUserMicNoty* cmd = (tag_CMDLootUserMicNoty*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 creatorid() { return _creatorid; } const 
	 inline void set_creatorid(uint32 value) { _creatorid = value; }

	 inline uint32 op1id() { return _op1id; } const 
	 inline void set_op1id(uint32 value) { _op1id = value; }

	 inline uint32 op2id() { return _op2id; } const 
	 inline void set_op2id(uint32 value) { _op2id = value; }

	 inline uint32 op3id() { return _op3id; } const 
	 inline void set_op3id(uint32 value) { _op3id = value; }

	 inline uint32 op4id() { return _op4id; } const 
	 inline void set_op4id(uint32 value) { _op4id = value; }

	 inline int32 busepwd() { return _busepwd; } const 
	 inline void set_busepwd(int32 value) { _busepwd = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomInfoReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomInfoReq* cmd = (tag_CMDSetRoomInfoReq*) data;
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
		tag_CMDSetRoomInfoReq* cmd = (tag_CMDSetRoomInfoReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 nallowjoinmode() { return _nallowjoinmode; } const 
	 inline void set_nallowjoinmode(uint32 value) { _nallowjoinmode = value; }

	 inline uint32 ncloseroom() { return _ncloseroom; } const 
	 inline void set_ncloseroom(uint32 value) { _ncloseroom = value; }

	 inline uint32 nclosepubchat() { return _nclosepubchat; } const 
	 inline void set_nclosepubchat(uint32 value) { _nclosepubchat = value; }

	 inline uint32 nclosecolorbar() { return _nclosecolorbar; } const 
	 inline void set_nclosecolorbar(uint32 value) { _nclosecolorbar = value; }

	 inline uint32 nclosefreemic() { return _nclosefreemic; } const 
	 inline void set_nclosefreemic(uint32 value) { _nclosefreemic = value; }

	 inline uint32 ncloseinoutmsg() { return _ncloseinoutmsg; } const 
	 inline void set_ncloseinoutmsg(uint32 value) { _ncloseinoutmsg = value; }

	 inline uint32 ncloseprvchat() { return _ncloseprvchat; } const 
	 inline void set_ncloseprvchat(uint32 value) { _ncloseprvchat = value; }

	 inline string& cname() { return _cname; } const 
	 inline void set_cname(const string& value) { _cname = value; }

	 inline string& cpwd() { return _cpwd; } const 
	 inline void set_cpwd(const string& value) { _cpwd = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomInfoReq_v2); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomInfoReq_v2* cmd = (tag_CMDSetRoomInfoReq_v2*) data;
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
		tag_CMDSetRoomInfoReq_v2* cmd = (tag_CMDSetRoomInfoReq_v2*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomInfoResp* cmd = (tag_CMDSetRoomInfoResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetRoomInfoResp* cmd = (tag_CMDSetRoomInfoResp*) data;
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


class SetRoomOPStatusReq
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_opstatus;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 opstatus() { return _opstatus; } const 
	 inline void set_opstatus(uint32 value) { _opstatus = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomOPStatusReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomOPStatusReq* cmd = (tag_CMDSetRoomOPStatusReq*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->opstatus = _opstatus;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetRoomOPStatusReq* cmd = (tag_CMDSetRoomOPStatusReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomOPStatusResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomOPStatusResp* cmd = (tag_CMDSetRoomOPStatusResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetRoomOPStatusResp* cmd = (tag_CMDSetRoomOPStatusResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 ruunerid() { return _ruunerid; } const 
	 inline void set_ruunerid(uint32 value) { _ruunerid = value; }

	 inline uint32 index() { return _index; } const 
	 inline void set_index(uint32 value) { _index = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomNoticeReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomNoticeReq* cmd = (tag_CMDSetRoomNoticeReq*) data;
		cmd->vcbid = _vcbid;
		cmd->ruunerid = _ruunerid;
		cmd->index = _index;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetRoomNoticeReq* cmd = (tag_CMDSetRoomNoticeReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomNoticeResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomNoticeResp* cmd = (tag_CMDSetRoomNoticeResp*) data;
		cmd->vcbid = _vcbid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetRoomNoticeResp* cmd = (tag_CMDSetRoomNoticeResp*) data;
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


class SendUserSeal
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_toid;
	uint32	_sealid;
	uint32	_sealtime;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 sealid() { return _sealid; } const 
	 inline void set_sealid(uint32 value) { _sealid = value; }

	 inline uint32 sealtime() { return _sealtime; } const 
	 inline void set_sealtime(uint32 value) { _sealtime = value; }


	int ByteSize() { return sizeof(tag_CMDSendUserSeal); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSendUserSeal* cmd = (tag_CMDSendUserSeal*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->toid = _toid;
		cmd->sealid = _sealid;
		cmd->sealtime = _sealtime;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSendUserSeal* cmd = (tag_CMDSendUserSeal*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_toid = cmd->toid;
		_sealid = cmd->sealid;
		_sealtime = cmd->sealtime;
	}

	void Log()
	{
		LOG("--------Receive message: SendUserSeal---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("toid = %d", _toid);
		LOG("sealid = %d", _sealid);
		LOG("sealtime = %d", _sealtime);
	}

};


class SendUserSealErr
{

private:

	uint32	_userid;
	uint32	_vcbid;
	int32	_errid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 errid() { return _errid; } const 
	 inline void set_errid(int32 value) { _errid = value; }


	int ByteSize() { return sizeof(tag_CMDSendUserSealErr); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSendUserSealErr* cmd = (tag_CMDSendUserSealErr*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSendUserSealErr* cmd = (tag_CMDSendUserSealErr*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_errid = cmd->errid;
	}

	void Log()
	{
		LOG("--------Receive message: SendUserSealErr---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("errid = %d", _errid);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline uint32 ttime() { return _ttime; } const 
	 inline void set_ttime(uint32 value) { _ttime = value; }

	 inline uint32 action() { return _action; } const 
	 inline void set_action(uint32 value) { _action = value; }


	int ByteSize() { return sizeof(tag_CMDForbidUserChat); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDForbidUserChat* cmd = (tag_CMDForbidUserChat*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
		cmd->ttime = _ttime;
		cmd->action = _action;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDForbidUserChat* cmd = (tag_CMDForbidUserChat*) data;
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


class FavoriteRoomReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_actionid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 actionid() { return _actionid; } const 
	 inline void set_actionid(int32 value) { _actionid = value; }


	int ByteSize() { return sizeof(tag_CMDFavoriteRoomReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDFavoriteRoomReq* cmd = (tag_CMDFavoriteRoomReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->actionid = _actionid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDFavoriteRoomReq* cmd = (tag_CMDFavoriteRoomReq*) data;
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
	 inline void set_errorid(int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 actionid() { return _actionid; } const 
	 inline void set_actionid(int32 value) { _actionid = value; }


	int ByteSize() { return sizeof(tag_CMDFavoriteRoomResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDFavoriteRoomResp* cmd = (tag_CMDFavoriteRoomResp*) data;
		cmd->errorid = _errorid;
		cmd->vcbid = _vcbid;
		cmd->actionid = _actionid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDFavoriteRoomResp* cmd = (tag_CMDFavoriteRoomResp*) data;
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


class LotteryGiftNotice
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_giftid;
	uint32	_noddsnum;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline uint32 noddsnum() { return _noddsnum; } const 
	 inline void set_noddsnum(uint32 value) { _noddsnum = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDLotteryGiftNotice); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDLotteryGiftNotice* cmd = (tag_CMDLotteryGiftNotice*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->giftid = _giftid;
		cmd->noddsnum = _noddsnum;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDLotteryGiftNotice* cmd = (tag_CMDLotteryGiftNotice*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_giftid = cmd->giftid;
		_noddsnum = cmd->noddsnum;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: LotteryGiftNotice---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("giftid = %d", _giftid);
		LOG("noddsnum = %d", _noddsnum);
		LOG("content = %s", _content.c_str());
	}

};


class BoomGiftNotice
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_giftid;
	int32	_beishu;
	uint64	_winmoney;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline int32 beishu() { return _beishu; } const 
	 inline void set_beishu(int32 value) { _beishu = value; }

	 inline uint64 winmoney() { return _winmoney; } const 
	 inline void set_winmoney(uint64 value) { _winmoney = value; }


	int ByteSize() { return sizeof(tag_CMDBoomGiftNotice); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDBoomGiftNotice* cmd = (tag_CMDBoomGiftNotice*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->giftid = _giftid;
		cmd->beishu = _beishu;
		cmd->winmoney = _winmoney;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDBoomGiftNotice* cmd = (tag_CMDBoomGiftNotice*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_giftid = cmd->giftid;
		_beishu = cmd->beishu;
		_winmoney = cmd->winmoney;
	}

	void Log()
	{
		LOG("--------Receive message: BoomGiftNotice---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("giftid = %d", _giftid);
		LOG("beishu = %d", _beishu);
		LOG("winmoney = %d", _winmoney);
	}

};


class LotteryPoolInfo
{

private:

	uint64	_nlotterypool;


public:

	 inline uint64 nlotterypool() { return _nlotterypool; } const 
	 inline void set_nlotterypool(uint64 value) { _nlotterypool = value; }


	int ByteSize() { return sizeof(tag_CMDLotteryPoolInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDLotteryPoolInfo* cmd = (tag_CMDLotteryPoolInfo*) data;
		cmd->nlotterypool = _nlotterypool;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDLotteryPoolInfo* cmd = (tag_CMDLotteryPoolInfo*) data;
		_nlotterypool = cmd->nlotterypool;
	}

	void Log()
	{
		LOG("--------Receive message: LotteryPoolInfo---------");
		LOG("nlotterypool = %d", _nlotterypool);
	}

};


class TradeFireworksReq
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_giftid;
	uint32	_giftnum;
	uint32	_sendtype;
	string	_srcalias;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline uint32 giftnum() { return _giftnum; } const 
	 inline void set_giftnum(uint32 value) { _giftnum = value; }

	 inline uint32 sendtype() { return _sendtype; } const 
	 inline void set_sendtype(uint32 value) { _sendtype = value; }

	 inline string& srcalias() { return _srcalias; } const 
	 inline void set_srcalias(const string& value) { _srcalias = value; }


	int ByteSize() { return sizeof(tag_CMDTradeFireworksReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeFireworksReq* cmd = (tag_CMDTradeFireworksReq*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->giftid = _giftid;
		cmd->giftnum = _giftnum;
		cmd->sendtype = _sendtype;
		strcpy(cmd->srcalias, _srcalias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTradeFireworksReq* cmd = (tag_CMDTradeFireworksReq*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_giftid = cmd->giftid;
		_giftnum = cmd->giftnum;
		_sendtype = cmd->sendtype;
		_srcalias = cmd->srcalias;
	}

	void Log()
	{
		LOG("--------Receive message: TradeFireworksReq---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("giftid = %d", _giftid);
		LOG("giftnum = %d", _giftnum);
		LOG("sendtype = %d", _sendtype);
		LOG("srcalias = %s", _srcalias.c_str());
	}

};


class TradeFireworksNotify
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_giftid;
	uint32	_giftnum;
	uint32	_sendtype;
	string	_srcalias;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline uint32 giftnum() { return _giftnum; } const 
	 inline void set_giftnum(uint32 value) { _giftnum = value; }

	 inline uint32 sendtype() { return _sendtype; } const 
	 inline void set_sendtype(uint32 value) { _sendtype = value; }

	 inline string& srcalias() { return _srcalias; } const 
	 inline void set_srcalias(const string& value) { _srcalias = value; }


	int ByteSize() { return sizeof(tag_CMDTradeFireworksNotify); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeFireworksNotify* cmd = (tag_CMDTradeFireworksNotify*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->giftid = _giftid;
		cmd->giftnum = _giftnum;
		cmd->sendtype = _sendtype;
		strcpy(cmd->srcalias, _srcalias.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTradeFireworksNotify* cmd = (tag_CMDTradeFireworksNotify*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_giftid = cmd->giftid;
		_giftnum = cmd->giftnum;
		_sendtype = cmd->sendtype;
		_srcalias = cmd->srcalias;
	}

	void Log()
	{
		LOG("--------Receive message: TradeFireworksNotify---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("giftid = %d", _giftid);
		LOG("giftnum = %d", _giftnum);
		LOG("sendtype = %d", _sendtype);
		LOG("srcalias = %s", _srcalias.c_str());
	}

};


class TradeFireworksErr
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_giftid;
	int32	_errid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 giftid() { return _giftid; } const 
	 inline void set_giftid(uint32 value) { _giftid = value; }

	 inline int32 errid() { return _errid; } const 
	 inline void set_errid(int32 value) { _errid = value; }


	int ByteSize() { return sizeof(tag_CMDTradeFireworksErr); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTradeFireworksErr* cmd = (tag_CMDTradeFireworksErr*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->giftid = _giftid;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTradeFireworksErr* cmd = (tag_CMDTradeFireworksErr*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_giftid = cmd->giftid;
		_errid = cmd->errid;
	}

	void Log()
	{
		LOG("--------Receive message: TradeFireworksErr---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("giftid = %d", _giftid);
		LOG("errid = %d", _errid);
	}

};


class MoneyAndPointOp
{

private:

	uint32	_vcbid;
	uint32	_srcid;
	uint32	_touserid;
	int64	_data;
	uint32	_optype;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 touserid() { return _touserid; } const 
	 inline void set_touserid(uint32 value) { _touserid = value; }

	 inline int64 data() { return _data; } const 
	 inline void set_data(int64 value) { _data = value; }

	 inline uint32 optype() { return _optype; } const 
	 inline void set_optype(uint32 value) { _optype = value; }


	int ByteSize() { return sizeof(tag_CMDMoneyAndPointOp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDMoneyAndPointOp* cmd = (tag_CMDMoneyAndPointOp*) data;
		cmd->vcbid = _vcbid;
		cmd->srcid = _srcid;
		cmd->touserid = _touserid;
		cmd->data = _data;
		cmd->optype = _optype;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDMoneyAndPointOp* cmd = (tag_CMDMoneyAndPointOp*) data;
		_vcbid = cmd->vcbid;
		_srcid = cmd->srcid;
		_touserid = cmd->touserid;
		_data = cmd->data;
		_optype = cmd->optype;
	}

	void Log()
	{
		LOG("--------Receive message: MoneyAndPointOp---------");
		LOG("vcbid = %d", _vcbid);
		LOG("srcid = %d", _srcid);
		LOG("touserid = %d", _touserid);
		LOG("data = %d", _data);
		LOG("optype = %d", _optype);
	}

};


class SetRoomWaitMicMaxNumLimit
{

private:

	uint32	_vcbid;
	uint32	_runnerid;
	uint32	_maxwaitmicuser;
	uint32	_maxuserwaitmic;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 runnerid() { return _runnerid; } const 
	 inline void set_runnerid(uint32 value) { _runnerid = value; }

	 inline uint32 maxwaitmicuser() { return _maxwaitmicuser; } const 
	 inline void set_maxwaitmicuser(uint32 value) { _maxwaitmicuser = value; }

	 inline uint32 maxuserwaitmic() { return _maxuserwaitmic; } const 
	 inline void set_maxuserwaitmic(uint32 value) { _maxuserwaitmic = value; }


	int ByteSize() { return sizeof(tag_CMDSetRoomWaitMicMaxNumLimit); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetRoomWaitMicMaxNumLimit* cmd = (tag_CMDSetRoomWaitMicMaxNumLimit*) data;
		cmd->vcbid = _vcbid;
		cmd->runnerid = _runnerid;
		cmd->maxwaitmicuser = _maxwaitmicuser;
		cmd->maxuserwaitmic = _maxuserwaitmic;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetRoomWaitMicMaxNumLimit* cmd = (tag_CMDSetRoomWaitMicMaxNumLimit*) data;
		_vcbid = cmd->vcbid;
		_runnerid = cmd->runnerid;
		_maxwaitmicuser = cmd->maxwaitmicuser;
		_maxuserwaitmic = cmd->maxuserwaitmic;
	}

	void Log()
	{
		LOG("--------Receive message: SetRoomWaitMicMaxNumLimit---------");
		LOG("vcbid = %d", _vcbid);
		LOG("runnerid = %d", _runnerid);
		LOG("maxwaitmicuser = %d", _maxwaitmicuser);
		LOG("maxuserwaitmic = %d", _maxuserwaitmic);
	}

};


class SetForbidInviteUpMic
{

private:

	uint32	_vcbid;
	uint32	_userid;
	int32	_reserve;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 reserve() { return _reserve; } const 
	 inline void set_reserve(int32 value) { _reserve = value; }


	int ByteSize() { return sizeof(tag_CMDSetForbidInviteUpMic); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetForbidInviteUpMic* cmd = (tag_CMDSetForbidInviteUpMic*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->reserve = _reserve;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetForbidInviteUpMic* cmd = (tag_CMDSetForbidInviteUpMic*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_reserve = cmd->reserve;
	}

	void Log()
	{
		LOG("--------Receive message: SetForbidInviteUpMic---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("reserve = %d", _reserve);
	}

};


class PropsFlashPlayTaskItem
{

private:

	uint32	_ntasktype;
	uint32	_narg;


public:

	 inline uint32 ntasktype() { return _ntasktype; } const 
	 inline void set_ntasktype(uint32 value) { _ntasktype = value; }

	 inline uint32 narg() { return _narg; } const 
	 inline void set_narg(uint32 value) { _narg = value; }


	int ByteSize() { return sizeof(tag_PropsFlashPlayTaskItem); }

	void SerializeToArray(void* data, int size)
	{
		tag_PropsFlashPlayTaskItem* cmd = (tag_PropsFlashPlayTaskItem*) data;
		cmd->nTaskType = _ntasktype;
		cmd->nArg = _narg;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_PropsFlashPlayTaskItem* cmd = (tag_PropsFlashPlayTaskItem*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 queryvcbid() { return _queryvcbid; } const 
	 inline void set_queryvcbid(uint32 value) { _queryvcbid = value; }


	int ByteSize() { return sizeof(tag_CMDQueryVcbExistReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryVcbExistReq* cmd = (tag_CMDQueryVcbExistReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryvcbid = _queryvcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryVcbExistReq* cmd = (tag_CMDQueryVcbExistReq*) data;
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
	 inline void set_errorid(int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 queryvcbid() { return _queryvcbid; } const 
	 inline void set_queryvcbid(uint32 value) { _queryvcbid = value; }

	 inline string& cqueryvcbname() { return _cqueryvcbname; } const 
	 inline void set_cqueryvcbname(const string& value) { _cqueryvcbname = value; }


	int ByteSize() { return sizeof(tag_CMDQueryVcbExistResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryVcbExistResp* cmd = (tag_CMDQueryVcbExistResp*) data;
		cmd->errorid = _errorid;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryvcbid = _queryvcbid;
		strcpy(cmd->cqueryvcbname, _cqueryvcbname.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryVcbExistResp* cmd = (tag_CMDQueryVcbExistResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 queryuserid() { return _queryuserid; } const 
	 inline void set_queryuserid(uint32 value) { _queryuserid = value; }

	 inline uint32 specvcbid() { return _specvcbid; } const 
	 inline void set_specvcbid(uint32 value) { _specvcbid = value; }


	int ByteSize() { return sizeof(tag_CMDQueryUserExistReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryUserExistReq* cmd = (tag_CMDQueryUserExistReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->queryuserid = _queryuserid;
		cmd->specvcbid = _specvcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryUserExistReq* cmd = (tag_CMDQueryUserExistReq*) data;
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
	 inline void set_errorid(int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 queryuserid() { return _queryuserid; } const 
	 inline void set_queryuserid(uint32 value) { _queryuserid = value; }

	 inline uint32 specvcbid() { return _specvcbid; } const 
	 inline void set_specvcbid(uint32 value) { _specvcbid = value; }

	 inline uint32 queryuserviplevel() { return _queryuserviplevel; } const 
	 inline void set_queryuserviplevel(uint32 value) { _queryuserviplevel = value; }

	 inline string& cspecvcbname() { return _cspecvcbname; } const 
	 inline void set_cspecvcbname(const string& value) { _cspecvcbname = value; }

	 inline string& cqueryuseralias() { return _cqueryuseralias; } const 
	 inline void set_cqueryuseralias(const string& value) { _cqueryuseralias = value; }


	int ByteSize() { return sizeof(tag_CMDQueryUserExistResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryUserExistResp* cmd = (tag_CMDQueryUserExistResp*) data;
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
		tag_CMDQueryUserExistResp* cmd = (tag_CMDQueryUserExistResp*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 openresult_type() { return _openresult_type; } const 
	 inline void set_openresult_type(int32 value) { _openresult_type = value; }


	int ByteSize() { return sizeof(tag_CMDOpenChestReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDOpenChestReq* cmd = (tag_CMDOpenChestReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->openresult_type = _openresult_type;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDOpenChestReq* cmd = (tag_CMDOpenChestReq*) data;
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


class OpenChestResp
{

private:

	int32	_errorid;
	uint32	_vcbid;
	uint32	_userid;
	int32	_usedchestnum;
	int32	_remainchestnum;
	int32	_openresult_type;
	int32	_openresult_0;
	int64	_poolvalue;
	int64	_tedengvalue;


public:

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 usedchestnum() { return _usedchestnum; } const 
	 inline void set_usedchestnum(int32 value) { _usedchestnum = value; }

	 inline int32 remainchestnum() { return _remainchestnum; } const 
	 inline void set_remainchestnum(int32 value) { _remainchestnum = value; }

	 inline int32 openresult_type() { return _openresult_type; } const 
	 inline void set_openresult_type(int32 value) { _openresult_type = value; }

	 inline int32 openresult_0() { return _openresult_0; } const 
	 inline void set_openresult_0(int32 value) { _openresult_0 = value; }

	 inline int64 poolvalue() { return _poolvalue; } const 
	 inline void set_poolvalue(int64 value) { _poolvalue = value; }

	 inline int64 tedengvalue() { return _tedengvalue; } const 
	 inline void set_tedengvalue(int64 value) { _tedengvalue = value; }


	int ByteSize() { return sizeof(tag_CMDOpenChestResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDOpenChestResp* cmd = (tag_CMDOpenChestResp*) data;
		cmd->errorid = _errorid;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->usedchestnum = _usedchestnum;
		cmd->remainchestnum = _remainchestnum;
		cmd->openresult_type = _openresult_type;
		cmd->openresult_0 = _openresult_0;
		cmd->poolvalue = _poolvalue;
		cmd->tedengvalue = _tedengvalue;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDOpenChestResp* cmd = (tag_CMDOpenChestResp*) data;
		_errorid = cmd->errorid;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_usedchestnum = cmd->usedchestnum;
		_remainchestnum = cmd->remainchestnum;
		_openresult_type = cmd->openresult_type;
		_openresult_0 = cmd->openresult_0;
		_poolvalue = cmd->poolvalue;
		_tedengvalue = cmd->tedengvalue;
	}

	void Log()
	{
		LOG("--------Receive message: OpenChestResp---------");
		LOG("errorid = %d", _errorid);
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("usedchestnum = %d", _usedchestnum);
		LOG("remainchestnum = %d", _remainchestnum);
		LOG("openresult_type = %d", _openresult_type);
		LOG("openresult_0 = %d", _openresult_0);
		LOG("poolvalue = %d", _poolvalue);
		LOG("tedengvalue = %d", _tedengvalue);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline string& alias() { return _alias; } const 
	 inline void set_alias(const string& value) { _alias = value; }

	 inline string& headurl() { return _headurl; } const 
	 inline void set_headurl(const string& value) { _headurl = value; }


	int ByteSize() { return sizeof(tag_CMDMobZhuboInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDMobZhuboInfo* cmd = (tag_CMDMobZhuboInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		strcpy(cmd->alias, _alias.c_str());
		strcpy(cmd->headurl, _headurl.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDMobZhuboInfo* cmd = (tag_CMDMobZhuboInfo*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 ncaifulevel() { return _ncaifulevel; } const 
	 inline void set_ncaifulevel(int32 value) { _ncaifulevel = value; }

	 inline int32 nlastmonthcostlevel() { return _nlastmonthcostlevel; } const 
	 inline void set_nlastmonthcostlevel(int32 value) { _nlastmonthcostlevel = value; }

	 inline int32 nthismonthcostlevel() { return _nthismonthcostlevel; } const 
	 inline void set_nthismonthcostlevel(int32 value) { _nthismonthcostlevel = value; }

	 inline int32 nthismonthcostgrade() { return _nthismonthcostgrade; } const 
	 inline void set_nthismonthcostgrade(int32 value) { _nthismonthcostgrade = value; }


	int ByteSize() { return sizeof(tag_CMDUserCaifuCostLevelInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserCaifuCostLevelInfo* cmd = (tag_CMDUserCaifuCostLevelInfo*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->ncaifulevel = _ncaifulevel;
		cmd->nlastmonthcostlevel = _nlastmonthcostlevel;
		cmd->nthismonthcostlevel = _nthismonthcostlevel;
		cmd->nthismonthcostgrade = _nthismonthcostgrade;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserCaifuCostLevelInfo* cmd = (tag_CMDUserCaifuCostLevelInfo*) data;
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
	 inline void set_userid(int32 value) { _userid = value; }

	 inline uint32 birthday_day() { return _birthday_day; } const 
	 inline void set_birthday_day(uint32 value) { _birthday_day = value; }

	 inline uint32 birthday_month() { return _birthday_month; } const 
	 inline void set_birthday_month(uint32 value) { _birthday_month = value; }

	 inline uint32 gender() { return _gender; } const 
	 inline void set_gender(uint32 value) { _gender = value; }

	 inline uint32 bloodgroup() { return _bloodgroup; } const 
	 inline void set_bloodgroup(uint32 value) { _bloodgroup = value; }

	 inline int32 birthday_year() { return _birthday_year; } const 
	 inline void set_birthday_year(int32 value) { _birthday_year = value; }

	 inline string& country() { return _country; } const 
	 inline void set_country(const string& value) { _country = value; }

	 inline string& province() { return _province; } const 
	 inline void set_province(const string& value) { _province = value; }

	 inline string& city() { return _city; } const 
	 inline void set_city(const string& value) { _city = value; }

	 inline uint32 moodlength() { return _moodlength; } const 
	 inline void set_moodlength(uint32 value) { _moodlength = value; }

	 inline uint32 explainlength() { return _explainlength; } const 
	 inline void set_explainlength(uint32 value) { _explainlength = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDUserMoreInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserMoreInfo* cmd = (tag_CMDUserMoreInfo*) data;
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
		tag_CMDUserMoreInfo* cmd = (tag_CMDUserMoreInfo*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserMoreInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserMoreInfoResp* cmd = (tag_CMDSetUserMoreInfoResp*) data;
		cmd->userid = _userid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserMoreInfoResp* cmd = (tag_CMDSetUserMoreInfoResp*) data;
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


class QueryUserMoreInfo
{

private:

	uint32	_srcid;
	uint32	_vcbid;
	uint32	_toid;
	int32	_errorid;


public:

	 inline uint32 srcid() { return _srcid; } const 
	 inline void set_srcid(uint32 value) { _srcid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 toid() { return _toid; } const 
	 inline void set_toid(uint32 value) { _toid = value; }

	 inline int32 errorid() { return _errorid; } const 
	 inline void set_errorid(int32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDQueryUserMoreInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryUserMoreInfo* cmd = (tag_CMDQueryUserMoreInfo*) data;
		cmd->srcid = _srcid;
		cmd->vcbid = _vcbid;
		cmd->toid = _toid;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryUserMoreInfo* cmd = (tag_CMDQueryUserMoreInfo*) data;
		_srcid = cmd->srcid;
		_vcbid = cmd->vcbid;
		_toid = cmd->toid;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: QueryUserMoreInfo---------");
		LOG("srcid = %d", _srcid);
		LOG("vcbid = %d", _vcbid);
		LOG("toid = %d", _toid);
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
	 inline void set_levelid(int32 value) { _levelid = value; }

	 inline int32 quanxianid() { return _quanxianid; } const 
	 inline void set_quanxianid(int32 value) { _quanxianid = value; }

	 inline uint32 quanxianprio() { return _quanxianprio; } const 
	 inline void set_quanxianprio(uint32 value) { _quanxianprio = value; }

	 inline uint32 sortid() { return _sortid; } const 
	 inline void set_sortid(uint32 value) { _sortid = value; }

	 inline uint32 sortprio() { return _sortprio; } const 
	 inline void set_sortprio(uint32 value) { _sortprio = value; }


	int ByteSize() { return sizeof(tag_CMDQuanxianId2Item); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQuanxianId2Item* cmd = (tag_CMDQuanxianId2Item*) data;
		cmd->levelid = _levelid;
		cmd->quanxianid = _quanxianid;
		cmd->quanxianprio = _quanxianprio;
		cmd->sortid = _sortid;
		cmd->sortprio = _sortprio;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQuanxianId2Item* cmd = (tag_CMDQuanxianId2Item*) data;
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
	 inline void set_actionid(uint32 value) { _actionid = value; }

	 inline uint32 actiontype() { return _actiontype; } const 
	 inline void set_actiontype(uint32 value) { _actiontype = value; }

	 inline int32 srcid() { return _srcid; } const 
	 inline void set_srcid(int32 value) { _srcid = value; }

	 inline int32 toid() { return _toid; } const 
	 inline void set_toid(int32 value) { _toid = value; }


	int ByteSize() { return sizeof(tag_CMDQuanxianAction2Item); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQuanxianAction2Item* cmd = (tag_CMDQuanxianAction2Item*) data;
		cmd->actionid = _actionid;
		cmd->actiontype = _actiontype;
		cmd->srcid = _srcid;
		cmd->toid = _toid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQuanxianAction2Item* cmd = (tag_CMDQuanxianAction2Item*) data;
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


class CloseGateObjectReq
{

private:

	uint64	_object;
	uint64	_objectid;


public:

	 inline uint64 object() { return _object; } const 
	 inline void set_object(uint64 value) { _object = value; }

	 inline uint64 objectid() { return _objectid; } const 
	 inline void set_objectid(uint64 value) { _objectid = value; }


	int ByteSize() { return sizeof(tag_CMDCloseGateObjectReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDCloseGateObjectReq* cmd = (tag_CMDCloseGateObjectReq*) data;
		cmd->object = _object;
		cmd->objectid = _objectid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDCloseGateObjectReq* cmd = (tag_CMDCloseGateObjectReq*) data;
		_object = cmd->object;
		_objectid = cmd->objectid;
	}

	void Log()
	{
		LOG("--------Receive message: CloseGateObjectReq---------");
		LOG("object = %d", _object);
		LOG("objectid = %d", _objectid);
	}

};


class CloseRoomNoty
{

private:

	uint32	_vcbid;
	string	_closereason;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline string& closereason() { return _closereason; } const 
	 inline void set_closereason(const string& value) { _closereason = value; }


	int ByteSize() { return sizeof(tag_CMDCloseRoomNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDCloseRoomNoty* cmd = (tag_CMDCloseRoomNoty*) data;
		cmd->vcbid = _vcbid;
		strcpy(cmd->closereason, _closereason.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDCloseRoomNoty* cmd = (tag_CMDCloseRoomNoty*) data;
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


class ClientPingResp
{

private:

	uint32	_userid;
	uint32	_roomid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(uint32 value) { _roomid = value; }


	int ByteSize() { return sizeof(tag_CMDClientPingResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDClientPingResp* cmd = (tag_CMDClientPingResp*) data;
		cmd->userid = _userid;
		cmd->roomid = _roomid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDClientPingResp* cmd = (tag_CMDClientPingResp*) data;
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


class QueryRoomGateAddrReq
{

private:

	uint32	_userid;
	uint32	_roomid;
	uint32	_flags;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(uint32 value) { _roomid = value; }

	 inline uint32 flags() { return _flags; } const 
	 inline void set_flags(uint32 value) { _flags = value; }


	int ByteSize() { return sizeof(tag_CMDQueryRoomGateAddrReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryRoomGateAddrReq* cmd = (tag_CMDQueryRoomGateAddrReq*) data;
		cmd->userid = _userid;
		cmd->roomid = _roomid;
		cmd->flags = _flags;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryRoomGateAddrReq* cmd = (tag_CMDQueryRoomGateAddrReq*) data;
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
	 inline void set_errorid(uint32 value) { _errorid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(uint32 value) { _roomid = value; }

	 inline uint32 flags() { return _flags; } const 
	 inline void set_flags(uint32 value) { _flags = value; }

	 inline int32 textlen() { return _textlen; } const 
	 inline void set_textlen(int32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDQueryRoomGateAddrResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDQueryRoomGateAddrResp* cmd = (tag_CMDQueryRoomGateAddrResp*) data;
		cmd->errorid = _errorid;
		cmd->userid = _userid;
		cmd->roomid = _roomid;
		cmd->flags = _flags;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDQueryRoomGateAddrResp* cmd = (tag_CMDQueryRoomGateAddrResp*) data;
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


class SetUserHideStateReq
{

private:

	uint32	_userid;
	uint32	_vcbid;
	int32	_hidestate;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 hidestate() { return _hidestate; } const 
	 inline void set_hidestate(int32 value) { _hidestate = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserHideStateReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserHideStateReq* cmd = (tag_CMDSetUserHideStateReq*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->hidestate = _hidestate;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserHideStateReq* cmd = (tag_CMDSetUserHideStateReq*) data;
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


class SetUserHideStateResp
{

private:

	uint32	_errorid;


public:

	 inline uint32 errorid() { return _errorid; } const 
	 inline void set_errorid(uint32 value) { _errorid = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserHideStateResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserHideStateResp* cmd = (tag_CMDSetUserHideStateResp*) data;
		cmd->errorid = _errorid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserHideStateResp* cmd = (tag_CMDSetUserHideStateResp*) data;
		_errorid = cmd->errorid;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserHideStateResp---------");
		LOG("errorid = %d", _errorid);
	}

};


class SetUserHideStateNoty
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_inroomstate;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 inroomstate() { return _inroomstate; } const 
	 inline void set_inroomstate(uint32 value) { _inroomstate = value; }


	int ByteSize() { return sizeof(tag_CMDSetUserHideStateNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSetUserHideStateNoty* cmd = (tag_CMDSetUserHideStateNoty*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->inroomstate = _inroomstate;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSetUserHideStateNoty* cmd = (tag_CMDSetUserHideStateNoty*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_inroomstate = cmd->inroomstate;
	}

	void Log()
	{
		LOG("--------Receive message: SetUserHideStateNoty---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("inroomstate = %d", _inroomstate);
	}

};


class UserAddChestNumNoty
{

private:

	uint32	_userid;
	uint32	_vcbid;
	uint32	_addchestnum;
	uint32	_totalchestnum;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 addchestnum() { return _addchestnum; } const 
	 inline void set_addchestnum(uint32 value) { _addchestnum = value; }

	 inline uint32 totalchestnum() { return _totalchestnum; } const 
	 inline void set_totalchestnum(uint32 value) { _totalchestnum = value; }


	int ByteSize() { return sizeof(tag_CMDUserAddChestNumNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserAddChestNumNoty* cmd = (tag_CMDUserAddChestNumNoty*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
		cmd->addchestnum = _addchestnum;
		cmd->totalchestnum = _totalchestnum;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserAddChestNumNoty* cmd = (tag_CMDUserAddChestNumNoty*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
		_addchestnum = cmd->addchestnum;
		_totalchestnum = cmd->totalchestnum;
	}

	void Log()
	{
		LOG("--------Receive message: UserAddChestNumNoty---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
		LOG("addchestnum = %d", _addchestnum);
		LOG("totalchestnum = %d", _totalchestnum);
	}

};


class JiangCiShu
{

private:

	int32	_beishu;
	int32	_count;


public:

	 inline int32 beishu() { return _beishu; } const 
	 inline void set_beishu(int32 value) { _beishu = value; }

	 inline int32 count() { return _count; } const 
	 inline void set_count(int32 value) { _count = value; }


	int ByteSize() { return sizeof(tag_JiangCiShu); }

	void SerializeToArray(void* data, int size)
	{
		tag_JiangCiShu* cmd = (tag_JiangCiShu*) data;
		cmd->beishu = _beishu;
		cmd->count = _count;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_JiangCiShu* cmd = (tag_JiangCiShu*) data;
		_beishu = cmd->beishu;
		_count = cmd->count;
	}

	void Log()
	{
		LOG("--------Receive message: JiangCiShu---------");
		LOG("beishu = %d", _beishu);
		LOG("count = %d", _count);
	}

};


class AddClosedFriendNotify
{

private:

	uint32	_userid;
	uint32	_vcbid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(tag_CMDAddClosedFriendNotify); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDAddClosedFriendNotify* cmd = (tag_CMDAddClosedFriendNotify*) data;
		cmd->userid = _userid;
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDAddClosedFriendNotify* cmd = (tag_CMDAddClosedFriendNotify*) data;
		_userid = cmd->userid;
		_vcbid = cmd->vcbid;
	}

	void Log()
	{
		LOG("--------Receive message: AddClosedFriendNotify---------");
		LOG("userid = %d", _userid);
		LOG("vcbid = %d", _vcbid);
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
	 inline void set_naction(int32 value) { _naction = value; }

	 inline int32 ntype() { return _ntype; } const 
	 inline void set_ntype(int32 value) { _ntype = value; }

	 inline int32 nrunerid() { return _nrunerid; } const 
	 inline void set_nrunerid(int32 value) { _nrunerid = value; }

	 inline string& createtime() { return _createtime; } const 
	 inline void set_createtime(const string& value) { _createtime = value; }

	 inline string& keyword() { return _keyword; } const 
	 inline void set_keyword(const string& value) { _keyword = value; }


	int ByteSize() { return sizeof(tag_AdKeywordInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_AdKeywordInfo* cmd = (tag_AdKeywordInfo*) data;
		cmd->naction = _naction;
		cmd->ntype = _ntype;
		cmd->nrunerid = _nrunerid;
		strcpy(cmd->createtime, _createtime.c_str());
		strcpy(cmd->keyword, _keyword.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_AdKeywordInfo* cmd = (tag_AdKeywordInfo*) data;
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


class AdKeywordsReq
{

private:

	int32	_num;
	string	_keywod;


public:

	 inline int32 num() { return _num; } const 
	 inline void set_num(int32 value) { _num = value; }

	 inline string& keywod() { return _keywod; } const 
	 inline void set_keywod(const string& value) { _keywod = value; }


	int ByteSize() { return sizeof(tag_CMDAdKeywordsReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDAdKeywordsReq* cmd = (tag_CMDAdKeywordsReq*) data;
		cmd->num = _num;
		strcpy(cmd->keywod, _keywod.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDAdKeywordsReq* cmd = (tag_CMDAdKeywordsReq*) data;
		_num = cmd->num;
		_keywod = cmd->keywod;
	}

	void Log()
	{
		LOG("--------Receive message: AdKeywordsReq---------");
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
	 inline void set_errid(int32 value) { _errid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDAdKeywordsResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDAdKeywordsResp* cmd = (tag_CMDAdKeywordsResp*) data;
		cmd->errid = _errid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDAdKeywordsResp* cmd = (tag_CMDAdKeywordsResp*) data;
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


class AdKeywordsNotify
{

private:

	int32	_num;
	string	_keywod;


public:

	 inline int32 num() { return _num; } const 
	 inline void set_num(int32 value) { _num = value; }

	 inline string& keywod() { return _keywod; } const 
	 inline void set_keywod(const string& value) { _keywod = value; }


	int ByteSize() { return sizeof(tag_CMDAdKeywordsNotify); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDAdKeywordsNotify* cmd = (tag_CMDAdKeywordsNotify*) data;
		cmd->num = _num;
		strcpy(cmd->keywod, _keywod.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDAdKeywordsNotify* cmd = (tag_CMDAdKeywordsNotify*) data;
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
	 inline void set_teacher_userid(uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 
	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int64 data1() { return _data1; } const 
	 inline void set_data1(int64 value) { _data1 = value; }

	 inline string& data2() { return _data2; } const 
	 inline void set_data2(const string& value) { _data2 = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherScoreReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherScoreReq* cmd = (tag_CMDTeacherScoreReq*) data;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->vcbid = _vcbid;
		cmd->data1 = _data1;
		strcpy(cmd->data2, _data2.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTeacherScoreReq* cmd = (tag_CMDTeacherScoreReq*) data;
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
		LOG("data1 = %d", _data1);
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
	 inline void set_type(int32 value) { _type = value; }

	 inline uint32 teacher_userid() { return _teacher_userid; } const 
	 inline void set_teacher_userid(uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 
	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline int32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(int32 value) { _vcbid = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherScoreResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherScoreResp* cmd = (tag_CMDTeacherScoreResp*) data;
		cmd->type = _type;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->vcbid = _vcbid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTeacherScoreResp* cmd = (tag_CMDTeacherScoreResp*) data;
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
	 inline void set_teacher_userid(uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 
	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline string& alias() { return _alias; } const 
	 inline void set_alias(const string& value) { _alias = value; }

	 inline uint32 usertype() { return _usertype; } const 
	 inline void set_usertype(uint32 value) { _usertype = value; }

	 inline uint32 score() { return _score; } const 
	 inline void set_score(uint32 value) { _score = value; }

	 inline string& logtime() { return _logtime; } const 
	 inline void set_logtime(const string& value) { _logtime = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int64 data1() { return _data1; } const 
	 inline void set_data1(int64 value) { _data1 = value; }

	 inline int64 data2() { return _data2; } const 
	 inline void set_data2(int64 value) { _data2 = value; }

	 inline int64 data3() { return _data3; } const 
	 inline void set_data3(int64 value) { _data3 = value; }

	 inline string& data4() { return _data4; } const 
	 inline void set_data4(const string& value) { _data4 = value; }

	 inline string& data5() { return _data5; } const 
	 inline void set_data5(const string& value) { _data5 = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherScoreRecordReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherScoreRecordReq* cmd = (tag_CMDTeacherScoreRecordReq*) data;
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
		tag_CMDTeacherScoreRecordReq* cmd = (tag_CMDTeacherScoreRecordReq*) data;
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
		LOG("data1 = %d", _data1);
		LOG("data2 = %d", _data2);
		LOG("data3 = %d", _data3);
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
	 inline void set_teacher_userid(uint32 value) { _teacher_userid = value; }

	 inline string& teacheralias() { return _teacheralias; } const 
	 inline void set_teacheralias(const string& value) { _teacheralias = value; }

	 inline int32 type() { return _type; } const 
	 inline void set_type(int32 value) { _type = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherScoreRecordResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherScoreRecordResp* cmd = (tag_CMDTeacherScoreRecordResp*) data;
		cmd->teacher_userid = _teacher_userid;
		strcpy(cmd->teacheralias, _teacheralias.c_str());
		cmd->type = _type;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTeacherScoreRecordResp* cmd = (tag_CMDTeacherScoreRecordResp*) data;
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


class RoborTeacherIdNoty
{

private:

	uint32	_vcbid;
	uint32	_roborid;
	uint32	_teacherid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 roborid() { return _roborid; } const 
	 inline void set_roborid(uint32 value) { _roborid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(tag_CMDRoborTeacherIdNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoborTeacherIdNoty* cmd = (tag_CMDRoborTeacherIdNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->roborid = _roborid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoborTeacherIdNoty* cmd = (tag_CMDRoborTeacherIdNoty*) data;
		_vcbid = cmd->vcbid;
		_roborid = cmd->roborid;
		_teacherid = cmd->teacherid;
	}

	void Log()
	{
		LOG("--------Receive message: RoborTeacherIdNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("roborid = %d", _roborid);
		LOG("teacherid = %d", _teacherid);
	}

};


class TeacherGiftListReq
{

private:

	uint32	_vcbid;
	uint32	_teacherid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(uint32 value) { _teacherid = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherGiftListReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherGiftListReq* cmd = (tag_CMDTeacherGiftListReq*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTeacherGiftListReq* cmd = (tag_CMDTeacherGiftListReq*) data;
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
	 inline void set_seqid(uint32 value) { _seqid = value; }

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(uint32 value) { _teacherid = value; }

	 inline string& useralias() { return _useralias; } const 
	 inline void set_useralias(const string& value) { _useralias = value; }

	 inline uint64 t_num() { return _t_num; } const 
	 inline void set_t_num(uint64 value) { _t_num = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherGiftListResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherGiftListResp* cmd = (tag_CMDTeacherGiftListResp*) data;
		cmd->seqid = _seqid;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		strcpy(cmd->useralias, _useralias.c_str());
		cmd->t_num = _t_num;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTeacherGiftListResp* cmd = (tag_CMDTeacherGiftListResp*) data;
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
		LOG("t_num = %d", _t_num);
	}

};


class RoomAndSubRoomIdNoty
{

private:

	uint32	_roomid;
	uint32	_subroomid;


public:

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(uint32 value) { _roomid = value; }

	 inline uint32 subroomid() { return _subroomid; } const 
	 inline void set_subroomid(uint32 value) { _subroomid = value; }


	int ByteSize() { return sizeof(tag_CMDRoomAndSubRoomIdNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDRoomAndSubRoomIdNoty* cmd = (tag_CMDRoomAndSubRoomIdNoty*) data;
		cmd->roomid = _roomid;
		cmd->subroomid = _subroomid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDRoomAndSubRoomIdNoty* cmd = (tag_CMDRoomAndSubRoomIdNoty*) data;
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
	 inline void set_teacherid(uint32 value) { _teacherid = value; }

	 inline uint32 roomid() { return _roomid; } const 
	 inline void set_roomid(uint32 value) { _roomid = value; }

	 inline float avarage_score() { return _avarage_score; } const 
	 inline void set_avarage_score(float value) { _avarage_score = value; }

	 inline string& data1() { return _data1; } const 
	 inline void set_data1(const string& value) { _data1 = value; }

	 inline uint32 data2() { return _data2; } const 
	 inline void set_data2(uint32 value) { _data2 = value; }


	int ByteSize() { return sizeof(tag_CMDTeacherAvarageScoreNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDTeacherAvarageScoreNoty* cmd = (tag_CMDTeacherAvarageScoreNoty*) data;
		cmd->teacherid = _teacherid;
		cmd->roomid = _roomid;
		cmd->avarage_score = _avarage_score;
		strcpy(cmd->data1, _data1.c_str());
		cmd->data2 = _data2;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDTeacherAvarageScoreNoty* cmd = (tag_CMDTeacherAvarageScoreNoty*) data;
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
		LOG("avarage_score = %d", _avarage_score);
		LOG("data1 = %s", _data1.c_str());
		LOG("data2 = %d", _data2);
	}

};


class ExitAlertReq
{

private:

	int32	_userid;


public:

	 inline int32 userid() { return _userid; } const 
	 inline void set_userid(int32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDExitAlertReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDExitAlertReq* cmd = (tag_CMDExitAlertReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDExitAlertReq* cmd = (tag_CMDExitAlertReq*) data;
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
	 inline void set_userid(int32 value) { _userid = value; }

	 inline string& email() { return _email; } const 
	 inline void set_email(const string& value) { _email = value; }

	 inline string& qq() { return _qq; } const 
	 inline void set_qq(const string& value) { _qq = value; }

	 inline string& tel() { return _tel; } const 
	 inline void set_tel(const string& value) { _tel = value; }

	 inline int32 hit_gold_egg_time() { return _hit_gold_egg_time; } const 
	 inline void set_hit_gold_egg_time(int32 value) { _hit_gold_egg_time = value; }

	 inline int32 data1() { return _data1; } const 
	 inline void set_data1(int32 value) { _data1 = value; }

	 inline int32 data2() { return _data2; } const 
	 inline void set_data2(int32 value) { _data2 = value; }

	 inline int32 data3() { return _data3; } const 
	 inline void set_data3(int32 value) { _data3 = value; }

	 inline string& data4() { return _data4; } const 
	 inline void set_data4(const string& value) { _data4 = value; }

	 inline string& data5() { return _data5; } const 
	 inline void set_data5(const string& value) { _data5 = value; }


	int ByteSize() { return sizeof(tag_CMDExitAlertResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDExitAlertResp* cmd = (tag_CMDExitAlertResp*) data;
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
		tag_CMDExitAlertResp* cmd = (tag_CMDExitAlertResp*) data;
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
	 inline void set_userid(int32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDSecureInfoReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSecureInfoReq* cmd = (tag_CMDSecureInfoReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSecureInfoReq* cmd = (tag_CMDSecureInfoReq*) data;
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
	 inline void set_remindtime(int32 value) { _remindtime = value; }

	 inline int32 data1() { return _data1; } const 
	 inline void set_data1(int32 value) { _data1 = value; }

	 inline int32 data2() { return _data2; } const 
	 inline void set_data2(int32 value) { _data2 = value; }

	 inline int32 data3() { return _data3; } const 
	 inline void set_data3(int32 value) { _data3 = value; }

	 inline string& data4() { return _data4; } const 
	 inline void set_data4(const string& value) { _data4 = value; }

	 inline string& data5() { return _data5; } const 
	 inline void set_data5(const string& value) { _data5 = value; }

	 inline string& data6() { return _data6; } const 
	 inline void set_data6(const string& value) { _data6 = value; }


	int ByteSize() { return sizeof(tag_CMDSecureInfoResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSecureInfoResp* cmd = (tag_CMDSecureInfoResp*) data;
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
		tag_CMDSecureInfoResp* cmd = (tag_CMDSecureInfoResp*) data;
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


class ReportMediaGateReq
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint32	_textlen;
	string	_content;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 textlen() { return _textlen; } const 
	 inline void set_textlen(uint32 value) { _textlen = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDReportMediaGateReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDReportMediaGateReq* cmd = (tag_CMDReportMediaGateReq*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->textlen = _textlen;
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDReportMediaGateReq* cmd = (tag_CMDReportMediaGateReq*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline int32 errid() { return _errid; } const 
	 inline void set_errid(int32 value) { _errid = value; }


	int ByteSize() { return sizeof(tag_CMDReportMediaGateResp); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDReportMediaGateResp* cmd = (tag_CMDReportMediaGateResp*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->errid = _errid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDReportMediaGateResp* cmd = (tag_CMDReportMediaGateResp*) data;
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


class HitGoldEggWebNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDHitGoldEggWebNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDHitGoldEggWebNoty* cmd = (tag_CMDHitGoldEggWebNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDHitGoldEggWebNoty* cmd = (tag_CMDHitGoldEggWebNoty*) data;
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


class HitGoldEggClientNoty
{

private:

	uint32	_vcbid;
	uint32	_userid;
	uint64	_money;


public:

	 inline uint32 vcbid() { return _vcbid; } const 
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint64 money() { return _money; } const 
	 inline void set_money(uint64 value) { _money = value; }


	int ByteSize() { return sizeof(tag_CMDHitGoldEggClientNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDHitGoldEggClientNoty* cmd = (tag_CMDHitGoldEggClientNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
		cmd->money = _money;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDHitGoldEggClientNoty* cmd = (tag_CMDHitGoldEggClientNoty*) data;
		_vcbid = cmd->vcbid;
		_userid = cmd->userid;
		_money = cmd->money;
	}

	void Log()
	{
		LOG("--------Receive message: HitGoldEggClientNoty---------");
		LOG("vcbid = %d", _vcbid);
		LOG("userid = %d", _userid);
		LOG("money = %d", _money);
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline uint32 teacherid() { return _teacherid; } const 
	 inline void set_teacherid(uint32 value) { _teacherid = value; }

	 inline int32 score() { return _score; } const 
	 inline void set_score(int32 value) { _score = value; }

	 inline int32 userid() { return _userid; } const 
	 inline void set_userid(int32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDUserScoreNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserScoreNoty* cmd = (tag_CMDUserScoreNoty*) data;
		cmd->vcbid = _vcbid;
		cmd->teacherid = _teacherid;
		cmd->score = _score;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserScoreNoty* cmd = (tag_CMDUserScoreNoty*) data;
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
	 inline void set_vcbid(uint32 value) { _vcbid = value; }

	 inline int32 userid() { return _userid; } const 
	 inline void set_userid(int32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDResetConnInfo); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDResetConnInfo* cmd = (tag_CMDResetConnInfo*) data;
		cmd->vcbid = _vcbid;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDResetConnInfo* cmd = (tag_CMDResetConnInfo*) data;
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 sessionid() { return _sessionid; } const 
	 inline void set_sessionid(uint32 value) { _sessionid = value; }

	 inline uint32 devicetype() { return _devicetype; } const 
	 inline void set_devicetype(uint32 value) { _devicetype = value; }


	int ByteSize() { return sizeof(tag_CMDUserOnlineBaseInfoNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDUserOnlineBaseInfoNoty* cmd = (tag_CMDUserOnlineBaseInfoNoty*) data;
		cmd->userid = _userid;
		cmd->sessionid = _sessionid;
		cmd->devicetype = _devicetype;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDUserOnlineBaseInfoNoty* cmd = (tag_CMDUserOnlineBaseInfoNoty*) data;
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


class Syscast
{

private:

	uint32	_newtype;
	uint64	_nid;
	string	_title;
	string	_content;


public:

	 inline uint32 newtype() { return _newtype; } const 
	 inline void set_newtype(uint32 value) { _newtype = value; }

	 inline uint64 nid() { return _nid; } const 
	 inline void set_nid(uint64 value) { _nid = value; }

	 inline string& title() { return _title; } const 
	 inline void set_title(const string& value) { _title = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDSyscast); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSyscast* cmd = (tag_CMDSyscast*) data;
		cmd->newType = _newtype;
		cmd->nid = _nid;
		strcpy(cmd->title, _title.c_str());
		strcpy(cmd->content, _content.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSyscast* cmd = (tag_CMDSyscast*) data;
		_newtype = cmd->newType;
		_nid = cmd->nid;
		_title = cmd->title;
		_content = cmd->content;
	}

	void Log()
	{
		LOG("--------Receive message: Syscast---------");
		LOG("newtype = %d", _newtype);
		LOG("nid = %d", _nid);
		LOG("title = %s", _title.c_str());
		LOG("content = %s", _content.c_str());
	}

};


class SessionTokenResp
{

private:

	uint32	_userid;
	string	_sessiontoken;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline string& sessiontoken() { return _sessiontoken; } const 
	 inline void set_sessiontoken(const string& value) { _sessiontoken = value; }


	int ByteSize() { return sizeof(CMDSessionTokenResp_t); }

	void SerializeToArray(void* data, int size)
	{
		CMDSessionTokenResp_t* cmd = (CMDSessionTokenResp_t*) data;
		cmd->userid = _userid;
		strcpy(cmd->sessiontoken, _sessiontoken.c_str());
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSessionTokenResp* cmd = (tag_CMDSessionTokenResp*) data;
		_userid = cmd->userid;
		_sessiontoken = cmd->sessiontoken;
	}

	void Log()
	{
		LOG("--------Receive message: SessionTokenResp---------");
		LOG("userid = %d", _userid);
		LOG("sessiontoken = %s", _sessiontoken.c_str());
	}

};


class ConfigSvrNoty
{

private:

	uint32	_type;
	uint32	_data_ver;


public:

	 inline uint32 type() { return _type; } const 
	 inline void set_type(uint32 value) { _type = value; }

	 inline uint32 data_ver() { return _data_ver; } const 
	 inline void set_data_ver(uint32 value) { _data_ver = value; }


	int ByteSize() { return sizeof(tag_CMDConfigSvrNoty); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDConfigSvrNoty* cmd = (tag_CMDConfigSvrNoty*) data;
		cmd->type = _type;
		cmd->data_ver = _data_ver;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDConfigSvrNoty* cmd = (tag_CMDConfigSvrNoty*) data;
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


class SessionTokenReq
{

private:

	uint32	_userid;


public:

	 inline uint32 userid() { return _userid; } const 
	 inline void set_userid(uint32 value) { _userid = value; }


	int ByteSize() { return sizeof(tag_CMDSessionTokenReq); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDSessionTokenReq* cmd = (tag_CMDSessionTokenReq*) data;
		cmd->userid = _userid;
	}

	void ParseFromArray(void* data, int size)
	{
		tag_CMDSessionTokenReq* cmd = (tag_CMDSessionTokenReq*) data;
		_userid = cmd->userid;
	}

	void Log()
	{
		LOG("--------Receive message: SessionTokenReq---------");
		LOG("userid = %d", _userid);
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
	 inline void set_userid(uint32 value) { _userid = value; }

	 inline uint32 termtype() { return _termtype; } const 
	 inline void set_termtype(uint32 value) { _termtype = value; }

	 inline uint32 type() { return _type; } const 
	 inline void set_type(uint32 value) { _type = value; }

	 inline uint32 needresp() { return _needresp; } const 
	 inline void set_needresp(uint32 value) { _needresp = value; }

	 inline uint32 validtime() { return _validtime; } const 
	 inline void set_validtime(uint32 value) { _validtime = value; }

	 inline uint32 versionflag() { return _versionflag; } const 
	 inline void set_versionflag(uint32 value) { _versionflag = value; }

	 inline uint32 version() { return _version; } const 
	 inline void set_version(uint32 value) { _version = value; }

	 inline uint32 length() { return _length; } const 
	 inline void set_length(uint32 value) { _length = value; }

	 inline string& content() { return _content; } const 
	 inline void set_content(const string& value) { _content = value; }


	int ByteSize() { return sizeof(tag_CMDPushGateMask); }

	void SerializeToArray(void* data, int size)
	{
		tag_CMDPushGateMask* cmd = (tag_CMDPushGateMask*) data;
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
		tag_CMDPushGateMask* cmd = (tag_CMDPushGateMask*) data;
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







#endif
