#
# Be sure to run `pod lib lint RZFileSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RZFileSelector'
  s.version          = '0.1.0'
  s.summary          = '图片，视频，文件（word,excel,pdf）选择器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  图片，视频，文件（word,excel,pdf）选择器
                       DESC

  s.homepage         = 'https://github.com/Reyzhang2010/RZFileSelector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Reyzhang2010' => 'zhanglei5415@163.com' }
  s.source           = { :git => 'https://github.com/Reyzhang2010/RZFileSelector.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'RZFileSelector/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RZFileSelector' => ['RZFileSelector/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'

  s.static_framework = true
    
  s.dependency 'HXPhotoPicker'
  s.dependency 'HXPhotoPicker/SDWebImage_AF'

end
