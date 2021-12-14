#import "SEGFacebookAppEventsIntegrationFactory.h"
#import "SEGFacebookAppEventsIntegration.h"

@implementation SEGFacebookAppEventsIntegrationFactory

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGFacebookAppEventsIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    return self;
}

- (id)setDataProcessingOptions:(NSArray<NSString *> *)options forCountry:(int)country forState:(int)state
{
    self.dataProcessingOptions = options;
    self.dataProcessingCountry = country;
    self.dataProcessingState = state;
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGFacebookAppEventsIntegration alloc] initWithSettings:settings
                                                    dataProcessingOptions:self.dataProcessingOptions
                                                    dataProcessingCountry:self.dataProcessingCountry
                                                    dataProcessingState:self.dataProcessingState];
}

- (NSString *)key
{
    return @"Facebook App Events";
}

@end
