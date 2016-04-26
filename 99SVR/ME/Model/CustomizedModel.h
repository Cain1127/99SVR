//
//  CustomizedModel.h
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 jiangys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomizedModel : NSObject

/** ID */
@property (nonatomic, copy) NSString *Id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *summary;
/** 时间 */
@property (nonatomic, copy) NSString *publishtile;

@end
