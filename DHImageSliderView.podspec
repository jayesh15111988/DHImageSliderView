Pod::Spec.new do |s|
  s.name          = 'DHImageSliderView'
  s.version       = '1.0'
  s.license       = 'MIT'
  s.summary       = 'DHKit Image Slider'
  s.homepage      = 'http://gitlab.duethealth.com/ios-projects'
  s.author        = 'Jayesh Kawli'
  s.source        = { 
			:git => 'git@gitlab.duethealth.com:ios-projects/dhimagesliderview.git',:tag => 'v1.0' 
		    }
  s.source_files  = 'DHImageSliderView/**'
  s.requires_arc  = true
  s.ios.deployment_target = '7.0'
end
