//
//  NSArray+Functional.h
//
//  Created by Matthias Hennemeyer on 15.03.12.
//

#import <Foundation/Foundation.h>

@interface NSArray (MHFunctional)
- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)mapWithIndex:(id (^)(id obj, NSUInteger index))block;
- (NSString *)mapToString:(id (^)(id obj))block;
- (void)eachWithIndex:(void (^)(id obj, NSUInteger index))block;
- (void)each:(void (^)(id obj))block;
- (id)inject:(id)inj to:(id (^)(id cum, id obj))block;
- (NSDictionary *) mapToDictWithKey:(NSString *)aKey andValue:(NSString *)aValue;
- (id)firstWith:(BOOL (^)(id obj))block;
- (NSArray *)first:(NSUInteger)count;
- (NSArray *)filter:(BOOL (^)(id obj))block;
- (NSArray *)select:(BOOL (^)(id obj))block;
- (NSArray *)add:(id)obj;
- (NSArray *)addAll:(NSArray *)arr;
- (NSArray *)reversed;
- (NSArray *)unique;

- (NSString *)toString:(NSString *)seperator;
@end
