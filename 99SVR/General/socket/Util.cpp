#include "stdafx.h"
#include "Util.h"


string int2string(int v)
{
	char temp[16];
	sprintf(temp, "%d", v);
	return temp;
}

void string2timestamp(const std::string &str,std::string &retStr)
{
	char tmp[32] = {0};
	//20160421035614
	if(str.size() != 14)
	{
		return;
	}

	sprintf(tmp, "%s-%s-%s %s:%s:%s", str.substr(0,4).c_str(),
		str.substr(4,2).c_str(),
		str.substr(6,2).c_str(),
		str.substr(8,2).c_str(),
		str.substr(10,2).c_str(),
		str.substr(12,2).c_str()
		);

	retStr = tmp;

	//return retStr;

}
