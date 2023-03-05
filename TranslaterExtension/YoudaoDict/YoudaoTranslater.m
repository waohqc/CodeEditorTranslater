//
//  YoudaoTranslater.m
//  TranslaterExtension
//
//  Created by qiancheng on 2023/2/28.
//

#import "YoudaoTranslater.h"
#import "TranslaterDefine.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *v = @"webdict";
static NSString *w = @"Mk6hqtUp33DGGtoS63tTJbMUYjRrG1Lu";
static NSString *_ = @"web";
static NSString *youdaoTransUrl = @"https://dict.youdao.com/jsonapi_s?doctype=json&jsonversion=4";

@implementation YoudaoSentenceTransModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation YoudaoWordModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation YoudaoWordTransModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation YouDaoResponse
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"wordTransResult":@"ec.word",
        @"sentenceTransResult":@"fanyi"
    }];
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

/**
 from youdao web site
 c698e2f.js
 */
@implementation YoudaoTranslater

#define CC_MD5_DIGEST_LENGTH 16

/// MD5加密
NSString *getMd5WithString(NSString * string)
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(original_str, (uint)strlen(original_str), digist);
#pragma clang diagnostic pop
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

/// 根据输入内容构建请求body
+ (NSDictionary *)buildFormDataWithContent:(NSString *)content {
    NSMutableString *timeStr = [[NSMutableString alloc] init];
    [timeStr appendString:content];
    [timeStr appendString:v];
    int time = timeStr.length % 10; // time
    
    NSString *r = [timeStr copy];
    NSString *o = getMd5WithString(r);
    
    NSMutableString *n = [[NSMutableString alloc] init];
    [n appendString:_];
    [n appendString:content];
    [n appendString:@(time).stringValue];
    [n appendString:w];
    [n appendString:o];
    
    NSString *f = getMd5WithString(n);
    return @{
        @"q" : content?:@"",
        @"le": @"en",
        @"t": @(time),
        @"client": @"web",
        @"sign": f,
        @"keyfrom": v
    };
}

+ (NSString *)getCookie {
    double randomVal = arc4random();
    while(randomVal > 1) randomVal /= 10;
    return [NSString stringWithFormat:@"OUTFOX_SEARCH_USER_ID_NCOO=%.7lf",randomVal * INT32_MAX];
}

+ (void)youdaoTranslateWithContent:(NSString *)content
                        completion:(void (^)(YouDaoResponse * _Nullable, NSError * _Nullable))completion {
    
    NSDictionary *headers = @{
      @"Accept": @"application/json, text/plain, */*",
      @"Accept-Language": @"zh-CN,zh;q=0.9",
      @"Connection": @"keep-alive",
      @"Content-Type": @"application/x-www-form-urlencoded",
      @"Cookie": [self getCookie],
      @"Origin": @"https://youdao.com",
      @"Referer": @"https://youdao.com/",
      @"Sec-Fetch-Dest": @"empty",
      @"Sec-Fetch-Mode": @"cors",
      @"Sec-Fetch-Site": @"same-site",
      @"User-Agent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
      @"sec-ch-ua": @"\"Chromium\";v=\"110\", \"Not A(Brand\";v=\"24\", \"Google Chrome\";v=\"110\"",
      @"sec-ch-ua-mobile": @"?0",
      @"sec-ch-ua-platform": @"\"macOS\""
    };
    NSDictionary *params = [self.class buildFormDataWithContent:content];
    [[AFHTTPSessionManager manager] POST:youdaoTransUrl
                              parameters:params
                                 headers:headers
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *parseErr = nil;
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            YouDaoResponse *response = [[YouDaoResponse alloc] initWithDictionary:responseObject error:&parseErr];
            if (completion) completion(response, parseErr?:nil);
        } else {
            parseErr = [[NSError alloc] initWithDomain:@"fun.waoh.translater"
                                                      code:1
                                                  userInfo:@{NSLocalizedFailureReasonErrorKey:@"解析错误"}];
            if (completion) completion(nil, parseErr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) completion(nil, error);
    }];
}

+ (NSString *)formatWord:(YoudaoWordTransModel *)workTransModel {
    NSMutableString *formatStr = [[NSMutableString alloc] init];
    [workTransModel.trs enumerateObjectsUsingBlock:^(YoudaoWordModel * _Nonnull wordModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [formatStr appendString:[NSString stringWithFormat:@"/// %ld. %@ %@\n",idx+1,wordModel.pos,wordModel.tran]];
        if(!idx) [formatStr insertString:@" " atIndex:3];
    }];
    [formatStr appendString:[NSString stringWithFormat:@"/// 美式发音: %@  英式发音:%@\n",workTransModel.usphone,workTransModel.ukphone]];
    return [formatStr copy];
}
@end
