//
//  BaseService.m
//  college
//
//  Created by xiongchi on 15/8/30.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "BaseService.h"
#import "AFHTTPRequestOperationManager.h"

@implementation BaseService

+ (void)JSONDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@", error);
        if (fail)
        {
            fail();
        }
    }];
}

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success)
        {
            success(responseObject);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DLog(@"error:%@",error);
        if (fail)
        {
            fail(error);
        }
    }];
}

+ (void)postUploadWithUrl:(NSString *)urlStr image:(UIImage*)imgInfo success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //@"http://localhost/demo/upload.php"
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    NSData *uploadData = UIImageJPEGRepresentation(imgInfo,0.5);
    DLog(@"kb:%zi",uploadData.length/1024);
//      [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
        
         [formData appendPartWithFileData:uploadData name:@"file"
                                fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        if (fail) {
            fail();
        }  
    }];  
}

+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //
        //        NSLog(@"完成 %@", result);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }  
    }];  
}

+(void)postUploadCustomWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //
        //        NSLog(@"完成 %@", result);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }  
    }];  
}

@end
