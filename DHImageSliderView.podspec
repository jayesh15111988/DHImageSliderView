Pod::Spec.new do |s|
  s.name          = 'DHImageSliderView'
  s.version       = '1.6'
  s.license       = 'MIT'
  s.summary       = 'DHImage Slider'
  s.homepage      = 'https://github.com/jayesh15111988'
  s.author        = 'Jayesh Kawli'
  s.source        = {  :git => 'git@github.com:jayesh15111988/DHImageSliderView.git', :tag => "#{s.version}" }
  s.source_files  = 'DHImageSliderView/*.{h,m}'
  s.requires_arc  = true
  s.ios.deployment_target = '7.0'
  s.resources = 'Graphics/*.png'
end
