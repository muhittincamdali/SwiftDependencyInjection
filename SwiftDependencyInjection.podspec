Pod::Spec.new do |s|
  s.name             = 'SwiftDependencyInjection'
  s.version          = '1.0.0'
  s.summary          = 'Lightweight dependency injection framework for Swift.'
  s.description      = 'SwiftDependencyInjection provides lightweight DI with property wrappers and container support.'
  s.homepage         = 'https://github.com/muhittincamdali/SwiftDependencyInjection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/SwiftDependencyInjection.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation'
end
