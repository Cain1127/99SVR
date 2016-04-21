#ifndef _JSON_MESSAGE_H_
#define _JSON_MESSAGE_H_

#include "Json.h"
#include "Log.h"

#include <vector>
#include <exception>

using namespace std;

class HomePageVideoroomItem
{
private:
	std::string _nvcbid;
	std::string _croompic;
	std::string _livetype;
	std::string _ncount;
	std::string _cname;
public:
	inline void set_nvcbid(std::string nvcbid){this->_nvcbid = nvcbid;}
	inline void set_croompic(std::string croompic){this->_croompic = croompic;}
	inline void set_livetype(std::string livetype){this->_livetype = livetype;}
	inline void set_ncount(std::string ncount){this->_ncount = ncount;}
	inline void set_cname(std::string cname){this->_cname = cname;}

	inline string& get_nvcbid() { return _nvcbid; } const 
	inline string& get_croompic() { return _nvcbid; } const 
	inline string& get_livetype() { return _livetype; } const 
	inline string& get_ncount() { return _ncount; } const 
	inline string& get_cname() { return _cname; } const 

	void Log()
	{
		LOG("--------Found Http message: HomePageHttpResponseVideoroomItem---------");
		LOG("nvcbid = %s", _nvcbid.c_str());
		LOG("croompic = %s", _croompic.c_str());
		LOG("livetype = %s", _livetype.c_str());
		LOG("ncount = %s", _ncount.c_str());
		LOG("cname = %s", _cname.c_str());
	}
};

class HomePageTextroomItem
{
private:
	std::string _nvcbid;
	std::string _roomname;
	std::string _croompic;
	std::string _livetype;
	std::string _ncount;
	std::string _clabel;
	std::string _teacherid;

public:
	inline void set_nvcbid(std::string nvcbid){this->_nvcbid = nvcbid;}
	inline void set_roomname(std::string roomname){this->_roomname = roomname;}
	inline void set_croompic(std::string croompic){this->_croompic = croompic;}
	inline void set_livetype(std::string livetype){this->_livetype = livetype;}
	inline void set_ncount(std::string ncount){this->_ncount = ncount;}
	inline void set_clabel(std::string clabel){this->_clabel = clabel;}
	inline void set_teacherid(std::string teacherid){this->_teacherid = teacherid;}

	inline string& get_nvcbid() { return _nvcbid; } const 
	inline string& get_roomname() { return _roomname; } const 
	inline string& get_croompic() { return _nvcbid; } const 
	inline string& get_livetype() { return _livetype; } const 
	inline string& get_ncount() { return _ncount; } const 
	inline string& get_clabel() { return _clabel; } const 
	inline string& get_teacherid() { return _teacherid; } const 

	void Log()
	{
		LOG("--------Found Http message: HomePageHttpResponseTextroomItem---------");
		LOG("nvcbid = %s", _nvcbid.c_str());
		LOG("roomname = %s", _roomname.c_str());
		LOG("croompic = %s", _croompic.c_str());
		LOG("livetype = %s", _livetype.c_str());
		LOG("ncount = %s", _ncount.c_str());
		LOG("clabel = %s", _clabel.c_str());
		LOG("teacherid = %s", _teacherid.c_str());
	}
};

class HomePageViewpointItem
{
private:
	std::string _viewid;
	std::string _teacherid;
	std::string _dtime;
	std::string _czans;
	std::string _title;
	std::string _roomid;
	std::string _calias;

public:
	inline void set_viewid(std::string viewid){this->_viewid = viewid;}
	inline void set_teacherid(std::string teacherid){this->_teacherid = teacherid;}
	inline void set_dtime(std::string dtime){this->_dtime = dtime;}
	inline void set_czans(std::string czans){this->_czans = czans;}
	inline void set_title(std::string title){this->_title = title;}
	inline void set_roomid(std::string roomid){this->_roomid = roomid;}
	inline void set_calias(std::string calias){this->_calias = calias;}

	inline string& get_viewid() { return _viewid; } const 
	inline string& get_teacherid() { return _teacherid; } const 
	inline string& get_dtime() { return _dtime; } const 
	inline string& get_czans() { return _czans; } const 
	inline string& get_title() { return _title; } const 
	inline string& get_roomid() { return _roomid; } const 
	inline string& get_calias() { return _calias; } const 

	void Log()
	{
		LOG("--------Found Http message: HomePageHttpResponseViewpointItem---------");
		LOG("viewid = %s", _viewid.c_str());
		LOG("teacherid = %s", _teacherid.c_str());
		LOG("dtime = %s", _dtime.c_str());
		LOG("czans = %s", _czans.c_str());
		LOG("title = %s", _title.c_str());
		LOG("roomid = %s", _roomid.c_str());
		LOG("calias = %s", _calias.c_str());
	}
};


class FollowTeacherRoomItem
{
private:
	std::string _nvcbid;
	std::string _roomname;
	std::string _teacherid;
	std::string _croompic;
	std::string _clabel;
	std::string _ncount;

public:
	inline void set_nvcbid(std::string nvcbid){this->_nvcbid = nvcbid;}
	inline void set_roomname(std::string roomname){this->_roomname = roomname;}
	inline void set_teacherid(std::string teacherid){this->_teacherid = teacherid;}
	inline void set_croompic(std::string croompic){this->_croompic = croompic;}
	inline void set_clabel(std::string clabel){this->_clabel = clabel;}
	inline void set_ncount(std::string ncount){this->_ncount = ncount;}

	inline string& get_nvcbid() { return _nvcbid; } const 
	inline string& get_roomname() { return _roomname; } const 
	inline string& get_teacherid() { return _teacherid; } const 
	inline string& get_croompic() { return _croompic; } const 
	inline string& get_clabel() { return _clabel; } const 
	inline string& get_ncount() { return _ncount; } const 

	void Log()
	{
		LOG("--------Found Http message: FollowTeacherHttpResponseRoomItem---------");
		LOG("nvcbid = %s", _nvcbid.c_str());
		LOG("roomname = %s", _roomname.c_str());
		LOG("teacherid = %s", _teacherid.c_str());
		LOG("croompic = %s", _croompic.c_str());
		LOG("clabel = %s", _clabel.c_str());
		LOG("ncount = %s", _ncount.c_str());
	}
};

class FootPrintItem
{
private:
	std::string _nvcbid;
	std::string _cname;
	std::string _password;
	std::string _croompic;
	std::string _ncount;
	std::string _cgateaddr;
	std::string _livetype;
	std::string _ntype;

public:
	inline void set_nvcbid(std::string nvcbid){this->_nvcbid = nvcbid;}
	inline void set_cname(std::string cname){this->_cname = cname;}
	inline void set_password(std::string password){this->_password = password;}
	inline void set_croompic(std::string croompic){this->_croompic = croompic;}
	inline void set_ncount(std::string ncount){this->_ncount = ncount;}
	inline void set_cgateaddr(std::string cgateaddr){this->_cgateaddr = cgateaddr;}
	inline void set_livetype(std::string livetype){this->_livetype = livetype;}
	inline void set_ntype(std::string ntype){this->_ntype = ntype;}

	inline string& get_nvcbid() { return _nvcbid; } const 
	inline string& get_cname() { return _cname; } const 
	inline string& get_password() { return _password; } const 
	inline string& get_croompic() { return _croompic; } const 
	inline string& get_ncount() { return _ncount; } const 
	inline string& get_cgateaddr() { return _cgateaddr; } const 
	inline string& get_livetype() { return _livetype; } const 
	inline string& get_ntype() { return _ntype; } const 

	void Log()
	{
		LOG("--------Found Http message: FootPrintHttpResponseItem---------");
		LOG("nvcbid = %s", _nvcbid.c_str());
		LOG("cname = %s", _cname.c_str());
		LOG("password = %s", _password.c_str());
		LOG("croompic = %s", _croompic.c_str());
		LOG("ncount = %s", _ncount.c_str());
		LOG("cgateaddr = %s", _cgateaddr.c_str());
		LOG("livetype = %s", _livetype.c_str());
		LOG("ntype = %s", _ntype.c_str());
	}
};

class CollectItem
{
private:
	std::string _nvcbid;
	std::string _cname;
	std::string _password;
	std::string _croompic;
	std::string _ncount;
	std::string _cgateaddr;
	std::string _ntype;
public:
	inline void set_nvcbid(std::string nvcbid){this->_nvcbid = nvcbid;}
	inline void set_cname(std::string cname){this->_cname = cname;}
	inline void set_password(std::string password){this->_password = password;}
	inline void set_croompic(std::string croompic){this->_croompic = croompic;}
	inline void set_ncount(std::string ncount){this->_ncount = ncount;}
	inline void set_cgateaddr(std::string cgateaddr){this->_cgateaddr = cgateaddr;}
	inline void set_ntype(std::string ntype){this->_ntype = ntype;}

	inline string& get_nvcbid() { return _nvcbid; } const 
	inline string& get_cname() { return _cname; } const 
	inline string& get_password() { return _password; } const 
	inline string& get_croompic() { return _croompic; } const 
	inline string& get_ncount() { return _ncount; } const 
	inline string& get_cgateaddr() { return _cgateaddr; } const 
	inline string& get_ntype() { return _ntype; } const 

	void Log()
	{
		LOG("--------Found Http message: CollectHttpResponseItem---------");
		LOG("nvcbid = %s", _nvcbid.c_str());
		LOG("cname = %s", _cname.c_str());
		LOG("password = %s", _password.c_str());
		LOG("croompic = %s", _croompic.c_str());
		LOG("ncount = %s", _ncount.c_str());
		LOG("cgateaddr = %s", _cgateaddr.c_str());
		LOG("ntype = %s", _ntype.c_str());
	}
};

class BannerItem
{
private:
	std::string _url;
	std::string _type;

public:
	inline void set_url(std::string url){this->_url = url;}
	inline void set_type(std::string type){this->_type = type;}

	inline string& get_url() { return _url; } const 
	inline string& get_type() { return _type; } const 

	void Log()
	{
		LOG("--------Found Http message: BannerHttpResponseItem---------");
		LOG("url = %s", _url.c_str());
		LOG("type = %s", _type.c_str());
	}
};



#endif