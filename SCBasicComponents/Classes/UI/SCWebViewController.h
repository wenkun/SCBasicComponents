//
//  SCWebViewController.h
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/8.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SHViewController.h"
#import "SHViewController.h"

@interface SCWebViewController : SHViewController <UIWebViewDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) NSString *htmlTitle;
//声明一个方法，外接调用时，只需要传递一个URL即可
- (void)loadHTML:(NSString *)htmlString;

@end
