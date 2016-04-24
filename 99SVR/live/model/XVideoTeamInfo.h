//
//  XVideoTeamInfo.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface VideoModel : NSObject

@property (nonatomic,assign) int nId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *picurl;
@property (nonatomic,copy) NSString *videourl;

@end

@interface XVideoTeamInfo : NSObject

@property (nonatomic,copy) NSString *teamName;
@property (nonatomic,copy) NSString *teamIcon;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSArray *videoList;

@end
