#import <Foundation/Foundation.h>
#if defined(__has_include) && __has_include(<Analytics/SEGAnalytics.h>)
#import <Analytics/SEGIntegration.h>
#else
#import <Segment/SEGIntegration.h>
#endif

@interface SEGFacebookAppEventsIntegration : NSObject<SEGIntegration>

@property(nonatomic, strong) NSDictionary *settings;
@property(nonatomic, strong) NSArray<NSString *> *dataProcessingOptions;
@property(nonatomic) int dataProcessingCountry;
@property(nonatomic) int dataProcessingState;

- (id)initWithSettings:(NSDictionary *)settings dataProcessingOptions:(NSArray<NSString *> *)options dataProcessingCountry:(int)country dataProcessingState:(int)state;

@end
