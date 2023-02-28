//
//  YoudaoTranslater.h
//  TranslaterExtension
//
//  Created by qiancheng on 2023/2/28.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

/// 句子翻译
@interface YoudaoSentenceTransModel : JSONModel
@property (nonatomic, copy) NSString *input;
@property (nonatomic, copy) NSString *tran;
@end

@protocol YoudaoWordModel;
@interface YoudaoWordModel : JSONModel
/// 词性 adj. adv. n.
@property (nonatomic, copy) NSString *pos;
/// 翻译结果
@property (nonatomic, copy) NSString *tran;
@end

/// 单词翻译
@interface YoudaoWordTransModel : JSONModel
/// 美式音标
@property (nonatomic, copy) NSString *usphone;

/// 英式音标
@property (nonatomic, copy) NSString *ukphone;

/// 所有翻译结果
@property (nonatomic, strong) NSArray<YoudaoWordModel> *trs;
@end


/// 翻译结果
@interface YouDaoResponse : JSONModel

/// 句子翻译
@property (nonatomic, strong) YoudaoSentenceTransModel *fanyi;

/// 单词翻译
@property (nonatomic, strong) YoudaoWordTransModel *word;
@end

@interface YoudaoTranslater : NSObject


/// 调用有道翻译接口
/// - Parameters:
///   - content: 内容
///   - completion: 翻译结果
+ (void)youdaoTranslateWithContent:(NSString *)content
                        completion:(void(^)(YouDaoResponse *_Nullable, NSError *_Nullable))completion;
@end

NS_ASSUME_NONNULL_END
