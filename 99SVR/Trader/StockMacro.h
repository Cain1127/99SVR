

/**
 *  股票系列的宏
 *
 */


#ifndef StockMacro_h
#define StockMacro_h

#pragma mark 适配============================

#define G_IPhone__4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone4
#define G_IPhone__5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone5
#define G_IPhone__6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone6
#define G_IPhone__6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)  //iPhone6Plus
/**
 *  目前适配4，5，6，6p的尺寸。根据不同的机型，返回不同的尺寸。❗️❗️❗️这里一定要按照要求传进去。必须要传字符串。里面是数组下标就是4，5，6，6三个。后期如果是有其它屏幕的适配 在依次添加
 *  @"50,100,200,300" ===》iPhone4 = 50，iphone5 =100 iphone6=200 iPhone6 Plus = 300
 */
#define IphoneModelArray(string)  [string componentsSeparatedByString:@","]
#define IphoneStringWithIntValue(string,X) [IphoneModelArray(string)[X] floatValue]
#define ValueWithTheIPhoneModelString(string) (G_IPhone__4 ? (IphoneStringWithIntValue(string,0)) : (G_IPhone__5 ? (IphoneStringWithIntValue(string,1)) :((G_IPhone__6 ? (IphoneStringWithIntValue(string,2)) :(IphoneStringWithIntValue(string,3))))))

#pragma mark model里面数据模型的转换
/**字符转换成UTF8 字符串*/
#define StrTransformCToUTF8(x) [NSString stringWithCString:x encoding:NSUTF8StringEncoding]
/**int 转换成字符串*/
#define IntTransformIntToStr(x) [NSString stringWithFormat:@"%d",x]
/**float 转成字符串*/
#define FloatTransformFloatToStr(x) [NSString stringWithFormat:@"%.2f",x]


#pragma mark 股票详情视图高度宏
#define STORCK_Deal_HeaderView_H ValueWithTheIPhoneModelString(@"150,180,200,220")//股票交易详情headerView
#define STORCK_Deal_StockCell_H ScreenWidth * 0.75 //股票交易详情股票走势图模块的
#define STORCK_Deal_BusinessRecordCell_VIP_H ValueWithTheIPhoneModelString(@"50,50,50,50")//股票交易详情 交易纪录 VIP状态
#define STORCK_Deal_BusinessRecordCell_NotVIP_H ValueWithTheIPhoneModelString(@"100,100,100,100")//股票交易详情 交易纪录 不是VIP状态
#define STORCK_Deal_WareHouseRecordCell_VIP_H ValueWithTheIPhoneModelString(@"120,120,120,120")//股票交易详情 持仓纪录 VIP状态
#define STORCK_Deal_WareHouseRecordCell_NotVIP_H ValueWithTheIPhoneModelString(@"200,200,200,200")//股票交易详情 持仓纪录 不是VIP状态


#endif /* StockMacro_h */
