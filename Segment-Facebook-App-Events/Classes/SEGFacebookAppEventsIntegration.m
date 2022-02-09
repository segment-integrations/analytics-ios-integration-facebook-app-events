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
        [FBSDKSettings.sharedSettings setAppID:appId];

        if ([(NSNumber *)self.settings[@"limitedDataUse"] boolValue]) {
            NSArray<NSString *> *options = self.dataProcessingOptions ? self.dataProcessingOptions : @[@"LDU"];
            int country = self.dataProcessingCountry ? self.dataProcessingCountry : 0;
            int state = self.dataProcessingState ? self.dataProcessingState : 0;

            [FBSDKSettings.sharedSettings setDataProcessingOptions:options country:country state:state];
            SEGLog(@"[FBSDKSettings setDataProcessingOptions:[%@] country:%d state:%d", [options componentsJoinedByString:@","], country, state);
        } else {
            [FBSDKSettings.sharedSettings setDataProcessingOptions:@[]];
            SEGLog(@"[FBSDKSettings setDataProcessingOptions:[]");
        }
    }
    return self;
}

+ (NSDictionary *)extractParameters: (NSDictionary *)properties
{
    // Facebook only accepts properties/parameters that have an NSString key, and an NSString or NSNumber as a value.
    // ... so we need to strip out everything else.  Not doing so results in a refusal to send and an
    // error in the console from the FBSDK.
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [properties enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *propKey = nil;
        NSString *propValue = nil;
        
        // this shouldn't ever fail, but just in case ...
        if ([key isKindOfClass:[NSString class]]) {
            propKey = key;
        }
        
        // only accept it if it's one of these types ...
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            propValue = obj;
        }
        
        // if we have both, put them in our output ...
        if (propKey && propValue) {
            [result setObject:propValue forKey:propKey];
        }
    }];
    
    return result;
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
            // Custom event
            NSMutableDictionary *properties = [payload.properties mutableCopy];
            [properties setObject:currency forKey:FBSDKAppEventParameterNameCurrency];
            [FBSDKAppEvents.shared logEvent:truncatedEvent
                                 valueToSum:[revenue doubleValue]
                                 parameters:[SEGFacebookAppEventsIntegration extractParameters:properties]];
            
            // Purchase event
            [FBSDKAppEvents.shared logPurchase:[revenue doubleValue] currency:currency parameters:[SEGFacebookAppEventsIntegration extractParameters:properties]];
        }
        else {
            [FBSDKAppEvents.shared logEvent:truncatedEvent
                                 parameters:[SEGFacebookAppEventsIntegration extractParameters:payload.properties]];
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
        [FBSDKAppEvents.shared logEvent:event];
    }];
    
}

#pragma mark - Callbacks for app state changes

- (void)applicationDidBecomeActive
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [FBSDKApplicationDelegate.sharedInstance initializeSDK];
        }];
    });
}

@end
