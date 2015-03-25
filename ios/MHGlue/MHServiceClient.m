//
//  MHServiceClient.m
//  MHGlue
//  Copyright (c) 2013 Matthias Hennemeyer
//

#import "MHServiceClient.h"

@interface MHServiceClient()
@property (nonatomic, strong) NSMutableDictionary *registerServices;
@property (nonatomic, strong) NSMutableDictionary *onUpdateBlocks;
@end

@implementation MHServiceClient
SINGLETON(MHServiceClient)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _registerServices = [[NSMutableDictionary alloc] init];
        _onUpdateBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) registerResource:(NSString *)key block:(void (^)(NSString *resourceId, NSDictionary *params))block {
    self.registerServices[key] = [block copy];
}

- (void) registerResources:(NSString *)key block:(void (^)(NSDictionary *params))block {
    self.registerServices[key] = [block copy];
}

- (void) registerNestedResources:(NSString *)nested forResource:(NSString *)key block:(void (^)(NSString *resourceId, NSDictionary *params))block {
    self.registerServices[[self nested:nested key:key]] = [block copy];
}

- (void) onDidLoadData:(NSString *)key block:(void (^)(void))block {
    self.onUpdateBlocks[key] = [block copy];
}

- (NSString *)nested:(NSString *)nested key:(NSString *)key {
    return [NSString stringWithFormat:@"%@||%@", key, nested];
}


- (NSString *)key:(NSString *)key resourceId:(NSString *)resourceId {
    return [NSString stringWithFormat:@"%@-%@", key, resourceId];
}

- (void) onDidLoadResource:(NSString *)key resourceId:(NSString *)resourceId block:(void (^)(void))block {
    self.onUpdateBlocks[[self key:key resourceId:resourceId]] = [block copy];
}

- (void) onDidLoadNestedResource:(NSString *)nested forKey:(NSString *)key resourceId:(NSString *)resourceId block:(void (^)(void))block {
    self.onUpdateBlocks[[self nested:nested key:[self key:key resourceId:resourceId]]] = [block copy];
}

- (void) loadResourceByKey:(NSString *)key resourceId:(NSString *)resourceId params:(NSDictionary *)params {
    BG(((void (^)(NSString *, NSDictionary *params))self.registerServices[key])(resourceId, params);
       UI(
          void (^uiblock)(void) =  self.onUpdateBlocks[[self key:key resourceId:resourceId]];
          if (uiblock!=nil) uiblock(););
       );
}

- (void) loadNestedResourceByKey:(NSString *)nested forKey:(NSString *)key resourceId:(NSString *)resourceId params:(NSDictionary *)params {
    BG(((void (^)(NSString *, NSDictionary *params))self.registerServices[[self nested:nested key:key]])(resourceId, params);
       UI(
          void (^uiblock)(void) =  self.onUpdateBlocks[[self nested:nested key:[self key:key resourceId:resourceId]]];
          if (uiblock!=nil) uiblock(););
       );
}

- (void) loadByKey:(NSString *)key params:(NSDictionary *)params {
    BG(((void (^)(NSDictionary *params))self.registerServices[key])(params);
       UI(
          void (^uiblock)(void) =  self.onUpdateBlocks[key];
          if (uiblock!=nil) uiblock(););
       );
}

@end
