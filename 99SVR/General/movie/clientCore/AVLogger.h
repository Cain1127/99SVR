#pragma once
#ifndef _AVLOG_H_
#define _AVLOG_H_

#include <stdio.h>
#include <string>
#include <iostream>
#include <list>
#include <time.h>
#include "media_common.h"


void __log_print__(char *fmt,...);
void __init_logprint( bool bl );


class CAVLogger: public IAVLogger
{
public:
	CAVLogger(void);
	virtual ~CAVLogger(void);
	virtual int print(int level,char *fmt,...);

	void SetLogMode(int nLogMode, int nLogLevel, char* szLogFile);
    void Start();
	void Stop();
	static void _ThreadFunc(void* arg);
private:
	void WriteRemainLog();
	void WriteLog(void);
};
#endif