Pod::Spec.new do |s|
  s.name             = "Astronomer-Facebook-App-Events"
  s.version          = "1.0.3"
  s.summary          = "Facebook App Events Integration for Astronomer's analytics-ios library."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.

                       This is the Facebook App Events integration for the iOS library.
                       DESC

  s.homepage         = "http://astronomer.io/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "Segment" => "friends@segment.com" }
  s.source           = { :git => "https://github.com/astronomer-integrations/analytics-ios-integration-facebook-app-events.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/segment'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'AstronomerAnalytics', '~> 3.0'
  s.dependency 'FBSDKCoreKit', '~> 4.15'

  s.pod_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
end
