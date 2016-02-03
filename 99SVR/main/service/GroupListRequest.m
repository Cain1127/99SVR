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
            NSDictionary *firDict = [dict objectForKey:@"arr"];
            if (firDict)
            {
                //先解析room  room id保存
                NSArray *roomAry = [firDict objectForKey:@"room"];
                NSMutableDictionary *dictObj = [NSMutableDictionary dictionary];
                if(roomAry)
                {
                    for (NSDictionary *dict in roomAry)
                    {
                        RoomHttp *room = [RoomHttp resultWithDict:dict];
                        [dictObj setValue:room forKey:room.nvcbid];
                    }
                }
                //通过room Array  分别加入到aryRoom
                NSDictionary *secDict = [firDict objectForKey:@"group"];
                NSMutableArray *aryRoom = [NSMutableArray array];
                if(secDict)
                {
                    for (NSDictionary *dict in [secDict allValues])
                    {
                        RoomGroup *room = [RoomGroup resultWithDict:dict];
                        [aryRoom addObject:room];
                        room.aryRoomHttp = [NSMutableArray array];
                        for (NSString *strId in room.groupArr)
                        {
                            RoomHttp *roomHttp = [dictObj objectForKey:strId];
                            if(roomHttp)
                            {
                                [room.aryRoomHttp addObject:roomHttp];
                            }
                        }
                    }
                }
                if (_groupBlock)
                {
                    _groupBlock(1,aryRoom);
                }
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
