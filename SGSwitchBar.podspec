Pod::Spec.new do |s|

  s.name         = "SGSwitchBar"

  s.version      = "0.2.2"

  s.summary      = "switch tool bar"

  s.description  = "a simple switch tool bar"

  s.homepage     = "https://github.com/install-b/SGInfiniteView"

  s.license      = "MIT"

  s.author       = { "ShanggenZhang" => "gkzhangshangen@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/install-b/SGInfiniteView.git", :tag => s.version }

  s.source_files  = "SGSwitchBar/*.{h,m}"

  s.framework  = "UIKit"

  s.requires_arc = true
end
