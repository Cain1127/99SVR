//
//  HttpMessageComplex.pb.h
//  99SVR
//
//  Created by xia zhonglin  on 4/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//
#ifndef __HTTP_COMPLEX_MESSAGE_H__
#define __HTTP_COMPLEX_MESSAGE_H__

#include <string>
#include <vector>
#include "Log.h"
#include "HttpMessage.pb.h"

using std::string;
using std::vector;

class TeamPriviteServiceSummaryPack
{
    
private:
    
    uint32 _vipLevelId;
    string _vipLevelName;
    vector<PrivateServiceSummary> _summaryList;
    
public:
    
    inline uint32& vipLevelId() { return _vipLevelId; } const
    
    inline void set_vipLevelId(const uint32& value) { _vipLevelId = value; }
    
    inline string& vipLevelName() { return _vipLevelName; } const
    
    inline void set_vipLevelName(const string& value) { _vipLevelName = value; }
    
    inline vector<PrivateServiceSummary>& summaryList() { return _summaryList; } const
    
    inline void set_summaryList(const vector<PrivateServiceSummary>& value) { _summaryList = value; }
    
};


class TeamIntroduce
{
    
private:
    
    string _teamName;
    string _teamIcon;
    string _introduce;
    vector<VideoInfo> _videoList;
    
public:
    
    inline string& teamName() { return _teamName; } const
    
    inline void set_teamName(const string& value) { _teamName = value; }
    
    inline string& teamIcon() { return _teamIcon; } const
    
    inline void set_teamIcon(const string& value) { _teamIcon = value; }
    
    inline string& introduce() { return _introduce; } const
    
    inline void set_introduce(const string& value) { _introduce = value; }
    
    inline vector<VideoInfo>& videoList() { return _videoList; } const
    
    inline void set_videoList(const vector<VideoInfo>& value) { _videoList = value; }
    
};

#endif /* HttpMessageComplex_pb_h */
