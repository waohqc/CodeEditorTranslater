//
//  SourceEditorCommand.m
//  TranslaterExtension
//
//  Created by qiancheng on 2023/2/26.
//

#import "SourceEditorCommand.h"
#import "TranslaterDefine.h"

#import <AFNetworking/AFNetworking.h>
@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    // filter slected str
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
    
    XTLog(@"%@",selectedStrs);
}

@end
