//
//  Common.h
//  LePats
//
//  Created by admin on 15/5/14.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#ifndef LePats_Common_h
#define LePats_Common_h


#define KMainScreenSize [UIScreen mainScreen].bounds.size
#define KShowMainViewController @"KShowMainViewController"
#define KShowLeftViewController @"KShowLeftViewController"
#define KUserLogout @"KUserLogout"
#define LOGIN_SUCESS_VC  @"LOGIN_SUCESS_VC"
#define KGotoViewController @"KGotoViewController"

#define KServiceResponseCode @"return_code"
#define KServiceResponseMsg @"result_msg"
#define KServiceResponseSuccess 10000
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SVR_LOGIN_IP @"login2.99ducaijing.cn"

#define SVR_LOGIN_PORT  7401

#define SVR_LVBBY_IP @"lobbyip5.99ducaijing.cn"

#define SVR_LVBBY_PORT  7301

#define SVR_LBS_IP @"lbs1.99ducaijing.cn"

#define SVR_LBS_PORT 2222

#define GBK_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

#define kGROUP_REQUEST_HTTP @"http://hall.99ducaijing.cn:8081/roomdata/room.php?act=roomdata"

#define kIMAGE_HTTP_URL @"http://roompic.99ducaijing.cn:8081/"

#define kHISTORY_HTTP_URL @"http://hall.99ducaijing.cn:8081/roomdata/room.php?act=history&userid="

#define kVideoImageHeight kScreenWidth*240/320 

#endif

