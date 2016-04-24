//
//  XConsumeRankModel.h
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"

@interface XConsumeRankModel : UITableViewCell

@property (nonatomic,copy) NSString *username;
@property (nonatomic,assign) int headid;
@property (nonatomic) NSNumber *consume;

//- (id)initWithDict:(NSDictionary *)dict;

@end
