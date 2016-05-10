#ifndef _TIMER_THREAD_H_
#define _TIMER_THREAD_H_

#include "platFromSel.h"
#if PLATFROM_WIN
#include <Windows.h>
#elif PLATFROM_ANDROID||PLATFROM_IOS
#include <pthread.h>
#endif

class Thread
{
public:
    Thread();
    virtual ~Thread();

    virtual void    Run() = 0;
    void            Start();
    void            Stop();
    bool            IsStop();
#if PLATFROM_WIN
	HANDLE m_hThread;
#elif PLATFROM_ANDROID||PLATFROM_IOS
    pthread_t m_hThread;
#endif
protected:
#if PLATFROM_WIN
    static DWORD WINAPI ThreadProc(LPVOID p);
#elif PLATFROM_ANDROID||PLATFROM_IOS
    static void *ThreadProc(void* p);
#endif
private:
    bool    m_stopFlag;

};

#endif
