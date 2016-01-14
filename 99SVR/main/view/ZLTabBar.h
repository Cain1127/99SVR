//
//  MyNBTabBar.h
//  NB2
//
//  Created by xia zhonglin on 1/7/16.
//  Copyright (c) 2015年 xia zhonglin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLTabController;
@protocol ZLTabBarDelegate <NSObject>

- (void)selectIndex:(UIViewController *)viewController;

@end

@interface ZLTabBar : UIView

@property (nonatomic,assign)id<ZLTabBarDelegate> delegate;

- (id)initWithItems:(NSArray *)items;

- (void)setSelectIndex:(NSInteger)nIndex;


@end

