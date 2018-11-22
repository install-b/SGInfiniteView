#
#  Be sure to run `pod spec lint SGInfiniteView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SGInfiniteView"
  s.version      = "0.2.2"
  s.summary      = "An iOS inifite scroll view"

  s.description  = <<-DESC
SGInfiniteView is an infinite scroll view control with unlimited switching back and forth around the view function. Integrated function of advertising by it you can be a code, also can be used in reading class app news about switching back and forth between modules Only need to implement a proxy method and an object can be the title bar of the view to view linkage with you.
                   DESC

  s.homepage     = "https://github.com/install-b/SGInfiniteView"


  s.license      = "MIT"

  s.author       = { "ShanggenZhang" => "gkzhangshangen@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/install-b/SGInfiniteView.git", :tag => s.version }

  s.source_files  = "SGInfiniteView/*.{h,m}"
  s.public_header_files = "SGInfiniteView/*.h"
  
  s.framework  = "UIKit"
  

  s.requires_arc = true


end
