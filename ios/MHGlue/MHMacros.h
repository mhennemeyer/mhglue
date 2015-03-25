//
//  MHMacros.h
//  MHGlue
//  Copyright (c) 2013 Matthias Hennemeyer
//

#ifndef cineday_MHMacros_h
#define cineday_MHMacros_h

#define STRINGIFY2( x) #x
#define STRINGIFY(x) STRINGIFY2(x)
#define PASTE2( a, b) a##b
#define PASTE( a, b) PASTE2( a, b)

#define PRINTTHIS(text) \
NSLog(PASTE( @, STRINGIFY(text)));

#define ctrlWithNib(name) [[name alloc] initWithNibName:@#name bundle:nil]
#define navWithRoot(ctrl) [[UINavigationController alloc] initWithRootViewController:ctrl]

#define SINGLETON(classname) \
+ (id)shared { \
static dispatch_once_t pred; \
__strong static id _shared = nil; \
dispatch_once(&pred, ^{ \
_shared = [[classname alloc] init]; \
}); \
return _shared; \
}

#define BG(content) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{ content })
#define BG_SYNC(content) dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{ content })
#define UI(content) dispatch_sync(dispatch_get_main_queue(),^{ content })


#define IPHONE4 [ [ UIScreen mainScreen ] bounds ].size.height<500
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


#endif
