//
//  RoomListRequest.m
//  99SVR
//
//  Created by xia zhonglin  on 12/18/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomListRequest.h"
#import "RoomHttp.h"
#import "RoomGroup.h"

@implementation RoomListRequest

- (void)requestRoomByUserId:(int)userId
{
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d",kHISTORY_HTTP_URL,userId]]];
    [request setHTTPMethod:@"POST"];
    __weak RoomListRequest *__self = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
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
                NSArray *histDict = [firDict objectForKey:@"FootPrint"];
                NSMutableArray *aryHist = [NSMutableArray array];
                if(![[firDict objectForKey:@"FootPrint"] isKindOfClass:[NSString class]])
                {
                    RoomGroup *group = [[RoomGroup alloc] init];
                    group.groupname = @"我的足迹";
                    group.groupid = @"FootPrint1";
                    group.aryRoomHttp = [NSMutableArray array];
                    [aryHist addObject:group];
                    
                    for (NSDictionary *aryDict in histDict)
                    {
                        RoomHttp *room = [RoomHttp resultWithDict:aryDict];
                        [group.aryRoomHttp addObject:room];
                    }
                }
                NSArray *collDict = [firDict objectForKey:@"Collent"];
                NSMutableArray *aryColl = [NSMutableArray array];
                if(![[firDict objectForKey:@"Collent"] isKindOfClass:[NSString class]])
                {
                    RoomGroup *group = [[RoomGroup alloc] init];
                    group.groupname = @"我的收藏";
                    group.groupid = @"Collent1";
                    group.aryRoomHttp = [NSMutableArray array];
                    [aryColl addObject:group];
                    
                    for (NSDictionary *aryDict in collDict)
                    {
                        RoomHttp *room = [RoomHttp resultWithDict:aryDict];
                        [group.aryRoomHttp addObject:room];
                    }
                }
                else
                {
                    RoomGroup *group = [[RoomGroup alloc] init];
                    group.groupname = @"我的收藏";
                    group.groupid = @"Collent1";
                    group.aryRoomHttp = [NSMutableArray array];
                    [aryColl addObject:group];
                }
                if (_historyBlock)
                {
                    _historyBlock(1,aryHist,aryColl);
                }
            }
        }
        else
        {
            if (_historyBlock)
            {
                _historyBlock(999,nil,nil);
            }
        }
    }
    else
    {
        DLog(@"获取信息错误:%d",(int)responseCode);
        if (_historyBlock)
        {
            _historyBlock((int)responseCode,nil,nil);
        }
    }
}

@end
