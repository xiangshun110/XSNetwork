#
# Be sure to run `pod lib lint XSNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XSNetwork'
  s.version          = '0.3.0'
  s.summary          = '对AFNetworking 4.0的封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xiangshun110/XSNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiangshun' => '113648883@qq.com' }
  s.source           = { :git => 'https://github.com/xiangshun110/XSNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.source_files = 'XSNetwork/Classes/**/*'
  #s.source_files = 'XSNetwork/Classes/**/*.{h,m,swift}'
  
  # s.resource_bundles = {
  #   'XSNetwork' => ['XSNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#  要排除的文件
#  s.exclude_files = 'MJRefresh/include/**'
  
    s.dependency 'AFNetworking', '~> 4.0.1'
    s.dependency 'MBProgressHUD', '~> 1.2.0'
end
