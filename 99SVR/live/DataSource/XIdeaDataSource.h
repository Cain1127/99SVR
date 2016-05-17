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
/**
 *  回调是否显示新观点的提示的view
 *
 *  @param value    是否显示
 *  @param topValue 是否在顶部
 */
-(void)ideaPromptViewIsShowBool:(BOOL )value tabToTopValue:(BOOL)topValue;

@end

@interface XIdeaDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id<XIdeaDelegate> delegate;

@property (nonatomic,copy) NSArray *aryModel;

@end
