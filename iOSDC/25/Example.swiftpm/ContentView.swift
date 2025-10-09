import SwiftUI
import UIKit
import ImageIO
import os

struct ContentView: View {
    let columns = Array(repeating: GridItem(.fixed(240)), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(0..<1000, id: \.self) { index in
                    GIFAnimationView()
                        .frame(width: 240, height: 200)
                        .clipped()
                }
            }
            .padding(2)
        }
    }
}

struct GIFAnimationView: UIViewRepresentable {
    private let logger = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: #file)
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        loadGIFAnimation(into: imageView)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
    
    private func loadGIFAnimation(into imageView: UIImageView) {
        guard let gifURL = Bundle.main.url(forResource: "elephant_gif", withExtension: "gif") else {
            logger.error("original.gif not found in bundle")
            return
        }
        
        
        guard let gifSource = CGImageSourceCreateWithURL(gifURL as CFURL, nil) else {
            logger.error("Failed to create CGImageSource from GIF")
            return
        }
        
        
        let frameCount = CGImageSourceGetCount(gifSource)
        var frames: [UIImage] = []
        var totalDuration: TimeInterval = 0
        
        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(gifSource, index, nil) else {
                logger.error("Failed to create CGImage at index \(index)")
                continue
            }
            
            let frame = UIImage(cgImage: cgImage)
            frames.append(frame)
            
            let frameDuration = getFrameDuration(from: gifSource, at: index)
            totalDuration += frameDuration
        }
        
        logger.info("Loaded \(frames.count) frames from GIF with total duration: \(totalDuration)")
        imageView.animationImages = frames
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    private func getFrameDuration(from source: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else {
            return 0.1
        }
        
        let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ??
                       gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double ?? 0.1
        
        return max(0.02, delayTime)
    }
}

struct SimpleGIFImageView: UIViewRepresentable {
    private let logger = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: #file)
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        loadGIFAsUIImage(into: imageView)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
    
    private func loadGIFAsUIImage(into imageView: UIImageView) {
        guard let gifURL = Bundle.main.url(forResource: "elephant_gif", withExtension: "gif") else {
            logger.error("elephant_gif.gif not found in bundle")
            return
        }
        
        guard let gifData = try? Data(contentsOf: gifURL) else {
            logger.error("Failed to load GIF data")
            return
        }
        
        let gifImage = UIImage(data: gifData)
        imageView.image = gifImage
        
        logger.info("GIFをUIImageとして読み込み完了 - アニメーションは表示されません")
        
        imageView.startAnimating()
    }
}
