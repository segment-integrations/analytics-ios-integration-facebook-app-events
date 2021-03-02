#import "SEGFacebookAppEventsIntegration.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#if defined(__has_include) && __has_include(<Analytics/SEGAnalytics.h>)
#import <Analytics/SEGAnalyticsUtils.h>
#else
#import <Segment/SEGAnalyticsUtils.h>
#endif

@implementation SEGFacebookAppEventsIntegration

#pragma mark - Initialization

- (id)initWithSettings:(NSDictionary *)settings dataProcessingOptions:(NSArray<NSString *> *)options dataProcessingCountry:(int)country dataProcessingState:(int)state
{
    if (self = [super init]) {
        self.settings = settings;
        self.dataProcessingOptions = options;
        self.dataProcessingCountry = country;
        self.dataProcessingState = state;
        
        NSString *appId = [settings objectForKey:@"appId"];
        [FBSDKSettings setAppID:appId];

        if ([(NSNumber *)self.settings[@"limitedDataUse"] boolValue]) {
            NSArray<NSString *> *options = self.dataProcessingOptions ? self.dataProcessingOptions : @[@"LDU"];
            int country = self.dataProcessingCountry ? self.dataProcessingCountry : 0;
            int state = self.dataProcessingState ? self.dataProcessingState : 0;

            [FBSDKSettings setDataProcessingOptions:options country:country state:state]; 
            SEGLog(@"[FBSDKSettings setDataProcessingOptions:[%@] country:%d state:%d", [options componentsJoinedByString:@","], country, state);
        } else {
            [FBSDKSettings setDataProcessingOptions:@[]];
            SEGLog(@"[FBSDKSettings setDataProcessingOptions:[]");
        }
    }
    return self;
}

+ (NSNumber *)extractRevenue:(NSDictionary *)dictionary withKey:(NSString *)revenueKey
{
    id revenueProperty = nil;
    
    for (NSString *key in dictionary.allKeys) {
        if ([key caseInsensitiveCompare:revenueKey] == NSOrderedSame) {
            revenueProperty = dictionary[key];
            break;
        }
    }
    
    if (revenueProperty) {
        if ([revenueProperty isKindOfClass:[NSString class]]) {
            // Format the revenue.
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            return [formatter numberFromString:revenueProperty];
        } else if ([revenueProperty isKindOfClass:[NSNumber class]]) {
            return revenueProperty;
        }
    }
    return nil;
}

+ (NSString *)extractCurrency:(NSDictionary *)dictionary withKey:(NSString *)currencyKey
{
    id currencyProperty = nil;
    
    for (NSString *key in dictionary.allKeys) {
        if ([key caseInsensitiveCompare:currencyKey] == NSOrderedSame) {
            currencyProperty = dictionary[key];
            return currencyProperty;
        }
    }

    // default to USD
    return @"USD";
}

- (void)track:(SEGTrackPayload *)payload
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        // FB Event Names must be <= 40 characters
        NSString *truncatedEvent = [payload.event substringToIndex: MIN(40, [payload.event length])];
        
        // Revenue & currency tracking
        NSNumber *revenue = [SEGFacebookAppEventsIntegration extractRevenue:payload.properties withKey:@"revenue"];
        NSString *currency = [SEGFacebookAppEventsIntegration extractCurrency:payload.properties withKey:@"currency"];
        if (revenue) {
            [FBSDKAppEvents logPurchase:[revenue doubleValue] currency:currency];
        
            // Custom event
            NSMutableDictionary *properties = [payload.properties mutableCopy];
            [properties setObject:currency forKey:FBSDKAppEventParameterNameCurrency];
            [FBSDKAppEvents logEvent:truncatedEvent
                            valueToSum:[revenue doubleValue]
                            parameters:properties];
        }
        else {
            [FBSDKAppEvents logEvent:truncatedEvent
                            parameters:payload.properties];
        }
    }];
}

- (void)screen:(SEGScreenPayload *)payload
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        // FB Event Names must be <= 40 characters
        // 'Viewed' and 'Screen' with spaces take up 14
        NSString *truncatedEvent = [payload.name substringToIndex: MIN(26, [payload.name length])];
        NSString *event = [[NSString alloc] initWithFormat:@"Viewed %@ Screen", truncatedEvent];
        [FBSDKAppEvents logEvent:event];
    }];
    
}

#pragma mark - Callbacks for app state changes

- (void)applicationDidBecomeActive
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [FBSDKAppEvents activateApp];
    }];
}

@end
