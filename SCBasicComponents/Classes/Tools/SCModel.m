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

#pragma mark - Interface

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
    
    NSMutableDictionary *replaceForm = [[NSMutableDictionary alloc] initWithDictionary:[self specialPropertyReplaceForm]];
    NSArray *allProperties = [SCModel getAllPropertiesWithClass:self.class];
    for (NSString *key in allProperties) {
        @autoreleasepool {
            NSString *realKey = nil;
            if (replaceForm.count > 0) {
                //自定义属性与数据key的一一对应转换
                for (NSString *replaceProperty in replaceForm.allKeys) {
                    if ([replaceProperty isEqualToString:key]) {
                        realKey = [NSString stringWithString:[replaceForm objectForKey:replaceProperty]];
                        [replaceForm removeObjectForKey:replaceProperty];
                        break;
                    }
                }
            }
            
            //有自定义的对应关系
            if (realKey) {
                [self setValue:data[realKey] forKey:key];
            }
            //默认属性名称后缀为‘_’的处理
            else if ([[key substringFromIndex:key.length-1] isEqualToString:@"_"]) {
                //“id_”类的属性
                realKey = [key substringToIndex:key.length-1];
                [self setValue:data[realKey] forKey:key];
            }
            else {
                //默认属性名称与数据key相同，直接赋值
                [self setValue:data[key] forKey:key];
            }
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

-(NSDictionary *)specialPropertyReplaceForm
{
    return [NSDictionary dictionary];
}

#pragma mark 转换为NSDictionary

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ : %@",[super description], [self conversionToDictionaryWithSpecailPropertyReplaced:NO]];
}

-(NSDictionary *)descDictionary
{
    return [self conversionToDictionaryWithSpecailPropertyReplaced:YES];
}

-(NSDictionary *)conversionToDictionaryWithSpecailPropertyReplaced:(BOOL)needReplace
{
    @synchronized (self) {
        NSMutableDictionary *desc = [[NSMutableDictionary alloc] init];
        NSArray *propArray = [SCModel getAllPropertiesWithClass:self.class];
        NSMutableDictionary *replaceForm = [[NSMutableDictionary alloc] init];
        if (needReplace) {
            [replaceForm addEntriesFromDictionary:[self specialPropertyReplaceForm]];
        }
        for (NSString *realP in propArray) {
            SEL aSel = NSSelectorFromString(realP);
            if ([self respondsToSelector:aSel] && [[self getPropertyClass:realP] isKindOfClass:[NSObject class]]) {
                //p为转换后key值
                NSString *p = realP;
                //获取value
                id value = [self performSelector:aSel];
                
                //是否转换成数据原有的key值到字典中
                if (needReplace) {
                    //查询原数据的key值若有替换，使用元数据的key值
                    BOOL hasReplace = NO;
                    for (NSString *replaceProperty in replaceForm.allKeys) {
                        if ([replaceProperty isEqualToString:realP]) {
                            p = [replaceForm objectForKey:replaceProperty];
                            hasReplace = YES;
                            [replaceForm removeObjectForKey:replaceProperty];
                            break;
                        }
                    }
                    //判断后缀是‘_’的情况
                    if (!hasReplace && [[p substringFromIndex:p.length-1] isEqualToString:@"_"]) {
                        p = [p substringToIndex:p.length-1];
                    }
                }
                
                //NSString和NSNumber类型
                if ([value isKindOfClass:[NSString class]] ||
                    [value isKindOfClass:[NSNumber class]]) {
                    [desc setObject:value forKey:p];
                }
                //SCModel类型
                else if ([value isKindOfClass:[SCModel class]]) {
                    NSDictionary *newValue = [(SCModel *)value descDictionary];
                    [desc setObject:newValue forKey:p];
                }
                //数组类型
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
                    }
                    [desc setObject:newArray forKey:p];
                }
            }
        }
        return desc;
    }
}

#pragma mark - 获取属性

///获取本类的所有属性，不包含父类的属性
- (NSArray *)getAllProperties
{
    @synchronized (self) {
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
}

///获取cla类的所有属性，包含派生自SCModel的所有成员的所有属性
+(NSArray *)getAllPropertiesWithClass:(Class)cla
{
    @synchronized (self) {
        u_int count;
        objc_property_t *properties  =class_copyPropertyList(cla, &count);
        NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++)
        {
            const char *propertyName = property_getName(properties[i]);
            NSString *pStr = [NSString stringWithUTF8String: propertyName];
            if (pStr) {
                [propertiesArray addObject: pStr];
            }
        }
        free(properties);
        
        Class superClass = class_getSuperclass(cla);
        if (class_respondsToSelector(superClass, @selector(isKindOfSCModelClass))) {
            [propertiesArray addObjectsFromArray:[SCModel getAllPropertiesWithClass:superClass]];
        }
        
        return propertiesArray;
    }
}

-(Class)getPropertyClass:(NSString *)propertyName
{
    @synchronized (self) {
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
}

+(NSArray *)getAllAttributesWithObject:(NSObject *)object
{
    @synchronized (self) {
        u_int count;
        objc_property_t *properties  =class_copyPropertyList([object class], &count);
        NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++)
        {
            @autoreleasepool {
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
        }
        free(properties);
        
        return [NSArray arrayWithArray:attributes];
    }
}

#pragma mark Copy

-(id)copyDataModel
{
    NSDictionary *dic = self.descDictionary;
    typeof(self) newModel = [[[self class] alloc] init];
    [newModel configData:dic];
    return newModel;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:
            [NSKeyedArchiver archivedDataWithRootObject:self]
            ];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.descDictionary forKey:[self codingKey]];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSDictionary* json;
    if ([aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)]) {
        json = [aDecoder decodeObjectOfClass:[NSString class] forKey:[self codingKey]];
    } else {
        json = [aDecoder decodeObjectForKey:[self codingKey]];
    }
    self = [[[self class] alloc] initWithData:json];
    return self;
}

-(NSString *)codingKey
{
    NSString *key = [NSString stringWithFormat:@"%@", [self class]];
    return key;
}


#pragma mark - 重写setValue方法

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

#pragma mark - NSArray类别

@implementation NSArray (SCModel)

+(NSArray *)analyzingWithArrayData:(NSArray *)data withMenberClass:(Class)cla
{
    if (data && (data.count == 0 || [data.firstObject isKindOfClass:cla])) {
        return data;
    }
    
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
