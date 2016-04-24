//
//  GitfModel.h
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property (nonatomic,copy) NSString *gid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *gif;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *price;

+ (GiftModel*)resultWithDict:(NSDictionary* )dict;

@end
