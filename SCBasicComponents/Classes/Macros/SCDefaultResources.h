//
//  SCDefaultResources.h
//  SCBasicComponents
//
//  Created by 文堃 杜 on 2018/2/9.
//  Copyright © 2018年 wenkun. All rights reserved.
//

#ifndef SCDefaultResources_h
#define SCDefaultResources_h

/* APP Info 信息 */
//Info文件数据
#define SCInfoDicationary [[NSBundle mainBundle] infoDictionary]
//APP Display Name
#define APPName [SCInfoDicationary objectForKey:@"CFBundleDisplayName"]
//APP Bundle Name
#define APPBundleName [SCInfoDicationary objectForKey:@"CFBundleName"]
//APP Version
#define APPVersion [SCInfoDicationary objectForKey:@"CFBundleShortVersionString"]
//APP Build Version
#define APPBuildVersion [SCInfoDicationary objectForKey:@"CFBundleVersion"]
//APP Bundle Identifier
#define APPBundleIdentifier [SCInfoDicationary objectForKey:@"CFBundleIdentifier"]


/* 沙盒路径 */
//沙盒主目录路径
#define SCPathHome NSHomeDirectory()
//沙盒Library目录路径
#define SCPathLibrary [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
//沙盒Documents目录路径
#define SCPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//沙盒Caches目录路径
#define SCPathCaches [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//沙盒tmp目录路径
#define SCPathTmp NSTemporaryDirectory()
//在沙盒路径中创建路径文件夹
#define SCFilePathCreate(filePath, error) if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];


//从storyboard里获取ViewController
#define ViewControllerFromStoryboard(storyboardName, viewControllerId) [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:viewControllerId]


#endif /* SCDefaultResources_h */
