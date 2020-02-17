//
//  SHOneDayViw.h
//  Robot
//
//  Created by haier on 2019/5/31.
//  Copyright © 2019 Haier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHOneDayViw : UIView
@property(nonatomic,strong)UIView* contentV;

-(void)setContentDate:(NSDate*)date;
-(NSDate*)getCurDay;
-(void)setSelectedState;
-(void)setDefaultState;
@end

NS_ASSUME_NONNULL_END
