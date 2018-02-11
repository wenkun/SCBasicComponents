#
# Be sure to run `pod lib lint SCBasicComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SCBasicComponents'
  s.version          = '0.1.0'
  s.summary          = '项目使用的基础组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
该组件整合了项目中经常使用的一些基础的宏和类的扩展，及自定义的一些类的集合
                       DESC

  s.homepage         = 'https://10.159.46.130/iOS_pods/SCBasicComponents.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenkun' => 'duwenkun@haier.com' }
  s.source           = { :git => 'https://10.159.46.130/iOS_pods/SCBasicComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SCBasicComponents/Classes/*.{h,m}'
  # s.exclude_files = "SCBasicComponents/Classes/Exclude"
  # s.exclude_files = "Classes/UIExtension"
  # s.exclude_files = "Classes/Maceos"
  # s.exclude_files = "Classes/Tools/SCLog"
  # s.source_files = {
  #   'SCBasicComponents' => ['SCBasicComponents/Classes/*.{h,m}']
  #   'SCBasicComponents' => ['SCBasicComponents/Classes/UIExtension/*.{h,m}']
  #   'SCBasicComponents' => ['SCBasicComponents/Classes/Maceos/*.{h,m}']
  #   'SCBasicComponents' => ['SCBasicComponents/Classes/Tools/SCLog/*.{h,m}']
  # }

  s.subspec "UIExtension" do |ss|
    ss.source_files = 'SCBasicComponents/Classes/UIExtension/*.{h,m}'
  end

  s.subspec "Tools" do |ss|
    ss.source_files = 'SCBasicComponents/Classes/Tools/**/*.{h,m}'
  end

  s.subspec "Maceos" do |ss|
    ss.source_files = 'SCBasicComponents/Classes/Maceos/*.h'
  end

  # s.resource_bundles = {
  #   'SCBasicComponents' => ['SCBasicComponents/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'STopAlertView'
end
