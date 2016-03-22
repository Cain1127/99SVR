#ifdef WIN
#include <windows.h>
#include <process.h>
#define ThreadVoid void
#define ThreadHandle uintptr_t
#else
#include <pthread.h>
#define ThreadVoid void*
#define ThreadHandle pthread_t
#endif


typedef ThreadVoid (*Runnable)(void*);

static ThreadHandle thread_handle;

//static Runnable runnable;
//static void* runnable_param;


class Thread
{

public:

	static void start(Runnable runnable, void* param);


	Thread();
	~Thread(void);

};
