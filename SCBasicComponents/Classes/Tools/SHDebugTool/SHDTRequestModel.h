//
//  SHDTRequestModel.h
//  Robot
//
//  Created by 星星 on 2018/7/13.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDTRequestModel : NSObject
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
///
@property (copy, nonatomic) NSString *responseString;
///
@property (strong, nonatomic) NSError *error;

@end
