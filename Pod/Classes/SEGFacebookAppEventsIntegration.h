#import <Foundation/Foundation.h>
#import <AstronomerAnalytics/SEGIntegration.h>

@interface SEGFacebookAppEventsIntegration : NSObject<SEGIntegration>

@property(nonatomic, strong) NSDictionary *settings;

- (id)initWithSettings:(NSDictionary *)settings;

@end