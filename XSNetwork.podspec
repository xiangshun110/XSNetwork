#
# Be sure to run `pod lib lint XSNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XSNetwork'
  s.version          = '1.0.6'
  s.summary          = '对网络请求的封装，基于Alamofire'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description = <<-DESC
  A lightweight network abstraction based on Alamofire.
  DESC

  s.homepage         = 'https://github.com/xiangshun110/XSNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiangshun' => '113648883@qq.com' }
  s.source           = { :git => 'https://github.com/xiangshun110/XSNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
#  s.swift_versions = ['5.0']
  
#  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

#  s.source_files = 'XSNetwork/Classes/**/*'

  s.pod_target_xcconfig = {
      'DEFINES_MODULE' => 'YES',
      'MACOSX_DEPLOYMENT_TARGET' => '10.13',
      'IPHONEOS_DEPLOYMENT_TARGET' => '12.0'
  }

  s.swift_version = '5.0'
  
  s.source_files = 'XSNetwork/Classes/**/*.{h,m,swift}'

  s.dependency 'Alamofire', '~> 5.11'
end
