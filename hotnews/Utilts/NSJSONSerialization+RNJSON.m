//
// Created by tym on 2014/05/10.
// Copyright (c) 2014 tym.COM. All rights reserved.
//


#import "NSJSONSerialization+RNJSON.h"

@implementation NSJSONSerialization (RNJSON)

+ (NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing *)error {
    NSData *d = [NSJSONSerialization dataWithJSONObject:obj options:opt error:error];
    return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
}

+ (id)JSONObjectWithString:(NSString *)string usingEncoding:(NSStringEncoding)encoding allowLossyConversion:(BOOL)lossy options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing *)error {
    NSData *d = [string dataUsingEncoding:encoding allowLossyConversion:lossy];
    if (!d) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:d options:opt error:error];
}

+ (id)JSONObjectWithString:(NSString *)string {
    NSError *e = nil;
    id obj = [NSJSONSerialization JSONObjectWithString:string usingEncoding:NSUTF8StringEncoding allowLossyConversion:YES options:0 error:&e];
    if (e) {
        ////LOG_MESSAGE(@"Error in serialization: %@", e.localizedDescription);
    }
    return obj;
}


@end
