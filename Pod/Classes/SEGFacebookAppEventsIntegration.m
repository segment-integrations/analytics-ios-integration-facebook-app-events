#import "SEGFacebookAppEventsIntegration.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Analytics/SEGAnalyticsUtils.h>

@implementation SEGFacebookAppEventsIntegration

#pragma mark - Initialization

- (id)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        
        NSString *appId = [settings objectForKey:@"appId"];
        [FBSDKSettings setAppID:appId];

        if ([(NSNumber *)self.settings[@"limitedDataUse"] boolValue]) {
            [FBSDKSettings setDataProcessingOptions:@[@"LDU"] country:0 state:0]; 
        } else {
            [FBSDKSettings setDataProcessingOptions:@[]];
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
