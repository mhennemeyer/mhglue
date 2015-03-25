//
//  MHSettings.m
//

#import "MHSettings.h"

NSString *LANGUAGE_KEY = @"languageKey";

@implementation MHSettings
SINGLETON(MHSettings)

- (NSString *)defaultLanguageIdentifier {
    return @"de";
}

- (NSString *) languageIdentifier {
    NSString *key = [[NSUserDefaults standardUserDefaults] valueForKey:LANGUAGE_KEY];
    if (nil==key) key = [self defaultLanguageIdentifier];
    return key;
}

- (NSLocale *) locale {
    return [[NSLocale alloc] initWithLocaleIdentifier:[self languageIdentifier]];
}
@end
