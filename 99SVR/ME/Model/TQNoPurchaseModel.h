//
//  TQNoPurchaseModel.h
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpMessageComplex.pb.h"

/*
 uint32 _vipLevelId;
 string _vipLevelName;
 vector<PrivateServiceSummary> _summaryList;
 */

@interface TQNoPurchaseModel : NSObject

- (id)initWithTeamSummaryPack:(TeamPrivateServiceSummaryPack *)teamSummaryPack;
/** <#desc#> */
@property (nonatomic ,assign)int vipLevelId;
/** <#desc#> */
@property (nonatomic ,copy)NSString *vipLevelName;



@end
