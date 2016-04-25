//
//  MediaBuffer.h
//  99SVR
//
//  Created by xia zhonglin  on 1/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaBuffer : NSObject

@property (nonatomic) unsigned int ts;
@property (nonatomic) unsigned int expiredtime;
@property (nonatomic) unsigned int recvlen;
@property (nonatomic) unsigned int framelen;
@property (nonatomic) unsigned int packetcount;
@property (nonatomic) unsigned int iscomplete;
@property (nonatomic) unsigned int lossflag;
@property (nonatomic,strong) NSMutableArray *pktstatus;
@property (nonatomic,strong) NSMutableData *data;

@end
