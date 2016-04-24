//
//  UserListView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserListSelectDelegate <NSObject>

- (void)selectUser:(NSInteger)nIndex;

@end

@interface UserListView : UIView

@property (nonatomic,assign) id<UserListSelectDelegate> delegate;
@property (nonatomic,assign) BOOL bShow;

- (id)initWithFrame:(CGRect)frame array:(NSArray *)items;

- (void)reloadItems:(NSArray *)items;

@end
