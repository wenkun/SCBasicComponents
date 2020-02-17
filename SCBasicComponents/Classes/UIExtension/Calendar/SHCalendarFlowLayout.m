//
//  SHCalendarFlowLayout.m
//  Robot
//
//  Created by haier on 2018/12/21.
//  Copyright © 2018 Haier. All rights reserved.
//

#import "SHCalendarFlowLayout.h"

@implementation SHCalendarFlowLayout
- (void)prepareLayout
{
    CGFloat item_w = self.collectionView.frame.size.width/7;
    self.itemSize = CGSizeMake(item_w, 50);

    self.collectionView.backgroundColor = [UIColor whiteColor];
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
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
    
    //header
//    NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
//    UICollectionViewLayoutAttributes* attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:index];
//    if (CGRectContainsRect(rect, attr.frame)) {
//        [attrArray addObject:attr];
//    }
    
    UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
    layoutHeader.frame =CGRectMake(0,0, self.headerReferenceSize.width, 40);
    [attrArray addObject:layoutHeader];
    
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
            attr.frame = CGRectMake(self.itemSize.width*curDay, 40, self.itemSize.width, self.itemSize.height);
        }
        else
        {
            CGFloat height = 0;
            NSInteger offset = indexPath.row+weekDay-6;
            NSInteger row = ceilf(offset/7.0);
            height = row*self.itemSize.height;
            
            
            
            attr.frame = CGRectMake(self.itemSize.width*curDay, height+40, self.itemSize.width, self.itemSize.height);
        }
    }
    
    
    return attr;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attr = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    
    if (attr==nil) {
        attr = [[UICollectionViewLayoutAttributes alloc] init];
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter] ) {
        attr.frame = CGRectZero;
    }
    else
    {
        if (indexPath.section==0) {
            attr.frame = CGRectMake(0, 0, self.headerReferenceSize.width, 40);
        }
        else
        {
            attr.frame = CGRectZero;
        }
    }
    
    return attr;
}
@end
