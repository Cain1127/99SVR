//
//  IdentifyService.m
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "IdentifyService.h"
#import "GTMBase64.h"


@implementation IdentifyService

- (void)requestIdentifier
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://api.99ducaijing.com/mapi/getidentity"]];
    [request setHTTPMethod:@"get"];
    __weak IdentifyService *__self = self;
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
        //        NSData* decodeData = [[NSData alloc] initWithBase64EncodedData:data options:0];
        //        NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
        //        NSLog(@"deocder:%@",decodeStr);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dict)
        {
            NSString *codeId = [dict objectForKey:@"codeid"];
            NSData *dataImg = [dict objectForKey:@"image"];
            NSData* decodeData = [[NSData alloc] initWithBase64EncodedData:dataImg options:0];
            UIImage *image = [UIImage imageWithData:decodeData];
            if (_identiBlock)
            {
                _identiBlock(1,codeId,image);
            }
        }
    }
    else
    {
        DLog(@"获取id失败:%d",(int)responseCode);
        if (_identiBlock)
        {
            _identiBlock((int)responseCode,nil,nil);
        }
    }
}
@end
