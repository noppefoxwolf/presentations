import UIKit

class GetColorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let context: CGContext = CGContext(data: nil, width: 2, height: 2, bitsPerComponent: 8, bytesPerRow: 2, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
        context.setFillColor(gray: 51.0 / 255.0, alpha: 1) // 3
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        context.setFillColor(gray: 68.0 / 255.0, alpha: 1) // 4
        context.fill(CGRect(x: 1, y: 0, width: 1, height: 1))
        context.setFillColor(gray: 17.0 / 255.0, alpha: 1) // 1
        context.fill(CGRect(x: 0, y: 1, width: 1, height: 1))
        context.setFillColor(gray: 34.0 / 255.0, alpha: 1) // 2
        context.fill(CGRect(x: 1, y: 1, width: 1, height: 1))

        let ctxData = context.data
        
//        let a = ctxData?.load(fromByteOffset: <#T##Int#>, as: <#T##T.Type#>)
//        print(a)

        let image = UIImage(cgImage: context.makeImage()!)
        
        // rgba
//        let context: CGContext = CGContext(data: nil, width: 2, height: 2, bitsPerComponent: 8, bytesPerRow: 4 * 2, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)!
//        context.setFillColor(CGColor(srgbRed: 17.0 / 255.0, green: 34.0 / 255.0, blue: 51.0 / 255.0, alpha: 1))
//        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
//        context.setFillColor(CGColor(srgbRed: 85.0 / 255.0, green: 102.0 / 255.0, blue: 119.0 / 255.0, alpha: 1))
//        context.fill(CGRect(x: 1, y: 0, width: 1, height: 1))
//        context.setFillColor(CGColor(srgbRed: 17.0 / 255.0, green: 34.0 / 255.0, blue: 51.0 / 255.0, alpha: 1))
//        context.fill(CGRect(x: 0, y: 1, width: 1, height: 1))
//        context.setFillColor(CGColor(srgbRed: 85.0 / 255.0, green: 102.0 / 255.0, blue: 119.0 / 255.0, alpha: 1))
//        context.fill(CGRect(x: 1, y: 1, width: 1, height: 1))
//        
//        let ctxData = context.data
//        
//        let image = UIImage(cgImage: context.makeImage()!)
//        struct C {
//            let r,g,b,a: UInt8
//        }
//        let a = ctxData?.load(as: C.self)
//        print(a)
        
    }
}
