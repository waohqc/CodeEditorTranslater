//
//  YoudaoTranslater.m
//  TranslaterExtension
//
//  Created by qiancheng on 2023/2/28.
//

#import "YoudaoTranslater.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *v = @"webdict";
static NSString *w = @"Mk6hqtUp33DGGtoS63tTJbMUYjRrG1Lu";
static NSString *_ = @"web";


@implementation YoudaoSentenceTransModel
@end

@implementation YoudaoWordModel
@end

@implementation YoudaoWordTransModel
@end

@implementation YouDaoResponse
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"word":@"ec.word"
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

+ (void)youdaoTranslateWithContent:(NSString *)content
                        completion:(void (^)(YouDaoResponse * _Nullable, NSError * _Nullable))completion {
    
}
@end
