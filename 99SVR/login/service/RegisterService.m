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
    [request setURL:[NSURL URLWithString:kGROUP_REQUEST_HTTP]];
    [request setHTTPMethod:@"POST"];
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
            
        }
    }
    else
    {
        DLog(@"获取id失败:%d",(int)responseCode);
        if (_regBlock)
        {
            _regBlock((int)responseCode);
        }
    }
}


@end
