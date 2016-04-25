//
//  GiftRequest.m
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "GiftRequest.h"
#import "GiftModel.h"
#import "BaseService.h"
#import "UserInfo.h"
#import "NSJSONSerialization+RemovingNulls.h"

@interface GiftRequest()
{}
@property (nonatomic) int fall;
@end

@implementation GiftRequest

- (void)requestGift
{
    __weak GiftRequest *__self = self;
    [BaseService postJSONWithUrl:kGift_URL parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if (dict && [dict objectForKey:@"gift"])
        {
            NSArray *array = [dict objectForKey:@"gift"];
            NSMutableArray *aryIndex = [NSMutableArray array];
            for (NSDictionary *dictionary in array) {
               [aryIndex addObject:[GiftModel resultWithDict:dictionary]];
            }
            [UserInfo sharedUserInfo].aryGift = aryIndex;
        }
    }
    fail:^(NSError *error){
        __self.fall++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [__self requestGift];
        });
    }];
}

@end


