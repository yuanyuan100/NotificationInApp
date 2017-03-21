Pod::Spec.new do |s|
  s.name             = "NotificationInApp"    #名称
  s.version          = "1.0.4"             #版本号
  s.summary          = "in app, psuh notification view by DIY."     #简短介绍，下面是详细介绍
  s.description      = <<-DESC
                       in app, psuh notification view by DIY | first try |fix some bug
                       DESC
  s.homepage         = "https://github.com/yuanyuan100/NotificationInApp"     
  s.license          = 'MIT'              #开源协议
  s.author           = "yuanyuan100"                  #作者信息
  s.source           = { :git =>"https://github.com/yuanyuan100/NotificationInApp.git", :tag => "1.0.4" }      
  s.platform     = :ios, '8.0'            #支持的平台及版本
  s.requires_arc = true                  
  s.source_files = 'NotificationInApp/PY_NotificationInAppClass/**/*.{h,m}'  
  s.frameworks = 'UIKit'
end