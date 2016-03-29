
#ifndef _Thread_Network_H
#define _Thread_Network_H

#ifdef WIN
#include <process.h>
#include <Windows.h>
#define ThreadVoid void
#define ThreadHandle uintptr_t
#define ThreadLock CRITICAL_SECTION
#define ThreadReturn 
#else
#include <pthread.h>
#include <unistd.h>

#define ThreadVoid void*
#define ThreadHandle pthread_t
#define ThreadLock pthread_mutex_t
#define ThreadReturn return NULL
#endif


typedef ThreadVoid (*Runnable)(void*);


class Thread
{

public:

	static void start(Runnable runnable, void* param);

	static void sleep(int milliseconds);

	static void initlock(ThreadLock* lock);

	static void lock(ThreadLock* lock);

	static void unlock(ThreadLock* lock);

	Thread();
	~Thread(void);

};

#endif
