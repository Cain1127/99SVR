//
//  ZLPrivateDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PrivateDelegate <NSObject>

- (void)showWhatIsPrivate;

@end



@interface ZLPrivateDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id<PrivateDelegate> delegate;

@property (nonatomic,copy) NSArray *aryVIP;
@property (nonatomic) NSInteger selectIndex;



@end
