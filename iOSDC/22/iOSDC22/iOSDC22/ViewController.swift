//
//  ViewController.swift
//  iOSDC22
//
//  Created by noppe on 2022/08/02.
//

import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController {
    
    let imageView: UIImageView = .init(frame: .null)
    var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        view = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
//        imageView.backgroundColor = .systemBackground
//        imageView.contentMode = .center
//        imageView.image = UIImage(named: "watch")
        
        // 2
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.magnificationFilter = .nearest
        imageView.image = UIImage(named: "watch")
        
        let tapGesture = UITapGestureRecognizer()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        func onTap() {
            let imageSize = CGSize(width: 16, height: 16)
            let targetView = tapGesture.view!
            let location = tapGesture.location(in: targetView)
            let x = Int(location.x * (imageSize.width / targetView.bounds.width))
            let y = Int(location.y * (imageSize.height / targetView.bounds.height))
            let point = CGPoint(x: x, y: y)
            print(point)
        }
        
        tapGesture.publisher(for: \.state).filter({ $0 == .ended }).sink { _ in
            onTap()
        }.store(in: &cancellables)
        
        
        
        
        let context = CGContext(
            data: nil,
            width: 16,
            height: 16,
            bitsPerComponent: 8,
            bytesPerRow: 1 * 16,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        )!
        context.setFillColor(gray: 1, alpha: 1)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
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
    }
}

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

