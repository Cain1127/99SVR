#ifndef __HTTP_COMPLEX_MESSAGE_H__
#define __HTTP_COMPLEX_MESSAGE_H__



#include <string>
#include <vector>
#include "Log.h"
#include "HttpMessage.pb.h"
using std::string;
using std::vector;

class TeamPrivateServiceSummaryPack
{

private:

	uint32 _vipLevelId;
	string _vipLevelName;
	uint32 _isOpen;
	vector<PrivateServiceSummary> _summaryList;

public:

	 inline uint32& vipLevelId() { return _vipLevelId; } const

	 inline void set_vipLevelId(const uint32& value) { _vipLevelId = value; }

	 inline string& vipLevelName() { return _vipLevelName; } const

	 inline void set_vipLevelName(const string& value) { _vipLevelName = value; }

	 inline uint32& isOpen() { return _isOpen; } const

	 inline void set_isOpen(const uint32& value) { _isOpen = value; }

	 inline vector<PrivateServiceSummary>& summaryList() { return _summaryList; } const

	 inline void set_summaryList(const vector<PrivateServiceSummary>& value) { _summaryList = value; }

};



#endif
