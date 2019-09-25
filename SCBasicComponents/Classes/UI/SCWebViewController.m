//
//  SCWebViewController.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/3/8.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCWebViewController.h"

@interface NSURLRequest (InvalidSSLCertificate)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@interface SCWebViewController ()

@property (nonatomic, strong) NSURLRequest *request;
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
//下面的三个属性是添加进度条的
@property (nonatomic, assign) BOOL theBool;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.htmlTitle;
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, PHONE_NAVIGATIONBAR__HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_NAVIGATIONBAR__HEIGHT - (IS_IPHONE_X ? 34 : 0))];
    
    _webView = [[UIWebView alloc] init];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webView];
    NSNumber *navHeight = [NSNumber numberWithInteger:(IsIOS11 ? PHONE_NAVIGATIONBAR__HEIGHT : 0)];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    if (IS_IPHONE_X) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-navHeight-[_webView]-34-|" options:0 metrics:NSDictionaryOfVariableBindings(navHeight) views:NSDictionaryOfVariableBindings(_webView)]];
    } else {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-navHeight-[_webView]-0-|" options:0 metrics:NSDictionaryOfVariableBindings(navHeight) views:NSDictionaryOfVariableBindings(_webView)]];
    }
    
    if (@available(iOS 11.0, *)) {
//        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // 添加返回按钮
    [self addLeftButton];
    // 添加进度条
    [self addProgressBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除progressView
    [self.progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//加载URL
- (void)loadHTML:(NSString *)htmlString {
    NSURL *url = [NSURL URLWithString:htmlString];
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegate
//开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSString* scheme = [[request URL] scheme];
//    判断是不是https
//    if ([scheme isEqualToString:@"https"]) {
//        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
//        if (!self.isAuthed) {
//            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [conn start];
//            [awebView stopLoading];
//            return NO;
//        }
//    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.progressView.progress = 0;
    self.theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 `
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.theBool = true; //加载完毕后，进度条完成
}

#pragma mark - NSURLConnectionDataDelegate <NSURLConnectionDelegate>
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        self.isAuthed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    SCDebugLog(@"网络不给力");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.isAuthed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:self.request];
    [connection cancel];
}

#pragma mark - init
- (void)addLeftButton {
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"btn_navigation_bar_return"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    
    return _backItem;
}

// 关闭按钮
- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        _closeItem.tintColor = [UIColor blackColor];
    }
    
    return _closeItem;
}

// 进度条
- (void)addProgressBar {
    CGFloat progressBarHeight = 0.5f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressView.trackTintColor = [UIColor whiteColor]; //背景色
    self.progressView.progressTintColor = HEXCOLOR(0x128bff); //进度色
    [self.navigationController.navigationBar addSubview:self.progressView];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

#pragma mark - action
- (void)backNative {
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative {
    [self.navigationController popViewControllerAnimated:YES];
}

// 进度条时间
- (void)timerCallback {
    if (self.theBool) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.timer invalidate];
        } else {
            self.progressView.progress += 0.1;
        }
    } else {
        self.progressView.progress += 0.1;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}

@end
