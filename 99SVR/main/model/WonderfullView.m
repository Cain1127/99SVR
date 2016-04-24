//
//  WonderfullView.m
//  99SVR
//
//  Created by ysmeng on 16/3/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "WonderfullView.h"

#import <objc/runtime.h>

@implementation WonderfullView

/**
 *  @author yangshengmeng, 16-03-29 09:03:43
 *
 *  @brief  通过运行时获取当前类的属性，并拼装为数组返回
 *
 *  @return 返回当前类的所有属性串
 *
 *  @since  v1.0.0
 */
- (NSArray *)getPropetName
{
    ///获取类的属性
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([WonderfullView class], &propertyCount);
    
    ///循环格式化属性名
    NSMutableArray *propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    
    return propertyNames;
}

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
+ (WonderfullView *)resultWithDict:(NSDictionary *)dict
{
    WonderfullView *result = [[WonderfullView alloc] init];
    NSArray *propertyArray = [result getPropetName];
    for (NSString* key in propertyArray) {
        @try
        {
            [result setValue:dict[key] forKey:key];
        }
        @catch(NSException *exception)
        {
            NSLog(@"except:%@:%@",key,dict[key]);
        }
    }
    
    return result;
}

@end
