//
//  GroupListRequest.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "GroupListRequest.h"
#import "RoomHttp.h"
#import "RoomGroup.h"

@implementation GroupListRequest

- (void)requestListRequest
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:kGROUP_REQUEST_HTTP]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10];
    __weak GroupListRequest *__self = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
    {
        [__self authInfo:response data:data err:connectionError];
    }];
}
- (void)authInfo:(NSURLResponse *)response data:(NSData*)data err:(NSError *)connectErr
{
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    if (!connectErr && responseCode == 200)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dict)
        {
            NSArray *firstArray = [dict objectForKey:@"groups"];
            NSMutableArray *aryRoom = [NSMutableArray array];
            if ([firstArray isKindOfClass:[NSArray class]] && firstArray.count>0)
            {
                for (NSDictionary *group in firstArray)
                {
                    RoomGroup *_roomgroup = [RoomGroup resultWithDict:group];
                    [aryRoom addObject:_roomgroup];
                }
            }
            NSDictionary *dictService = [dict objectForKey:@"service"];
            if ([dictService objectForKey:@"groupId"] && [dictService objectForKey:@"groupName"] && [dictService objectForKey:@"roomList"])
            {
                RoomGroup *_roomgroup = [RoomGroup resultWithDict:dictService];
                [aryRoom addObject:_roomgroup];
            }
            NSDictionary *dictOther = [dict objectForKey:@"other"];
            if ([dictOther objectForKey:@"groupId"] && [dictOther objectForKey:@"groupName"] && [dictOther objectForKey:@"roomList"])
            {
                RoomGroup *_roomgroup = [RoomGroup resultWithDict:dictOther];
                [aryRoom addObject:_roomgroup];
            }
            if (_groupBlock)
            {
                _groupBlock(1,aryRoom);
            }
        }
        else
        {
            if(_groupBlock)
            {
                _groupBlock(999,nil);
            }
        }
        
    }
    else
    {
        DLog(@"获取信息错误:%d",(int)responseCode);
        if (_groupBlock)
        {
            _groupBlock((int)responseCode,nil);
        }
    }
}

@end
