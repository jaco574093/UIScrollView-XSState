#

Pod::Spec.new do |spec|

  spec.name         = "UIScrollView+XSState"
  spec.version      = "1.0.0"
  spec.summary      = "UIScrollView及其子类状态显示"

  spec.description  = <<-DESC
  					给UIScrollView、UITableView、UICollectionView设置状态
                   DESC

  spec.homepage     = "https://github.com/jaco574093/UIScrollView-XSState"

  spec.license      = "MIT"
  spec.author       = { "雅各" => "jaco574093@gmail.com" }


  spec.source       = { :git => "https://github.com/jaco574093/UIScrollView-XSState.git", :tag => "1.0.0" }

  spec.source_files  = "*.{h,m}"
  # spec.exclude_files = "Classes/Exclude"
  spec.public_header_files = "*.h"

end
