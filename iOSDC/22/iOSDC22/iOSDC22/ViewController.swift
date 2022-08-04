//
//  ViewController.swift
//  iOSDC22
//
//  Created by noppe on 2022/08/02.
//

import UIKit
import SnapKit

class SimplePixelArtEditViewController: UIViewController {
    let imageView: UIImageView = .init(frame: .null)
//    let context: CGContext = CGContext(data: nil, width: 16, height: 16, bitsPerComponent: 8, bytesPerRow: 16, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    let context: CGContext = CGContext(data: nil, width: 4096, height: 4096, bitsPerComponent: 8, bytesPerRow: 4 * 4096, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        //view.backgroundColor = .secondarySystemBackground
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
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(onTap))
        imageView.addGestureRecognizer(tapGesture)
        
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(origin: .zero, size: CGSize(width: 16, height: 16)))
        
        drawAllRGBColor()
    }
    
    func drawAllRGBColor() {
        var i: Int = 0
        for r in 0..<256 {
            for g in 0..<256 {
                for b in 0..<256 {
                    i += 1
                    let x = i % 4096
                    let y = i / 4096
                    let color = CGColor(
                        red: Double(r) / 255,
                        green: Double(g) / 255,
                        blue: Double(b) / 255,
                        alpha: 1
                    )
                    context.setFillColor(color)
                    context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }
        }
        imageView.image = UIImage(cgImage: context.makeImage()!)
    }
    
    func drawAllGrayColor() {
        for i in 0..<256 {
            let x = i % 16
            let y = i / 16
            let gray = Double(i) / 255.0
            print(x, y, gray)
            context.setFillColor(CGColor(gray: gray, alpha: 1))
            context.fill(CGRect(x: x, y: y, width: 1, height: 1))
        }
        imageView.image = UIImage(cgImage: context.makeImage()!)
    }
    
    @objc func onTap(_ tapGesture: UITapGestureRecognizer) {
        let imageSize = CGSize(width: 16, height: 16)
        let targetView = tapGesture.view!
        let location = tapGesture.location(in: targetView)
        let x = Int(location.x * (imageSize.width / targetView.bounds.width))
        let y = Int(location.y * (imageSize.height / targetView.bounds.height))
        let point = CGPoint(x: x, y: y)
        context.setFillColor(CGColor(gray: 0, alpha: 1))
        context.fill(CGRect(origin: point, size: CGSize(width: 1, height: 1)))
        imageView.image = UIImage(cgImage: context.makeImage()!, scale: 1, orientation: .downMirrored)
    }
}
        
//        let context = CGContext(
//            data: nil,
//            width: 16,
//            height: 16,
//            bitsPerComponent: 8,
//            bytesPerRow: 1 * 16,
//            space: CGColorSpaceCreateDeviceGray(),
//            bitmapInfo: CGImageAlphaInfo.none.rawValue
//        )!
//        context.setFillColor(gray: 1, alpha: 1)
//        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
//
//        CGContext(
//            data: nil,
//            width: 16,
//            height: 16,
//            bitsPerComponent: 8,
//            bytesPerRow: 4 * 16,
//            space: CGColorSpaceCreateDeviceRGB(),
//            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
//        )!

extension CGContext {
    func fillEllipseLine(in rect: CGRect) {
        for point in [CGPoint]() {
            let rect = CGRect(origin: point, size: CGSize(width: 1, height: 1))
            let path = UIBezierPath(rect: rect).cgPath
            addPath(path)
        }
        fillPath()
    }
}

