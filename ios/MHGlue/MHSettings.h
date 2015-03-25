//
//  MHSettings.h
//

#import <Foundation/Foundation.h>

@interface MHSettings : NSObject
+ (MHSettings *)shared;
- (NSLocale *)locale;
- (NSString *)languageIdentifier;
@end
