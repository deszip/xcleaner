# Uncomment the next line to define a global platform for your project
platform :osx, '10.10'

target 'xcleaner' do
    use_frameworks!

    workspace ‘xclean’
	xcodeproj ‘xcleaner/xcleaner.xcodeproj’

    target 'xcleanerTests' do
    
        inherit! :search_paths
        pod 'Nimble'
    
    end

end
