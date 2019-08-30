Pod::Spec.new do |s|
  s.name         = 'FCNumberButton'
  s.version      = '0.0.2'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = 'https://github.com/xiaoallocinit/FCNumberButton.git'
  s.author = { "xiaoallocinit" => "xiao2683@qq.com" }
  s.summary      = '商品数量的加减按钮的Swift版'
   s.description      = <<-DESC
购物加一减一按钮,商品数量的加减按钮的Swift版
                       DESC
  s.swift_version = "4.2"
  s.platform     = :ios, '9.0'
  s.source       = { git: 'https://github.com/xiaoallocinit/FCNumberButton.git', :tag => s.version.to_s}
  s.source_files = 'FCNumberButton/**/*'
  s.frameworks   =  'UIKit'
  s.requires_arc = true

end
