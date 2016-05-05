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

/** 屏幕宽高*/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenSourchWidth [UIScreen mainScreen].bounds.size.width
#define kScreenSourchHeight [UIScreen mainScreen].bounds.size.height

#define HEIGHT_MENU_VIEW(x,y) ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? x : y)

#define kFontSize(size) [UIFont systemFontOfSize:size]

/** 适配*/
#define kiOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define kiOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define kiOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kiOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kiOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define kiPhone4_OR_4s    (kScreenHeight == 480)
#define kiPhone5_OR_5c_OR_5s   (kScreenHeight == 568)
#define kiPhone6_OR_6s   (kScreenHeight == 667)
#define kiPhone6Plus_OR_6sPlus   (kScreenHeight == 736)
#define kiPad (UI_USER_INTEkACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 加载本地文件*/
#define kLoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define kLoadArray(file,type) [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define kLoadDict(file,type) [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

/** 资源路径 */
#define kPNG_PATH(NAME) [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define kJPG_PATH(NAME) [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define kPATH(NAME,EXT) [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

/** 加载图片 */
#define kPNG_IMAGE_FILE(NAME)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define kJPG_IMAGE_FILE(NAME)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kIMAGE_FILE(NAME,EXT)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define kIMAGE_NAMED(NAME)     [UIImage imageNamed:NAME]

/** 弱指针
 Example:
    @WeakObj(self)
    [self doSomething^{
        @StrongObj(self)
        if (!self) return;
            ...
    }];
 */
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#pragma mark 小鸟加载图像
/**显示小鸟加载*/
#define Loading_Bird_Show [[UIApplication sharedApplication].keyWindow makeToastActivity_bird];
#define Loading_Bird_Show(view) [view makeToastActivity_bird]
/**隐藏小鸟加载*/
#define Loading_Bird_Hide(view) [view hideToastActivity]


#endif
