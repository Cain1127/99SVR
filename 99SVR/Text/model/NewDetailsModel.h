//
//  NewDetailsModel.h
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewDetailsModel : NSObject

@property (nonatomic,copy) NSString *calias;
@property (nonatomic,copy) NSString *dtime;
@property (nonatomic) NSNumber *czans;
@property (nonatomic) NSNumber *teacherid;
@property (nonatomic) NSNumber *viewid;
@property (nonatomic) NSNumber *reads;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ccontent;

+ (NewDetailsModel*)resultWithDict:(NSDictionary* )dict;

@end
