Pod::Spec.new do |s|
  s.name = "PathMenu"
  s.version = "2.0.0"
  s.summary = "Path 4.2 menu using CoreAnimation in Swift."
  s.homepage = 'https://github.com/pixyzehn/PathMenu'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "Nagasawa Hiroki" => "civokjots10@gmail.com" }
  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source = { :git => "https://github.com/pixyzehn/PathMenu.git", :tag => "#{s.version}" }
  s.source_files = "PathMenu/*.swift"
end
