# Be sure to run `pod lib lint RxCommonKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# new code update github
# local not code: pod repo add RxCommonKit  https://github.com/DanielZSY/RxCommonKit.git
# local uodate code: cd ~/.cocoapods/repos/RxCommonKit. Then execute: pod repo update RxCommonKit
# pod repo push RxCommonKit RxCommonKit.podspec --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
# pod trunk push RxCommonKit.podspec --allow-warnings
# pod install or pod update on you project execute

Pod::Spec.new do |s|
  s.version          = '0.0.1'
  s.name             = 'RxCommonKit'
  s.summary          = 'RxCommonKit'
  s.module_name      = 'RxCommonKit'
  
  s.homepage         = 'https://github.com/DanielZSY/RxCommonKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DanielZSY' => 'danielzsy@163.com' }
  s.source           = { :git => 'https://github.com/DanielZSY/RxCommonKit.git', :tag => s.version.to_s }
  
  s.platform              = :ios, '10.0'
  s.swift_versions        = "5"
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.0' }
  
  s.frameworks    = 'UIKit'
  s.libraries     = 'z', 'c++', 'sqlite3'
  s.source_files  = 'RxCommonKit/**/*.{swift,h,m}'
  s.resources = ['RxCommonKit/Assets/**/*.strings']
  
  s.dependency 'Moya'
  s.dependency 'Result'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'HandyJSON'
  s.dependency 'Alamofire'
  s.dependency 'SwiftDate'
  s.dependency 'Starscream'
  s.dependency 'GRDB.swift'
  s.dependency 'BFKit-Swift'
  s.dependency 'CryptoSwift'
  s.dependency 'AlamofireImage'
  s.dependency 'AlamofireNetworkActivityIndicator'
end
