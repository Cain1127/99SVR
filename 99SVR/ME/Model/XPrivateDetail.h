//
//  XPrivateDetail.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface XPrivateDetail : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *publishtime;
@property (nonatomic,copy) NSString *videourl;
@property (nonatomic,copy) NSString *videoname;
@property (nonatomic,copy) NSString *attachmenturl;
@property (nonatomic,copy) NSString *attachmentname;
@property (nonatomic,copy) NSString *html5url;
@property (nonatomic) int operatestockid;
@end
