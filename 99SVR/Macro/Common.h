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
#define kSocketNetworkKey @"kSocketNetworkKey" // socket网络检测Key
#define kSocketNetworkStateKey @"kSocketNetworkStateKey" // socket保存当前网络状态

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
//http://hall.99ducaijing.cn:8081/roomdata/room.php?act=history&userid=1765152&client=2
#define kGROUP_REQUEST_HTTP @"http://hall.99ducaijing.cn:8081/roomdata/room2.php?act=roomdata&client=android"

#define kIMAGE_HTTP_URL @"http://roompic.99ducaijing.cn:8081/"

#define kIMAGE_HTTP_HOME_URL @"http://172.16.41.99/images/roompic/"

#define kHISTORY_HTTP_URL @"http://hall.99ducaijing.cn:8081/roomdata/room2.php?act=history&client=2&userid="

#define kVideoImageHeight kScreenWidth*9/16

#define kLineColor RGB(207, 207, 207)
#define kNavigationHeight 64
#define kSinaKey @"4288225685"

#define kRedirectURI @"http://api.99ducaijing.com/loginapi/RedirectByWeibo"
#define  kWXAPP_ID "wxfbfe01336f468525"
#define  kWXAPP_SEC "acc28b09efbb768a1b5b7b6514903ef8"

#define LBS_HTTP_HOST @"http://testlbs.99ducaijing.cn:2222/"

#define kPay_URL @"http://phpapi.99ducaijing.cn/mobile.php?s=/pay/index"
#define kGift_URL @"http://admin.99ducaijing.com/index.php?m=Api&c=Gift"

#define kGif_Image_URL "http://admin.99ducaijing.com/Uploads/Picture"

#define kHome_Banner_URL "http://admin.99ducaijing.com/index.php?m=Api&c=Banner"

#define kHome_LivingList_URL @"http://hall.99ducaijing.cn:8081/mobile/index.php"

#define kBand_mobile_getcode_URL @"http://api.99ducaijing.com/mapiphone/getmsgcode"
#define kBand_mobile_setphone_URL @"http://api.99ducaijing.com/mapiphone/setphone"
#define kBand_mobile_checkcode_URL @"http://api.99ducaijing.com/mapiphone/checkphonecode"

#define LBS_ROOM_GATE [NSString stringWithFormat:@"%@tygetgate",LBS_HTTP_HOST]

#define LBS_ROOM_MEDIA [NSString stringWithFormat:@"%@tygetmedia",LBS_HTTP_HOST]

#define LBS_ROOM_TEXT [NSString stringWithFormat:@"%@tygettext",LBS_HTTP_HOST]

#define lbs_status @"http://admin.99ducaijing.com/?m=Api&c=ClientConfig&clientType=2&parameterName="

#define kTEXT_NEW_DETAILS_URL @"http://hall.99ducaijing.cn:8081/viewpoint/index.php?s=/Index/getViewPoint/id/"

#define kPrivate_detail_url @"http://testphp.99ducaijing.cn/mobile.php?s=/Share/personalSecrets/id/"

#if 1
#define kTEXT_FOLLOW_URL @"http://hall.99ducaijing.cn:8081/mobile/text_rooms.php?act=follow&userid="
#define kTEXT_GROUP_URL @"http://hall.99ducaijing.cn:8081/mobile/text_rooms.php?act=script"
#define kRegisterNumber @"http://testphp.99ducaijing.cn/api.php?s="
#else
#define kRegisterNumber @"http://api.99ducaijing.com/"
#define kImage_TEXT_URL @"http://122.13.81.62:22806/test/getimage.php?tid="
#define kTEXT_GROUP_URL @"http://122.13.81.62:22806/test/test.php?act=script"
#endif

#define kLbs_all_path @"lbs1.99ducaijing.cn:2222;lbs2.99ducaijing.cn:2222;58.210.107.54:2222;122.193.102.23:2222;112.25.230.249:2222"
//#define kLbs_all_path @"testlbs.99ducaijing.cn:2222;lbs2.99ducaijing.cn:2222"

#endif

