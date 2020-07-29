#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegrationFactory.h>

@interface SEGFacebookAppEventsIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (instancetype)instance;

@property(nonatomic, strong) NSArray<NSString *> *dataProcessingOptions;
@property(nonatomic) int *dataProcessingCountry;
@property(nonatomic) int *dataProcessingState;

- (id)setDataProcessingOptions:(NSArray<NSString *> *)options forCountry:(int *)country forState:(int *)state;

@end
