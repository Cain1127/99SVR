//
//  XZDecoder.m
//  99SVR
//
//  Created by xia zhonglin  on 1/25/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XZDecoder.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/time.h>

//static int rtspConnect_time_out=6;
//
//int getNextFrame(void *userData,unsigned char *cFrame,int nLength)
//{
//    int size = nLength;
//    int ret = -1;
//    struct timeval tv;
//    gettimeofday(&tv,NULL);
//    NSMutableArray *aryVideo = (__bridge NSMutableArray *)userData;
//    do{
//        struct timeval result;
//        gettimeofday(&result,NULL);
//        if(aryVideo.count>0)
//        {
//            @synchronized(aryVideo)
//            {
//                NSData *data = [aryVideo objectAtIndex:0];
//                size = (int)data.length;
//                memcpy(cFrame, [data bytes], data.length);
//                [aryVideo removeObjectAtIndex:0];
//                ret = 0;
//            }
//        }
//        if(result.tv_sec-tv.tv_sec>=rtspConnect_time_out)
//        {
//            DLog(@"退出了");
//            return -1;
//        }
//    }while(ret);
//    return size;
//}

@interface XZDecoder()
{
    AVFormatContext *pFormatCtx;
    NSArray *_videoStreams;
}

@property (nonatomic,strong) NSMutableArray *aryVideo;

@end

@implementation XZDecoder

- (void)ffmpegInit
{
/*    AVInputFormat* pAvinputFmt = NULL;
    AVCodec         *pCodec = NULL;
    AVIOContext		*pb = NULL;
    uint8_t	*buf = NULL;
    buf = (uint8_t*)malloc(sizeof(uint8_t)*1024);
    avcodec_register_all();
    pb = avio_alloc_context(buf, 1024, 0, (__bridge void *)(_aryVideo), getNextFrame,NULL,NULL);
    pAvinputFmt = av_find_input_format("H264");
    pFormatCtx = avformat_alloc_context();
    pFormatCtx->pb = pb;
    if(avformat_open_input(&pFormatCtx, "", pAvinputFmt, NULL) != 0 )
    {
        pFormatCtx = NULL;
        av_free(pb);
    }
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0) {
        avformat_close_input(&pFormatCtx);
        return ;
    }
    av_dump_format(pFormatCtx, 0,"test", false);
  */   
   
}

- (int) openVideoStream
{
    return 1;
}

@end
