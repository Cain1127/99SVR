//
//  XPrivateService.h
//  99SVR
//
//  Created by xia zhonglin  on 4/27/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPrivateSummary : NSObject

@property (nonatomic ) int nId;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *summary;
@property (nonatomic , copy) NSString *publishtime;
@property (nonatomic , copy) NSString *teamname;

@end

@interface XPrivateService : NSObject

@property (nonatomic ) int vipLevelId;
@property (nonatomic , copy) NSString *vipLevelName;
@property (nonatomic ) int isOpen;
@property (nonatomic,copy) NSArray *summaryList;

@end
