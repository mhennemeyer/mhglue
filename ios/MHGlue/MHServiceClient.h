//
//  MHServiceClient.h
//  MHGlue
//  Copyright (c) 2013 Matthias Hennemeyer
//

#import <Foundation/Foundation.h>

@interface MHServiceClient : NSObject
+ (MHServiceClient *)shared;

- (void) registerResources:(NSString *)key block:(void (^)(NSDictionary *params))block;
- (void) registerResource:(NSString *)key block:(void (^)(NSString *resourceId, NSDictionary *params))block;

- (void) registerNestedResources:(NSString *)nested forResource:(NSString *)key block:(void (^)(NSString *resourceId, NSDictionary *params))block;

- (void) onDidLoadData:(NSString *)key block:(void (^)(void))block;
- (void) onDidLoadResource:(NSString *)key resourceId:(NSString *)resourceId block:(void (^)(void))block;
- (void) onDidLoadNestedResource:(NSString *)nested forKey:(NSString *)key resourceId:(NSString *)resourceId block:(void (^)(void))block;

- (void) loadByKey:(NSString *)key params:(NSDictionary *)params;
- (void) loadResourceByKey:(NSString *)key resourceId:(NSString *)resourceId params:(NSDictionary *)params;
- (void) loadNestedResourceByKey:(NSString *)nested forKey:(NSString *)key resourceId:(NSString *)resourceId params:(NSDictionary *)params;
@end
