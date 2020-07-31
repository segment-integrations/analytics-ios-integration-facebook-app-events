# Analytics

[![CircleCI](https://circleci.com/gh/segment-integrations/analytics-ios-integration-facebook-app-events.svg?style=svg)](https://circleci.com/gh/segment-integrations/analytics-ios-integration-facebook-app-events)
[![Version](https://img.shields.io/cocoapods/v/Segment-Facebook-App-Events.svg?style=flat)](http://cocoapods.org/pods/Segment-Facebook-App-Events)
[![License](https://img.shields.io/cocoapods/l/Segment-Facebook-App-Events.svg?style=flat)](http://cocoapods.org/pods/Segment-Facebook-App-Events)

Facebook App Events integration for analytics-ios.

## Installation

To install the Segment-Facebook App Events integration, simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod "Segment-Facebook-App-Events"
```

## Usage

After adding the dependency, you must register the integration with our SDK.  To do this, import the Facebook App Events integration in your `AppDelegate`:

```
#import <Segment-Facebook-App-Events/SEGFacebookAppEventsIntegrationFactory.h>
```

And add the following lines:

```
NSString *const SEGMENT_WRITE_KEY = @" ... ";
SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:SEGMENT_WRITE_KEY];

[config use:[SEGFacebookAppEventsIntegrationFactory instance]];

[SEGAnalytics setupWithConfiguration:config];

```

### Data Processing Options
  To override the Data Processing Options when the Limited Data Use destination setting is enabled, call the `setDataProcessingOptions`
  method when initializing the FB App Events integration SDK. For example:
  ```
    SEGFacebookAppEventsIntegrationFactory *fb = [SEGFacebookAppEventsIntegrationFactory instance];

    // Optional - Set the Data Processing Options to override the default options of [['LDU'], 0, 0]
    [fb setDataProcessingOptions:@[ @"LDU" ] forCountry:1 forState: 1000];

    // Add the bundle FB integration SDK
    [config use:fb];
  ```
For more information on Facebook's Data Processing Options, reference their documentation: https://developers.facebook.com/docs/marketing-apis/data-processing-options#mobile-sdks

## License

```
WWWWWW||WWWWWW
 W W W||W W W
      ||
    ( OO )__________
     /  |           \
    /o o|    MIT     \
    \___/||_||__||_|| *
         || ||  || ||
        _||_|| _||_||
       (__|__|(__|__|

The MIT License (MIT)

Copyright (c) 2019 Segment, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
