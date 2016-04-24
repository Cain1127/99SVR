//
//  ConsumeRankDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumeRankDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *aryModel;

@end
