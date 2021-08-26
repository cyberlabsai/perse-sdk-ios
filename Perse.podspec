Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.name         = "Perse"
  spec.version      = "0.2.0"
  spec.summary      = "Perse SDK iOS"
  spec.description  = <<-DESC
    "This SDK provides camera integration and abstracts the communication with the Perse's API endpoints and also convert the response from json to a pre-defined responses."
                   DESC

  spec.homepage     = "https://github.com/cyberlabsai/perse-sdk-ios/"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author             = { 'CyberLabs.AI'   => 'contato@cyberlabs.ai' }

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "https://github.com/cyberlabsai/perse-sdk-ios.git", :tag => "#{spec.version}" }
  
  spec.ios.deployment_target = '14.1'
  
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.source_files  = "Perse/src/**/*", "Classes", "Classes/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"
  spec.dependency 'Alamofire', '~> 5.2'
  spec.dependency 'PerseLite', '~> 0.3.0'
  spec.dependency 'YoonitCamera'
  
  spec.static_framework = true
  
  spec.pod_target_xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '${SRCROOT}/**',
    'FRAMEWORK_SEARCH_PATHS' => '${SRCROOT}/**',
    'HEADER_SEARCH_PATHS' => '${SRCROOT}/**'
  }
end
