//
//  ZLPrivateDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPrivateSummary;

@protocol PrivateDelegate <NSObject>
@optional
- (void)showWhatIsPrivate;
- (void)showPrivateDetail:(XPrivateSummary *)summary;
@end



@interface ZLPrivateDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id<PrivateDelegate> delegate;

@property (nonatomic,copy) NSArray *aryVIP;
@property (nonatomic) NSInteger selectIndex;

@end
