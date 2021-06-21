Change Log
==========
Version 2.1.2 *(21st June, 2021)*
-------------------------------------------
* Updated FBSDKCoreKit to 11.0.0

Version 2.1.1 *(28nd April, 2021)*
-------------------------------------------
* Updated FBSDKCoreKit to 9.2.


Version 2.1.0 *(2nd March, 2021)*
-------------------------------------------
* Updated FBSDKCoreKit to 9.x.
* Changed country/state values to be `int` from `int *`.  Still compatible but removes warnings.
 
Version 2.0.01 *(7th October, 2020)*
-------------------------------------------
* Update SEGAnalytics import to support new namespacing introduced in v4.x

Version 2.0.0 *(31st July, 2020)*
-------------------------------------------

* Update FDSDKCoreKit to 7.1.1
* Update Cocoapods version
* Implement the new Limited Data Use Segment destination setting which is disabled by default. When enabled, the FB App Events integration
  will enable Limited Data Use mode in the FB iOS SDK and request that Facebook auto-geolocate the event in the
  data processing options. When disabled, FB App Events integration will not send any Data Processing Options. **To maintain the behavior of previous integration SDK versions (`<= 2.0.0`) you must enable the Limited Data Use destination setting before upgrading to version 2.0.0.**
  
  
  To override the Data Processing Options when the Limited Data Use setting is enabled, call the `setDataProcessingOptions`
  method when initializing the FB App Events integration SDK. For example:
  ```
    SEGFacebookAppEventsIntegrationFactory *fb = [SEGFacebookAppEventsIntegrationFactory instance];

    // Optional - Set the Data Processing Options to override the default options of [['LDU'], 0, 0]
    [fb setDataProcessingOptions:@[ @"LDU" ] forCountry:1 forState: 1000];

    // Add the bundle FB integration SDK
    [config use:fb];
  ```
For more information on Facebook's Data Processing Options, reference their documentation: https://developers.facebook.com/docs/marketing-apis/data-processing-options#mobile-sdks
 

Version 1.1.1 *(4th June, 2020)*
-------------------------------------------

* Relaxes Segment Analytics library dependency.

Version 1.1.0 *(18th November, 2019)*
-------------------------------------------

* Update FDSDKCoreKit to 5.10.0
* Update Analytics to 3.7
* Update Specta to 1.0.7
* Update Expecta 1.0.6
* Remove Bolts
* Update Cocoapods version

Version 1.0.3 *(16th September, 2016)*
-------------------------------------------

* Updates FDSDKCoreKit to 4.15 - < 5.0

Version 1.0.2 *(22nd August, 2016)*
-------------------------------------------
*(Supports analytics-ios 3.0+)

* Updates support for Analytics 3.0 - < 4.0

Version 1.0.1 *(12th April, 2016)*
-------------------------------------------
*(Supports analytics-ios 3.0.+ and FBSDK 4.10.1+)*

* Updates name used in integration from "Facebook" to "Facebook App Events" to match metadata.
* Truncates event names to 40 characters.

Version 1.0.0 *(26th March, 2016)*
-------------------------------------------
*(Supports analytics-ios 3.0.+ and FBSDK 4.10.1+)*

Initial release.
