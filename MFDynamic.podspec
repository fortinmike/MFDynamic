Pod::Spec.new do |s|
  s.name             = "MFDynamic"
  s.version          = "1.1.1"
  s.summary          = "MFDynamic eliminates stringly-typed User Defaults, NSCoding boilerplate and more."
  s.homepage         = "http://github.com/fortinmike/MFDynamic"
  s.license          = 'MIT'
  s.author           = { "Michaël Fortin" => "fortinmike@irradiated.net" }
  s.source           = { :git => "https://github.com/fortinmike/MFDynamic.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/IrradiatedApps'

  s.ios.deployment_target = '6.1'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'MFDynamic/Source'
  s.prefix_header_file = 'MFDynamic/Source/MFDynamic-Prefix.pch'
  s.public_header_files = 'MFDynamic/Source/**/*.h'
  
  s.dependency 'MAObjCRuntime', '~> 0.0.1'
end
