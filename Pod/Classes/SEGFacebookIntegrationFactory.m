#import "SEGFacebookIntegrationFactory.h"
#import "SEGFacebookIntegration.h"

@implementation SEGFacebookIntegrationFactory

+ (id)instance
{
    static dispatch_once_t once;
    static SEGFacebookIntegration *sharedInstance;
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

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGFacebookIntegration alloc] initWithSettings:settings];
}

- (NSString *)key
{
    return @"Facebook";
}

@end