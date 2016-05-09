#pragma comment(lib,"WS2_32.lib")  
#pragma comment(lib,"winmm.lib")
#include "rtmpSender.h"
#define DLog(...)

int32 CRtmpClient::socketInit() {
#if PLATFROM_WIN
	WORD version;
	WSADATA wsaData;
	version = MAKEWORD(1, 1);
	return (WSAStartup(version, &wsaData) == 0);  
#else
	return 0;
#endif
}

CRtmpClient::CRtmpClient(void) {
	DLog("===SDK CRtmpClient::CRtmpClient\n");

	rtmpRcvThreadHandle=NULL;
	rtmpSendThreadHandle=NULL;
	isRtmpRcvThreadStop = true;
	isRtmpSendThreadStop = true;
	_rtmpHandle = NULL;
	_h264RawInBuf=NULL;
	rtmpRcvBuf=NULL;

	_rtmpDataObserver=NULL;
	_rtmpRcvVideoObserver=NULL;
	_rtmpRcvAudioObserver=NULL;

#if PLATFROM_WIN
	InitializeCriticalSection(&m_rtmpSendStructMutex);
#elif PLATFROM_ANDROID
	pthread_mutex_init(&m_rtmpSendStructMutex, NULL);
#endif
}

CRtmpClient::~CRtmpClient(void) {
	DLog("===SDK CRtmpClient::~CRtmpClient\n");

	while(m_rtmpSend_list.size()>0)
	{
		RtmpSendStruct _rtmpSendStruct;
#if PLATFROM_WIN
		::EnterCriticalSection(&m_rtmpSendStructMutex);
#elif PLATFROM_ANDROID
		::pthread_mutex_lock(&m_rtmpSendStructMutex);
#endif
		_rtmpSendStruct = m_rtmpSend_list.front();
		m_rtmpSend_list.pop_front();
		delete[] _rtmpSendStruct.buf;
#if PLATFROM_WIN
		::LeaveCriticalSection(&m_rtmpSendStructMutex);
#elif PLATFROM_ANDROID
		::pthread_mutex_unlock(&m_rtmpSendStructMutex);
#endif
	}

#if PLATFROM_WIN
	::DeleteCriticalSection(&m_rtmpSendStructMutex);
#elif PLATFROM_ANDROID
	pthread_mutex_destroy(&m_rtmpSendStructMutex);
#endif
}

bool CRtmpClient::init() {
	DLog("===SDK CRtmpClient::rtmpInit\n");

	socketInit();
	_rtmpHandle = RTMP_Alloc();
	RTMP_Init(_rtmpHandle);
	return 0;
}

void CRtmpClient::unInit() {
	DLog("===SDK CRtmpClient::rtmpUnInit\n");
	if(_rtmpHandle) {
		RTMP_Close(_rtmpHandle);
		RTMP_Free(_rtmpHandle); 
#if PLATFROM_WIN
		WSACleanup();
#endif	
		_rtmpHandle = NULL;
	}
}

bool CRtmpClient::receiveconnect(const int8* url, const int8* port) {
	bool bLiveStream = true;

	_rtmpHandle->Link.timeout = 10;

	if(RTMP_IsConnected(_rtmpHandle)) {
		return false;
	}

	if(RTMP_SetupURL2(_rtmpHandle, (int8*)url, (int8 *)port)<0) {
		RTMP_Free(_rtmpHandle);
#if PLATFROM_WIN
		WSACleanup();
#endif	
		return false;
	}

	if (bLiveStream) {
		_rtmpHandle->Link.lFlags |= RTMP_LF_LIVE;
	}

	RTMP_SetBufferMS(_rtmpHandle, RTMP_SERVER_BUFFER);     

	if(RTMP_Connect(_rtmpHandle, NULL) < 0) {
		RTMP_Free(_rtmpHandle);
#if PLATFROM_WIN
		WSACleanup();
#endif	
		return false;
	}
	if(RTMP_ConnectStream(_rtmpHandle,0)<0) {
		RTMP_Close(_rtmpHandle);
		RTMP_Free(_rtmpHandle);
#if PLATFROM_WIN
		WSACleanup();
#endif	
		return false;
	}
#ifdef PLATFROM_WIN
	_startTime = GetTickCount();
#endif
	return true;
}  
bool CRtmpClient::rtmpReceiveStart(const char *addr, const char *roomId)
{
	isRtmpRcvThreadStop = FALSE;

	if(!rtmpRcvBuf)
	{
		rtmpRcvBuf = (char*)malloc(RTMP_RCV_BUF_SIZE);
		memset(rtmpRcvBuf, 0, RTMP_RCV_BUF_SIZE);
	}

	init();

	receiveconnect(addr, roomId);

#if PLATFROM_WIN
	rtmpRcvThreadHandle = CreateThread(NULL, 0, rtmpRcvThreadRoutine, (LPVOID)this, 0, NULL);
#elif PLATFROM_ANDROID
	if (pthread_create(&rtmpRcvThreadHandle, NULL, rtmpRcvThreadRoutine, this) != 0) {
		return -1;
	}
#endif

	return true;
}
bool CRtmpClient::rtmpReceiveStop()
{
	if(isRtmpRcvThreadStop) {
		return false;
	}
	isRtmpRcvThreadStop = TRUE;

	unInit();

#if PLATFROM_WIN
	WaitForSingleObject(rtmpRcvThreadHandle, INFINITE);
	CloseHandle(rtmpRcvThreadHandle);
#elif PLATFROM_ANDROID
	pthread_join(rtmpRcvThreadHandle, NULL);
#endif
	rtmpRcvThreadHandle = NULL;

	if(rtmpRcvBuf) {
		free(rtmpRcvBuf);
		rtmpRcvBuf = NULL;
	}

	return false;
}


bool CRtmpClient::getRtmpAudioData() {
	if (rtmpPkt.m_packetType != RTMP_PACKET_TYPE_AUDIO) {
		return false;
	}
	if(rtmpPkt.m_nBodySize <= 0) {
		return false;
	}
	if(rtmpPkt.m_body[0] == -81) {
		memcpy(rtmpRcvBuf, rtmpPkt.m_body+2, rtmpPkt.m_nBodySize-2);
		rtmpRcvBufLen = rtmpPkt.m_nBodySize-2;
		return true;
	}
	return false;
}

bool CRtmpClient::getRtmpVideoData() {
	unsigned char const startCode[4] = {0x00, 0x00, 0x00, 0x01};
	if (rtmpPkt.m_packetType != RTMP_PACKET_TYPE_VIDEO) {
		return false;
	}
	if(rtmpPkt.m_nBodySize <= 0) {
		return false;
	}
	if((rtmpPkt.m_body[0]&0x1F) == 0x17 && rtmpPkt.m_body[1] == 0x0) {
		uint16_t spsLen = ((uint16_t)rtmpPkt.m_body[11] << 8) | (rtmpPkt.m_body[12]);
		if(spsLen > rtmpPkt.m_nBodySize) return false;
		uint16_t ppsLen = ((uint16_t)rtmpPkt.m_body[spsLen+14] << 8) | (rtmpPkt.m_body[spsLen+15]);
		if((spsLen+ppsLen) > rtmpPkt.m_nBodySize) {
			return false;
		}
		memcpy(rtmpRcvBuf, startCode, 4);
		memcpy(rtmpRcvBuf+4, rtmpPkt.m_body+13, spsLen);
		memcpy(rtmpRcvBuf+4+spsLen, startCode, 4);
		memcpy(rtmpRcvBuf+8+spsLen, rtmpPkt.m_body+spsLen+16, ppsLen);
		rtmpRcvBufLen = spsLen+ppsLen+8;
		return true;
	} else if(((rtmpPkt.m_body[0]&0x1F) == 0x17 || (rtmpPkt.m_body[0]&0x1F) == 0x27)
		&& rtmpPkt.m_body[1] == 0x1) {
			uint32_t dataLen = ((uint32_t)rtmpPkt.m_body[5] << 24)
				| ((uint32_t)rtmpPkt.m_body[6] << 16)
				| ((uint32_t)rtmpPkt.m_body[7] << 8)
				| ((uint8_t)rtmpPkt.m_body[8]) ;
			if(dataLen > rtmpPkt.m_nBodySize) {
				return false;
			}
			memcpy(rtmpRcvBuf, startCode, 4);
			memcpy(rtmpRcvBuf+4, rtmpPkt.m_body+9, dataLen);
			rtmpRcvBufLen = dataLen+4;
			return true;
	} else {
		return false;
	}
	return false;
}

int32_t CRtmpClient::rtmpRcvThreadRun()
{
	return 0;
}
int32_t CRtmpClient::rtmpRcvThreadStop()
{
	return 0;
}
int32_t CRtmpClient::rtmpRcvThreadProc()
{
	while(!isRtmpRcvThreadStop) {
		while (RTMP_ReadPacket(_rtmpHandle, &rtmpPkt)) {
			printf("RTMP_ReadPacket\n");
			if (RTMPPacket_IsReady(&rtmpPkt)) {
				if(getRtmpVideoData()) {
					if(_rtmpRcvVideoObserver)
						_rtmpRcvVideoObserver->onRtmpVideoData(rtmpRcvBuf, rtmpRcvBufLen, 0, 0);
				} else if(getRtmpAudioData()) {
					if(_rtmpRcvAudioObserver)
						_rtmpRcvAudioObserver->onRtmpAudioData(rtmpRcvBuf,rtmpRcvBufLen);
						//fwrite(rtmpRcvBuf, 1, rtmpRcvBufLen, fpA);
				}
				RTMPPacket_Free(&rtmpPkt);
			}

			if(isRtmpRcvThreadStop) {
				break;
			}
		}
		//usleep(50);
#if 0
		int32_t nRead = RTMP_Read(rtmpHandle, rtmpRcvBuf, RTMP_RCV_BUF_SIZE);
		if(nRead > 0) {
			if(_rtmpDataObserver) {
				_rtmpDataObserver->onRtmpStreamData(rtmpRcvBuf, nRead, 0, 0);
			}
		}
#endif
	}
	return 0;
}
bool CRtmpClient::rtmpRcvRestart()
{
	return true;
}


#if PLATFROM_WIN
DWORD WINAPI CRtmpClient::rtmpRcvThreadRoutine(void* args) {
#elif PLATFROM_ANDROID
void *CRtmpClient::rtmpRcvThreadRoutine(void* args) {
#endif
	CRtmpClient* pParam = (CRtmpClient *)args;
	pParam->rtmpRcvThreadProc();
	return 0;
}

#ifdef PLATFROM_WIN
bool CRtmpClient::sendconnect(const int8* url, const int8* port) {
	if(RTMP_IsConnected(_rtmpHandle)) {
		return false;;
	}
	if(RTMP_SetupURL2(_rtmpHandle, (int8*)url, (int8 *)port)<0) {
		RTMP_Free(_rtmpHandle);
#if PLATFROM_WIN
		WSACleanup();
#endif	
		return false;
	}
	RTMP_EnableWrite(_rtmpHandle);

	RTMP_SetBufferMS(_rtmpHandle, 1000*60);

	if(RTMP_Connect(_rtmpHandle, NULL) < 0) {
		RTMP_Free(_rtmpHandle);
#if PLATFROM_WIN
		WSACleanup();
#endif	
		return false;
	}
	if(RTMP_ConnectStream(_rtmpHandle,0)<0) {
		RTMP_Close(_rtmpHandle);
		RTMP_Free(_rtmpHandle);
#if PLATFROM_WIN
		WSACleanup();
#endif	
		return false;
	}
	_startTime = GetTickCount();
	return true;

}  
bool CRtmpClient::rtmpSendStart(const char *addr, const char *roomId)
{
	isRtmpSendThreadStop = FALSE;

	::InitializeCriticalSection(&_rtmpCS); 

	_h264RawInBufLen = 0;
	_curPos = 0;
	_isSendMeta = false;
	_startTime = 0;
	_fileSendInitFlg = false;
	_isAacSendHeader = false;

	if(!_h264RawInBuf)
	{
		_h264RawInBuf = new uint8[H264_RAW_IN_LEN];
		memset(_h264RawInBuf, 0, H264_RAW_IN_LEN);
	}

	init();
	sendconnect(addr, roomId);

#if PLATFROM_WIN
	rtmpSendThreadHandle = CreateThread(NULL, 0, rtmpSendThreadRoutine, (LPVOID)this, 0, NULL);
#elif PLATFROM_ANDROID
	if (pthread_create(&rtmpSendThreadHandle, NULL, rtmpSendThreadRoutine, this) != 0) {
		return -1;
	}
#endif

	return true;
}
bool CRtmpClient::rtmpSendStop()
{
	if(isRtmpSendThreadStop) {
		return false;
	}
	isRtmpSendThreadStop = TRUE;
#if PLATFROM_WIN
	WaitForSingleObject(rtmpSendThreadHandle, INFINITE);
	CloseHandle(rtmpSendThreadHandle);
#elif PLATFROM_ANDROID
	pthread_join(rtmpSendThreadHandle, NULL);
#endif
	rtmpSendThreadHandle = NULL;

	unInit();

	if(_h264RawInBuf)
	{
		delete[] _h264RawInBuf;
		_h264RawInBuf=NULL;
	}

	::DeleteCriticalSection(&_rtmpCS);

	return true;
}

int32_t CRtmpClient::rtmpSendThreadProc()
{
	while(!isRtmpSendThreadStop) {
		if(m_rtmpSend_list.size() > 0) {
			RtmpSendStruct _rtmpSendStruct;
#if PLATFROM_WIN
			::EnterCriticalSection(&m_rtmpSendStructMutex);
#elif PLATFROM_ANDROID
			::pthread_mutex_lock(&m_rtmpSendStructMutex);
#endif
			_rtmpSendStruct = m_rtmpSend_list.front();
			m_rtmpSend_list.pop_front();
#if PLATFROM_WIN
			::LeaveCriticalSection(&m_rtmpSendStructMutex);
#elif PLATFROM_ANDROID
			::pthread_mutex_unlock(&m_rtmpSendStructMutex);
#endif
			if(_rtmpSendStruct.pt == 99){
				sendH264Stream((char*)_rtmpSendStruct.buf, 
					_rtmpSendStruct.len, _rtmpSendStruct.width, _rtmpSendStruct.height, 15);
			} else if(_rtmpSendStruct.pt == 97) {
				sendAAcSpecInfo();
				sendAAcStream((uint8_t*)_rtmpSendStruct.buf, _rtmpSendStruct.len, 0); 
			}
			delete[] _rtmpSendStruct.buf;
		}
	}

	return 0;
}

void CRtmpClient::RtmpStreamVideoInput(char* pdata,int len, int width, int height)
{
	if(m_rtmpSend_list.size() > 1000) {
		return;
	}

	RtmpSendStruct _rtmpSendStruct = {0};
	_rtmpSendStruct.len = len;
	_rtmpSendStruct.ts = 0;
	_rtmpSendStruct.pt = 99;
	_rtmpSendStruct.width=width;
	_rtmpSendStruct.height=height;
	//_rtmpSendStruct.roomId = m_roomId;
	//_rtmpSendStruct.userId = m_userId;
	_rtmpSendStruct.buf = new char[len];
	memcpy(_rtmpSendStruct.buf, pdata, len);

	::EnterCriticalSection(&m_rtmpSendStructMutex);
	m_rtmpSend_list.push_back(_rtmpSendStruct);
	::LeaveCriticalSection(&m_rtmpSendStructMutex);	
}
void CRtmpClient::RtmpStreamAudioInput(char* pdata, int len,unsigned int ts)
{
	if(m_rtmpSend_list.size() > 1000) {
		return;
	}

	RtmpSendStruct _rtmpSendStruct = {0};
	_rtmpSendStruct.len = len;
	_rtmpSendStruct.ts = ts;
	_rtmpSendStruct.pt = 97;

	//_rtmpSendStruct.roomId = m_roomId;
	//_rtmpSendStruct.userId = m_userId;

	_rtmpSendStruct.buf = new char[len];
	memcpy(_rtmpSendStruct.buf, pdata, len);

	::EnterCriticalSection(&m_rtmpSendStructMutex);
	m_rtmpSend_list.push_back(_rtmpSendStruct);
	::LeaveCriticalSection(&m_rtmpSendStructMutex);	
}

#if PLATFROM_WIN
DWORD WINAPI CRtmpClient::rtmpSendThreadRoutine(void* args) {
#elif PLATFROM_ANDROID
void *CRtmpClient::rtmpSendThreadRoutine(void* args) {
#endif
	CRtmpClient* pParam = (CRtmpClient *)args;
	pParam->rtmpSendThreadProc();
	return 0;
}

bool CRtmpClient::rdSpsPpsFrame(nalUnit &nalU) {
	uint32 i = _curPos;
	for(; i < _h264RawInBufLen - 4; i++) {
		if((_h264RawInBuf[i] == 0x00 && _h264RawInBuf[i+1] == 0x00 &&
			_h264RawInBuf[i+2] == 0x00 && _h264RawInBuf[i+3] == 0x01)) { 
				i += 4;
				uint32 pos = i;
				bool noEndFlg = false;
				for(; pos < _h264RawInBufLen - 3; pos++){
					if(_h264RawInBuf[pos] == 0x00 &&
						_h264RawInBuf[pos+1] == 0x00 &&
						_h264RawInBuf[pos+2] == 0x01) {
							noEndFlg = true;
							break;
					}
				}
				if(noEndFlg) { // not end
					if(_h264RawInBuf[pos-1] == 0x0) { // 0 [0] 0 1
						_curPos = pos - 1;
						nalU.size = pos - i - 1;
					} else {
						_curPos = pos;
						nalU.size = pos - i;
					}
				} else {
					if(_h264RawInBuf[pos-1] == 0x0) {
						nalU.size = _h264RawInBufLen - i - 1;
					} else {
						nalU.size = _h264RawInBufLen - i;
					}
					_curPos = _h264RawInBufLen; // ǿ���˳�
				}

				nalU.type = _h264RawInBuf[i]&0x1f;
				nalU.data = &_h264RawInBuf[i];
				return true;
		} else if((_h264RawInBuf[i] == 0x00
			&& _h264RawInBuf[i+1] == 0x00 &&
			_h264RawInBuf[i+2] == 0x01)){
				i += 3;
				uint32 pos = i;
				bool noEndFlg = false;
				for(; pos < _h264RawInBufLen - 3; pos++) {
					if(_h264RawInBuf[pos] == 0x00 &&
						_h264RawInBuf[pos+1] == 0x00 &&
						_h264RawInBuf[pos+2] == 0x01) {
							noEndFlg = true;
							break;
					}
				}
				if(noEndFlg) { // no ending
					if(_h264RawInBuf[pos-1] == 0x0) { // 0 [0] 0 1
						_curPos = pos - 1;
						nalU.size = pos - i - 1;
					} else {
						_curPos = pos;
						nalU.size = pos - i;
					}
				} else {
					if(_h264RawInBuf[pos-1] == 0x0) {
						nalU.size = _h264RawInBufLen - i - 1;  
					} else {
						nalU.size = _h264RawInBufLen - i;
					}
					_curPos = _h264RawInBufLen; // ǿ���˳�
				}
				nalU.type = _h264RawInBuf[i]&0x1f;
				nalU.data = &_h264RawInBuf[i];
				return true;
		}
	}
	return false;
}

int32 CRtmpClient::sendPkt(uint32 rtmpPktType, int32 chn, uint8 *data,
							uint32 size, uint32 timeStamp) {  
	if(_rtmpHandle == NULL) {  
		return false;
	}
	RTMPPacket packet;
	RTMPPacket_Reset(&packet);
	RTMPPacket_Alloc(&packet, size);

	packet.m_packetType = rtmpPktType;
	packet.m_nChannel = chn;
	packet.m_headerType = RTMP_PACKET_SIZE_LARGE;
	packet.m_nTimeStamp = GetTickCount() - _startTime;
	packet.m_nInfoField2 = _rtmpHandle->m_stream_id;
	packet.m_nBodySize = size;
	memcpy(packet.m_body, data, size);

	::EnterCriticalSection(&_rtmpCS);
	int32 nRet = RTMP_SendPacket(_rtmpHandle,&packet,0);
	::LeaveCriticalSection(&_rtmpCS);
	RTMPPacket_Free(&packet);

	return nRet;
}

int32 CRtmpClient::sendH264MetaData(RtmpMetaDataP lpMetaData) {
	if(lpMetaData == NULL) {
		return -1;
	}
	 
	int8 body[1024] = {0};
	int32 i = 0;
	body[i++] = 0x17; // 1:keyframe  7:AVC
	body[i++] = 0x00; // AVC sequence header

	body[i++] = 0x00;
	body[i++] = 0x00;
	body[i++] = 0x00;

	// AVCDecoderConfigurationRecord.
	body[i++] = 0x01;                   // configurationVersion
	body[i++] = lpMetaData->spsData[1]; // AVCProfileIndication
	body[i++] = lpMetaData->spsData[2]; // profile_compatibility
	body[i++] = lpMetaData->spsData[3]; // AVCLevelIndication
	body[i++] = (int8)0xff;             // lengthSizeMinusOne

	// sps frame
	body[i++] = (int8)0xE1; //&0x1f
	body[i++] = lpMetaData->spsLen>>8;
	body[i++] = lpMetaData->spsLen&0xff;
	memcpy(&body[i],lpMetaData->spsData,lpMetaData->spsLen);
	i= i+lpMetaData->spsLen;

	// pps frame
	body[i++] = 0x01; //&0x1f
	body[i++] = lpMetaData->ppsLen>>8;
	body[i++] = lpMetaData->ppsLen&0xff;
	memcpy(&body[i],lpMetaData->ppsData,lpMetaData->ppsLen);
	i= i+lpMetaData->ppsLen;

	int32 ret = sendPkt(RTMP_PACKET_TYPE_VIDEO, 0x3, (uint8*)body,i,0); 
	
	return ret;
}  

int32 CRtmpClient::sendH264Data(uint8 *data, uint32 size, 
							  bool bIsKeyFrame, uint32 nTimeStamp) {
	if(data == NULL) {
		return false;
	}
	uint8 *body = new uint8[size+9];
	int32 i = 0;
	if(bIsKeyFrame) {
		body[i++] = 0x17;// 1:Iframe  7:AVC
	} else {
		body[i++] = 0x27;// 2:Pframe  7:AVC
	}
	body[i++] = 0x01;// AVC nalU
	body[i++] = 0x00;
	body[i++] = 0x00;
	body[i++] = 0x00;

	// nalU size
	body[i++] = size>>24;
	body[i++] = size>>16;
	body[i++] = size>>8;
	body[i++] = size&0xff;

	// nalU data
	memcpy(&body[i],data,size);
	int32 ret = sendPkt(RTMP_PACKET_TYPE_VIDEO, RTMP_VIDEO_CHAN, body, i+size,nTimeStamp);

	delete[] body;

	return ret;
}  

bool CRtmpClient::sendH264File(const int8 *fileName) {
	RtmpMetaData metaData;
	nalUnit nalU;

	if(_fileSendInitFlg == false) {
		_fileSendInitFlg = true;
		if(fileName == NULL) {
			return FALSE;
		}
		FILE *fp = fopen(fileName, "rb");
		if(!fp) {
			return false;
		}
		_h264RawInBufLen = fread(_h264RawInBuf, sizeof(uint8), H264_RAW_IN_LEN, fp);
		if(_h264RawInBufLen >= H264_RAW_IN_LEN) {
			return false;
		}
		fclose(fp);
		
		memset(&metaData,0,sizeof(RtmpMetaData));
		  
		rdSpsPpsFrame(nalU);
		metaData.spsLen = nalU.size;
		memcpy(metaData.spsData,nalU.data,nalU.size);

		rdSpsPpsFrame(nalU);
		metaData.ppsLen = nalU.size;
		memcpy(metaData.ppsData,nalU.data,nalU.size);
  
		metaData.width = 480;
		metaData.height = 320;
		metaData.frameRate = 25;

		// ����MetaData
		sendH264MetaData(&metaData);
	}
	uint32 tick = 0;
	if(rdSpsPpsFrame(nalU)) {
		bool IFrame  = (nalU.type == 0x05) ? TRUE : FALSE;
		if(((nalU.type & 0x1F) == 0x5)
			|| ((nalU.type & 0x1F) == 0x1)) {
			sendH264Data(nalU.data,nalU.size,IFrame,tick);
		}
	}
	return TRUE;
}  

bool CRtmpClient::sendH264Stream(int8 *pdata, int32 len, 
								 int16 width, int16 height, 
								 int16 frameRate){   
	if(len >= H264_RAW_IN_LEN){ 
		return 0;
	}
	int32 metaDataFlg = 0;
	memset(&_rtmpMetaData,0,sizeof(RtmpMetaData));
	memcpy(_h264RawInBuf, pdata, len);

	nalUnit nalU;
	RtmpMetaData metaData;
	_h264RawInBufLen = len;

	_curPos = 0;
	if(_isSendMeta == false) {
		_isSendMeta = true;

		memset(&metaData, 0, sizeof(RtmpMetaData));

		rdSpsPpsFrame(nalU);
		if((nalU.type & 0x1f) == SPS_FRAME) {
			metaData.spsLen = nalU.size;
			memcpy(metaData.spsData, nalU.data, nalU.size);
			metaDataFlg++;
		}
		rdSpsPpsFrame(nalU);
		if((nalU.type & 0x1f) == PPS_FRAME){
			metaData.ppsLen = nalU.size;
			memcpy(metaData.ppsData, nalU.data, nalU.size);
			metaDataFlg++;
		}
		if(metaDataFlg == 2) {
			metaData.width = width;
			metaData.height = height;
			metaData.frameRate = frameRate;
			sendH264MetaData(&metaData);
		}
		while(rdSpsPpsFrame(nalU)) {
			if(((nalU.type & 0x1F) == 0x1)
				|| ((nalU.type & 0x1F) == 0x5)) {
				bool IFrame  = (nalU.type == 0x05) ? TRUE : FALSE; 
				sendH264Data(nalU.data, nalU.size, IFrame, 0);
			}
		}
	} else {
		_curPos = 0;
		while(rdSpsPpsFrame(nalU)) {
			if(((nalU.type & 0x1F) == 0x5)
				|| ((nalU.type & 0x1F) == 0x1)) {
				bool IFrame  = (nalU.type == 0x05) ? TRUE : FALSE;
				sendH264Data(nalU.data, nalU.size, IFrame, 0);
			}
		}
	}
	return TRUE;
}

int32 CRtmpClient::sendAAcSpecInfo() {
	RTMPPacket * packet;
	uint8 * body;
	unsigned char *buf;  
	unsigned long len;   
	
	if(_isAacSendHeader == false) {
		_isAacSendHeader = true;
		
		len = 2;
		buf = (unsigned char*)malloc(sizeof(char)*2);
		buf[0] = 0x12;
		buf[1] = 0x20;
		//faacEncGetDecoderSpecificInfo(hEncoder, &buf, &len);

		packet = (RTMPPacket *)malloc(RTMP_HEAD_SIZE+len+2);
		memset(packet,0,RTMP_HEAD_SIZE);

		packet->m_body = (int8 *)packet + RTMP_HEAD_SIZE;
		body = (uint8 *)packet->m_body;

		/*AF 00 + AAC RAW data*/
		body[0] = 0xAF;
		body[1] = 0x00;
		memcpy(&body[2], buf, len);
		free(buf);

		packet->m_packetType = RTMP_PACKET_TYPE_AUDIO;
		packet->m_nBodySize = len + 2;
		packet->m_nChannel = 0x3;
		packet->m_nTimeStamp = GetTickCount() - _startTime;
		packet->m_hasAbsTimestamp = 0;
		packet->m_headerType = RTMP_PACKET_SIZE_LARGE;
		packet->m_nInfoField2 = _rtmpHandle->m_stream_id;;

		::EnterCriticalSection(&_rtmpCS);
		int32 nRet = RTMP_SendPacket(_rtmpHandle, packet, TRUE);
		::LeaveCriticalSection(&_rtmpCS);
		free(packet);
		
	}
	return true;
}

int32 CRtmpClient::sendAAcStream(uint8 *aacData, int32 aacDataLen, uint32 timeStamp)
{
	if(aacDataLen <= 0) {
		return -1;
	}
	long timerOffset = GetTickCount() - _startTime;
	aacData += 7;
	aacDataLen -= 7;
	if (aacDataLen > 0) {
		::EnterCriticalSection(&_rtmpCS);
		RTMPPacket *packet;
		uint8 * body;

		packet = (RTMPPacket *)malloc(RTMP_HEAD_SIZE+aacDataLen+2);
		memset(packet,0,RTMP_HEAD_SIZE);

		packet->m_body = (int8 *)packet + RTMP_HEAD_SIZE;
		body = (uint8 *)packet->m_body;

		/*AF 01 + AAC RAW data*/
		body[0] = 0xAF;
		body[1] = 0x01;
		memcpy(&body[2], aacData, aacDataLen);

		packet->m_packetType = RTMP_PACKET_TYPE_AUDIO;
		packet->m_nBodySize = aacDataLen+2;
		packet->m_nChannel = RTMP_AUDIO_CHAN;
		packet->m_nTimeStamp = timerOffset;
		packet->m_hasAbsTimestamp = 0;
		packet->m_headerType = RTMP_PACKET_SIZE_MEDIUM;
		packet->m_nInfoField2 = _rtmpHandle->m_stream_id;;

		/*���÷��ͽӿ�*/
		RTMP_SendPacket(_rtmpHandle, packet, TRUE);
		free(packet);
		::LeaveCriticalSection(&_rtmpCS); 
	}
	return 0;
}
#endif

void  CRtmpClient::onRtmpSet(rtmpDataObserver *_rtmpObserver)
{
	_rtmpDataObserver = _rtmpObserver;
}
void  CRtmpClient::onRtmpVideoSet(rtmpRcvVideoObserver *_rtmpObserver)
{
	_rtmpRcvVideoObserver = _rtmpObserver;
}
void  CRtmpClient::onRtmpAudioSet(rtmpRcvAudioObserver *_rtmpObserver)
{
	_rtmpRcvAudioObserver = _rtmpObserver;
}
