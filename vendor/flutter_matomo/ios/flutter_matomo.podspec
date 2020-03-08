#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_matomo'
  s.version          = '0.0.1'
  s.summary          = 'Matomo tracking for flutter'
  s.description      = <<-DESC
Matomo tracking for flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MatomoTracker', '> 7'

  s.ios.deployment_target = '12.0'
end
