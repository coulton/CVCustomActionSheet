Pod::Spec.new do |spec|
  spec.name             = 'CVCustomActionSheet'
  spec.version          = '0.11'
  spec.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.homepage         = 'https://github.com/coultonvento/CVCustomActionSheet'
  spec.author           = { 'Coulton Vento' => 'me@coultonvento.com' }
  spec.social_media_url = "http://twitter.com/coultonvento"
  spec.summary          = 'A super-simple, customizable iOS 8 - styled action sheet.'
  spec.source           = { :git => 'https://github.com/coultonvento/CVCustomActionSheet.git', :tag => 'v0.11' }
  spec.source_files     = 'CVCustomActionSheet/*.{h,m}'
  spec.framework        = 'UIKit', 'Foundation'
  spec.platform         = :ios, "7.0"
  spec.requires_arc     = true
end