//
//  MHModel.m
//  cineday
//
//

#import "MHModel.h"


@interface MHModel()
@property (nonatomic, strong) id json;
@end

@implementation MHModel
- (id)initFromJson:(id)json {
    self = [self init];
    if (self) {
        _json = json;
    }
    return self;
}
@end
