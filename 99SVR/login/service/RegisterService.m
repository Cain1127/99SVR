//
//  RegisterService.m
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RegisterService.h"

@implementation RegisterService

- (void)registerServer:(NSString *)strName pwd:(NSString *)strPwd
             seesionId:(NSString *)strSession codeId:(NSString *)strCodeId
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    NSString *strRequest = [NSString stringWithFormat:@"http://api.99ducaijing.com/mapi/register?type=3&account=%@&pwd=%@&codeid=%@&code=%@",
    //                            strName,strPwd,strSession,strCodeId];
    //    [request setURL:[NSURL URLWithString:strRequest]];
    [request setURL:[NSURL URLWithString:@"http://api.99ducaijing.com/mapi/register"]];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:3] forKey:@"type"];
    [dict setObject:strName forKey:@"account"];
    [dict setObject:strPwd forKey:@"pwd"];
    [dict setObject:strSession forKey:@"codeid"];
    [dict setObject:strCodeId forKey:@"code"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];
    __weak RegisterService *__self = self;
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
            int nValue = [[dict objectForKey:@"errcode"] intValue];
            if(nValue==1)
            {
                NSDictionary *data = [dict objectForKey:@"data"];
                if ([data objectForKey:@"userid"])
                {
                    if (_regBlock)
                    {
                        _regBlock(nValue,[data objectForKey:@"userid"]);
                    }
                }
                else
                {
                    if (_regBlock)
                    {
                        _regBlock(nValue,@"服务器连接错误");
                    }
                }
            }
            else
            {
                if (_regBlock)
                {
                    _regBlock(nValue,[dict objectForKey:@"errmsg"]);
                }
            }
        }
        else
        {
            if (_regBlock)
            {
                _regBlock(-999,@"连接异常");
            }
        }
    }
    else
    {
        if (_regBlock)
        {
            _regBlock((int)responseCode,@"服务器连接错误");
        }
    }
}


@end
