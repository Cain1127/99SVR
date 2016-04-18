//
//  MacroHeader.h
//  99SVR
//
//  Created by 刘海东 on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

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


#endif /* MacroHeader_h */
