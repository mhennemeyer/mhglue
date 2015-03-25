//
//  MHCache
//

#import <Foundation/Foundation.h>

typedef enum MHCacheExpirationPolicy {
    kMHCacheExpirationAlways = 0,
    kMHCacheExpirationNever = INT_MAX,
    kMHCacheExpirationMinute = 60,
    kMHCacheExpirationHour = 3600,
    kMHCacheExpirationDay = 3600*24,
    kMHCacheExpirationWeek = 3600*24*7
    
} MHCacheExpirationPolicy;

@interface MHCache : NSObject
+ (MHCache *)shared;

@property (assign) BOOL enabled;

- (UIImage *)imageForKey:(NSString *)key;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

- (void)set:(NSData *)data forKey:(NSString *)key expirationPolicy:(MHCacheExpirationPolicy)expirationPolicy;

- (NSData *)get:(NSString *)key;
@end
