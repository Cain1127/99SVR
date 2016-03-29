//
//  WonderfullView.h
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 16-03-29 09:03:45
 *
 *  @brief  主页中，精彩观点内容的数据模型类
 *
 *  @since  v1.0.0
 */
@interface WonderfullView : NSObject

@property (nonatomic,copy) NSString *teacherid; ///观点提出专家的ID
@property (nonatomic,copy) NSString *calias;    ///专家名字
@property (nonatomic,copy) NSString *viewid;    ///观点记录ID
@property (nonatomic,copy) NSString *dtime;     ///观点发布日期
@property (nonatomic,assign) NSInteger czans;   ///观看次数
@property (nonatomic,copy) NSString *title;     ///标题

/**
 *  @author yangshengmeng, 16-03-29 09:03:42
 *
 *  @brief  通过字典对象创建WonderfullView(精彩观点)的数据模型
 *
 *  @param  dict 原字典数据
 *
 *  @return 返回当前类的实例
 *
 *  @since  v1.0.0
 */
+ (WonderfullView *)resultWithDict:(NSDictionary *)dict;

@end
