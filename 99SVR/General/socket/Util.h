
#include <stdio.h>
#include <string>
using std::string;

typedef const string& rstring;

string int2string(int v);

void string2timestamp(const std::string &str,std::string &retStr);

#ifdef WIN
string UTF8ToGBK(const std::string& strUTF8);

string GBKToUTF8(const std::string& strGBK);
#endif