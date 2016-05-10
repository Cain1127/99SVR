#pragma once  
#include "platFromSel.h"
#include <list>
#include <stdio.h>
#include "typedef.h"
#include "media_common.h"
#include "logger.h"

#ifdef PLATFROM_WIN
#include "faac.h"
#include "amf.h"
#include "rtmp_sys.h"
#include "rtmp.h"
#else
#include "../librtmp/amf.h"
#include "../librtmp/rtmp_sys.h"
#include "../librtmp/rtmp.h"
#endif

using namespace std;

#define RTMP_RCV_BUF_SIZE  (3600*10)
#define RTMP_SERVER_BUFFER (3600*1000)


#define H264_RAW_IN_LEN (1280*720*5) // 5M
#define SPS_FRAME   (0x07)
#define PPS_FRAME   (0x08)
#define SLICE_FRAME (0x01)
#define IDR_FRAME   (0x05)
#define SEI_FRAME   (0x06)
#define RTMP_HEAD_SIZE   (sizeof(RTMPPacket)+RTMP_MAX_HEADER_SIZE)

#define AAC_SPEC_LEN (2)
#define RTMP_VIDEO_CHAN (0x4)
#define RTMP_AUDIO_CHAN (0x4)


typedef struct _NaluUnit {
	int32 type;
	int32 size;
	uint8 *data;
}nalUnit;

typedef struct RtmpSendStruct{
	char* buf;
	int len;
	int32_t ts;
	int32_t pt;
	int32_t roomId;
	int32_t userId;
	int width;
	int height;
} RtmpSendStruct;

typedef struct _RtmpMetaData {
	uint32 width;
	uint32 height;
	uint32 frameRate;
	uint32 spsLen;
	uint8  spsData[1024];
	uint32 ppsLen;
	uint8  ppsData[1024];
}RtmpMetaData, *RtmpMetaDataP;  

class CRtmpStreamObserver
{
public:
	virtual void RtmpStreamVideoInput(char* pdata,int len, int width, int height)=0;
	virtual void RtmpStreamAudioInput(char* pdata, int len,unsigned int ts)=0;
};


class rtmpDataObserver {
public:
	virtual void onRtmpStreamData(char *data, uint32_t len, uint32_t width, uint32_t height) = 0;
};

class rtmpRcvVideoObserver {
public:
	virtual void onRtmpVideoData(char *data, uint32_t len, uint32_t width, uint32_t height) = 0;
};

class rtmpRcvAudioObserver {
public:
	virtual void onRtmpAudioData(char *data, uint32_t len) = 0;
};


class CRtmpClient {
public:
	CRtmpClient(void);
	~CRtmpClient(void);

	bool init();
	void unInit();
	bool sendconnect(const int8* url, const int8* port);  
	bool sendH264File(const int8 *fileName); 
	bool sendH264Stream(int8 *pdata, int32 len, int16 width, int16 height, int16 frameRate);

	int32 sendAAcSpecInfo();
	int32 sendAAcStream(uint8 *aacData, int32 aacDataLen, uint32 timeStamp);

	void RtmpStreamVideoInput(char* pdata,int len, int width, int height);
	void RtmpStreamAudioInput(char* pdata, int len,unsigned int ts);
	
	bool	receiveconnect(const int8* url, const int8* port);  
	bool    rtmpReceiveStart(const char *addr, const char *roomId);
	bool    rtmpReceiveStop();
	int32_t rtmpRcvThreadRun();
	int32_t rtmpRcvThreadStop();
	int32_t rtmpRcvThreadProc();
	bool    rtmpRcvRestart();
	void    onRtmpSet(rtmpDataObserver *_rtmpObserver);
	void    onRtmpVideoSet(rtmpRcvVideoObserver *_rtmpObserver);
	void    onRtmpAudioSet(rtmpRcvAudioObserver *_rtmpObserver);
	bool	getRtmpVideoData();
	bool	getRtmpAudioData();

	bool    rtmpSendStart(const char *addr, const char *roomId);
	bool    rtmpSendStop();
	int32_t rtmpSendThreadProc();
	int32 socketInit();
	bool rdSpsPpsFrame(nalUnit &nalu);
	int32 sendPkt(uint32 rtmpPktType, int32 chn, uint8 *data, uint32 size, uint32 timeStamp);
	int32 sendH264MetaData(RtmpMetaDataP lpMetaData);
	int32 sendH264Data(uint8 *data, uint32 size, bool bIsKeyFrame, uint32 nTimeStamp); 

#if PLATFROM_WIN
	static DWORD WINAPI rtmpRcvThreadRoutine(void* args);
	static DWORD WINAPI rtmpSendThreadRoutine(void* args);
#elif PLATFROM_ANDROID
	static void *rtmpRcvThreadRoutine(void* args);
	static void *rtmpSendThreadRoutine(void* args);
#endif

	list<RtmpSendStruct> m_rtmpSend_list;
	
#if PLATFROM_WIN
	CRITICAL_SECTION m_rtmpSendStructMutex;
#elif PLATFROM_ANDROID
	pthread_mutex_t m_rtmpSendStructMutex;
#endif

#ifdef PLATFROM_WIN
	CRITICAL_SECTION _rtmpCS;
#endif

private:
	bool             isRtmpRcvThreadStop;
	bool             isRtmpSendThreadStop;
	RTMPPacket       rtmpPkt;
	char             *rtmpRcvBuf;
#if PLATFROM_WIN
	int32_t          rtmpRcvBufLen;
	HANDLE           rtmpRcvThreadHandle;
	HANDLE           rtmpSendThreadHandle;
#elif PLATFROM_ANDROID
	int32_t          rtmpRcvBufLen;
	pthread_t        rtmpRcvThreadHandle;
	pthread_t        rtmpSendThreadHandle;
#endif

	RTMP*        _rtmpHandle;  
	uint8*       _h264RawInBuf;  
	uint32       _h264RawInBufLen;  
	uint32       _curPos;  
	RtmpMetaData _rtmpMetaData;
	bool         _isSendMeta;
	uint64       _startTime;
	bool         _fileSendInitFlg;
	bool         _isAacSendHeader;

	rtmpDataObserver *_rtmpDataObserver;
	rtmpRcvVideoObserver *_rtmpRcvVideoObserver;
	rtmpRcvAudioObserver *_rtmpRcvAudioObserver;
}; 

