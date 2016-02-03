//
//  IdeaModel.h
//  99SVR
//
//  Created by xia zhonglin  on 1/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"

@interface IdeaModel : NSObject

@property (nonatomic) UInt32 vcbid;
@property (nonatomic) uint32 userid;
@property (nonatomic) short viewtypeid;
@property (nonatomic) short viewtypelen;
@property (nonatomic,copy) NSString *strContent;

- (id)initWithIdea:(CMDTextRoomViewGroupRes_t *)resp;

@end
