//
//  IdeaDetailedTableViewController.h
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 专家观点详情>**********************************/

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

/**
 *  <#Description#>
 *
 *  @param replyValue 评论数
 *  @param giftValue  礼物数
 */
typedef void(^RefreshCellData)(BOOL replyValue,BOOL giftValue);

@interface TQDetailedTableViewController : CustomViewController

- (id)initWithViewId:(int)viewId;

@property (nonatomic , copy) RefreshCellData refreshCellDataBlock;

@end
