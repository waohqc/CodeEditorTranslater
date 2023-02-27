//
//  YoudaoTranslater.h
//  TranslaterExtension
//
//  Created by qiancheng on 2023/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YoudaoTranslater : NSObject

+ (NSDictionary *)buildFormDataWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
