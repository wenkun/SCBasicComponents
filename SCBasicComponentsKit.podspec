#
# Be sure to run `pod lib lint SCBasicComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
# 2019110402

Pod::Spec.new do |s|
  s.name             = 'SCBasicComponentsKit'
  s.version          = '0.5.8'
  s.summary          = '项目使用的基础组件'
  s.description      = <<-DESC
该组件整合了项目中经常使用的一些基础的宏和类的扩展，及自定义的一些类的集合
                       DESC
  s.homepage         = 'https://github.com/wenkun/SCBasicComponents.git'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenkun' => 'duwenkun89@163.com' }
#  s.source           = { :git => 'https://10.199.96.150/iOS_pods/SCBasicComponents.git', :tag => s.version.to_s }
  s.source           = { :git => 'https://github.com/wenkun/SCBasicComponents.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.vendored_frameworks = ['build/Debug-iphoneos/SCBasicComponentsKit.framework']
  s.requires_arc = true
  s.frameworks = 'UIKit', 'Foundation'
end