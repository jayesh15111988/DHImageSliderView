Pod::Spec.new do |s|
  s.name          = 'DHImageSliderView'
  s.version       = '1.0'
  s.license       = 'MIT'
  s.summary       = 'DH Image Slider'
  s.homepage      = 'https://github.com/jayesh15111988'
  s.author        = 'Jayesh Kawli'
  s.source        = { 
			:git => 'git@github.com:jayesh15111988/DHImageSliderView.git',:tag => 'v1.1' 
		    }
  s.source_files  = 'DHImageSliderView/**'
  s.requires_arc  = true
  s.ios.deployment_target = '7.0'
end
