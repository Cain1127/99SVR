#include "Http.h"

#include "stdafx.h"
#include "Util.h"
#include "platform.h"

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
		retStr = str;
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

#ifdef WIN
string UTF8ToGBK(const std::string& strUTF8)  
{  
	int len = MultiByteToWideChar(CP_UTF8, 0, strUTF8.c_str(), -1, NULL, 0);
	unsigned short * wszGBK = new unsigned short[len + 1];
	memset(wszGBK, 0, len * 2 + 2);
	MultiByteToWideChar(CP_UTF8, 0, (LPCSTR)strUTF8.c_str(), -1, (LPWSTR)wszGBK, len);

	len = WideCharToMultiByte(CP_ACP, 0, (LPCWSTR)wszGBK, -1, NULL, 0, NULL, NULL);
	char *szGBK = new char[len + 1];
	memset(szGBK, 0, len + 1);
	WideCharToMultiByte(CP_ACP,0, (LPCWSTR)wszGBK, -1, szGBK, len, NULL, NULL);
	//strUTF8 = szGBK;
	std::string strTemp(szGBK);
	delete[]szGBK;
	delete[]wszGBK;
	return strTemp;
}

string GBKToUTF8(const std::string& strGBK)
{  
	string strOutUTF8 = "";
	WCHAR * str1;
	int n = MultiByteToWideChar(CP_ACP, 0, strGBK.c_str(), -1, NULL, 0);
	str1 = new WCHAR[n];
	MultiByteToWideChar(CP_ACP, 0, strGBK.c_str(), -1, str1, n);
	n = WideCharToMultiByte(CP_UTF8, 0, str1, -1, NULL, 0, NULL, NULL);
	char * str2 = new char[n];
	WideCharToMultiByte(CP_UTF8, 0, str1, -1, str2, n, NULL, NULL);
	strOutUTF8 = str2;
	delete[]str1;
	str1 = NULL;
	delete[]str2;
	str2 = NULL;
	return strOutUTF8;
}
#endif
