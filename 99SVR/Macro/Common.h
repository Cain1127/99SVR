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

#define SVR_LOGIN_PORT 7401

#define SVR_LVBBY_IP @"lobbyip5.99ducaijing.cn"

#define SVR_LVBBY_PORT  7301

//#define LBS_HTTP_HOST @"http://lbs1.99ducaijing.cn:2222/"

#define LBS_HTTP_HOST @"http://lbs1.99ducaijing.cn:2222/"
#define LBS_HTTP_HOST1 @"http://lbs1.99ducaijing.cn:2222/"
#define LBS_HTTP_HOST3 @"http://lbs3.99ducaijing.cn:2222/"

#define LBS_ROOM_WEB [NSString stringWithFormat:@"%@tygetweb",LBS_HTTP_HOST]
#define LBS_ROOM_GATE [NSString stringWithFormat:@"%@tygetgate",LBS_HTTP_HOST]

#define SVR_LBS_PORT 2222

#define GBK_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

//#define kGROUP_REQUEST_HTTP @"http://hall.99ducaijing.cn:8081/roomdata/room.php?act=roomdata&client=android"
#define kGROUP_REQUEST_HTTP @"http://hall.99ducaijing.cn:8081/roomdata/room2.php?act=roomdata&client=android"

#define kIMAGE_HTTP_URL @"http://roompic.99ducaijing.cn:8081/"

#define kHISTORY_HTTP_URL @"http://hall.99ducaijing.cn:8081/roomdata/room2.php?act=history&userid="

#define kVideoImageHeight kScreenWidth*9/16

#define kLineColor RGB(207, 207, 207)

#define kRegisterNumber @"http://api.99ducaijing.com/"

#define kSinaKey @"4288225685"

#define kRedirectURI @"http://api.99ducaijing.com/loginapi/RedirectByWeibo"

#define  kWXAPP_ID "wxfbfe01336f468525"

#define  kWXAPP_SEC "acc28b09efbb768a1b5b7b6514903ef8"

#define kImage_TEXT_URL @"http://172.16.41.99/test/getimage.php?tid="
#define kTEXT_GROUP_URL @"http://172.16.41.99/test/test.php?act=script"
#define kTEXT_NEW_DETAILS_URL @"http://172.16.41.99/viewpoint/index.php?s=/Index/getViewPoint/id/"

// 充值支付请求URL
#define kPay_URL @"http://abc.99ducaijing.com/mobile/wap_cz"

//#define kImage_TEXT_URL @"http://121.33.236.180:22807/test/getimage.php?tid="
//#define kTEXT_GROUP_URL @"http://121.33.236.180:22807/test/test.php?act=script"
//#define kTEXT_NEW_DETAILS_URL @"http://121.33.236.180:22807/viewpoint/index.php?s=/Index/getViewPoint/id/"

#define kGift_URL @"http://42.81.53.201/99admintest/index.php?m=Api&c=Gift"

#define kGif_Image_URL @"http://42.81.53.201/99admintest/Uploads/Picture/"

#endif

