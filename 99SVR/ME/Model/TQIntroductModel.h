//
//  TQIntroductModel.h
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"

@interface TQIntroductModel : NSObject

- (id)initWithTeamSummaryPack:(PrivateServiceSummary *)summaryList;

@end
