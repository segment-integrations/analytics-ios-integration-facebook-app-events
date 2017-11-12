#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>

@interface SEGFacebookAppEventsIntegration : NSObject<SEGIntegration>

@property(nonatomic, strong) NSDictionary *settings;
@property(nonatomic, strong) NSCharacterSet *charactersToReplace;

- (id)initWithSettings:(NSDictionary *)settings;

@end