swiftui_interface = Dir['/Applications/Xcode-16.0.0-beta.4.app/Contents/Developer/Platforms/**/SwiftUI.framework/**/*.swiftinterface']

for file_path in swiftui_interface
  if !File.read(file_path).include?("ViewPreviewSource")
    File.open(file_path, 'a') do |file|
      file.puts("@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *)
      extension SwiftUICore.View {
        public func variableBlur(maxRadius: CoreFoundation.CGFloat, mask: SwiftUI.Image, opaque: Swift.Bool) -> some SwiftUI.View
      }")
    end
  end
end
