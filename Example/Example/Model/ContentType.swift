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
        let image =  UIImage(named: imageName)!
        return image
    }
    
    private var imageName: String {
        switch self {
        case .Music:
            return "content_music.png"
        case .Films:
            return "content_films.png"
        }
    }
    
    var description: String {
        return rawValue
    }
}