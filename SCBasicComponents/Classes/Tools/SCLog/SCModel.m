//
//  SCModel.m
//  IntelligentCommunity
//
//  Created by 文堃 杜 on 2018/2/28.
//  Copyright © 2018年 SmartCare. All rights reserved.
//

#import "SCModel.h"
#import <objc/runtime.h>

@implementation SCModel

-(BOOL)isKindOfSCModelClass
{
    return YES;
}

-(instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        [self configData:data];
    }
    return self;
}

-(void)configData:(NSDictionary *)data
{
    //兼容处理，解析data可能是NSNull对象
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSArray *allProperties = [SCModel getAllPropertiesWithClass:self.class];
    for (NSString *key in allProperties) {
        if ([[key substringFromIndex:key.length-1] isEqualToString:@"_"]) {
            //“id_”类的属性
            NSString *realKey = [key substringToIndex:key.length-1];
            [self setValue:data[realKey] forKey:key];
        }
        else {
            [self setValue:data[key] forKey:key];
        }
    }
}

+(NSArray *)analyzingWithArrayData:(NSArray *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in data) {
        SCModel *object = [[[self class] alloc] initWithData:dic];
        [array addObject:object];
    }
    return array;
}

#pragma mark - 获取属性

///获取本类的所有属性，不包含父类的属性
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char *propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    
    return propertiesArray;
}

///获取cla类的所有属性，包含派生自SCModel的所有成员的所有属性
+(NSArray *)getAllPropertiesWithClass:(Class)cla
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(cla, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char *propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    
    Class superClass = class_getSuperclass(cla);
    if (class_respondsToSelector(superClass, @selector(isKindOfSCModelClass))) {
        [propertiesArray addObjectsFromArray:[SCModel getAllPropertiesWithClass:superClass]];
    }
    
    return propertiesArray;
}

-(Class)getPropertyClass:(NSString *)propertyName
{
    objc_property_t property = class_getProperty([self class], propertyName.UTF8String);
    NSString *attClass = nil;
    NSString *att = [NSString stringWithUTF8String:property_getAttributes(property)];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"T@\".*\"," options:0 error:&error];
    if (error) {
        NSLog(@"NSRegularExpression error: %@", error);
    }
    else {
        NSTextCheckingResult *check = [regex firstMatchInString:att options:0 range:NSMakeRange(0, att.length)];
        if (check) {
            attClass = [att substringWithRange:NSMakeRange(check.range.location+3, check.range.length-5)];
        }
    }
    
    return NSClassFromString(attClass);
}

+(NSArray *)getAllAttributesWithObject:(NSObject *)object
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([object class], &count);
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        NSString *attName = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *attClass = nil;
        NSString *att = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
        
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"T@\".*\"," options:0 error:&error];
        if (error) {
            NSLog(@"NSRegularExpression error: %@", error);
        }
        else {
            NSTextCheckingResult *check = [regex firstMatchInString:att options:0 range:NSMakeRange(0, att.length)];
            if (check) {
                attClass = [att substringWithRange:NSMakeRange(check.range.location+3, check.range.length-5)];
            }
        }
        if ((attClass && attClass.length > 0) && (attName && attName.length > 0)) {
            [attributes addObject:@{@"name" : attName, @"class" : attClass}];
        }
    }
    free(properties);
    
    return [NSArray arrayWithArray:attributes];
}

#pragma mark - 转换为NSDictionary

-(NSDictionary *)descDictionary
{
    NSMutableDictionary *desc = [[NSMutableDictionary alloc] init];
    NSArray *propArray = [SCModel getAllPropertiesWithClass:self.class];
    for (NSString *p in propArray) {
        SEL aSel = NSSelectorFromString(p);
        if ([self respondsToSelector:aSel]) {
            id value = [self performSelector:aSel];
            if ([value isKindOfClass:[NSString class]] ||
                [value isKindOfClass:[NSNumber class]]) {
                [desc setObject:value forKey:p];
            }
            else if ([value isKindOfClass:[SCModel class]]) {
                NSDictionary *newValue = [(SCModel *)value descDictionary];
                [desc setObject:newValue forKey:p];
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *newArray = [[NSMutableArray alloc] init];
                for (NSObject *obj in value) {
                    if ([obj isKindOfClass:[SCModel class]]) {
                        NSDictionary *newObj = [(SCModel *)obj descDictionary];
                        [newArray addObject:newObj];
                    }
                    else if ([obj isKindOfClass:[NSString class]] ||
                             [obj isKindOfClass:[NSNumber class]] ||
                             [obj isKindOfClass:[NSDictionary class]] ||
                             [obj isKindOfClass:[NSArray class]]) {
                        [newArray addObject:obj];
                    }
                    [desc setObject:newArray forKey:p];
                }
            }
        }
    }
    return desc;
}

#pragma mark - 

-(void)setValue:(id)value forKey:(NSString *)key
{
    Class cla = [self getPropertyClass:key];
    
    if (!cla || !value) {
        return;
    }
    
    if ([value isKindOfClass:[NSDictionary class]] && class_respondsToSelector(cla, @selector(isKindOfSCModelClass))) {
        SEL aSel = NSSelectorFromString(key);
        if ([self respondsToSelector:aSel]) {
            SCModel *model = [[cla alloc] initWithData:value];
            [super setValue:model forKey:key];
        }
    }
    else if (![value isKindOfClass:[NSNull class]]) {
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    return;
}

@end

@implementation NSArray (SCModel)

+(NSArray *)analyzingWithArrayData:(NSArray *)data withMenberClass:(Class)cla
{
    if (!data.firstObject ||
        ![data.firstObject isKindOfClass:[NSDictionary class]] ||
        !cla ||
        !class_respondsToSelector(cla, @selector(isKindOfSCModelClass))) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in data) {
        SCModel *object = [[cla alloc] initWithData:dic];
        [array addObject:object];
    }
    return array;
}

@end