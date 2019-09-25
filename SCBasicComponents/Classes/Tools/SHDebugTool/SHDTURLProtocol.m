//
//  SHDebugTool.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//
#ifndef __Require_noErr_Quiet
#define __Require_noErr_Quiet(errorCode, exceptionLabel)                      \
do                                                                          \
{                                                                           \
if ( __builtin_expect(0 != (errorCode), 0) )                            \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif

#ifndef __Require_Quiet
#define __Require_Quiet(assertion, exceptionLabel)                            \
do                                                                          \
{                                                                           \
if ( __builtin_expect(!(assertion), 0) )                                \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif

#ifndef __nRequire_Quiet
#define __nRequire_Quiet(assertion, exceptionLabel)  __Require_Quiet(!(assertion), exceptionLabel)
#endif



#define SecurityLevel 2

#import "SHDTURLProtocol.h"
#import "SHDebugTool.h"
#import "SHDTRequestModel.h"

static NSString *const HTTPHandledIdentifier = @"HttpHandleIdentifier";

@interface SHDTURLProtocol () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession         *session;
@property (nonatomic, strong) NSURLResponse        *response;
@property (nonatomic, strong) NSMutableData        *data;
@property (nonatomic, strong) NSDate               *startDate;
@property (nonatomic, strong) NSError              *error;

///
@property (copy, nonatomic) NSString *startDateString;
///
@property (copy, nonatomic) NSURL *url;
///
@property (copy, nonatomic) NSString *method;
///
@property (copy, nonatomic) NSDictionary *headerFields;
///
@property (copy, nonatomic) NSString *mineType;
///
@property (copy, nonatomic) NSString *requestBody;
///
@property (copy, nonatomic) NSString *statusCode;
@property (nonatomic , assign) BOOL isImage;
///
@property (copy, nonatomic) NSString *totalDuration;
@property(nonatomic,retain)NSData *caData;
@property(nonatomic,retain)NSString* trustDomain;

@end

@implementation SHDTURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    if (!([request.URL.host containsString:@"haier.net"]
        ||[request.URL.host containsString:@"haiershequ.com"])) {
        return NO;
    }
    if ([NSURLProtocol propertyForKey:HTTPHandledIdentifier inRequest:request] ) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:HTTPHandledIdentifier
                     inRequest:mutableReqeust];
    return mutableReqeust;
}

- (void)startLoading {
    self.startDate                                        = [NSDate date];
    self.data                                             = [NSMutableData data];
    NSURLSessionConfiguration *configuration              = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session                                          = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    self.dataTask                                         = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)stopLoading {
    [self.dataTask cancel];
    self.dataTask           = nil;
    SHDTRequestModel *requestModel = [[SHDTRequestModel alloc] init];
    requestModel.startDateString = [self.startDate stringWithFormat:@"YYYY-MM-dd hh:mm:ss"];
    requestModel.url = self.request.URL;
    requestModel.method = self.request.HTTPMethod;
    requestModel.headerFields = self.request.allHTTPHeaderFields;
    requestModel.mineType = self.response.MIMEType;
    if (self.request.HTTPBody) {
        
        requestModel.requestBody = [self prettyStringWihtData:self.request.HTTPBody];
    } else if (self.request.HTTPBodyStream) {
        NSData* data = [self dataFromInputStream:self.request.HTTPBodyStream];
       
        requestModel.requestBody = [self prettyStringWihtData:data];
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    requestModel.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    if (self.response.MIMEType) {
        requestModel.isImage = [self.response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    }
    NSString *absoluteString = self.request.URL.absoluteString.lowercaseString;
    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"] || [absoluteString hasSuffix:@".gif"]) {
        requestModel.isImage = YES;
    }
    requestModel.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSinceDate:self.startDate]];

    requestModel.responseString = [self prettyStringWihtData:self.data];
    requestModel.error = self.error;
    [[SHDebugTool sharedInstance].requestArray insertObject:requestModel atIndex:0];
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSString *host = challenge.protectionSpace.host;
//        SCDebugLog(@"%@", host);
        
        if (SecurityLevel==1) {
            SecTrustRef trust = challenge.protectionSpace.serverTrust;
            //方案1：系统方法验证
            NSMutableArray *certificates = [NSMutableArray array];
            NSData *cerData = [NSData dataWithData:self.caData];/* 在 App Bundle 中你用来做锚点的证书数据，证书是 CER 编码的，常见扩展名有：cer, crt...*/
            SecCertificateRef cerRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
            [certificates addObject:(__bridge_transfer id)cerRef];
            
            // 设置锚点证书。
            SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)certificates);
            // true 代表仅被传入的证书作为锚点，false 允许系统 CA 证书也作为锚点
            SecTrustSetAnchorCertificatesOnly(trust, false);
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
        }
        else if(SecurityLevel == 2)
        {
            /* 调用自定义的验证过程 */
            if ([self myCustomValidation:challenge]) {
                
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }
            } else {
                /* 无效的话，取消 */
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }
        else
        {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
    self.error = error;
    self.dataTask = nil;
    [self.session finishTasksAndInvalidate];
    self.session = nil;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}

#pragma mark - Primary
- (NSData *)dataFromInputStream:(NSInputStream *)stream {
    NSMutableData *data = [[NSMutableData alloc] init];
    if (stream.streamStatus != NSStreamStatusOpen) {
        [stream open];
    }
    NSInteger readLength;
    uint8_t buffer[1024];
    while((readLength = [stream read:buffer maxLength:1024]) > 0) {
        [data appendBytes:buffer length:readLength];
    }
    return data;
}
- (NSData *)caData{
    return nil;
    if (!_caData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];
        _caData = [NSData dataWithContentsOfFile:path];
    }
   return _caData;
}
#pragma mark - ACtion

- (NSString *)prettyStringWihtData:(NSData *)data{
    if (!data) return nil;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *jsonString = @"";
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        // NSJSONSerialization escapes forward slashes. We want pretty json, so run through and unescape the slashes.
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
-(BOOL)myCustomValidation:(NSURLAuthenticationChallenge *)challenge
{
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    
    NSMutableArray *policies = [NSMutableArray array];
    if (self.trustDomain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)self.trustDomain)];
    } else {
        // BasicX509 不验证域名是否相同
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    
    SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
    
    
    if (self.caData) {
        
        NSArray* serverCertificates = AFCertificateTrustChainForServerTrust(trust);
        NSArray *publicKeys = AFPublicKeyTrustChainForServerTrust(trust);
        
        //方案1：系统方法验证
        NSMutableArray *certificates = [NSMutableArray array];
        NSData *cerData = [NSData dataWithData:self.caData];/* 在 App Bundle 中你用来做锚点的证书数据，证书是 CER 编码的，常见扩展名有：cer, crt...*/
        SecCertificateRef cerRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
        [certificates addObject:(__bridge_transfer id)cerRef];
        
        // 设置锚点证书。
        SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)certificates);
        // true 代表仅被传入的证书作为锚点，false 允许系统 CA 证书也作为锚点
        SecTrustSetAnchorCertificatesOnly(trust, false);
        
        if (serverTrustIsVaild(trust)) {
            return YES;
        }
        
        //方案2：证书验证
        NSUInteger trustedCertificateCount = 0;
        for (NSData *trustChainCertificate in serverCertificates) {
            if ([self.caData isEqualToData:trustChainCertificate]) {
                trustedCertificateCount++;
            }
        }
        if (trustedCertificateCount>0) {
            return YES;
        }
        
        
        //方案3：公开密钥验证
        NSUInteger trustedPublicKeyCount = 0;
        id publicKey = AFPublicKeyForCertificate(self.caData);
        for (id trustChainPublicKey in publicKeys) {
            if (AFSecKeyIsEqualToKey((__bridge SecKeyRef)trustChainPublicKey, (__bridge SecKeyRef)publicKey)) {
                trustedPublicKeyCount += 1;
            }
        }
        if (trustedPublicKeyCount>0) {
            return YES;
        }
    }
    
    
    return serverTrustIsVaild(trust);
}
static BOOL serverTrustIsVaild(SecTrustRef trust) {
    BOOL allowConnection = NO;
    
    // 假设验证结果是无效的
    SecTrustResultType trustResult = kSecTrustResultInvalid;
    
    // 函数的内部递归地从叶节点证书到根证书的验证
    OSStatus statue = SecTrustEvaluate(trust, &trustResult);
    
    if (statue == noErr) {
        // kSecTrustResultUnspecified: 系统隐式地信任这个证书
        // kSecTrustResultProceed: 用户加入自己的信任锚点，显式地告诉系统这个证书是值得信任的
        
        allowConnection = (trustResult == kSecTrustResultProceed
                           || trustResult == kSecTrustResultUnspecified);
    }
    return allowConnection;
}
static NSArray * AFCertificateTrustChainForServerTrust(SecTrustRef serverTrust) {
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        [trustChain addObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)];
    }
    
    return [NSArray arrayWithArray:trustChain];
}
static NSArray * AFPublicKeyTrustChainForServerTrust(SecTrustRef serverTrust) {
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        
        SecCertificateRef someCertificates[] = {certificate};
        CFArrayRef certificates = CFArrayCreate(NULL, (const void **)someCertificates, 1, NULL);
        
        SecTrustRef trust;
        __Require_noErr_Quiet(SecTrustCreateWithCertificates(certificates, policy, &trust), _out);
        
        SecTrustResultType result;
        __Require_noErr_Quiet(SecTrustEvaluate(trust, &result), _out);
        
        [trustChain addObject:(__bridge_transfer id)SecTrustCopyPublicKey(trust)];
        
    _out:
        if (trust) {
            CFRelease(trust);
        }
        
        if (certificates) {
            CFRelease(certificates);
        }
        
        continue;
    }
    CFRelease(policy);
    
    return [NSArray arrayWithArray:trustChain];
}
static id AFPublicKeyForCertificate(NSData *certificate) {
    id allowedPublicKey = nil;
    SecCertificateRef allowedCertificate;
    SecCertificateRef allowedCertificates[1];
    CFArrayRef tempCertificates = nil;
    SecPolicyRef policy = nil;
    SecTrustRef allowedTrust = nil;
    SecTrustResultType result;
    
    allowedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificate);
    __Require_Quiet(allowedCertificate != NULL, _out);
    
    allowedCertificates[0] = allowedCertificate;
    tempCertificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);
    
    policy = SecPolicyCreateBasicX509();
    __Require_noErr_Quiet(SecTrustCreateWithCertificates(tempCertificates, policy, &allowedTrust), _out);
    __Require_noErr_Quiet(SecTrustEvaluate(allowedTrust, &result), _out);
    
    allowedPublicKey = (__bridge_transfer id)SecTrustCopyPublicKey(allowedTrust);
    
_out:
    if (allowedTrust) {
        CFRelease(allowedTrust);
    }
    
    if (policy) {
        CFRelease(policy);
    }
    
    if (tempCertificates) {
        CFRelease(tempCertificates);
    }
    
    if (allowedCertificate) {
        CFRelease(allowedCertificate);
    }
    
    return allowedPublicKey;
}
static BOOL AFSecKeyIsEqualToKey(SecKeyRef key1, SecKeyRef key2) {
    return [(__bridge id)key1 isEqual:(__bridge id)key2];
}
@end
