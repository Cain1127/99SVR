//
//  BaseService.h
//  college
//
//  Created by xiongchi on 15/8/30.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseService : NSObject

/**
 *  另外封装的post请求，带timeout
 */
+ (void)post:(NSString *)url dictionay:(id)dict timeout:(int)time success:(void (^)(id responseObject))success
        fail:(void (^)(NSError *error))fail;
/**
 *  封装get,带timeout
 */
+ (void)get:(NSString *)url dictionay:(id)dict timeout:(int)time success:(void (^)(id responseObject))success
        fail:(void (^)(NSError *error))fail;


+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success
                   fail:(void (^)(NSError *error))fail;

+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters
               success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;
+ (void)JSONDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail;

+ (void)postUploadWithUrl:(NSString *)urlStr image:(UIImage*)imgInfo success:(void (^)(id responseObject))success fail:(void (^)())fail;

+(void)postUploadCustomWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail;

@end
