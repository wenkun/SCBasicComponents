//
//  NSError+SCExtension.h
//  GoodAir
//
//  Created by 文堃 杜 on 2017/5/16.
//  Copyright © 2017年 青岛海尔科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Error类型Key
extern NSString * const SErrorTypeKey;
/// String类型的Code Key
extern NSString * const SErrorCodeStringKey;
/// 原始的数据Error数据Key
extern NSString * const SErrorRawDataKey;

/// 无错误类型定义
extern NSInteger const SErrorTypeNone;
/// 自定义错误类型
extern NSInteger const SErrorTypeCustom;
/// HTTP网络错误类型
extern NSInteger const SErrorTypeHTTP;
/// 服务端返回的业务错误类型
extern NSInteger const SErrorTypeServerBusiness;
/// 外接设备返回错误类型
extern NSInteger const SErrorTypeExternalDevice;

/// 无法转成Int类型的code默认设置为SErrorCodeNotIntValue
extern NSString * const SErrorCodeNotIntValue;

/**
 NSError扩展，支持String类型的错误编码。
 当code的值为-111111时，表示实际的错误编码为String类型，需要从codeString或者根据SErrorCodeStringKey来取出来
 */
@interface NSError (SCExtension)

/**
 生成一个NSError对象。
 
 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param code The error code for the error.
 @param description 错误描述，NSLocalizedDescriptionKey的对应值。
 @return NSError对象。
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code description:(NSString *)description;
/**
生成一个NSError对象。

@param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
@param code The error code for the error.
@param description 错误描述，NSLocalizedDescriptionKey的对应值。
@param errorType Error类型，参考SErrorType，可自定义类型。
@return NSError对象。
*/
+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code description:(NSString *)description type:(NSInteger)errorType;

/**
 生成一个NSError对象，针对非整型的错误码。
 如果错误码codeString可以转成整型，则赋值给code属性；否则code的值统一为SErrorCodeNotIntValue。
 
 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param codeString NSString类型的code。
 @param description 错误描述。
 @return NSError对象。
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain codeString:(NSString *)codeString description:(NSString *)description;
/**
 生成一个NSError对象，针对非整型的错误码。
 如果错误码codeString可以转成整型，则赋值给code属性；否则code的值统一为SErrorCodeNotIntValue。
 
 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param codeString NSString类型的code。
 @param description 错误描述。
 @param errorType Error类型，参考SErrorType，可自定义类型。
 @return NSError对象。
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain codeString:(NSString *)codeString description:(NSString *)description type:(NSInteger)errorType;

/**
 生成一个NSError对象，针对非整型的错误码。
 如果错误码codeString可以转成整型，则赋值给code属性；否则code的值统一为SErrorCodeNotIntValue。
 
 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param codeString NSString类型的code。
 @param description 错误描述。
 @param rawData 原始错误数据。
 @return NSError对象。
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain codeString:(NSString *)codeString description:(NSString *)description rawData:(id)rawData;
/**
 生成一个NSError对象，针对非整型的错误码。
 如果错误码codeString可以转成整型，则赋值给code属性；否则code的值统一为SErrorCodeNotIntValue。
 
 @param domain The error domain—this can be one of the predefined NSError domains, or an arbitrary string describing a custom domain. domain must not be nil. See Error Domains for a list of predefined domains.
 @param codeString NSString类型的code。
 @param description 错误描述。
 @param rawData 原始错误数据。
 @param errorType Error类型，参考SErrorType，可自定义类型。
 @return NSError对象。
 */
+(instancetype)errorWithDomain:(NSErrorDomain)domain codeString:(NSString *)codeString description:(NSString *)description rawData:(id)rawData type:(NSInteger)errorType;

/**
 自定义Error类型，默认为SErrorTypeNone，可在SErrorType枚举的基础上自定义增加。
 */
@property (nonatomic, readonly) NSInteger errorType;

/**
 读取错误码字符串，部分错误码为英文字符组合，需用codeString获取。
 */
@property (nonatomic, readonly) NSString *codeString;

/**
 原始Error数据。
 */
@property (nonatomic, readonly) id rawData;

@end
