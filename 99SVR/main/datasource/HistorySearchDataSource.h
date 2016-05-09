//
//  HistorySearchDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HistoryDelegate <NSObject>

@optional

- (void)selectIndex:(NSString *)strInfo;

- (void)delSelectIndex:(NSString *)strInfo;

- (void)deleteAll;

@end

@interface HistorySearchDataSource : NSObject<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,assign) id<HistoryDelegate> delegate;

- (void)setModel:(NSArray *)aryModel;

@end
