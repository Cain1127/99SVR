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

#define kNavColor UIColorFromRGB(0x0078DD)

#define SVR_LOGIN_IP @"login2.99ducaijing.cn"
#define SVR_LOGIN_PORT 7401
#define SVR_LVBBY_IP @"lobbyip5.99ducaijing.cn"
#define SVR_LVBBY_PORT  7301
#define SVR_LBS_PORT 2222

#define kRoom_head_view_height 118

#define kLibaryCache kLibraryPath

#define GBK_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

#define kVideoImageHeight kScreenWidth*9/16

#define kLineColor RGB(207, 207, 207)

#define kNavigationHeight 64

#define kSinaKey @"4288225685"

#define kRedirectURI @"http://api.99ducaijing.com/loginapi/RedirectByWeibo"

#define kWXAPP_ID "wxfbfe01336f468525"

#define kWXAPP_SEC "acc28b09efbb768a1b5b7b6514903ef8"

#define kPay_URL @"http://phpapi.99ducaijing.cn/mobile.php?s=/pay/index"

#define kGift_URL @"http://admin.99ducaijing.com/index.php?m=Api&c=Gift"

#define kGif_Image_URL "http://admin.99ducaijing.com/Uploads/Picture"

#define lbs_status @"http://admin.99ducaijing.com/?m=Api&c=ClientConfig&clientType=2&parameterName="

#define kLbs_all_path @"lbs1.99ducaijing.cn:2222;lbs2.99ducaijing.cn:2222;58.210.107.54:2222;122.193.102.23:2222;112.25.230.249:2222"

/**隐私权条款*/
#define YSQTK_URL @"http://phpapi.99ducaijing.cn/mobile.php?s=/Protocol/appysxy"

/**用户服务协议*/
#define FWXY_URL   @"http://phpapi.99ducaijing.cn/mobile.php?s=/Protocol/appyhxy"


#endif

