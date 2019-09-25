//
//  SHErrorMessage.h
//  Robot
//
//  Created by 文堃 杜 on 2018/8/9.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHErrorMessage : NSObject

+(NSString *)messageOfRequestError:(NSError *)error;

@end
