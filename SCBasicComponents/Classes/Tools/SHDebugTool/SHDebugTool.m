
//
//  SHDebugTool.m
//  Robot
//
//  Created by 星星 on 2018/7/11.
//  Copyright © 2018年 Haier. All rights reserved.
//

#import "SHDebugTool.h"
#import "SHDTWindowRootController.h"
#import "SHDTURLProtocol.h"

@interface SHDebugTool ()
///
@property (strong, nonatomic) UIWindow *window;
///
@property (assign, nonatomic) BOOL isWorking;
@property (assign, nonatomic) CGFloat fps;
///
@property (strong, nonatomic) CADisplayLink *link;
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (assign, nonatomic) NSInteger count;

@end
@implementation SHDebugTool
+ (void)load{
    [self sharedInstance];
}
+ (instancetype)sharedInstance
{
    static SHDebugTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[SHDebugTool alloc] init];
        }
    });
    
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentFamilyUpdated) name:CurrentFamilyUpdatedNotificationName object:nil];
    }
    return self;
}
-(void)dealloc{
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_link invalidate];
        _link = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)startWorking{
#ifdef uSDK_DEBUG
    if (enble) {
        if (!_isWorking) {
            _isWorking = YES;
            
            [self registerURLProtocol];
            self.window.frame = CGRectMake(0, ScreenHeight-49-60, 60, 60);
            self.window.hidden = NO;
            self.window.backgroundColor = [UIColor clearColor];
            
            if (_link) {
                [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                [_link invalidate];
                _link = nil;
            }
            _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsDisplayLinkAction:)];
            [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        [self showWindow];
    }
#endif
}
- (void)stopWorking {
    if (_isWorking) {
        _isWorking = NO;
        self.window.hidden = YES;
    }
}

- (void)showWindow{
    _window.hidden = NO;
}
- (void)hideWindow{
    _window.hidden = YES;
}

- (void)currentFamilyUpdated{
    [self startWorking];
}
- (void)applicationDidFinishLaunchingNotification{
    [self startWorking];
}
#pragma mark - FPS
- (void)fpsDisplayLinkAction:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    _fps = _count / delta;
    _count = 0;
    
    SHDTWindowRootController *vc = self.window.rootViewController;
    vc.fps =_fps;
}

- (void)registerURLProtocol {
    if (![NSURLProtocol registerClass:[SHDTURLProtocol class]]) {
        SCDebugLog(@"SHDTURLProtocol reigsiter URLProtocol fail.");
    }
}

- (void)unregisterURLProtocol {
    [NSURLProtocol unregisterClass:[SHDTURLProtocol class]];
}
#pragma mark - property
- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] init];
        _window.windowLevel = UIWindowLevelAlert+1;
        SHDTWindowRootController *vc = [[SHDTWindowRootController alloc] init];
        _window.rootViewController = vc;
    }
    return _window;
}
- (NSMutableArray *)requestArray{
    if (!_requestArray) {
        _requestArray = [NSMutableArray array];
    }
    return _requestArray;
}
@end
