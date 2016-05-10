
#include "AVLogger.h"


CAVLogger::CAVLogger(void)
{
	m_hThread=NULL;
	m_bIsRunning=FALSE;
	m_bIsStop=FALSE;
	m_nLogMode=1;
	m_nLogLevel=1;
	m_fpLog=NULL;
	InitializeCriticalSection(&m_lstLogs_mutex);
}

CAVLogger::~CAVLogger(void)
{
	DeleteCriticalSection(&m_lstLogs_mutex);
}

int CAVLogger::print(int level,char *fmt,...)
{
	if(level < m_nLogLevel)
		return 0;

	char szBuf[2048];
	va_list ap;
	va_start(ap, fmt);
	vsprintf(szBuf,fmt,ap);
	va_end(ap);

	time_t nowtime;  
	nowtime = time(NULL); //获取日历时间  
	//cout << nowtime << endl;  //输出nowtime  

	//打印时间信息
	struct tm *local,*gm;  
	local=localtime(&nowtime);  //获取当前系统时间  
	//dsptime(local);   
	//gm=gmtime(&nowtime);  //获取格林尼治时间  
	//dsptime(gm); 

	char szTime[32];
	sprintf(szTime, "%d-%d-%d %d:%d:%d", local->tm_year+1900, local->tm_mon+1, local->tm_mday,
		local->tm_hour, local->tm_min, local->tm_sec);

	//::OutputDebugStringA(szTime);
	//::OutputDebugStringA("  ");
	//::OutputDebugStringA(szBuf);
	//::OutputDebugStringA("\n");

	std::string strLogText=szTime;
	strLogText += " ";
	strLogText += szBuf;

	EnterCriticalSection(&m_lstLogs_mutex);
	m_lstLogs.push_back(strLogText);
	LeaveCriticalSection(&m_lstLogs_mutex);

	return 0;
}

void CAVLogger::SetLogMode(int nLogMode, int nLogLevel, char* szLogFile)
{
	m_nLogMode = nLogMode;
	m_nLogLevel = nLogLevel;
	m_strLogFile = szLogFile;
}

void CAVLogger::Start()
{
	if(!m_hThread && !m_bIsRunning)
	{
		if(m_fpLog ==0) {
			m_fpLog =fopen(m_strLogFile.c_str(), "a+");
		}
		if(m_fpLog ==0)
			return;
		fprintf(m_fpLog, "begin Avlogger=========================\n");

		m_bIsStop = FALSE;
		m_bIsRunning=TRUE;
		unsigned nThreadID = 0;
		m_hThread = (HANDLE)_beginthreadex(0, 0, (unsigned (__stdcall *)(void *))_ThreadFunc, this, 0, &nThreadID);
	}
}

void CAVLogger::Stop()
{
	if(m_hThread)
	{
		m_bIsStop=TRUE;
		//TerminateThread(m_hThread, 0);
		m_hThread = NULL;
        m_bIsRunning = FALSE;

		WriteRemainLog();

		if(m_fpLog !=0) {
			fprintf(m_fpLog, "End Avlogger=========================\n");
			fclose(m_fpLog);
			m_fpLog=NULL;
		}
	}
}

void CAVLogger::_ThreadFunc(void* arg)
{
	CAVLogger* pLogger= (CAVLogger*)arg;
	while(!pLogger->m_bIsStop)
	{
		pLogger->WriteLog();
	}
}

void CAVLogger::WriteRemainLog()
{
	EnterCriticalSection(&m_lstLogs_mutex);
	if(m_lstLogs.size() >0) {

		std::list<std::string>::iterator it = m_lstLogs.begin();
		for( ; it != m_lstLogs.end(); ++it )
		{
			std::string str( *it );
			fwrite( str.c_str(), sizeof(char), str.length()+1, m_fpLog);
		}
		m_lstLogs.clear();
		fflush(m_fpLog);
	}
	LeaveCriticalSection(&m_lstLogs_mutex);
}

void CAVLogger::WriteLog()
{
	if(m_lstLogs.size()>0)
	{
		EnterCriticalSection(&m_lstLogs_mutex);
		if(m_lstLogs.size() >0) {

			std::list<std::string>::iterator it = m_lstLogs.begin();
			for( ; it != m_lstLogs.end(); ++it )
			{
				std::string str( *it );
				fwrite( str.c_str(), sizeof(char), str.length()+1, m_fpLog);
			}
			m_lstLogs.clear();

			//std::string strLogText = m_lstLogs.front();
			//m_lstLogs.pop_front();
			//fwrite(strLogText.c_str(), sizeof(char), strLogText.length()+1, m_fpLog);

			fflush(m_fpLog);
		}
		LeaveCriticalSection(&m_lstLogs_mutex);
	}
	else {
		long curPos = ftell( m_fpLog );
		if( curPos > 1024*500 )
		{
			fclose(m_fpLog);
			m_fpLog =fopen(m_strLogFile.c_str(), "w+");
		}
		Sleep(30);
	}
}
