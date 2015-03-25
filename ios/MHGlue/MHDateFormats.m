//
//  MHDateFormats.m
//
//  Created by Matthias Hennemeyer on 06.03.12.
//

#import "MHDateFormats.h"
#import "MHSettings.h"

#define DATE_FORMAT_YMD @"yyyy-MM-dd"
#define TIME_FORMAT_HM @"HH:mm"
#define DATE_SEPERATOR @", "
#define FULL_FORMAT_YMDHM_Z @"yyyy-MM-dd'T'HH:mm:ss.'000Z'"

#define FULL_DISPLAY_FORMAT @"EE dd.MM.yyyy HH:mm"
#define DISPLAY_FORMAT @"EE dd.MM.yyyy"

@implementation MHDateFormats

+ (NSLocale *)locale {
    return [[MHSettings shared] locale];
}

+ (NSDateFormatter *)dateFormatter:(NSString *)formatTemplate {
    NSLocale *locale = [self locale];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:formatTemplate 
                                                             options:0 
                                                              locale:locale];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:locale];
	[dateFormatter setDateFormat:formatString];
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterPlain:(NSString *)formatTemplate {
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:formatTemplate
                                                             options:0
                                                              locale:nil];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterEdyyy {
    return [self dateFormatter:DISPLAY_FORMAT];
    //return [self dateFormatter:@"EEEdMMMyyyy"];
}

+ (NSDateFormatter *)dateFormatterMMyyyy {
    return [self dateFormatter:@"MMyyyy"];
}

+ (NSDateFormatter *)dateFormatterddMMyyyy {
    return [self dateFormatter:@"ddMMyyyy"];
}

+ (NSDateFormatter *)dateFormatteryyyy {
    return [self dateFormatter:@"yyyy"];
}

+ (NSDateFormatter *)dateFormatterHM {
    return [self dateFormatter:@"HH:mm"];
}

+ (NSDateFormatter *)dateFormatterFull {
    return [self dateFormatter:FULL_DISPLAY_FORMAT];
    //return [self dateFormatter:@"EEEdMMMyyyyHHmm"];
}

+ (NSString *)dateStringFilledWithZerosForTimeFromDate:(NSDate *)aDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[MHSettings shared] languageIdentifier]]];
    [dateFormatter setDateFormat:DATE_FORMAT_YMD];
    NSString *dateString = [dateFormatter stringFromDate:aDate];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TIME_FORMAT_HM];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"uk"]];
    NSString *assembledDateString = [NSString stringWithFormat:@"%@T00:00:00.000", dateString];
    NSLog(@"Zero Assembled Date: %@", assembledDateString);
    
    return assembledDateString;
}

+ (NSDate *)dateFromISOTimeString:(id)xmlTime {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
	
	NSDate *retVal = [dateFormatter dateFromString:xmlTime];
	return retVal;
}

@end
