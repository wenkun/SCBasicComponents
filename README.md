
## Installation

```ruby
source 'https://10.159.46.130/iOS_pods/PodSpecRepo.git'
pod 'SCBasicComponents', :git=>'https://10.159.46.130/iOS_pods/SCBasicComponents.git'
```

## Author

duwenkun@haier.com

## License

SCBasicComponents is available under the MIT license. See the LICENSE file for more info.


## Example

    //SCDefaultsUI.h 提供系统版本、手机屏幕尺寸、十六进制颜色等一些宏
    //SCDefaultResources.h 提供资源文件相关一些宏
    //UIExtension 对UIKit框架的一些类进行扩展

    //SCLog提供区分是否为debug日志，并提供Log写入本地功能
    SCLog(@"[APP]%@", [UIDevice deviceMode]);
    SCLog(@"[TEST] Just a Test");
    SCDebugLog(@"Can you find me?");
    [SCLogManager startLogAndWriteToFile]; //Log写入本地
    SCLog(@"[APP]%@", [UIDevice deviceMode]);
    SCLog(@"[TEST] Just a Test");
    SCDebugLog(@"Can you find me?");
    
    //Label高度自动适配计算
    CGSize size = [label setAutoFrame];
    
    //View无限旋转动画
    [view startRotateAnimation];
    
## Update

0.2.2 ：
 新增SCAppJump类：1、封装系统的openUrl方法，添加回到主线程处理。
                                    2、封装跳转WIFI设置页及其他系统设置页的方法，以绕过苹果审核。
                                    3、封装拨打电话方法


