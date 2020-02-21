//
//  SCProgressView.h
//  AWFileHash-AWFileHash
//
//  Created by 文堃 杜 on 2020/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCProgressView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) CIColor *trackColor;
//@property (nonatomic, strong) UIColor *trackColor;

@end

NS_ASSUME_NONNULL_END
