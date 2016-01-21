//
//  TeacherModel.h
//  99SVR
//
//  Created by xia zhonglin  on 1/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherModel : NSObject

@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,copy) NSString *strImg;
@property (nonatomic) NSInteger zans;//赞
@property (nonatomic,copy) NSString *strName;//讲师昵称
@property (nonatomic) int vcbid;
@property (nonatomic) int userid;
@property (nonatomic) short headid;  //headid
@property (nonatomic) int  teacherid; //讲师ID
@property (nonatomic) int64_t funs;
@property (nonatomic) int64_t todaymoods;
@property (nonatomic) int64_t historyLives;
@property (nonatomic) short labellen;
@property (nonatomic) short goodatlen;
@property (nonatomic) short introducelen;

@end
