//
//  TQPersonalModel.h
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*
 
 uint32	_id;
 string	_title;
 string	_summary;
 string	_publishtime;
 string	_teamname;

 */
#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"
@interface TQPersonalModel : NSObject

- (id)initWithMyPrivateService:(PrivateServiceSummary *)PrivateServiceSummary;
/** 标题 */
@property(nonatomic,copy) NSString *title;
/** 正文 */
@property(nonatomic,copy) NSString *summary;
/** ID */
@property(nonatomic,assign) int ID;

/** 名称 */
@property(nonatomic,copy) NSString *teamname;
/** 时间 */
@property(nonatomic,copy) NSString *publishtime;



@end
