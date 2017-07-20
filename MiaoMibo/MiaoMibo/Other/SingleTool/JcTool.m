//
//  JcTool.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcTool.h"

@implementation JcTool
implementationSingleton(JcTool);


- (NSString *)psdAppandStringWithOriString:(NSString *)oriString appendString:(NSString *)appendString
{
    NSMutableString *mutaString = [oriString mutableCopy];
    
    [mutaString appendString:appendString];
    
    NSString *resultString = [mutaString copy];
    
    return resultString;
}
- (BOOL)isEmpty:(NSString *)value
{
    if (value == nil) {
        return YES;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [self trim:value].length == 0;
    }
    return NO;
}

- (BOOL)isNotEmpty:(NSString *)value
{
    return ![self isEmpty:value];
}

- (BOOL)isEmptyArray:(NSArray *)values
{
    return values == nil || values.count == 0;
}

- (BOOL)isNotEmptyArray:(NSArray *)values
{
    return ![self isEmptyArray:values];
}
- (NSString *)trim:(NSString *)value
{
    if (value == nil) {
        return nil;
    }
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [value stringByReplacingOccurrencesOfString:@"\u2006" withString:@""];
}
- (NSInteger)toInteger:(id)value
{
    return [[NSString stringWithFormat:@"%@", value] integerValue];
}

- (NSString *)toStr:(id)value
{
    if (value == nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", value];
}

- (NSString *)toString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%zd", value];
}
- (NSUInteger)length:(NSString *)value
{
    if ([self isEmpty:value]) {
        return 0;
    }
    NSUInteger n = [value length];
    int i,l = 0,a = 0,b = 0;
    unichar c;
    for(i = 0; i < n; i++){
        c = [value characterAtIndex:i];
        if(isblank(c)){
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

- (NSString *)encode:(NSString *)value
{
    if (value == nil) {
        return @"";
    }
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[value UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '*' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
    //    CFStringRef escaped =
    //    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                            (CFStringRef)value,
    //                                            NULL,
    //                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
    //                                            kCFStringEncodingUTF8);
    //    return (NSString *)CFBridgingRelease(escaped);
    //    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, NULL, kCFStringEncodingUTF8));
    //    return outputStr;
    //    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
    //    return outputStr;
}

- (NSString *)decode:(NSString *)value
{
    if ([self isEmpty:value]) {
        return nil;
    }
    NSMutableString *outputStr = [NSMutableString stringWithString:value];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, outputStr.length)];
    return [outputStr stringByRemovingPercentEncoding];
}


-(NSString *)trimWhitespaceAndNewlineWithString : (NSString *)valueString
{
    if (valueString == nil) {
        return nil;
    }
    //去除掉首尾的空白字符和换行字符
    valueString = [valueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    valueString = [valueString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    valueString = [valueString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return valueString;
}
- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}
@end
