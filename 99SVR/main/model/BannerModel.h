//
//  BannerModel.h
//  99SVR
//
//  Created by xia zhonglin  on 3/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject


@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSDictionary *action;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSDictionary *params;

@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *roomName;
@property (nonatomic,copy) NSString *webUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *viewpointId;


+ (BannerModel*)resultWithDict:(NSDictionary* )dict;

- (id)initWithData:(void *)pData;

@end
