//
//  PubDefine.h
//  LePats
//
//  Created by 夏钟林 on 15/5/13.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#ifndef LePats_PubDefine_h
#define LePats_PubDefine_h



#ifdef DEBUG

#define ENABLE_ASSERT_STOP          1
#define ENABLE_DEBUGLOG             1

#endif

// 颜色日志
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,150,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg250,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,235,30;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

// debug log
#ifdef ENABLE_DEBUGLOG
#define APP_DebugLog(...) NSLog(__VA_ARGS__)
#define APP_DebugLogBlue(...) LogBlue(__VA_ARGS__)
#define APP_DebugLogRed(...) LogRed(__VA_ARGS__)
#define APP_DebugLogGreen(...) LogGreen(__VA_ARGS__)
#else
#define APP_DebugLog(...) do { } while (0);
#define APP_DebugLogBlue(...) do { } while (0);
#define APP_DebugLogRed(...) do { } while (0);
#define APP_DebugLogGreen(...) do { } while (0);
#endif

// log
#define APP_Log(...) NSLog(__VA_ARGS__)

// assert
#ifdef ENABLE_ASSERT_STOP
#define APP_ASSERT_STOP                     {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define APP_ASSERT(condition)               {NSAssert(condition, @" ! Assert");}
#else
#define APP_ASSERT_STOP                     do {} while (0);
#define APP_ASSERT(condition)               do {} while (0);
#endif


/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Redefine

#define ApplicationDelegate                 ((BubblyAppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define SelfNavBar                          self.navigationController.navigationBar
#define SelfTabBar                          self.tabBarController.tabBar
#define SelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define SelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0)

#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)


#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define HeightFor4InchScreen                568.0f
#define HeightFor3p5InchScreen              480.0f

#define ViewCtrlTopBarHeight                (IsiOS7Later ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (IsiOS7Later ? YES : NO)




//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - app define


#define Is4Inch                                 [UtilityFunc is4InchScreen]

#define RGB_AppWhite                            RGB(252.0f, 252.0f, 252.0f)

#define RGB_TextLightGray                       RGB(200.0f, 200.0f, 200.0f)
#define RGB_TextMidLightGray                    RGB(127.0f, 127.0f, 127.0f)
#define RGB_TextDarkGray                        RGB(100.0f, 100.0f, 100.0f)
#define RGB_TextLightDark                       RGB(50.0f, 50.0f, 50.0f)
#define RGB_TextDark                            RGB(10.0f, 10.0f, 10.0f)
#define RGB_TextAppOrange                       RGB(224.0f, 83.0f, 51.0f)
#define SIZE_TextSmall                          10.0f
#define SIZE_TextContentNormal                  13.0f
#define SIZE_TextTitleMini                      15.0f
#define SIZE_TextTitleNormal                    17.0f
#define SIZE_TextLarge                          16.0f
#define SIZE_TextHuge                           18.0f
#define XC_HTTP_TIMEOUT                         10


#define VIDEO_LOW  NSLocalizedString(@"videoLow", nil)
#define VIDEO_HIGH  NSLocalizedString(@"videoHight", nil)


#define  MJRefreshFooterPullToRefresh NSLocalizedString(@"pulltomore","")
#define  MJRefreshFooterReleaseToRefresh NSLocalizedString(@"releasemore", "")
#define  MJRefreshFooterRefreshing  NSLocalizedString(@"devfresh", "")

#define  MJRefreshHeaderPullToRefresh NSLocalizedString(@"pullto", "")
#define  MJRefreshHeaderReleaseToRefresh NSLocalizedString(@"releaseRefresh", "")
#define  MJRefreshHeaderRefreshing NSLocalizedString(@"devfresh", "")


//#define kLeftMenuBgColor RGB(61, 120, 201)
#define kTableViewBgColor RGB(247, 247, 247) // tableView 背景颜色

#pragma mark 股票详情颜色宏
//#define COLOR_STOCK_Line_Kuang  UIColorFromRGB(0xe5e5e5)//股票线框的颜色
#define COLOR_STOCK_Line_ZuHe UIColorFromRGB(0xf8b551)//组合收益线的颜色
#define COLOR_STOCK_Line_HS300 UIColorFromRGB(0x038cff)//沪深三百收益线的颜色
#define COLOR_STOCK_YingKui UIColorFromRGB(0xea544a)//持仓盈亏颜色
#define COLOR_STOCK_Text_Black UIColorFromRGB(0x4c4c4c)//股票详情黑色字体
#define COLOR_STOCK_BackGroundColor UIColorFromRGB(0xf8f8f8)//股票的背景色
#define COLOR_STOCK_Blue UIColorFromRGB(0x0078dd)//蓝色背景色
#define COLOR_STOCK_Orange UIColorFromRGB(0xf8b551)//辅助色橙色
#define COLOR_StyleLines UIColorFromRGB(0xcfcfcf) //分割线的颜色
#define COLOR_STOCK_Text_Gay UIColorFromRGB(0xb2b2b2)//字体灰色字体
#define COLOR_STOCK_Warning UIColorFromRGB(0xea544a)//私人订制页面注意的字体颜色

#endif
