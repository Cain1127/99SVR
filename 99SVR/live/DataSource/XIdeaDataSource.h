//
//  XIdeaDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/27/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
@class TQIdeaModel ;
@protocol XIdeaDelegate <NSObject>

- (void)selectIdea:(TQIdeaModel *)model;

-(void)ideaPromptViewIsShowBool:(BOOL )value tabToTopValue:(BOOL)topValue;

@end

@interface XIdeaDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id<XIdeaDelegate> delegate;

@property (nonatomic,copy) NSArray *aryModel;

@end
