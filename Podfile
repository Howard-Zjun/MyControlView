source 'https://github.com/CocoaPods/Specs.git'

platform:ios, '13.0'

workspace 'MyControlView.xcworkspace'

def commonPods

  use_frameworks!

  #  pod 'MyBaseExtension', :path => '/Users/Howard-Zjun/MyBaseExtension'
  pod 'MyBaseExtension', :git => 'https://github.com/Howard-Zjun/MyBaseExtension.git'
end

target 'MyControlView' do

  use_frameworks!
  project 'MyControlView.xcodeproj'
  
  commonPods
end

target 'ModuleDebug' do
  
  use_frameworks!
  project 'ModuleDebug/ModuleDebug.xcodeproj'
  
  commonPods
end
