import UIKit
import SwiftUI

struct ContentView3: UIViewControllerRepresentable {
    func makeUIViewController(
        context: Context
    ) -> some UIViewController {
        UINavigationController(rootViewController: ViewController())
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {
        
    }
}

final class ViewController: UIViewController {
    let textView = UITextView()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        textView.supportsAdaptiveImageGlyph = true
        textView.text = "You make my everyday so special. "
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),
            textView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            view.trailingAnchor.constraint(
                equalTo: textView.safeAreaLayoutGuide.trailingAnchor,
                constant: 20
            ),
            textView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: UIAction { [unowned self] _ in
                export()
            }
        )
        
        let adaptiveImageGlyph = NSAdaptiveImageGlyph(imageContent: imageContent())
        textView.attributedText = NSAttributedString(adaptiveImageGlyph: adaptiveImageGlyph)
    }
    
    func imageContent() -> Data {
        let imageContent = NSMutableData()
        let destination = CGImageDestinationCreateWithData(
            imageContent,
            NSAdaptiveImageGlyph.contentType.identifier as CFString,
            1,
            nil
        )!
        let metadata = CGImageMetadataCreateMutable()
        CGImageMetadataSetValueWithPath(
            metadata,
            nil,
            "tiff:DocumentName" as CFString,
            UUID().uuidString as CFString
        )
        let image = UIImage(resource: ._032)
        CGImageDestinationAddImageAndMetadata(
            destination,
            image.cgImage!,
            metadata,
            nil
        )
        CGImageDestinationFinalize(destination)
        return imageContent as Data
    }
    
    func a() {
        let url = Bundle.main.url(forResource: "export", withExtension: "heic")!
        let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let metadata = CGImageSourceCopyMetadataAtIndex(imageSource, 0, nil)!
        
        print(metadata)
    }
    
    func export() {
        var adaptiveImageGlyph: NSAdaptiveImageGlyph!
        let range = NSRange(location: 0, length: textView.attributedText.length)
        textView.attributedText.enumerateAttribute(
            .adaptiveImageGlyph,
            in: range,
            using: { value, _, stop in
                adaptiveImageGlyph = value! as? NSAdaptiveImageGlyph
                stop.pointee = true
            }
        )
        exportGenmoji(adaptiveImageGlyph)
    }
    
    func exportGenmoji(_ adaptiveImageGlyph: NSAdaptiveImageGlyph) {
        adaptiveImageGlyph.imageContent // heic file
        
        let vc = UIActivityViewController(
            activityItems: [adaptiveImageGlyph.imageContent],
            applicationActivities: []
        )
        present(vc, animated: true)
    }
}



