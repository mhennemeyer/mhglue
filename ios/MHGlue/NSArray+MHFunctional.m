//
//  NSArray+Functional.m
//
//  Created by Matthias Hennemeyer on 15.03.12.
//


#import "NSArray+MHFunctional.h"

@implementation NSArray (MHFunctional)

- (NSArray *)map:(id (^)(id obj))block
{
	NSMutableArray *output = [NSMutableArray array];
	for (id obj in self)
		[output addObject:block(obj)];
	return [NSArray arrayWithArray:output];
}

- (NSArray *)add:(id)obj
{
    if (obj==nil) return self;
	NSMutableArray *output = [NSMutableArray array];
    [output addObjectsFromArray:self];
    [output addObject:obj];
	return [NSArray arrayWithArray:output];
}

- (NSArray *)addAll:(NSArray *)arr
{
    if (arr==nil) return self;
    NSMutableArray *output = [NSMutableArray array];
    [output addObjectsFromArray:self];
    [output addObjectsFromArray:arr];
    return [NSArray arrayWithArray:output];
}

- (NSArray *)filter:(BOOL (^)(id obj))block
{
	NSMutableArray *output = [NSMutableArray array];
	for (id obj in self)
		if (!block(obj)) [output addObject:obj];
	return [NSArray arrayWithArray:output];
}

- (NSArray *)select:(BOOL (^)(id obj))block
{
    NSMutableArray *output = [NSMutableArray array];
    for (id obj in self)
        if (block(obj)) [output addObject:obj];
    return [NSArray arrayWithArray:output];
}

- (NSArray *) unique {
    NSMutableArray *output = [NSMutableArray array];
    
    output = [self valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]];
    
    return [NSArray arrayWithArray:output];
}

- (NSArray *)reversed
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
	return [NSArray arrayWithArray:array];
}

- (NSArray *)mapWithIndex:(id (^)(id obj, NSUInteger index))block
{
	NSMutableArray *output = [NSMutableArray array];
	for (NSUInteger i = 0; i<[self count]; i++) {
        id obj = [self objectAtIndex:i];
		[output addObject:block(obj, i)];
    }
	return [NSArray arrayWithArray:output];
}

- (NSString *)mapToString:(id (^)(id obj))block
{
	NSMutableString *output = [NSMutableString string];
	for (id obj in self)
		[output appendString:block(obj)];
	return [NSString stringWithString:output];
}

- (NSDictionary *) mapToDictWithKey:(NSString *)aKey andValue:(NSString *)aValue {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    
    [self each:^(id obj) {
        [dict setValue:[obj valueForKey:aValue] forKey:[obj valueForKey:aKey]];
    }];
    
    return dict;
    
}

- (void)eachWithIndex:(void (^)(id obj, NSUInteger index))block
{
	for (NSUInteger i = 0; i<[self count]; i++) block([self objectAtIndex:i], i);
}

- (void)each:(void (^)(id obj))block
{
	for (id obj in self) block(obj);
}

- (id)inject:(id)inj to:(id (^)(id cum, id obj))block
{
    id retVal = inj;
	for (id obj in self) {
		retVal = block(retVal, obj);
    }
	return retVal;
}

- (id)firstWith:(BOOL (^)(id obj))block {
    for (id obj in self) {
        if (block(obj)) return obj;
    }
    return nil;
}

- (NSArray *)first:(NSUInteger)count {
    if ([self count]==0) return @[];
    if (count>[self count]) {
        count = [self count] - 1;
    }
    NSRange range = NSRangeFromString([NSString stringWithFormat:@"0, %lu", (unsigned long)count]);
    return [self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}

- (NSString *)toString:(NSString *)seperator {
    return [self inject:@"" to:^id(id cum, id obj) {
        return [cum isEqualToString:@""] ? [NSString stringWithFormat:@"%@", obj] : [NSString stringWithFormat:@"%@%@%@", cum, seperator, obj];
    }];
}
@end
