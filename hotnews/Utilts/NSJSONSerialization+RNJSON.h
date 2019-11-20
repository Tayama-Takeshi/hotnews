//
// Created by tym on 2013/09/26.
// Copyright (c) 2013 tym.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (RNJSON)

+ (NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError * __autoreleasing *)error;
+ (id)JSONObjectWithString:(NSString *)string;

@end
