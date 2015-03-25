//
//  MHWebService.m
//  MHGlue
//  Copyright (c) 2013 Matthias Hennemeyer
//

#import "MHWebService.h"
#import "MHCache.h"
#import "UIImage+MHThumbnails.h"

@implementation MHWebService

- (void)addHeader:(NSString *)header forKey:(NSString *)key {
    if (self.headers==nil) {
        self.headers = [[NSMutableDictionary alloc] init];
    }
    [self.headers setValue:header forKey:key];
}

-(NSData *) getResourcesData:(NSDictionary *)params {
    NSString *url = [self urlWithParams:params];
    //NSLog(@"Get Url: %@", url);
    NSData *retVal = [[MHCache shared] get:url];
    if (retVal==nil) {
        retVal = [self get:url expiration:self.expirationForResources];
    }

    return retVal;
}

-(NSData *) getResource:(NSString *)resourceId {
    NSString *url = [self urlWithId:resourceId];
    //NSLog(@"Get Url: %@", url);
    NSData *retVal = [[MHCache shared] get:url];
    if (retVal==nil) {
        retVal = [self get:url expiration:self.expirationForResource];
    }
    
    
    return retVal;
}

- (NSData *) getNestedResources:(NSString *)nested resourceId:(NSString *)resourceId {
    NSString *url = [self nestedUrl:nested withId:resourceId];
    //NSLog(@"Get Url: %@", url);
    NSData *retVal = [[MHCache shared] get:url];
    if (retVal==nil) {
        
    }
    return retVal;
}


- (NSData *) get:(NSString *) url expiration:(MHCacheExpirationPolicy)expiration {
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    for (NSString *key in [self.headers allKeys]) {
        [urlRequest addValue:self.headers[key] forHTTPHeaderField:key];
    }
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    [[MHCache shared] set:data forKey:url expirationPolicy:expiration];
    
    return data;
}

- (NSString *)urlWithId:(NSString *)resourceId {
    return [NSString stringWithFormat:@"%@/%@", self.resourcesUrl, resourceId];
}

- (NSString *)nestedUrl:(NSString *)nested withId:(NSString *)resourceId {
    return [NSString stringWithFormat:@"%@/%@", [self urlWithId:resourceId], nested];
}

- (NSString *)urlWithParams:(NSDictionary *)params {
    NSString *url = [NSString stringWithFormat:@"%@?", self.resourcesUrl];
    for (NSString *name in [params allKeys]) {
        url = [NSString stringWithFormat:@"%@%@=%@&",url,name, params[name]];
    }
    return url;
}

+ (UIImage *)imageForImageView:(UIImageView *)imageView andUrl:(NSString*)url andPlaceholder:(NSString* )placeholder {
    UIImage *image = [[MHCache shared] imageForKey:url];
    
    if(!image)
    {
        // if we didn't find an image, create a placeholder image and
        // put it in the "cache". Start the download of the actual image
        NSString* placeHolderLabel =@"placeholder.png";
        if(placeholder)
            placeHolderLabel = placeholder;
        
        image = [UIImage imageNamed:placeHolderLabel];
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.frame = imageView.frame;
        NSLog(@"height: %f", imageView.frame.size.height);
        [activityIndicatorView startAnimating];
        [imageView addSubview:activityIndicatorView];
        
        //dispatch_async to get the image data
        BG(
           NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
           UIImage *anImage = [UIImage imageWithData:data];
           if( anImage != nil ) {
               [[MHCache shared] setImage:anImage forKey:url];
           }
           
           //dispatch_async on the main queue to update the UI
           UI(
              if( anImage != nil ) {
                  imageView.image = anImage;
              }
              [activityIndicatorView removeFromSuperview];
              );
           );
    }
    // return the image, it could be the placeholder, or an image from the cache
    return image;
}

+ (UIImage *)imageForImageView:(UIImageView *)imageView andUrl:(NSString*)url andPlaceholder:(NSString* )placeholder andSize:(CGSize)size
{
    NSLog(@"load image: %@", url);
    NSString *key = [NSString stringWithFormat:@"%@-%f-%f", url, size.height, size.width];
    UIImage *image = [[MHCache shared] imageForKey:key];
    
    if(image==nil) {
        NSString* placeHolderLabel =@"placeholder.png";
        
        if(placeholder)
            placeHolderLabel = placeholder;
        
        image = [[UIImage imageNamed:placeHolderLabel] thumbnailOfSize:size];
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.frame = imageView.frame;
        NSLog(@"height: %f", imageView.frame.size.height);
        [activityIndicatorView startAnimating];
        [imageView addSubview:activityIndicatorView];
        
        //dispatch_async to get the image data
        BG(
           NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
           __block UIImage *anImage = [UIImage imageWithData:data];
           
           
           //dispatch_async on the main queue to update the UI
           UI(
              if( anImage != nil ) {
                  anImage = [anImage thumbnailOfSize:size];
                  if( anImage != nil ) {
                      [[MHCache shared] setImage:anImage forKey:key];
                  }
                  NSLog(@"update imageview: %@", imageView);
                  imageView.image = anImage;
                  NSLog(@"Image: %@", imageView.image);
              }
              [activityIndicatorView removeFromSuperview];
              );
           );
    }
    // return the image, it could be the placeholder, or an image from the cache
    return image;
}

@end
