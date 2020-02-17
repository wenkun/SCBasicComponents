//
//  SHCalendarNoHeaderFlowLayout.m
//  Robot
//
//  Created by haier on 2019/6/5.
//  Copyright © 2019 Haier. All rights reserved.
//

#import "SHCalendarNoHeaderFlowLayout.h"

@implementation SHCalendarNoHeaderFlowLayout
- (void)prepareLayout
{
    CGFloat item_w = floor([UIScreen mainScreen].bounds.size.width/7) ;
    self.itemSize = CGSizeMake(item_w, 30);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
-(CGSize)collectionViewContentSize
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, self.collectionView.frame.size.height);
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attrArray = [[NSMutableArray alloc] init];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:index];
        if (CGRectContainsRect(rect, attr.frame)) {
            [attrArray addObject:attr];
        }
    }
    
    return attrArray;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if (attr==nil) {
        attr = [[UICollectionViewLayoutAttributes alloc] init];
    }
    if (self.datasource) {
        NSDate* firstdate = [self.datasource objectAtIndex:0];
        NSInteger weekDay = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:firstdate]-1;//0-6
        NSDate* date = [self.datasource objectAtIndex:indexPath.row];
        NSInteger curDay = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:date]-1;
        if (indexPath.row<=6-weekDay) {
            attr.frame = CGRectMake(self.itemSize.width*curDay, 0, self.itemSize.width, self.itemSize.height);
        }
        else
        {
            CGFloat height = 0;
            NSInteger offset = indexPath.row+weekDay-6;
            NSInteger row = ceilf(offset/7.0);
            height = row*self.itemSize.height;
            
            
            
            attr.frame = CGRectMake(self.itemSize.width*curDay, height, self.itemSize.width, self.itemSize.height);
        }
    }
    
    
    return attr;
}

@end
