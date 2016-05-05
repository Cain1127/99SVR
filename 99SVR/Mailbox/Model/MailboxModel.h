//
//  MailboxModel.h
//  99SVR
//
//  Created by Jiangys on 16/5/4.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailboxModel : NSObject

/** 图标 */
@property(nonatomic, copy) NSString *icon;
/** 标题 */
@property(nonatomic, copy) NSString *title;
/** 未读数 */
@property(nonatomic, assign) NSInteger unreadCount;
/** 跳转Controller */
@property(nonatomic, copy) NSString *skipVc;

@end
