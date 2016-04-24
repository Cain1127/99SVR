
#include "platform.h"
#include "Thread.h"


#define THREAD_POOL_COUNT 10

ThreadHandle thread_handle[THREAD_POOL_COUNT];
int thread_index = 0;

Thread::Thread(void)
{
}

void Thread::start(Runnable func, void* param)
{

	thread_index = (thread_index + 1) % THREAD_POOL_COUNT;

#ifdef WIN
	thread_handle[thread_index] = _beginthread(func, 0, param);
#else
	pthread_create(&(thread_handle[thread_index]), NULL, func, param);
#endif

}


void Thread::sleep(int milliseconds)
{
#ifdef WIN
	Sleep(milliseconds);
#else
	sleep(milliseconds / 1000);
#endif
}

void Thread::initlock(ThreadLock* lock)
{
#ifdef WIN
	InitializeCriticalSection(lock);
#else
	pthread_mutex_init(lock, NULL);
#endif
}

void Thread::lock(ThreadLock* lock)
{
#ifdef WIN
	EnterCriticalSection(lock);
#else
	pthread_mutex_lock(lock);
#endif
}

void Thread::unlock(ThreadLock* lock)
{
#ifdef WIN
	LeaveCriticalSection(lock);
#else
	pthread_mutex_unlock(lock);
#endif
}

Thread::~Thread(void)
{
}
