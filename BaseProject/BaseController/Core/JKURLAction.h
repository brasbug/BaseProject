//
//  NVURLAction.h
//  BaseProject
//
//  Created by Jack on 16/2/1.
//  Copyright © 2016年 宇之楓鷙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKURLAction : NSObject

/**
 需要导航到的url地址
 */
@property (nonatomic, strong, readonly) NSURL *url;

/**
 所有的参数构建成query
 */
@property (nonatomic, readonly) NSString* query;

/**
 如果url为http url，则会询问是否在外部打开
 默认为NO
 */
@property (nonatomic) BOOL openExternal;



///////////////////////////////////////////
+ (id)actionWithURL:(NSURL *)url;
+ (id)actionWithURLString:(NSString *)urlString;
//+ (id)actionWithHost:(NSString *)host;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURLString:(NSString *)urlString;
//- (id)initWithHost:(NSString *)host;


- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key;
- (void)setDouble:(double)doubleValue forKey:(NSString *)key;
- (void)setString:(NSString *)string forKey:(NSString *)key;

/**
 如果参数不为4中基本类型，可以使用anyObject进行传递
 不建议使用该方法
 anyObject不支持在URL中进行传递
 */
- (void)setAnyObject:(id)object forKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
/**
 如果参数不为4中基本类型，可以使用anyObject进行传递
 不建议使用该方法
 anyObject不支持在URL中进行传递
 */
- (id)anyObjectForKey:(NSString *)key;

//允许删除一个已存在的key
- (void)removeObjectForKey:(id)aKey;

/**
 *  parameters for navigator
 *
 *  @return
 */
- (NSDictionary *)queryDictionary;


@end


@interface UIViewController (urlAction)
@property (nonatomic, strong) JKURLAction *urlAction;
@end


@interface NSURL (Ext)

/**
 将query解析为NSDictionary
 
 @return 返回参数字典对象，参数的值已经进行了decode.
 (stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding)
 */
- (NSDictionary *)parseQuery;

@end

