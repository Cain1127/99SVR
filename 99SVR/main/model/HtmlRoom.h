//
//  HtmlRoom.h
//  99SVR
//
//  Created by xia zhonglin  on 12/11/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlRoom : NSObject

@property (nonatomic,copy) NSString *strUrl;
@property (nonatomic,copy) NSString *strAddress;
@property (nonatomic,assign) int nPort;
@property (nonatomic,copy) NSString *strRoomId;
@property (nonatomic,copy) NSString *strRoomName;



@end
