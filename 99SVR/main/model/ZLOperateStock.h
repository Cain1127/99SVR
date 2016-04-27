//
//  ZLOperateStock.h
//  99SVR
//
//  Created by xia zhonglin  on 4/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLOperateStock : NSObject

@property (nonatomic) uint32_t operateid;
@property (nonatomic,copy) NSString *teamid;
@property (nonatomic,copy) NSString *teamname;
@property (nonatomic,copy) NSString *teamicon;
@property (nonatomic,copy) NSString *focus;

@property (nonatomic) float goalprofit;
@property (nonatomic) float totalprofit;
@property (nonatomic) float dayprofit;
@property (nonatomic) float monthprofit;
@property (nonatomic) float winrate;

@end
