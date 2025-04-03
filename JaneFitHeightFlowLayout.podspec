Pod::Spec.new do |s|

  s.name         = "JaneFitHeightFlowLayout"
  s.version      = "1.0.2"
  s.summary      = "自适应高度瀑布流列表布局"
  s.homepage     = "https://github.com/Jane1in99/JaneFitHeightFlowLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "janelin99" => "864927438@qq.com" }

  s.platform     = :ios
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Jane1in99/JaneFitHeightFlowLayout.git", :tag => "#{s.version}" }

  s.source_files  = "JaneWaterFlowLayout/JaneFitHeightFlowLayout/*.{h,m}"

  s.requires_arc = true
end
