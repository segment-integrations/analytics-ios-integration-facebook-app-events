#import "SEGFacebookIntegration.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Analytics/SEGAnalyticsUtils.h>

@implementation SEGFacebookIntegration

#pragma mark - Initialization

- (id)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        
        NSString *appId = [settings objectForKey:@"appId"];
        [FBSDKSettings setAppID:appId];
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
    // Normal events
    [FBSDKAppEvents logEvent:payload.event];

    // Revenue & currency tracking
    NSNumber *revenue = [SEGFacebookIntegration extractRevenue:payload.properties withKey:@"revenue"];
    NSString *currency = [SEGFacebookIntegration extractCurrency:payload.properties withKey:@"currency"];
    if (revenue) {
        [FBSDKAppEvents logPurchase:[revenue doubleValue] currency:currency];
    }
}

- (void)screen:(SEGScreenPayload *)payload
{
    NSString *event = [[NSString alloc] initWithFormat:@"Viewed %@ Screen", payload.name];
    [FBSDKAppEvents logEvent:event];
}

#pragma mark - Callbacks for app state changes

- (void)applicationDidBecomeActive
{
    [FBSDKAppEvents activateApp];
}

@end