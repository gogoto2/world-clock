# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'WorldClock' do
    pod 'FMDB'
end

target 'WorldClockWatch' do
    pod 'FMDB'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Pods-WorldClockWatch'
            target.build_configurations.each do |config|
                config.build_settings['SUPPORTED_PLATFORMS'] = ['watchos', 'watchsimulator']
            end
        end
    end
end