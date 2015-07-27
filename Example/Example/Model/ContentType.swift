// For License please refer to LICENSE file in the root of Persei project

import Foundation

import UIKit

enum ContentType: String, CustomStringConvertible {
    case Music
    case Films

    func next() -> ContentType {
        switch self {
        case .Music:
            return .Films
        case .Films:
            return .Music
        }
    }
    
    var image: UIImage {
        let image =  UIImage(named: "content_\(rawValue.lowercaseString).png")!
        return image
    }
    
    var description: String {
        return rawValue
    }
}