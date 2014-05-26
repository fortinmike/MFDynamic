Pod::Spec.new do |s|
  s.name             = "MFDynamic"
  s.version          = "1.2.0"
  s.summary          = "MFDynamic eliminates NSCoding boilerplate, stringly-typed user defaults and more."
  s.homepage         = "http://github.com/fortinmike/MFDynamic"
  s.license          = 'MIT'
  s.author           = { "Michaël Fortin" => "fortinmike@irradiated.net" }
  s.source           = { :git => "https://github.com/fortinmike/MFDynamic.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/IrradiatedApps'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'MFDynamic/Source'
  s.public_header_files = 'MFDynamic/Source/**/*.h'
  
  s.dependency 'MAObjCRuntime', '~> 0.0.1'
end
