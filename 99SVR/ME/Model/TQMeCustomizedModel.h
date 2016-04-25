//
//  TQMeCustomizedModel.h
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface TQMeCustomizedModel : NSObject

/** 团队ID */
@property(nonatomic,copy) NSString *teamid;
/** 团队名称 */
@property(nonatomic,copy) NSString *teamname;

/** 团队头像 */
@property(nonatomic,copy) NSString *teamicon;
/** 等级ID */
@property(nonatomic,assign)int levelid;
/** 到期时间 */
@property(nonatomic,copy) NSString *expirationdate;
/** VIP等级名称 */
@property(nonatomic,copy) NSString *levelname;


@end
