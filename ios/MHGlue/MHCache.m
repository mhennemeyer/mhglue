//
//  MHCache
//

#import "MHCache.h"

@interface MHCache()
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSMutableDictionary *requests;
@end

@implementation MHCache
SINGLETON(MHCache)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _images = [[NSMutableDictionary alloc] init];
        _requests = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (UIImage *)imageForKey:(NSString *)key {
    UIImage *image = [self.images valueForKey:key];
    if (image==nil) {
        image = [self readImageForKey:key];
    }
    return image;
}

- (UIImage *)readImageForKey:(NSString *)key {
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self pathStringForKey:key]]];
    if ([imgData length]<100) return nil;
    UIImage *img = [[UIImage alloc] initWithData:imgData];
    NSLog(@"Found Image!");
    return img;
}

- (NSString *)fileNameForKey:(NSString *)key {
    return [key lastPathComponent];
}

- (NSString *)pathStringForKey:(NSString *)key {
    
    return [[self documentsDirectory] stringByAppendingPathComponent:[self fileNameForKey:key]];
}

- (void) writeImage:(UIImage *)image forKey:(NSString *)key {
    NSData *imageData = UIImageJPEGRepresentation(image, 1  );
    if (imageData==nil) return;
    NSLog(@"write file: %@", [self pathStringForKey:key]);
    [imageData writeToFile:[self pathStringForKey:key] atomically:YES];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [self writeImage:image forKey:key];
    [self.images setObject:image forKey:key];
}

- (void)set:(NSData *)data forKey:(NSString *)key expirationPolicy:(MHCacheExpirationPolicy)expirationPolicy {
    // todo
    if (data==nil) return;
    NSDate *expire = [NSDate dateWithTimeIntervalSinceNow:expirationPolicy];
    NSLog(@"url: %@\nexpire: %@", key, expire);
    [self.requests setValue:@{@"expire":expire, @"data":data} forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:@{@"expire":expire, @"data":data} forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSData *)get:(NSString *)key {
    NSData *retVal = nil;
    if (self.enabled) {
        id cachedObject = self.requests[key];
        if (cachedObject==nil) {
            cachedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (cachedObject!=nil) {
                self.requests[key] = cachedObject;
            }
        }
        
        NSDate *timeStamp = [cachedObject valueForKey:@"expire"];
        //NSLog(@"timeStamp: %@\ncompare: %i", timeStamp, [timeStamp compare:[NSDate date]]==NSOrderedDescending);
        retVal = [timeStamp compare:[NSDate date]]==NSOrderedDescending ? [cachedObject valueForKey:@"data"] : nil;
    }
    return retVal;
}

#pragma mark - Helpers

- (NSString *)documentsDirectory {
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
