#include "timerThread.h"

Thread::Thread()
    :m_stopFlag(false)
    ,m_hThread(NULL)
{
}

Thread::~Thread()
{
    Stop();
}
void Thread::Start()
{
    unsigned long *p =NULL;
#if PLATFROM_WIN	
    m_hThread = ::CreateThread(NULL, 0, ThreadProc, this, 0, p);
#elif PLATFROM_ANDROID ||PLATFROM_IOS
    pthread_create(&m_hThread, NULL, ThreadProc, this);
#endif	
}

#if PLATFROM_WIN	
DWORD WINAPI Thread::ThreadProc(LPVOID p)
#elif PLATFROM_ANDROID||PLATFROM_IOS
void *Thread::ThreadProc(void* p)
#endif
{
    Thread* thread = (Thread*)p;
    thread->Run();

    //CloseHandle( thread->m_hThread );
    thread->m_hThread= NULL;
    return 0;
}
void Thread::Stop()
{
    m_stopFlag = true;
    if(m_hThread != NULL)
    {
#if PLATFROM_WIN		
        if(WaitForSingleObject(m_hThread,INFINITE) != WAIT_ABANDONED)
        {
            CloseHandle(m_hThread);
        }
#elif PLATFROM_ANDROID||PLATFROM_IOS
    	pthread_join(m_hThread, NULL);
#endif		
        m_hThread = NULL;
    }
}
bool Thread::IsStop()
{
    return m_stopFlag;
}
