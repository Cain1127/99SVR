//
//  UtilsMacro.h
//  XCMonit_Ip
//
//  Created by xia zhonglin  on 14-5-19.
//  Copyright (c) 2014年 xia zhonglin . All rights reserved.
//

#ifndef XCMonit_Ip_UtilsMacro_h
#define XCMonit_Ip_UtilsMacro_h

#define UIColorFromRGBA(r,g,b,a) [UIColor \
colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 alpha:a]

#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]
#define NSStringFromFloat(floatValue) [NSString stringWithFormat:@"%.01f",floatValue]
#define NSStringFromLong(intValue) [NSString stringWithFormat:@"%lld",intValue]
#define NSStringFromInteger(integerValue) [NSString stringWithFormat:@"%zi",integerValue]
#define NSStringFromInt64(integerValue) [NSString stringWithFormat:@"%lld",integerValue]

enum connectP2P
{
    CONNECT_NO_ERROR = 0 ,
    CONNECT_P2P_SERVER,
    CONNECT_DEV_ERROR
};

// 定义宏
#define WeakSelf(o)  __weak typeof(o) weakSelf = o;

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}


#define kNSCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kLibraryPath  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define IOS_SYSTEM_8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLog(...)
#endif

#define XCFONT(x) [UIFont systemFontOfSize:x]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenSourchWidth [UIScreen mainScreen].bounds.size.width
#define kScreenSourchHeight [UIScreen mainScreen].bounds.size.height

#define HEIGHT_MENU_VIEW(x,y) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? x : y)

#define kFontSize(size) [UIFont systemFontOfSize:size]

#endif
