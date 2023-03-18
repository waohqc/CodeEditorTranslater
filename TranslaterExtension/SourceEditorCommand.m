//
//  SourceEditorCommand.m
//  TranslaterExtension
//
//  Created by qiancheng on 2023/2/26.
//

#import "SourceEditorCommand.h"

#import "TranslaterDefine.h"
#import "YoudaoTranslater.h"
@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    NSMutableArray<NSString *> *selectedStrs = [[NSMutableArray alloc] init];
    for (XCSourceTextRange *sourceRange in invocation.buffer.selections) {
        NSMutableString *selectedStr = [[NSMutableString alloc] init];
        for(NSInteger i=sourceRange.start.line;i<=sourceRange.end.line;i++) {
            if(i == sourceRange.end.line && sourceRange.end.column == 0) break;
            NSString *curLine = [invocation.buffer.lines[i] copy];
            if (sourceRange.start.line == sourceRange.end.line) {
                NSInteger len = sourceRange.end.column - sourceRange.start.column;
                [selectedStr appendString:[curLine substringWithRange:NSMakeRange(sourceRange.start.column, len)]];
            } else if (i == sourceRange.start.line) {
                [selectedStr appendString:[curLine substringFromIndex:sourceRange.start.column]];
            } else if (i == sourceRange.end.line) {
                [selectedStr appendString:[curLine substringToIndex:sourceRange.end.column]];
            } else {
                [selectedStr appendString:curLine];
            }
        }
        selectedStr = [NSMutableString stringWithString:[selectedStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];
        selectedStr = [NSMutableString stringWithString:[selectedStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [selectedStrs addObject:selectedStr];
    }
    
    // request and translate
    if (selectedStrs.count == 1) {
        [YoudaoTranslater youdaoTranslateWithContent:selectedStrs[0]
                                          completion:^(YouDaoResponse * _Nullable transResponse, NSError * _Nullable err) {
            if (transResponse && !err) {
                [self fillTransResultInLines:invocation.buffer.lines
                                     content:selectedStrs[0]
                                  selections:invocation.buffer.selections
                                 transResult:transResponse];
            }
            completionHandler(err);
        }];
    } else {
        NSError *err = [[NSError alloc] initWithDomain:@"fun.waoh.translater"
                                                  code:2
                                              userInfo:@{NSLocalizedFailureReasonErrorKey:@"内容过多，减少后重试"}];
        completionHandler(err);
    }
}


- (void)fillTransResultInLines:(NSMutableArray<NSString *> *)lines
                       content:(NSString *)content
                    selections:(NSArray<XCSourceTextRange *> *)selections
                   transResult:(YouDaoResponse *)transResponse {
    NSInteger line = selections.firstObject.start.line;
    NSMutableString *appendStr = [[NSMutableString alloc] initWithString:@"#CodeEditorTranslater:"];
    if(!transResponse.sentenceTransResult) [appendStr appendString:@"\n"];
    if (transResponse.sentenceTransResult) {
        [appendStr appendString:transResponse.sentenceTransResult.tran];
    } else if (transResponse.wordTransResult){
        [appendStr appendString:[YoudaoTranslater formatWord:transResponse.wordTransResult]];
    } else {
        [appendStr appendString:[NSString stringWithFormat:@"/// 暂无\"%@\"相关翻译",content]];
    }
    if (![lines[line] hasPrefix:@" *"]) {
        [appendStr insertString:@"///" atIndex:0];
    }
    [lines insertObject:appendStr atIndex:line];
}
@end
