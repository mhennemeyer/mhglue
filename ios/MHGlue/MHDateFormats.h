//
//  MHDateFormats.h
//
//  Created by Matthias Hennemeyer on 06.03.12.
//

#import <Foundation/Foundation.h>

@interface MHDateFormats : NSObject
+ (NSDateFormatter *)dateFormatterEdyyy;
+ (NSDateFormatter *)dateFormatterHM;
+ (NSDateFormatter *)dateFormatterFull;
+ (NSDateFormatter *)dateFormatterMMyyyy;
+ (NSDateFormatter *)dateFormatteryyyy;
+ (NSDateFormatter *)dateFormatterddMMyyyy;
+ (NSString *)dateStringFilledWithZerosForTimeFromDate:(NSDate *)aDate;
+ (NSDateFormatter *)dateFormatter:(NSString *)formatTemplate;
+ (NSDateFormatter *)dateFormatterPlain:(NSString *)formatTemplate;

+ (NSDate *)dateFromISOTimeString:(id)xmlTime;


@end
