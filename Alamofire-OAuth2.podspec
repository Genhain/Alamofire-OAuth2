#
# Be sure to run `pod lib lint Alamofire-OAuth2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Alamofire-OAuth2'
  s.version          = '0.1.1'
  s.summary          = 'A short description of Alamofire-OAuth2.'

  s.homepage         = 'https://github.com/pencildrummer/Alamofire-OAuth2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Fabio Borella' => 'info@pencildrummer.com' }
  s.source           = { :git => 'https://github.com/pencildrummer/Alamofire-OAuth2.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Alamofire-OAuth2/Classes/**/*'

  s.dependency 'Alamofire', '~> 3.3'
  s.dependency 'AlamofireObjectMapper'

end
