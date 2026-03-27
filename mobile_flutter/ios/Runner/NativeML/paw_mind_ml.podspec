#
# paw_mind_ml.podspec
# CocoaPods spec for PawMind Native ML Module
#
# Usage: Add to mobile_flutter/ios/Podfile
#

Pod::Spec.new do |s|
  s.name             = 'paw_mind_ml'
  s.version          = '0.0.1'
  s.summary          = 'On-device ML module for PawMind (vision + LLM + TTS)'
  s.description      = <<-DESC
PawMind Native ML Module
- MediaPipe Holistic for dog pose/expression detection
- Phi-3-mini (MLX) for on-device LLM reasoning
- Piper for on-device TTS synthesis
DESC
  s.homepage         = 'https://github.com/bbugs280/paw-mind'
  s.license          = { :file => '../License' }
  s.author           = { 'Vincent Y' => 'vincent@pawmind.app' }
  s.source           = { :path => '.' }
  s.source_files     = 'PawMindML.swift'
  s.dependency 'Flutter'
  s.dependency 'MLX'
  s.dependency 'MediaPipeHolistic'
  s.dependency 'PiperTTS'
  
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.0'
  
  # Required for MLX (Metal GPU acceleration)
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-framework Metal -framework MetalPerformanceShaders'
  }
  
  # Model files (not bundled - download on-demand for production)
  # For POC: manually place models in Runner/Models/
  s.resource_bundles = {
    'paw_mind_ml_models' => ['Models/*.mlx', 'Models/*.piper']
  }
end
