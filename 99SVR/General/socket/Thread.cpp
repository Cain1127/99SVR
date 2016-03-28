#include "platform.h"
#include "Thread.h"

ThreadHandle thread_handle;

Thread::Thread(void)
{
}

void Thread::start(Runnable func, void* param)
{

#ifdef WIN
	thread_handle = _beginthread(func, 0, param);
#else
	pthread_create(&thread_handle, NULL, func, param);
#endif

}


Thread::~Thread(void)
{
}