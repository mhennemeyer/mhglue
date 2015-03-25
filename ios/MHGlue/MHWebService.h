//
//  MHWebService.h
//

#import <Foundation/Foundation.h>
#import "MHCache.h"

@interface MHWebService : NSObject
@property (assign) MHCacheExpirationPolicy expirationForResource;
@property (assign) MHCacheExpirationPolicy expirationForResources;
@property (nonatomic, strong) NSString *resourcesUrl;
@property (nonatomic, strong) NSMutableDictionary *headers;
-(NSData *) getResourcesData:(NSDictionary *)params;
-(NSData *) getResource:(NSString *)resourceId;
- (NSData *) getNestedResources:(NSString *)nested resourceId:(NSString *)resourceId;

/*
 Will be added to all requests
 */
- (void)addHeader:(NSString *)header forKey:(NSString *)key;

#pragma mark - Image Loading

+ (UIImage *)imageForImageView:(UIImageView *)imageView andUrl:(NSString*)url andPlaceholder:(NSString* )placeholder;
+ (UIImage *)imageForImageView:(UIImageView *)imageView andUrl:(NSString*)url andPlaceholder:(NSString* )placeholder andSize:(CGSize)size;
@end
