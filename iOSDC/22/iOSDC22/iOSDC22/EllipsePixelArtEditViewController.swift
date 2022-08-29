import UIKit

class EllipsePixelArtEditViewController: UIViewController {
    let imageView: UIImageView = .init(frame: .null)
//    let context: CGContext = CGContext(data: nil, width: 16, height: 16, bitsPerComponent: 8, bytesPerRow: 16, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    let context: CGContext = CGContext(data: nil, width: 64, height: 64, bitsPerComponent: 8, bytesPerRow: 4 * 64, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        context.interpolationQuality = .none
//        context.setAllowsAntialiasing(false)
        
        //view.backgroundColor = .systemBackground
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(512)
        }
        
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleToFill
        imageView.layer.magnificationFilter = .nearest
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(onPan))
        imageView.addGestureRecognizer(panGesture)
        
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(origin: .zero, size: CGSize(width: 16, height: 16)))
    }
    
    var p0: CGPoint = .zero
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        let imageSize = CGSize(width: 64, height: 64)
        let targetView = panGesture.view!
        let location = panGesture.location(in: targetView)
        
        let x = Int(location.x * (imageSize.width / targetView.bounds.width))
        let y = Int(location.y * (imageSize.height / targetView.bounds.height))
        let point = CGPoint(x: x, y: y)
        
        if panGesture.state == .began {
            p0 = point
            return
        }
        
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(origin: .zero, size: CGSize(width: 64, height: 64)))
        
        context.setStrokeColor(CGColor(gray: 0, alpha: 1))
        let origin = p0
        let size = CGSize(width: point.x - p0.x, height: point.y - p0.y)
        context.addEllipse(in: CGRect(origin: origin, size: size))
        context.strokePath()
        
        imageView.image = UIImage(cgImage: context.makeImage()!, scale: 1, orientation: .downMirrored)
    }
}
