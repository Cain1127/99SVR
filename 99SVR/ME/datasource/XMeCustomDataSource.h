//
//  TQMecustomView.h
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TQMeCustomizedModel;

@protocol MeCustomDelegate <NSObject>

- (void)selectIndex:(TQMeCustomizedModel *)model;

@end

@interface XMeCustomDataSource : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,copy) NSArray *aryModel;

@property (nonatomic,assign) id<MeCustomDelegate> delegate;


@end
