# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'example-playlist-itunes-music' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Moya/Combine', '~> 15.0.0'
  pod 'Kingfisher', '~> 7.0'
  
  target 'example-playlist-itunes-musicTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
