#import <Foundation/Foundation.h>

#if defined(__has_include) && __has_include(<Analytics/SEGAnalytics.h>)
#import <Analytics/SEGIntegrationFactory.h>
#else
#import <Segment/SEGIntegrationFactory.h>
#endif

@interface SEGFacebookAppEventsIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (instancetype)instance;

@property(nonatomic, strong) NSArray<NSString *> *dataProcessingOptions;
@property(nonatomic) int dataProcessingCountry;
@property(nonatomic) int dataProcessingState;

- (id)setDataProcessingOptions:(NSArray<NSString *> *)options forCountry:(int)country forState:(int)state;

@end
