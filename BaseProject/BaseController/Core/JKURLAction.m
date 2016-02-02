//
//  NVURLAction.m
//  BaseProject
//
//  Created by Jack on 16/2/1.
//  Copyright © 2016年 宇之楓鷙. All rights reserved.
//

#import "JKURLAction.h"

@interface JKURLAction ()

@property (strong, nonatomic) NSMutableDictionary *params; // setParams:forKey:

@end


@implementation JKURLAction


+ (id)actionWithURL:(NSURL *)url {
    return [[JKURLAction alloc] initWithURL:url];
}

+ (id)actionWithURLString:(NSString *)urlString {
    return [[self alloc] initWithURLString:urlString];
}

//+ (id)actionWithHost:(NSString *)host {
//    return [[self alloc] initWithHost:host];
//}

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        
        NSDictionary *dic = [url parseQuery];
        _params = [NSMutableDictionary dictionary];
        for (NSString *key in [dic allKeys]) {
            id value = [dic objectForKey:key];
            [_params setObject:value forKey:[key lowercaseString]];
        }
    }
    return self;
}

- (id)initWithURLString:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

//- (id)initWithHost:(NSString *)host {
//    NSString *scheme = [[NVNavigator navigator] handleableURLScheme];
//    if (scheme.length<1) {
//        return nil;
//    }
//    return [self initWithURLString:[NSString stringWithFormat:@"%@://%@", scheme, host]];
//}

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key {
    [_params setObject:[NSNumber numberWithInteger:intValue] forKey:[key lowercaseString]];
}

- (void)setDouble:(double)doubleValue forKey:(NSString *)key {
    [_params setObject:[NSNumber numberWithDouble:doubleValue] forKey:[key lowercaseString]];
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
    if (string.length > 0) {
        [_params setObject:string forKey:[key lowercaseString]];
    }
}

- (void)setAnyObject:(id)object forKey:(NSString *)key {
    if(object) {
        [_params setObject:object forKey:[key lowercaseString]];
    }
}


- (NSInteger)integerForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr integerValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr integerValue];
        }
    }
    return 0;
}

- (double)doubleForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr doubleValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr doubleValue];
        }
    }
    return .0;
}

- (NSString *)stringForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return urlStr;
        }
    }
    return nil;
    
    //    NSString *urlStr = [_urlParams objectForKey:[key lowercaseString]];
    //    if(urlStr)
    //        return [urlStr stringByReplacingPercentEscapes];
    //    id obj = [_otherParams objectForKey:[key lowercaseString]];
    //    return [obj isKindOfClass:[NSString class]] ? obj : nil;
}

- (id)anyObjectForKey:(NSString *)key {
    return [_params objectForKey:[key lowercaseString]];
}

- (void)removeObjectForKey:(id)aKey
{
    [_params removeObjectForKey:aKey];
}


- (NSString *)description {
    if([_params count]) {
        NSMutableArray *paramsDesc = [NSMutableArray arrayWithCapacity:_params.count];
        for(NSString *key in [_params keyEnumerator]) {
            id value = [_params objectForKey:[key lowercaseString]];
            
            if ([value isKindOfClass:[NSString class]]) {
                [paramsDesc addObject:[NSString stringWithFormat:@"%@=%@", [key lowercaseString], [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            } else {
                [paramsDesc addObject:[NSString stringWithFormat:@"%@=%@", [key lowercaseString], value]];
            }
        }
        NSString *urlString = [_url absoluteString];
        NSRange range = [urlString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            NSString *pureURLStirng = [urlString substringToIndex:range.location];
            return [pureURLStirng stringByAppendingFormat:@"?%@",[paramsDesc componentsJoinedByString:@"&"]];
        } else {
            return [urlString stringByAppendingFormat:@"?%@",[paramsDesc componentsJoinedByString:@"&"]];
        }
    } else {
        return [_url absoluteString];
    }
}

- (NSDictionary *)queryDictionary {
    return _params;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (!otherDictionary) {
        return;
    }
    [_params addEntriesFromDictionary:otherDictionary];
}

- (void)addParamsFromURLAction:(JKURLAction *)otherURLAction {
    NSDictionary *dic = [otherURLAction queryDictionary];
    [self addEntriesFromDictionary:dic];
}


@end








/**
 *  URLEXT
 */
@implementation NSURL (Ext)

- (NSDictionary *)parseQuery {
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            continue;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CFStringRef originValue = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)([elements objectAtIndex:1]),  CFSTR(""), kCFStringEncodingUTF8);
        [dict setObject:(__bridge NSString*)originValue forKey:key];
        CFRelease(originValue);
    }
    return dict;
}

@end

